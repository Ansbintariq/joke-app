import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  String name;
  String usdata;
  Detail({
    required this.name,
    required this.usdata,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
        ),
      ),
      body: Column(
        children: [
          Text(
            widget.usdata,
          )
        ],
      ),
    );
  }
}
