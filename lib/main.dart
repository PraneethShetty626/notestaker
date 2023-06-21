import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notestaker/data_model.dart';
import 'package:notestaker/screens.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(221, 230, 237, 1),
      ),
      home: ChangeNotifierProvider(
        create: (context) => DataModel(),
        child: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    DataModel model = Provider.of<DataModel>(context, listen: false);
    return Scaffold(
      appBar: ScreenElements.appBar(model),
      body: ScreenElements.futureReadyBody(model),
    );
  }
}
