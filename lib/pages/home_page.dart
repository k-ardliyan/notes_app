import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/pages/detail_page.dart';
import 'package:notes_app/db/notes_database.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  // search controller
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  NotesDatabase _db = NotesDatabase();
  Note note;
  int count = 0;
  int layoutColumn = 2;
  List<Note> noteList;
  List<Note> noteListPinned;
  List<Note> noteListNotPinned;
  int countPinned = 0;
  int countNotPinned = 0;

  // save layout column
  void saveLayoutColumn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('layoutColumn', layoutColumn);
  }

  // get layout column
  void getLayoutColumn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    layoutColumn = prefs.getInt('layoutColumn');
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
      getLayoutColumn();
    }

    Widget drawer() {
      return Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 42,
                          height: 42,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Text>[
                          Text(
                            'Simple Note App',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'by k-ardliyan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ListTile(
                    horizontalTitleGap: 0,
                    title: Text(
                      'v.1.0.0',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // icon menu to open drawer
            IconButton(
              padding: EdgeInsets.all(0),
              splashRadius: 24,
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            Expanded(
              child: AnimSearchBar(
                rtl: true,
                width: 400,
                textController: searchController,
                closeSearchOnSuffixTap: true,
                helpText: 'Cari judul note...',
                onSuffixTap: () {
                  setState(() {
                    searchController.clear();
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget noNote() {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        sliver: SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Tidak ada note',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    Widget note(notes, countNotes) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: layoutColumn,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childCount: countNotes,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                color: notes[index].isPinned == 1
                    ? Colors.blue[100]
                    : Colors.blueGrey[50],
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (notes[index].title != '')
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '${notes[index].title}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${notes[index].content}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onLongPress: () {
                // show dialog use list tile to show option
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Pilih opsi'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.push_pin),
                              title: notes[index].isPinned == 1
                                  ? Text('Hapus dari pin')
                                  : Text('Pin'),
                              onTap: () {
                                setState(() {
                                  if (notes[index].isPinned == 1) {
                                    notes[index].isPinned = 0;
                                  } else {
                                    notes[index].isPinned = 1;
                                  }
                                  editNote(notes[index]);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.archive),
                              title: notes[index].isArchived == 1
                                  ? Text('Hapus dari arsip')
                                  : Text('Arsipkan'),
                              onTap: () {
                                setState(() {
                                  if (notes[index].isArchived == 1) {
                                    notes[index].isArchived = 0;
                                  } else {
                                    notes[index].isArchived = 1;
                                  }
                                  editNote(notes[index]);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Hapus'),
                              onTap: () {
                                // alert
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Hapus note?'),
                                      content: Text(
                                          'Apakah anda yakin ingin menghapus note ini?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Batal'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Hapus'),
                                          onPressed: () {
                                            deleteNote(notes[index]);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              onTap: () async {
                var note =
                    await navigateToDetail(context, this.noteList[index]);
                if (note != null) editNote(note);
              },
            );
          },
        ),
      );
    }

    // Scaffold
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var note = await navigateToDetail(context, null);
          if (note != null) addNote(note);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6,
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.archive),
                onPressed: () {
                  Navigator.pushNamed(context, '/archive');
                },
              ),
              IconButton(
                icon: layoutColumn == 2
                    ? Icon(Icons.view_module)
                    : Icon(Icons.view_list),
                onPressed: () {
                  setState(() {
                    layoutColumn = layoutColumn == 2 ? 1 : 2;
                    saveLayoutColumn();
                  });
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            if (countPinned > 0)
              SliverStickyHeader.builder(
                builder: (context, state) => Container(
                  height: 40.0,
                  color: (state.isPinned ? Colors.pink : Colors.lightBlue)
                      .withOpacity(1.0 - state.scrollPercentage),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pinned Notes',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                sliver: note(noteListPinned, countPinned),
              ),
            SliverStickyHeader.builder(
              builder: (context, state) => Container(
                height: 40.0,
                color: (state.isPinned ? Colors.lightBlue : Colors.lightBlue)
                    .withOpacity(1.0 - state.scrollPercentage),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Notes',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              sliver: countNotPinned > 0
                  ? note(noteListNotPinned, countNotPinned)
                  : noNote(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Note> navigateToDetail(BuildContext context, Note note) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage(note);
    }));
    return result;
  }

  Future addNote(Note note) async {
    int result = await _db.insert(note);
    if (result != 0) {
      updateListView();
    }
  }

  Future editNote(Note note) async {
    int result = await _db.update(note);
    if (result != 0) {
      updateListView();
    }
  }

  Future deleteNote(Note note) async {
    int result = await _db.delete(note.id);
    if (result != 0) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = _db.initDb();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = _db.getNotes();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          this.noteListNotPinned =
              noteList.where((note) => note.isPinned == 0).toList();
          this.noteListPinned =
              noteList.where((note) => note.isPinned == 1).toList();
          this.countNotPinned = noteListNotPinned.length;
          this.countPinned = noteListPinned.length;
        });
      });
    });
  }
}
