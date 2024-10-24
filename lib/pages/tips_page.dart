import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditation_app/services/clinet.dart';

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  Future<List<dynamic>> fetchTips() async {
    try {
      Response response = await Client.dio.get('/tips');
      return response.data;
    } catch (e) {
      return []; //Return empty list if there is an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //if there is no tips available
            return const Center(child: Text('No tips available.'));
          } else {
            final tips = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return _buildTipCard(tip);
                },
              ),
            );
          }
        },
      ),
    );
  }

  // Card for each tip
  Widget _buildTipCard(dynamic tip) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip['text'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'By ${tip['author']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      '${tip['upvotes'].length}',
                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.thumb_down, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    Text(
                      '${tip['downvotes'].length}',
                      style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
