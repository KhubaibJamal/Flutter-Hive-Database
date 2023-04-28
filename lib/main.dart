import 'package:flutter/material.dart';
import 'package:flutter_hive/Page/home_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'Models/notes_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var pathDirectory = await getApplicationDocumentsDirectory();
  Hive.init(pathDirectory.path);

  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>("notes");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Database Demo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
