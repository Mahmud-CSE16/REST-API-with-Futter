import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:restapi/services/note_services.dart';
import 'package:restapi/views/note_list.dart';

void setupLocation(){
  GetIt.I.registerLazySingleton(() => NoteService()); 
}

void main() {
  setupLocation();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter REST API demo",
      theme: ThemeData(
        primarySwatch:Colors.blue,
      ),
      home: NoteList(),
    );
  }
}

