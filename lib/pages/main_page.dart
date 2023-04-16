import 'package:flutter/material.dart';
import '/controller/notebook_controller.dart';
import '/models/notebook.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.notebookList});
  final List<Notebook> notebookList;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> notesPageScaffoldKey =
      GlobalKey<ScaffoldState>();
  final _appBarTitles = ["Notebook", "Todos", "Calendar"];

  int _selectedPageIndex = 0;

  int _selectedBookIndex = 0;

  ///destination选择时的行为
  void _onDesSelected(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    notesPageScaffoldKey.currentState!.closeDrawer();
  }

  void _onBookSelected(int index) {
    if (index < widget.notebookList.length) {
      setState(() {
        _selectedBookIndex = index;
      });
    } else if (index == widget.notebookList.length) {
    } else if (index == widget.notebookList.length + 1) {
      Navigator.pushNamed(context, "SettingPage");
    }

    notesPageScaffoldKey.currentState!.closeDrawer();
  }

  ///打开navDrawer
  void _openNavDrawer() {
    notesPageScaffoldKey.currentState!.openDrawer();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        key: notesPageScaffoldKey,
        appBar: mainAppBar(),
        drawer: navDrawer(widget.notebookList),
        bottomNavigationBar: bottomNavBar(),
        body: pages[_selectedPageIndex],
        floatingActionButton: FABs(context)[_selectedPageIndex]);
  }

  List<FloatingActionButton?> FABs(BuildContext context) {
    var notebookPageFAB = FloatingActionButton(
      onPressed: () async {
        Note? newNote =
            await Navigator.pushNamed(context, "NoteEditPage") as Note?;
        if (newNote != null) {
          setState(() {
            widget.notebookList[_selectedBookIndex].notesContained.add(newNote);
          });
          NotebookController.updateUserNotebook(
              updateNotebook: widget.notebookList[_selectedBookIndex]);
        }
      },
      child: const Icon(Icons.edit_outlined),
    );
    var todoPageFAB = FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    );
    if (widget.notebookList.isEmpty) {
      return [null, todoPageFAB, null];
    }
    return [notebookPageFAB, todoPageFAB, null];
  }

  List<Widget> get pages {
    var noNotebookView = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No notebook found."),
          const Text("Push the button below to create new one."),
          ElevatedButton.icon(
            onPressed: () async {
              var results =
                  await Navigator.pushNamed(context, "NotebookEditPage")
                      as List<String>?;
              if (results != null) {
                var newNotebook = await NotebookController.createUserNotebook(
                    results[0], results[1]);
                setState(() {
                  widget.notebookList.add(newNotebook!);
                });
              }
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Create New Notebook"),
          ),
        ],
      ),
    );
    if (widget.notebookList.isEmpty) {
      return [
        noNotebookView,
        Center(child: Text(_appBarTitles[_selectedPageIndex])),
        Center(child: Text(_appBarTitles[_selectedPageIndex]))
      ];
    }

    var noNoteView = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("No note found."),
          Text("Push the bottom-right button to create new one."),
        ],
      ),
    );
    if (widget.notebookList[_selectedBookIndex].notesContained.isEmpty) {
      return [
        noNoteView,
        Center(child: Text(_appBarTitles[_selectedPageIndex])),
        Center(child: Text(_appBarTitles[_selectedPageIndex]))
      ];
    }

    var notebookNotesView = ListView(
      padding: const EdgeInsets.only(left: 16, right: 16),
      itemExtent: 88,
      children: widget.notebookList[_selectedBookIndex].notesContained
          .map<Widget>((item) {
        return noteCard(item);
      }).toList(),
    );
    return [
      notebookNotesView,
      Center(child: Text(_appBarTitles[_selectedPageIndex])),
      Center(child: Text(_appBarTitles[_selectedPageIndex]))
    ];
  }

  NavigationBar bottomNavBar() {
    return NavigationBar(
      selectedIndex: _selectedPageIndex,
      onDestinationSelected: _onDesSelected,
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.book_outlined), label: "Notebook"),
        NavigationDestination(icon: Icon(Icons.check_outlined), label: "Todos"),
        NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined), label: "Calendar"),
      ],
    );
  }

  ///todo:根据选择的destination更改Drawer
  ///Notes界面:显示已经创建的书,在标题栏添加创建书的按钮
  ///Todo界面:显示已经创建的待办列表，在标题栏添加创建列表的按钮
  ///calendar界面:显示日视图，周视图，月视图以及仿Google日历的日程视图，标题栏不显示按钮
  NavigationDrawer navDrawer(List<Notebook> notebookList) {
    var drawerHeadlines = [
      notebookDrawerHeadline(notebookList),
      todosDrawerHeadline(),
      calendarDrawerHeadline()
    ];
    List<Widget> drawerChildren = [drawerHeadlines[_selectedPageIndex]];
    if (_selectedPageIndex == 0) {
      drawerChildren += notebookList.map<Widget>((item) {
        return NavigationDrawerDestination(
            icon: const Icon(Icons.book_outlined),
            label: SizedBox(
              width: 200,
              child: Text(
                item.title!,
                overflow: TextOverflow.ellipsis,
              ),
            ));
      }).toList();
    } else if (_selectedPageIndex == 1) {
    } else if (_selectedPageIndex == 2) {}

    drawerChildren += [
      const Divider(
        indent: 28,
        endIndent: 28,
      ),
      const NavigationDrawerDestination(
          icon: Icon(Icons.dark_mode_outlined), label: Text("DarkMode")),
      const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined), label: Text("Settings")),
    ];

    return NavigationDrawer(
      selectedIndex: _selectedBookIndex,
      onDestinationSelected: _onBookSelected,
      children: drawerChildren,
    );
  }

  ///todo:实现搜索方法
  AppBar mainAppBar() {
    return AppBar(
      leading:
          IconButton(onPressed: _openNavDrawer, icon: const Icon(Icons.menu)),
      title: Text(_appBarTitles[_selectedPageIndex]),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
    );
  }

  ///显示note概览的card
  Widget noteCard(Note note) {
    return Card(
      child: InkWell(
        onTap: () async {
          var noteCache = await Navigator.pushNamed(context, "NoteEditPage",
              arguments: note) as Note?;
          if (noteCache != null) {
            setState(() {
              note = noteCache;
            });
            NotebookController.updateUserNotebook(
                updateNotebook: widget.notebookList[_selectedBookIndex]);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              noteTitle(note),
              noteSubtitle(note),
              noteLastEditTime(note)
            ],
          ),
        ),
      ),
    );
  }

  ///noteCard中显示note标题的widget
  Text noteTitle(Note note) {
    return Text(
      note.title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: const ColorScheme.light().onSurfaceVariant,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  ///noteCard中显示note副标题的widget
  Text noteSubtitle(Note note) {
    return Text(
      note.content,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey[800],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  ///noteCard中显示note更新时间的widget
  Row noteLastEditTime(Note note) {
    return Row(
      children: [
        const Icon(
          Icons.refresh_outlined,
          size: 12,
          weight: 500,
        ),
        const SizedBox(width: 4, height: 12),
        Text(
          note.getFormatedUpdateTime(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget notebookDrawerHeadline(List<Notebook> notebookList) {
    return Container(
      height: 56,
      width: 336,
      padding: const EdgeInsets.only(top: 2, left: 28, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Notebook",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const ColorScheme.light().onSurfaceVariant,
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                var results =
                    await Navigator.pushNamed(context, "NotebookEditPage")
                        as List<String>?;
                if (results != null) {
                  var newNotebook = await NotebookController.createUserNotebook(
                      results[0], results[1]);
                  setState(() {
                    widget.notebookList.add(newNotebook!);
                  });
                }
              },
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
    );
  }

  Widget todosDrawerHeadline() {
    return Container(
      height: 56,
      width: 336,
      padding: const EdgeInsets.only(top: 2, left: 28, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Todos",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const ColorScheme.light().onSurfaceVariant,
              ),
            ),
          ),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.add_circle_outline))
        ],
      ),
    );
  }

  Widget calendarDrawerHeadline() {
    return Container(
      height: 56,
      width: 336,
      padding: const EdgeInsets.only(top: 20, left: 28),
      child: Text(
        "Calendar",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const ColorScheme.light().onSurfaceVariant,
        ),
      ),
    );
  }
}
