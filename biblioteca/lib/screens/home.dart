import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int) onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

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
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center, // Centra el texto horizontalmente
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: const Text(
                    'Mi Cuenta',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => onNavigate(1),
                ),
                ListTile(
                  leading: const Icon(Icons.search,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: const Text(
                    'Buscar en el Catálogo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => onNavigate(3),
                ),
                const ListTile(
                  leading: Icon(Icons.house,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: Text('Direccion y horas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const ListTile(
                  leading: Icon(Icons.mobile_screen_share,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: Text('Colecciones Digitales',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const ListTile(
                  leading: Icon(Icons.calendar_month,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: Text('Eventos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const ListTile(
                  leading: Icon(Icons.menu_book,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: Text('Recien Llegados',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const ListTile(
                  leading: Icon(Icons.question_answer_outlined,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: Text('Como lo hago?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const ListTile(
                  leading: Icon(Icons.stars_outlined,
                      color: Color.fromARGB(255, 62, 179, 66), size: 50),
                  title: Text('Destacar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
