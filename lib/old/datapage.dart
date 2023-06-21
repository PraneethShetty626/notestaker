// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:localstorage/localstorage.dart';
// import 'package:notestaker/expandable_text_button.dart';

// class DataPage extends StatefulWidget {
//   final LocalStorage storage;
//   const DataPage(this.storage, {super.key});

//   @override
//   State<DataPage> createState() => _DataPageState();
// }

// class _DataPageState extends State<DataPage> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active ||
//             snapshot.connectionState == ConnectionState.done) {
//           //
//           // Handle error later
//           if (snapshot.hasError) {
//             return const Text('Error');
//           } else if (snapshot.hasData) {
//             //
//             Map<String, dynamic>? data = snapshot.data;
//             data ??= {};

//             if (data.isNotEmpty) {
//               List<dynamic> datalist = data['datalist'];

//               int l = datalist.length - 1;

//               return Column(
//                 children: [
//                   Expanded(
//                     // height: 700,
//                     child: ListView.builder(
//                       reverse: true,
//                       itemBuilder: (context, index) {
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.80,
//                               padding: const EdgeInsets.all(10),
//                               margin: const EdgeInsets.all(10),
//                               decoration: const BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20.0)),
//                                 gradient: LinearGradient(
//                                     colors: [
//                                       Color.fromARGB(255, 255, 254, 254),
//                                       Color.fromARGB(255, 255, 255, 255),
//                                       Color.fromARGB(255, 233, 234, 236)
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey,
//                                     blurRadius: 12,
//                                     offset: Offset(0, 6),
//                                   ),
//                                 ],
//                               ),
//                               child: InkWell(
//                                 onDoubleTap: () {
//                                   Clipboard.setData(ClipboardData(
//                                     text: datalist[l - index],
//                                   )).then((value) => ScaffoldMessenger.of(
//                                           context)
//                                       .showSnackBar(const SnackBar(
//                                           duration: Duration(milliseconds: 200),
//                                           content: Text(
//                                               "Text copied to clipboard"))));
//                                 },
//                                 child: SelectableText(
//                                   datalist[l - index],
//                                   textAlign: TextAlign.justify,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.10,
//                               child: IconButton(
//                                 icon: const Icon(Icons.delete),
//                                 onPressed: () {
//                                   datalist.removeAt(l - index);
//                                   widget.storage
//                                       .setItem('datalist', datalist)
//                                       .then((value) => ScaffoldMessenger.of(
//                                               context)
//                                           .showSnackBar(const SnackBar(
//                                               duration:
//                                                   Duration(milliseconds: 200),
//                                               content: Text(
//                                                   "Text deleted successfully"))));
//                                 },
//                               ),
//                             )
//                           ],
//                         );
//                       },
//                       // reverse: true,
//                       itemCount: datalist.length,
//                     ),
//                   ),
//                   ExpandableTextField(datalist, widget.storage)
//                 ],
//               );
//             } else {
//               return Center(child: ExpandableTextField([], widget.storage));
//             }
//           } else {
//             return const Text('Empty data');
//           }
//         }

//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//       stream: widget.storage.stream,
//     );
//   }
// }
