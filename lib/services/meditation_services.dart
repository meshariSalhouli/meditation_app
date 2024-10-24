// import 'dart:async';
// import "package:dio/dio.dart";
// import 'package:meditation_app/models/tip.dart';
// import 'package:meditation_app/services/clinet.dart';

// class MeditationServices {
//   Future<List<Tip>> getTips() async {
//     List<Tip> tip = [];
//     try {
//       Response response = await Client.dio.get('/pets');
//       tip = (response.data as List).map((tip) => Tip.fromJson(tip)).toList();
//     } on DioError catch (error) {
//       print(error);
//     }
//     return tip;
//   }

//   Future<Tip> createPet({required Tip tip}) async {
//     late Tip retrievedTip;
//     try {
//       FormData data = FormData.fromMap({
//         "text": tip.text,
//         "author": tip.author,
//        // "image": await MultipartFile.fromFile(
//           tip.image,
//         ),
//       });
//       Response response = await Client.dio.post('/pets', data: data);
//       retrievedTip = Tip.fromJson(response.data);
//     } on DioError catch (error) {
//       print(error);
//     }
//     return retrievedTip;
//   }

//   Future<Pet> updatePet({required Pet pet}) async {
//     late Pet retrievedPet;
//     try {
//       FormData data = FormData.fromMap({
//         "name": pet.name,
//         "age": pet.age,
//         "adopted": pet.adopted,
//         "gender": pet.gender,
//         "image": await MultipartFile.fromFile(
//           pet.image,
//         ),
//       });

//       Response response = await Client.dio.put('/pets/${pet.id}', data: data);
//       retrievedPet = Pet.fromJson(response.data);
//     } on DioError catch (error) {
//       print(error);
//     }
//     return retrievedPet;
//   }

//   Future<void> deletePet({required int petId}) async {
//     try {
//       await Client.dio.delete('/pets/${petId}');
//     } on DioError catch (error) {
//       print(error);
//     }
//   }

//   Future<Pet> adoptPet({required int petId}) async {
//     late Pet retrievedPet;
//     try {
//       Response response = await Client.dio.post('/pets/adopt/${petId}');
//       retrievedPet = Pet.fromJson(response.data);
//     } on DioError catch (error) {
//       print(error);
//     }
//     return retrievedPet;
//   }
// }
