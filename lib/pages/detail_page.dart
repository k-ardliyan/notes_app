import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6,
        color: Colors.greenAccent,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child:
              Text('Edited on ${DateTime.now().hour}:${DateTime.now().minute}'),
        ),
      ),
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter title here',
              ),
            ),
            // textformfield full screen
            Expanded(
              child: TextFormField(
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
    );
  }
}
