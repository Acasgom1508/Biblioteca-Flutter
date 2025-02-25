import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Usuario no autenticado.'),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://static.nationalgeographicla.com/files/styles/image_3200/public/006-library-biblioteca-angelica-a-roma_0002.jpg?w=1600&h=1283",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 51, 96, 164),
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'Perfil',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Libros')
                  .where('estado', isEqualTo: 'Alquilado')
                  .where('alquiladoPor', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final libros = snapshot.data!.docs;
                if (libros.isEmpty) {
                  return const Center(child: Text('No tienes libros alquilados.'));
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: libros.length,
                        itemBuilder: (context, index) {
                          final libro = libros[index].data() as Map<String, dynamic>;
                          final id = libros[index].id;
                          return buildLibroItem(libro, id, context);
                        },
                      ),
                    ),
                    // Botón para generar PDF
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 51, 96, 164),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                        label: const Text(
                          'Generar PDF de libros alquilados',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => mostrarPDFLibros(libros, context),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para construir cada elemento de la lista de libros
  Widget buildLibroItem(Map<String, dynamic> libro, String id, BuildContext context) {
    final String nombre = libro['nombre'] ?? 'Sin título';
    final String autor = libro['autor'] ?? 'Desconocido';
    final String ruta = libro['ruta'] ?? '';

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ruta.isNotEmpty)
              Image.asset(
                ruta,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey,
                  child: const Icon(Icons.book, size: 50),
                ),
              )
            else
              Container(
                width: 100,
                height: 150,
                color: Colors.grey,
                child: const Icon(Icons.book, size: 50),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    autor,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => devolverLibro(id, context),
                    child: const Text('Devolver'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Función para devolver un libro
  void devolverLibro(String id, BuildContext context) {
    FirebaseFirestore.instance.collection('Libros').doc(id).update({
      'estado': 'Disponible',
      'alquiladoPor': null,
    }).catchError((e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('No se pudo devolver el libro: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  /// Mostrar pantalla para visualizar/imprimir el PDF
  void mostrarPDFLibros(List<QueryDocumentSnapshot> libros, BuildContext context) {
    // Navegar a una nueva pantalla para mostrar el PDF
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PDFScreen(libros: libros),
      ),
    );
  }
}

/// Clase para la pantalla de visualización del PDF
class PDFScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot> libros;

  const PDFScreen({Key? key, required this.libros}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa del PDF'),
        backgroundColor: const Color.fromARGB(255, 51, 96, 164),
      ),
      body: PdfPreview(
        build: (format) => generatePDF(format),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
      ),
    );
  }

  /// Generar el documento PDF
  Future<Uint8List> generatePDF(PdfPageFormat format) async {
    final pdf = pw.Document();
    
    // Obtener fecha actual para el encabezado
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year}';

    // Agregar página al documento
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Encabezado
              pw.Header(
                level: 0,
                child: pw.Text('Listado de libros alquilados', 
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Fecha: $formattedDate'),
              pw.SizedBox(height: 20),
              
              // Tabla de libros
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Encabezado de la tabla
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('#', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Título', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Autor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  
                  // Filas de libros
                  for (int i = 0; i < libros.length; i++)
                    buildLibroPDFRow(i + 1, libros[i].data() as Map<String, dynamic>),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Text('Total de libros alquilados: ${libros.length}', 
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)
              ),
              
              // Pie de página
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text('Biblioteca App - Registro de préstamos', 
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey)
                ),
              ),
            ],
          );
        },
      ),
    );
    
    return pdf.save();
  }

  /// Crea una fila de la tabla para el PDF
  pw.TableRow buildLibroPDFRow(int index, Map<String, dynamic> libro) {
    final String nombre = libro['nombre'] ?? 'Sin título';
    final String autor = libro['autor'] ?? 'Desconocido';
    
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text('$index'),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(nombre),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(autor),
        ),
      ],
    );
  }
}