import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/providers/exercisesProvider.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  void initState() {
    super.initState();
    // Fetch exercises on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().fetchExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Videos'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.yellow],
          ),
        ),
        child: exerciseProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: exerciseProvider.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exerciseProvider.exercises[index];
                  return ListTile(
                    title: Text(
                      exercise.title,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onTap: exerciseProvider.canPlayNextVideo(index)
                        ? () {
                            context.push('/video/${exercise.id}');
                          }
                        : null,
                  );
                },
              ),
      ),
    );
  }
}
