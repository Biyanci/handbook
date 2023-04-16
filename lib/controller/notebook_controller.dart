import 'dart:io';
import '/models/notebook.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

///getFile, readFile, writeFile
///appDocumentDir(user-generated): /data/user/0/com.example.hand_book_test/app_flutter
///for notebooks: ~/notebooks
///for todos: ~/todos
///appSurportDir(isn't user-generated): /data/user/0/com.example.hand_book_test/files
///for notebooks: ~/notebooks
///for todos: ~/todos
class NotebookController {
  static Future<String> _getAppDocDir() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  ///返回notebooks所在目录，末尾没带pathSeparator("/" or "\\")
  static Future<String> _getUserNotebooksDir() async {
    return "${await _getAppDocDir()}${Platform.pathSeparator}notebooks";
  }

  /*
  static String getExampleNotebooksDir(){
    
  }*/

  ///返回所有notebook
  static Future<List<Notebook>> getUserNotebooks() async {
    String notebookDir = await NotebookController._getUserNotebooksDir();

    if (await Directory(notebookDir).exists() == false) {
      await Directory(notebookDir).create(recursive: true);
    }

    var notebookFileList = Directory(notebookDir).list();

    List<Notebook> notebookList = [];

    await for (var element in notebookFileList) {
      var jsonText = await File(element.path).readAsString();
      var jsonMap = json.decode(jsonText);
      var notebookCache = Notebook.fromJsonMap(jsonMap);
      notebookList.add(notebookCache);
    }

    return notebookList;
  }

  /*
  static List<File> getExampleNotebooks(){

  }*/

  ///创建notebook并写入到json，成功返回创建的Notebook对象，否则返回null
  ///必须检查是否为空
  static Future<Notebook?> createUserNotebook(
      String title, String synopsis) async {
    var notebook = Notebook(title, synopsis, DateTime.now(), DateTime.now());
    var jsonMap = notebook.toJsonMap();

    String notebookDir =
        "${await _getAppDocDir()}${Platform.pathSeparator}notebooks${Platform.pathSeparator}$title.json";

    String jsonText = json.encode(jsonMap);
    var jsonFile = await File(notebookDir).create(recursive: true);

    if (await jsonFile.exists() == true) {
      await jsonFile.writeAsString(jsonText);
    } else if (await jsonFile.exists() == false) {
      return null;
    }

    return notebook;
  }

  ///更新user笔记本，传入需要更新的笔记本，更新成功返回true，失败返回false
  ///notebook有更改时使用
  static Future<bool> updateUserNotebook(
      {required Notebook updateNotebook}) async {
    var jsonMap = updateNotebook.toJsonMap();

    String notebookDir =
        "${await _getAppDocDir()}${Platform.pathSeparator}notebooks${Platform.pathSeparator}${updateNotebook.title}.json";

    String jsonText = json.encode(jsonMap);
    var jsonFile = await File(notebookDir).create(recursive: true);

    if (await jsonFile.exists() != true) {
      return false;
    }
    await jsonFile.writeAsString(jsonText);
    return true;
  }

  /*
  static void createExampleNotebook(){

  }*/
}
