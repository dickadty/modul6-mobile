import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Game List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Daftar Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List dataGame = [];

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/games'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dataGame = data.take(20).toList();
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget _listItem(String url, String judul, String genre, String platform) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(url, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Genre: $genre",
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "Platform: $platform",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: dataGame.length,
          itemBuilder: (context, index) {
            return _listItem(
              dataGame[index]['thumbnail'] ?? "https://via.placeholder.com/150",
              dataGame[index]['title'] ?? 'Tidak ada judul',
              dataGame[index]['genre'] ?? 'Tidak ada genre',
              dataGame[index]['platform'] ?? 'Tidak ada platform',
            );
          },
        ),
      ),
    );
  }
}
