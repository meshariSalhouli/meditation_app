import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
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
                GestureDetector(
                  onTap: () {
                    context.push('/edit-profile');
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/Images/undraw_Pic_profile_re_7g2h.png'),
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
