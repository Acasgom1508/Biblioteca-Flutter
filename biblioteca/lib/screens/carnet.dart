import 'package:flutter/material.dart';

class CarnetScreen extends StatelessWidget {
  const CarnetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150), // Ajusta la altura aquí
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://static.nationalgeographicla.com/files/styles/image_3200/public/006-library-biblioteca-angelica-a-roma_0002.jpg?w=1600&h=1283",
                ),
                fit: BoxFit.cover, // Para que la imagen cubra todo
              ),
            ),
          ),
          backgroundColor: Colors.transparent, // Hace que la imagen se vea bien
          elevation: 0, // Elimina la sombra de la AppBar
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity, // Ocupa todo el ancho de la pantalla
            color: const Color.fromARGB(255, 51, 96, 164), // Fondo del texto
            padding: const EdgeInsets.all(5.0), // Espaciado alrededor del texto
            child: const Text(
              'Carnet',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Centra el texto horizontalmente
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Esta pantalla no tiene ningún contenido',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
