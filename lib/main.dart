import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movie App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MyHomePage(title: 'Flutter Movie App'),
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
  TextEditingController moviecontroller = TextEditingController();
  var movie = "", year = "", genre = "", actors = "", posterlink = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movie App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Movie App'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                TextField(
                  controller: moviecontroller,
                  decoration: InputDecoration(
                      hintText: 'Type Movie Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(onPressed: _search, child: const Text("Search")),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(children: [
                      Image.network(posterlink, scale: 1.5,
                          errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/movie.png',
                          scale: 1.5,
                        );
                      }),
                      const SizedBox(height: 8),
                      Text(moviecontroller.text.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: (FontWeight.bold), fontSize: 24)),
                      Text('Year : $year'),
                      Text('Genre : $genre'),
                      Text('Actors : $actors'),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _search() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    var movie = (moviecontroller.text);
    var apiid = "94135625";
    var url = Uri.parse('https://www.omdbapi.com/?t=$movie&apikey=$apiid');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      progressDialog.dismiss();
      setState(() {
        posterlink = parsedJson['Poster'];
        movie = parsedJson['Title'];
        year = parsedJson['Year'];
        genre = parsedJson['Genre'];
        actors = parsedJson['Actors'];

        Fluttertoast.showToast(
            msg: "Succesfully Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);
      });
    } else {
      setState(() {
        const Text("No record");
      });
    }
  }
}
