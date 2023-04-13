// import 'package:flutter/material.dart';

// import '../model/resep_model.dart';

// class DetailResep extends StatelessWidget {
//   final Resep resep;
//   DetailResep({required this.resep});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(resep.name),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 300,
//               width: double.infinity,
//               child: Image.memory(
//                 resep.picture,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Text(resep.name),
//             Text(resep.ingredients),
//             Text(resep.step),
//           ],
//         ),
//       ),
//     );
//   }
// }
