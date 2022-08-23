import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class HomePage extends StatefulWidget {
  // search controller
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Card(
                color: Colors.blue,
              ),
              Card(
                color: Colors.red,
              ),
              Card(
                color: Colors.green,
              ),
              Card(
                color: Colors.yellow,
              ),
              Card(
                color: Colors.orange,
              ),
              Card(
                color: Colors.purple,
              ),
              Card(
                color: Colors.pink,
              ),
              Card(
                color: Colors.brown,
              ),
              Card(
                color: Colors.grey,
              ),
              Card(
                color: Colors.black,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/detail');
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
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(horizontal: 16),
                  title: Container(
                    child: AnimSearchBar(
                      autoFocus: false,
                      rtl: true,
                      width: 320,
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
                ),
              ),
            ];
          },
          body: Column(
            children: [
              // header(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Text('Pinned',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              note(),
            ],
          ),
        ),
      ),
    );
  }
}
