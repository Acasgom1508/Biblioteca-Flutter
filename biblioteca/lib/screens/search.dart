import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Referencia a la colección "Libros" en Firebase
  final CollectionReference librosCollection =
      FirebaseFirestore.instance.collection('Libros');
  // Variable para almacenar el término de búsqueda
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
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
          // Título "Buscar"
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 51, 96, 164),
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'Buscar',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar libro',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
          // Lista de libros
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: librosCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Filtra los libros según el término de búsqueda
                final libros = snapshot.data!.docs.where((doc) {
                  final libro = doc.data() as Map<String, dynamic>;
                  final nombre = libro['nombre']?.toLowerCase() ?? '';
                  return nombre.contains(searchTerm.toLowerCase());
                }).toList();
                return ListView.builder(
                  itemCount: libros.length,
                  itemBuilder: (context, index) {
                    final libro = libros[index].data() as Map<String, dynamic>;
                    final id = libros[index].id;
                    return buildLibroItem(libro, id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir cada elemento de la lista de libros
  Widget buildLibroItem(Map<String, dynamic> libro, String id) {
    final String nombre = libro['nombre'] ?? 'Sin título';
    final String autor = libro['autor'] ?? 'Desconocido';
    final String estado = libro['estado'] ?? 'Desconocido';
    final String ruta = libro['ruta'] ?? '';
    final bool disponible = estado == 'Disponible';

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del libro
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
                  // Título del libro
                  Text(
                    nombre,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Autor
                  Text(
                    autor,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  // Estado del libro
                  Text(
                    estado,
                    style: TextStyle(
                      fontSize: 16,
                      color: disponible ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón "Alquilar" (solo si está disponible)
                  if (disponible)
                    ElevatedButton(
                      onPressed: () => alquilarLibro(id, estado),
                      child: const Text('Alquilar'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void alquilarLibro(String id, String estado) {
    if (estado == 'Disponible') {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        librosCollection.doc(id).update({
          'estado': 'Alquilado',
          'alquiladoPor': user.uid,
        }).catchError((e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('No se pudo alquilar el libro: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Usuario no autenticado.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Libro no disponible'),
          content: const Text('Este libro ya está alquilado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void devolverLibro(String id) {
    librosCollection.doc(id).update({
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
}
