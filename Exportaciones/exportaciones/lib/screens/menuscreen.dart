import 'package:antioquia/screens/exportaciones.dart';
import 'package:antioquia/screens/registar.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exportaciones Jw',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 50),
        ),
        backgroundColor: const Color.fromARGB(255, 212, 212, 212),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Exports menu'),
            // subtitle: Text('Crear'),
            leading: Icon(
              Icons.menu_book,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            // trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            title: const Text('Create product'),
            // subtitle: const Text('Crear'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              final route =
                  MaterialPageRoute(builder: (context) => const Registrar());
              Navigator.push(context, route);
            },
          ),
          ListTile(
            title: const Text('View product'),
            // subtitle: const Text('Visualizar'),
            leading: const Icon(
              Icons.arrow_right_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              final route = MaterialPageRoute(
                  builder: (context) => const ListarExportaciones());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }
}
