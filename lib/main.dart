import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joke_app/datapass.dart';
import 'package:joke_app/model/joke_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke ',
      home: Home(),
    );
  }
}

class Joke extends StatefulWidget {
  const Joke({super.key});

  @override
  State<Joke> createState() => _JokeState();
}

class _JokeState extends State<Joke> {
  bool loading = true;
  bool show = false;
  late JockModel myModel;
  getDatafromApi() async {
    final responce = await http
        .get(Uri.parse("https://official-joke-api.appspot.com/random_joke"));

    if (responce.statusCode == 200) {
      print(responce.statusCode);
      var body = jsonDecode(responce.body);

      setState(() {
        // print("running");
        myModel = JockModel(
            jokeId: body["id"].toString(),
            // // // // convert string to int      int.parse(myModel.jokeId),
            jokeType: body["type"].toString(),
            setup: body["setup"].toString(),
            puchline: body["punchline"].toString());
        loading = false;
        print(myModel.setup);
      });
    }
  }

  @override
  void initState() {
    getDatafromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.arrow_back),
                    Icon(Icons.settings),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 100,
                  width: 100,
                  color: const Color.fromARGB(255, 194, 193, 190),
                  child: const Icon(
                    Icons.mic,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 250,
                  width: 250,
                  color: const Color.fromARGB(255, 212, 168, 164),
                  child: myModel.puchline == null
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(myModel.setup.toString()),
                            show == true
                                ? Text(myModel.puchline.toString())
                                : const SizedBox(
                                    height: 10,
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            show = false;
                            getDatafromApi();
                          });
                        },
                        child: const Text("New joke")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (show == false) {
                              show = true;
                            } else {
                              show = false;
                            }
                          });
                        },
                        child: const Text("Answer")),
                  ],
                ),
              ],
            ),
    );
  }
}
