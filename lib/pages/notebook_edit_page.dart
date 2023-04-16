import 'package:flutter/material.dart';

class NotebookEditPage extends StatefulWidget {
  const NotebookEditPage({super.key});

  @override
  State<NotebookEditPage> createState() => _NotebookEditPageState();
}

class _NotebookEditPageState extends State<NotebookEditPage> {
  String? title, synopsis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: editPageAppbar(context),
      body: editPageBody(),
    );
  }

  Padding editPageBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Title",
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            onChanged: (value) {
              synopsis = value;
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Synopsis"),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  AppBar editPageAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "Create Notebook",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      ),
      actions: [
        createTextButton(context),
      ],
    );
  }

  TextButton createTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (title == null || synopsis == null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("字段为空"),
              content: const Text("请输入书名和简介"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("返回"),
                ),
              ],
            ),
          );
        } else if (title!.trim().isEmpty || synopsis!.trim().isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("字段为空"),
              content: const Text("请输入书名和简介"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("返回"),
                ),
              ],
            ),
          );
        } else {
          List<String> results = [title!, synopsis!];
          Navigator.pop(context, results);
        }
      },
      child: const Text(
        "Create",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
