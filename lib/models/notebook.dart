class Note {
  String title, content;

  DateTime createTime = DateTime.now(), updateTime;

  Note(this.title, this.content, this.updateTime);

  Note.fromJsonMap(Map<String, dynamic> jsonMap)
      : title = jsonMap["note_title"],
        content = jsonMap["note_content"],
        createTime = DateTime.parse(jsonMap["note_create_time"]),
        updateTime = DateTime.parse(jsonMap["note_create_time"]);

  void editNote(DateTime updateTime, {String? title, String? content}) {
    if (title != null) {
      this.title = title;
      this.updateTime = updateTime;
    }
    if (content != null) {
      this.content = content;
      this.updateTime = updateTime;
    }
  }

  Map<String, String> toJsonMap() {
    return {
      "note_title": title,
      "note_content": content,
      "note_create_time": getFormatedCreateTime(),
      "note_update_time": getFormatedUpdateTime()
    };
  }

  String getFormatedCreateTime() {
    String returnString = "${createTime.year}-";

    if (createTime.month < 10) {
      returnString += "0${createTime.month}-";
    } else if (createTime.month >= 10) {
      returnString += "${createTime.month}-";
    }

    if (createTime.day < 10) {
      returnString += "0${createTime.day}";
    } else if (createTime.day >= 10) {
      returnString += "${createTime.day}";
    }

    return returnString;
  }

  String getFormatedUpdateTime() {
    String returnString = "${updateTime.year}-";

    if (updateTime.month < 10) {
      returnString += "0${updateTime.month}-";
    } else if (updateTime.month >= 10) {
      returnString += "${updateTime.month}-";
    }

    if (updateTime.day < 10) {
      returnString += "0${updateTime.day}";
    } else if (updateTime.day >= 10) {
      returnString += "${updateTime.day}";
    }

    return returnString;
  }
}

class Notebook {
  String? title, synopsis;

  DateTime? createTime, updateTime;

  List<Note> notesContained = [];

  Notebook(this.title, this.synopsis, this.createTime, this.updateTime);

  Notebook.fromJsonMap(Map<String, dynamic> jsonMap) {
    title = jsonMap["notebook_title"];
    synopsis = jsonMap["notebook_synopsis"];
    createTime = DateTime.parse(jsonMap["notebook_create_time"]);
    updateTime = DateTime.parse(jsonMap["notebook_update_time"]);
    notesContained = fromDynamicToNote(jsonMap);
  }

  Map<String, dynamic> toJsonMap() {
    List<Map<String, String>> notesList = [];
    for (int i = 0; i < notesContained.length; i++) {
      notesList.add(notesContained[i].toJsonMap());
    }

    return {
      "notebook_title": title,
      "notebook_synopsis": synopsis,
      "notebook_create_time": getFormatedCreateTime(),
      "notebook_update_time": getFormatedUpdateTime(),
      "notes_contained": notesList,
    };
  }

  List<Note> fromDynamicToNote(Map<String, dynamic> jsonMap) {
    List<dynamic> jsonMapList = jsonMap["notes_contained"];
    List<Note> notesList = [];

    for (int i = 0; i < jsonMapList.length; i++) {
      notesList.add(Note.fromJsonMap(jsonMapList[i]));
    }

    return notesList;
  }

  String getFormatedCreateTime() {
    String returnString = "${createTime!.year}-";

    if (createTime!.month < 10) {
      returnString += "0${createTime!.month}-";
    } else if (createTime!.month >= 10) {
      returnString += "${createTime!.month}-";
    }

    if (createTime!.day < 10) {
      returnString += "0${createTime!.day}";
    } else if (createTime!.day >= 10) {
      returnString += "${createTime!.day}";
    }

    return returnString;
  }

  String getFormatedUpdateTime() {
    String returnString = "${updateTime!.year}-";

    if (updateTime!.month < 10) {
      returnString += "0${updateTime!.month}-";
    } else if (updateTime!.month >= 10) {
      returnString += "${updateTime!.month}-";
    }

    if (updateTime!.day < 10) {
      returnString += "0${updateTime!.day}";
    } else if (updateTime!.day >= 10) {
      returnString += "${updateTime!.day}";
    }

    return returnString;
  }
}
