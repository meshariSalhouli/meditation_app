// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

// class HomePage extends StatelessWidget {
//   File? _image;
//   final _picker = ImagePicker();

//   @override
//   Widget build(BuildContext context) {

//     // List of card data
//     final List<Map<String, dynamic>> cards = [
//       {"name": "Tips", "icon": Icons.lightbulb, "route": "/tips"},
//       {"name": "Yoga", "icon": Icons.self_improvement, "route": "/yoga"},
//       {"name": "Music", "icon": Icons.music_note, "route": "/music"},
//       {"name": "Meditation", "icon": Icons.spa, "route": "/meditation"},
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home page"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //Row for profile picture and welcome text
//             Row(
//               children: [
//                 //Using image as a button
//                 Container(
//                   width: 100,
//                   height: 100,
//                   margin: const EdgeInsets.only(top: 20),
//                   decoration: BoxDecoration(color: Colors.blue[200]),
//                   child: _image != null
//                       ? Image.file(
//                           _image!,
//                           width: 200.0,
//                           height: 200.0,
//                           fit: BoxFit.fitHeight,
//                         )
//                       : Container(
//                           decoration: BoxDecoration(color: Colors.blue[200]),
//                           width: 200,
//                           height: 200,
//                           child:
//                               Image.network("https://i.sstatic.net/l60Hf.png"),
//                         ),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "Welcome, ",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             //Search bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             //4 gridview cards with gestures

//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: cards.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       GoRouter.of(context)
//                           .go(cards[index]['route']); // Navigate when tapped
//                     },
//                     child: Card(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                       elevation: 5,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(cards[index]['icon'],
//                               size: 50, color: Colors.blue),
//                           const SizedBox(height: 10),
//                           Text(
//                             cards[index]['name'],
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
            // Row for profile picture and welcome text
            Row(
              children: [
                // Using image as a button
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

            // Search bar
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

            //Gridview for cards
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  //Card 1 Tips
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/tips');
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lightbulb, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text(
                            'Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Card 2 Yoga
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go('/yoga');
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.self_improvement,
                              size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text(
                            'Yoga',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Card 3 Music
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go('/music');
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.music_note, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text(
                            'Music',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Card 4 Meditation
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go('/meditation');
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.spa, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text(
                            'Meditation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
