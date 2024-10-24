import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  File? _image;
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Row for profile picture and welcome text
            Row(
              children: [
                //Using image as a button
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.blue[200]),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.blue[200]),
                          width: 200,
                          height: 200,
                          child:
                              Image.network("https://i.sstatic.net/l60Hf.png"),
                        ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Welcome, ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            //Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //4 cards here
          ],
        ),
      ),
    );
  }
}
