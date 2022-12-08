// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:joke_app/Detail.dart';
import 'package:joke_app/model/nation_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  List<CountryModel> coutryRecordList = [];
  late CountryModel myModel;
  @override
  void initState() {
    super.initState();
    getDatafromApi();
  }

  getDatafromApi() async {
    try {
      setState(() {
        loading = true;
      });
      final responce = await http.get(
        Uri.parse(
            'https://datausa.io/api/data?drilldowns=Nation&measures=Population'),
      );
      print(responce.statusCode);
      var body = jsonDecode(responce.body);
      if (responce.statusCode == 200) {
        List data = body['data'].toList();

        for (var i = 0; i < data.length; i++) {
          var model = CountryModel(
            id: data[i]['ID Nation'].toString(),
            nation: data[i]['Nation'].toString(),
            slug: data[i]['Slug Nation'].toString(),
            idYear: data[i]['ID Year'].toString(),
            population: data[i]['Population'].toString(),
            year: data[i]['Year'].toString(),
          );
          coutryRecordList.add(model);
          print(coutryRecordList);
        }
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      print("Catch e: $e");
      setState(() {
        loading = false;
      });
    }
  }

  TextEditingController searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("wer");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Scren'),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchcontroller,
          ),
          Container(
              child: loading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: coutryRecordList.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => Detail(
                                      name: coutryRecordList[index].population,
                                      usdata: coutryRecordList[index].nation,
                                    ))));
                          },
                          child: Container(
                              color: Colors.green,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(coutryRecordList[index].year),
                                  Text(coutryRecordList[index].population),
                                ],
                              )),
                        );
                      }),
                    )),
        ],
      ),
    );
  }
}

Widget card(
    {required context,
    required countryName,
    required population,
    required year}) {
  return Container(
    padding: const EdgeInsets.all(30),
    margin: const EdgeInsets.all(50),
    height: MediaQuery.of(context).size.height,
    width: 500,
    color: Colors.blueGrey,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Nation:'),
            Text('$countryName'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Population:'),
            Text('$population'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Year:'),
            Text('$year'),
          ],
        ),
      ],
    ),
  );
}
