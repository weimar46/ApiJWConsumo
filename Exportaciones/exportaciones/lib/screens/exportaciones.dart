import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Exportacion {
  final String producto;
  final int kilos;
  final int precioKilos;
  final double precioDolar;

  Exportacion({
    required this.producto,
    required this.precioKilos,
    required this.precioDolar,
    required this.kilos,
  });

  factory Exportacion.fromJson(Map<String, dynamic> json) {
    return Exportacion(
      producto: json['producto'],
      precioKilos: json['precioKilos'],
      precioDolar: json['precioDolar'],
      kilos: json['kilos'],
    );
  }
}

Future<List<Exportacion>> fetchPosts() async {
  final response = await http.get(
      Uri.parse('https://exportaciones.onrender.com/exportaciones')); //cambiar

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> exportacionesJson = jsonData['msg'];
    return exportacionesJson.map((json) => Exportacion.fromJson(json)).toList();
  } else {
    throw Exception('Export loading failed');
  }
}

class ListarExportaciones extends StatefulWidget {
  const ListarExportaciones({Key? key}) : super(key: key);

  @override
  State<ListarExportaciones> createState() => _ListarExportacionesState();
}

class _ListarExportacionesState extends State<ListarExportaciones> {
  // Método para editar una exportación
  Future<void> editarExportacion(Exportacion exportacion) async {
    // URL de la API donde se encuentra el recurso a editar
    const String url = 'https://exportaciones.onrender.com/exportaciones';

    // Convierte los datos de la exportación a un formato que la API pueda entender (JSON)
    final Map<String, dynamic> datosActualizados = {
      // Aquí debes incluir los campos que deseas actualizar
      'producto': exportacion.producto,
      'kilos': exportacion.kilos,
      'precioKilos': exportacion.precioKilos,
      'precioDolar': exportacion.precioDolar,
    };
    print('Data update:');
    print(datosActualizados);

    // Codificar los datos a JSON
    final String cuerpoJson = jsonEncode(datosActualizados);

    try {
      // Realiza la solicitud PUT al servidor
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Establecer la cabecera para indicar que el cuerpo es JSON
        body: cuerpoJson, // Pasar el cuerpo codificado JSON
      );

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        print('Export edit successfully');
        setState(() {});
      } else {
        print('Error editing the export: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error making the request: $e');
    }
  }

  void mostrarVentanaEdicion(BuildContext context, Exportacion exportacion) {
    TextEditingController productoController =
        TextEditingController(text: exportacion.producto);
    TextEditingController kilosController =
        TextEditingController(text: exportacion.kilos.toString());
    TextEditingController precioKilosController =
        TextEditingController(text: exportacion.precioKilos.toString());
    TextEditingController precioDolarController =
        TextEditingController(text: exportacion.precioDolar.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Export'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: productoController,
                  decoration: InputDecoration(labelText: 'Product'),
                ),
                TextField(
                  controller: kilosController,
                  decoration: InputDecoration(labelText: 'Kilos'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioKilosController,
                  decoration: InputDecoration(labelText: 'Price per kilo'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioDolarController,
                  decoration: InputDecoration(labelText: 'Price per dollars'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Convertir los valores de texto a tipos numéricos
                int kilos = int.parse(kilosController.text);
                int precioKilos = int.parse(precioKilosController.text);
                double precioDolar = double.parse(precioDolarController.text);

                // Crear la instancia de Exportacion con los valores convertidos
                Exportacion exportacionActualizada = Exportacion(
                  producto: productoController.text,
                  kilos: kilos,
                  precioKilos: precioKilos,
                  precioDolar: precioDolar,
                );
                editarExportacion(exportacionActualizada);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void eliminarExportacion(Exportacion exportacion) async {
    try {
      // URL de la API para eliminar la exportación (reemplaza 'tu_api' con la URL de tu API)
      String url =
          'https://exportaciones.onrender.com/exportaciones/${exportacion.producto}';

      // Realiza la solicitud DELETE a la API
      final response = await http.delete(Uri.parse(url));

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // La exportación se eliminó correctamente
        print(
            'The Export with product ${exportacion.producto} was delete successfully.');
      } else {
        // Hubo un error al eliminar la exportación
        print('Error deleting the Export: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores
      print('Error deleting the Export: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
      ),
      body: FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Exportacion> exportaciones =
                snapshot.data as List<Exportacion>;
            return ListView.builder(
              itemCount: exportaciones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(exportaciones[index].producto),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exportaciones[index].kilos.toString()),
                      Text(exportaciones[index].precioKilos.toString()),
                      Text(exportaciones[index].precioDolar.toString()),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          mostrarVentanaEdicion(context, exportaciones[index]);
                          // Implementar la lógica para editar aquí
                          print('Edit');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          eliminarExportacion(exportaciones[index]);
                          // Implementar la lógica para eliminar aquí
                          print('Delete');
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
