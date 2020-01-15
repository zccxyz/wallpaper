import 'package:flutter/material.dart';
import 'package:us/app/wallpaper/classify.dart';
import 'package:us/app/wallpaper/search.dart';
import 'package:us/app/wallpaper/wallpaper.dart';
import 'package:us/tool/tool.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: <Widget>[
          Wallpaper(),
          Classify(),
          Search(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black26,
        type: BottomNavigationBarType.shifting,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            backgroundColor: defColor2,
            icon: Icon(Icons.wallpaper),
            title: Text("壁纸"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clear_all),
            title: Text("分类"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("搜索"),
          ),
        ],
        onTap: (i){
          setState(() {
            index = i;
          });
        },
      ),
    );
  }
}
