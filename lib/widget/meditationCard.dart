// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:meditation_app/providers/MeditationProvider.dart';
// import 'package:provider/provider.dart';

// class Meditationcard extends StatelessWidget {
//   final Tip tip;
//   const Meditationcard({Key? key, required this.tip}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           Expanded(
//             child: Image.network(
//               tip.image,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(tip.username),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             GoRouter.of(context).push('/update/${tip.id}');
//                           },
//                           icon: const Icon(Icons.edit)),
//                       IconButton(
//                           onPressed: () {
//                             Provider.of<MeditationProvider>(context,
//                                     listen: false)
//                                 tip.delete(tip.id!);
//                           },
//                           icon: const Icon(
//                             Icons.delete,
//                             color: Colors.red,
//                           ))
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
