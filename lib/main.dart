import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'pages/notebook_edit_page.dart';
import 'models/notebook.dart';
import 'controller/notebook_controller.dart';
import 'pages/main_page.dart';
import 'pages/note_edit_page.dart';
import 'pages/setting_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Notebook> notebookList = await NotebookController.getUserNotebooks();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  runApp(MainApp(
    notebookList: notebookList,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.notebookList});
  final List<Notebook> notebookList;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        "MainPage": (context) => MainPage(
              notebookList: notebookList,
            ),
        "NoteEditPage": (context) => const NoteEditPage(),
        "SettingPage": (context) => const SettingPage(),
        "NotebookEditPage": (context) => const NotebookEditPage()
      },
      initialRoute: "MainPage",
    );
  }
}
