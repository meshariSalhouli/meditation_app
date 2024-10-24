import 'package:flutter/material.dart';

class MeditationProvider extends ChangeNotifier {
  List<String> meditation = [];

  String? _username;
  String? _password;
}
// Future<void> getPets() async {
//     meditation = await MeditationProvider().getPets();
//   }

//   void createPet(Pet pet) async {
//     Pet newPet = await PetServices().createPet(pet: pet);
//     pets.insert(0, newPet);
//     notifyListeners();
//   }

//   void updatePet(Pet pet) async {
//     Pet newPet = await PetServices().updatePet(pet: pet);
//     int index = pets.indexWhere((pet) => pet.id == newPet.id);
//     pets[index] = newPet;
//     notifyListeners();
//   }

//   void adoptPet(int petId) async {
//     Pet newPet = await PetServices().adoptPet(petId: petId);
//     int index = pets.indexWhere((pet) => pet.id == newPet.id);
//     pets[index] = newPet;
//     notifyListeners();
//   }

//   void deletePet(int petId) async {
//     await PetServices().deletePet(petId: petId);
//     pets.removeWhere((pet) => pet.id == petId);
//     notifyListeners();
//   }

// }
