// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:localstorage/localstorage.dart';
// import 'package:notestaker/datapage.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final LocalStorage _storage = LocalStorage('db');
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       builder: (context, snapshot) {
//         if (snapshot.data == true) {
//           return Scaffold(
//             body: DataPage(_storage),
//           );
//         }
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//       future: _storage.ready,
//     );
//   }
// }
