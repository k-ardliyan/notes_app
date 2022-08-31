import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/db/notes_database.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  NotesDatabase _db = NotesDatabase();
  Note note;
  int countArchive = 0;
  List<Note> notesListArchive;

  @override
  Widget build(BuildContext context) {
    if (notesListArchive == null) {
      notesListArchive = List<Note>();
      updateListView();
    }

    Widget note() {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childCount: countArchive,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                color: notesListArchive[index].isPinned == 1
                    ? Colors.red[100]
                    : Colors.blueGrey[50],
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (notesListArchive[index].title != '')
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '${notesListArchive[index].title}',
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
                        '${notesListArchive[index].content}',
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
                              leading: Icon(Icons.archive),
                              title: notesListArchive[index].isArchived == 1
                                  ? Text('Hapus dari arsip')
                                  : Text('Arsipkan'),
                              onTap: () {
                                setState(() {
                                  notesListArchive[index].isArchived =
                                      notesListArchive[index].isArchived == 1
                                          ? 0
                                          : 1;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Note telah kembali ke daftar note'),
                                    duration: Duration(seconds: 1),
                                  ));
                                  editNote(notesListArchive[index]);
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
                                            deleteNote(notesListArchive[index]);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Note telah dihapus dari daftar note'),
                                              duration: Duration(seconds: 1),
                                            ));
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Edit Note hanya bisa dilakukan di halaman utama',
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    Widget noNote() {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Tidak ada note yang ditampilkan',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverStickyHeader.builder(
              builder: (context, state) => Container(
                height: 40.0,
                color: Colors.grey[200],
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      //back with note
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    ),
                    Text(
                      'Archive Notes',
                    ),
                  ],
                ),
              ),
              sliver: countArchive == 0 ? noNote() : note(),
            ),
          ],
        ),
      ),
    );
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
          this.notesListArchive =
              noteList.where((note) => note.isArchived == 1).toList();
          this.countArchive = notesListArchive.length;
        });
      });
    });
  }
}
