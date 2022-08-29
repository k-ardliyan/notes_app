import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class DetailPage extends StatefulWidget {
  final Note note;
  DetailPage(this.note);

  @override
  _DetailPageState createState() => _DetailPageState(this.note);
}

class _DetailPageState extends State<DetailPage> {
  Note note;
  _DetailPageState(this.note);

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    }

    void validateForm() {
      FormState formState = _formKey.currentState;

      if (formState.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note saved'),
          ),
        );
        if (note == null) {
          note = Note(
            title: titleController.text,
            content: contentController.text,
            isArchived: false,
            isPinned: false,
            updatedAt: DateTime.now(),
          );
        } else {
          note.title = titleController.text;
          note.content = contentController.text;
        }
        Navigator.of(context).pop(note);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          validateForm();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BottomAppBar(
          notchMargin: 6,
          color: Colors.greenAccent,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
                'Edited on ${DateTime.now().hour}:${DateTime.now().minute}'),
          ),
        ),
      ),
      appBar: AppBar(
        title: note == null ? Text('Tambah Note') : Text('Detail Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter title here',
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: contentController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some note';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your note here',
                    border: InputBorder.none,
                  ),
                  maxLines: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
