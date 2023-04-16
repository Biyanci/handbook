import 'package:flutter/material.dart';

import '../models/notebook.dart';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({super.key});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  @override
  Widget build(BuildContext context) {
    Note? note;
    String title = "", content = "";
    var titleTextFieldContro = TextEditingController();
    var contentTextFieldContro = TextEditingController();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      note = ModalRoute.of(context)!.settings.arguments as Note;
      titleTextFieldContro.text = note.title;
      contentTextFieldContro.text = note.content;
    }

    var editPageAppbar = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        onPressed: () {
          note = Note(title, content, DateTime.now());
          Navigator.pop(context, note);
        },
      ),
      title: const Text(
        "Edit",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      ),
    );

    var saveFAB = FloatingActionButton(
      onPressed: () {
        note = Note(title, content, DateTime.now());
        Navigator.pop(context, note);
      },
      child: const Icon(Icons.save_outlined),
    );
    var titleEditingField = TextField(
      controller: titleTextFieldContro,
      maxLines: 1,
      onChanged: (value) {
        if (note != null) {
          note!.title = value;
        } else if (note == null) {
          title = value;
        }
      },
      decoration: const InputDecoration(
        labelText: "Title",
        border: UnderlineInputBorder(),
      ),
    );
    var contentEditingField = TextField(
      controller: contentTextFieldContro,
      minLines: 20,
      maxLines: null,
      onChanged: (value) {
        if (note != null) {
          note!.content = value;
        } else if (note == null) {
          content = value;
        }
      },
      decoration: const InputDecoration(border: InputBorder.none),
    );
    return Scaffold(
      appBar: editPageAppbar,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleEditingField,
              const SizedBox(
                height: 16,
              ),
              const Text("Content"),
              contentEditingField
            ],
          ),
        ),
      ),
      floatingActionButton: saveFAB,
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: bottomAppBar(),
    );
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      padding: const EdgeInsets.only(left: 4, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.list_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.mic_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
    );
  }
}
