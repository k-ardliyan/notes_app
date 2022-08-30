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
  int isArchived = 0;
  int isPinned = 0;

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
            isArchived: isArchived,
            isPinned: isPinned,
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
          color: Colors.blue,
          shape: CircularNotchedRectangle(),
          child: IconTheme(
              data: IconThemeData(color: Colors.white),
              child: Row(
                children: [
                  IconButton(
                    icon: isPinned == 0
                        ? Icon(Icons.push_pin_outlined)
                        : Icon(Icons.push_pin),
                    onPressed: () {
                      setState(() {
                        isPinned = isPinned == 0 ? 1 : 0;
                      });
                    },
                  ),
                  IconButton(
                    icon: isArchived == 0
                        ? Icon(Icons.archive_outlined)
                        : Icon(Icons.archive),
                    onPressed: () {
                      setState(() {
                        isArchived = isArchived == 0 ? 1 : 0;
                      });
                    },
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      'Edited ${note != null ? (note.updatedAt.hour.toString() + ':' + note.updatedAt.minute.toString()) : DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )),
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
