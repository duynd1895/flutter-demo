import 'package:call_api/services/note_service.dart';
import 'package:call_api/views/note_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';



void setupLocator() {
   GetIt.I.registerLazySingleton(() => NoteService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}


