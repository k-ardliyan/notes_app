import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';

class DetailPage extends StatefulWidget {
  final Note note;
  DetailPage({this.note});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void validateForm() {
    FormState formState = _formKey.currentState;
    ScaffoldState scaffoldState = _scaffoldKey.currentState;

    if (formState.validate()) {
      formState.save();
      Note note = Note(
        title: titleController.text,
        content: contentController.text,
        isArchived: false,
        isPinned: false,
        updatedAt: DateTime.now(),
      );
      Navigator.of(context).pop(note);
    } else {
      scaffoldState.showSnackBar(
        SnackBar(
          content: Text('Form tidak boleh kosong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Detail Page'),
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
                      return 'Content is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your content here',
                    // no border
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
