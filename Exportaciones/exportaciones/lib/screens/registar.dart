import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Dolar {
  // ignore: non_constant_identifier_names
  final String valor; //final que en tiempo de ejecucion no cambia
  // ignore: non_constant_identifier_names
  final String unidad;

  Dolar(
      // ignore: non_constant_identifier_names
      {required this.valor,
      // ignore: non_constant_identifier_names
      required this.unidad});

  factory Dolar.fromJson(Map<String, dynamic> json) {
    return Dolar(
        valor: json['valor'],
        unidad: json['unidad']);
  }
}

//Incorporar Future para traer la api
Future<String> fetchCurrentPrice() async {
  final response = await http.get(Uri.parse('https://www.datos.gov.co/resource/mcec-87by.json'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      // Obtener el último valor registrado
      var latestValue = data.first;
      return latestValue['valor'];
    } else {
      throw Exception('no data available');
    }
  } else {
    throw Exception('data loading failed');
  }
}










class Http{
  static String url ="https://exportaciones.onrender.com/exportaciones";
  static postUsarios(Map usuario) async{
    try {
      final res =await http.post(
        Uri.parse(url),
        headers:{
          'content-Type':'application/json'
        },
        body:json.encode(usuario),
      );
      if(res.statusCode==200){
        var data=jsonDecode(res.body.toString());
        print(data);
        
      }else{
        print('failure in the insertion');
      }
    } catch (e) {
      print(e.toString());
    }
  } 
}

class Registrar extends StatefulWidget {
  const Registrar({super.key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

TextEditingController producto= TextEditingController();
TextEditingController kilos= TextEditingController();
TextEditingController precioKilos = TextEditingController();
TextEditingController precioDolar= TextEditingController();


class _RegistrarState extends State<Registrar> {
  @override
  void initState() {
    super.initState();
    // Llamar a la función para cargar el valor del precio actual
    loadCurrentPrice();
  }

  Future<void> loadCurrentPrice() async {
    try {
      // Obtener el precio actual
      var currentPrice = await fetchCurrentPrice();
      setState(() {
        // Asignar el precio actual al controlador
        precioDolar.text = currentPrice;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: producto,
              decoration: const InputDecoration(hintText: 'Product'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: kilos,
              decoration: const InputDecoration(hintText: 'Kilos'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: precioKilos,
              decoration: const InputDecoration(hintText: 'Price per Kilo '),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: precioDolar,
              decoration: const InputDecoration(hintText: 'Present price'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                var usuario = {
                  "producto": producto.text,
                  "kilos": kilos.text,
                  "precioKilos": precioKilos.text,
                  "precioDolar": precioDolar.text
                };
                print(usuario);
                Http.postUsarios(usuario);
              },
              icon: const Icon(Icons.maps_ugc_sharp),
              label: const Text('Register'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
