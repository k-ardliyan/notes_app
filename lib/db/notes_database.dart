import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase {
  static NotesDatabase _notesDatabase;
  // static Database _database;
  NotesDatabase._createObject();

  factory NotesDatabase() {
    if (_notesDatabase == null) {
      _notesDatabase = NotesDatabase._createObject();
    }
    return _notesDatabase;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase = openDatabase(path, version: 1, onCreate: _onCreate);

    return notesDatabase;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, is_archived INTEGER, is_pinned INTEGER, updated_at TEXT)');
  }

  Future<int> insert(Note object) async {
    Database db = await this.initDb();
    int result = await db.insert('notes', object.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var result = await db.query('notes', orderBy: 'title');
    return result;
  }

  Future<int> update(Note object) async {
    Database db = await this.initDb();
    int result = await db.update('notes', object.toMap(),
        where: 'id = ?', whereArgs: [object.id]);
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int result = await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<Note>> getNotes() async {
    var noteMapList = await select();
    int count = noteMapList.length;
    // List<Note> noteList = List<Note>();
    List<Note> noteList = List.generate(count, (i) {
      return Note.fromMapObject(noteMapList[i]);
    });
    return noteList;
  }
}
