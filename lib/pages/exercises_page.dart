import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditation_app/services/clinet.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tipController = TextEditingController();
  bool isSubmitting = false;
  final String token = 'userTokenHere'; // Replace with actual token
  final String currentUserId = 'currentUserId'; // Replace with actual user ID

  Future<List<dynamic>> fetchExercises() async {
    try {
      Response response = await Client.dio.get('/yoga');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchMyExercises() async {
    try {
      Response response = await Client.dio.get('/yoga',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      List<dynamic> allExercises = response.data;
      return allExercises
          .where((tip) => tip['authorId'] == currentUserId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  int _wordCount(String text) {
    return text.split(' ').where((word) => word.isNotEmpty).length;
  }

  Future<void> submitExercises() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isSubmitting = true;
      });

      await Client.dio.post(
        '/exersice',
        data: {
          'text': _tipController.text,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tip created successfully')),
      );
      _tipController.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create tip')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('exercises'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "All Exercises"),
              Tab(text: "My Exercises"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllExercisesTab(),
            _buildMyTipsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllExercisesTab() {
    return Column(
      children: [
        _buildExercisesForm(),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: fetchExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No exercises available.'));
              } else {
                final exercises = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return _buildexerciseCard(exercise);
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyTipsTab() {
    return FutureBuilder<List<dynamic>>(
      future: fetchMyExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tips created by you.'));
        } else {
          final exercises = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return _buildexerciseCard(exercise);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildExercisesForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _tipController,
              decoration: InputDecoration(
                labelText: 'Create a Tip (Max 100 words)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              maxLength: 100,
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tip cannot be empty';
                }
                if (_wordCount(value) > 100) {
                  return 'Tip cannot exceed 100 words';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            isSubmitting
                ? CircularProgressIndicator()
                : Center(
                    child: ElevatedButton(
                      onPressed: submitExercises,
                      child: Text('Submit Tip'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildexerciseCard(dynamic tip) {
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
              style: const TextStyle(
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
