import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/pages/detail_page.dart';
import 'package:notes_app/db/notes_database.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

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
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
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
                    leading: Icon(Icons.archive),
                    horizontalTitleGap: 0,
                    title: Text('Archive'),
                    onTap: () {
                      Navigator.pushNamed(context, '/archive');
                    },
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

    Widget note() {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childCount: count,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                color: Colors.orange[300],
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: '${noteList[index].title}',
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
                        '${noteList[index].content}',
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
                              title: Text('Pin'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.archive),
                              title: Text('Archive'),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
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
        color: Colors.grey,
        shape: CircularNotchedRectangle(),
        child: IconTheme(
          data: IconThemeData(
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverStickyHeader.builder(
            //   builder: (context, state) => Container(
            //     height: 40.0,
            //     color: (state.isPinned ? Colors.pink : Colors.lightBlue)
            //         .withOpacity(1.0 - state.scrollPercentage),
            //     padding: EdgeInsets.symmetric(horizontal: 16.0),
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       'Pinned Notes',
            //       style: const TextStyle(color: Colors.white),
            //     ),
            //   ),
            //   sliver: note(),
            // ),
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
              sliver: note(),
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
        });
      });
    });
  }
}
