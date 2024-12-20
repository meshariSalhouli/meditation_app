import 'package:flutter/material.dart';
import 'package:meditation_app/models/yoga.dart';
import 'package:meditation_app/services/clinet.dart';

class ExerciseProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  List<Exercise> get exercises => _exercises;
  bool get isLoading => _isLoading;

  Future<void> fetchExercises() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started

    try {
      final response = await Client.dio.get('/exercises');
      _exercises = (response.data as List)
          .map((data) => Exercise.fromJson(data))
          .toList();
    } catch (e) {
      print("Error fetching exercises: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Function to check if the next video can be played
  bool canPlayNextVideo(int index) {
    if (index == 0) return true; // The first video can always be played
    return _exercises[index - 1]
        .finished; // Check if the previous video is finished
  }

  // Function to mark an exercise as finished
  Future<void> markExerciseFinished(int exerciseId) async {
    try {
      await Client.dio.post('/exercises/$exerciseId');
      await fetchExercises(); // Refresh the exercises after marking one as finished
    } catch (e) {
      print("Error marking exercise as finished: $e");
    }
  }

  // Function to get an exercise by its ID
  Exercise getExerciseById(int id) {
    return _exercises.firstWhere((exercise) => exercise.id == id);
  }
}
