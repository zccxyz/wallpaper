import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:us/tool/request.dart';
import 'package:us/tool/tool.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wallpaper extends StatefulWidget {
  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> with TickerProviderStateMixin {
  List data = [];
  int page = 1;
  List spec = [
    {'name': '所有专题', 'id': ''},
    {'name': '热门', 'id': 'ff8080816a525a11016a53ac8b441a80'},
    {'name': '摄影', 'id': 'ff8080816560f528016560fa72ac0013'},
    {'name': '设计', 'id': 'ff808081656b24dd01656ee6837b0e1d'},
    {'name': '原创', 'id': 'ff808081656b24dd01656ee417000e17'},
    {'name': '抽象', 'id': 'f80808169dbf6aa0169dd15110f1071'},
    {'name': '创作者', 'id': 'ff808081656b24dd01656ef2dab90e56'},
    {'name': '风景', 'id': 'ff80808169dbf6aa0169dc0ecc420160'},
    {'name': '人物', 'id': 'ff80808169dbf6aa0169dc2a54030313'},
    {'name': '动物', 'id': 'ff80808169dbfa580169dc62c4ff055e'},
    {'name': '主屏', 'id': 'ff8080816a87dbfa016a8b33bc32289f'},
    {'name': '免费', 'id': 'ff8080816e00e3c2016e1517ade34e31'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    var rs = await Request().get('wallpaper/list', {'p': page});
    if (rs.data['Code'] == 0) {
      setState(() {
        for (var v in rs.data['Data']) {
          data.add(v);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.length == 0
        ? Scaffold(
            backgroundColor: defColor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Text("友视觉"),
              backgroundColor: defColor,
            ),
            body: Center(
                child: SpinKitDoubleBounce(
                    color: Colors.white,
                    size: 30.0,
                    controller: AnimationController(
                        vsync: this,
                        duration: const Duration(milliseconds: 1200)))),
          )
        : DefaultTabController(
            length: spec.length,
            child: Scaffold(
              backgroundColor: defColor,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: Text("友视觉"),
                backgroundColor: defColor,
                bottom: PreferredSize(
                    child: TabBar(
                      indicatorColor: lightColor,
                      unselectedLabelColor: defColor2,
                      labelColor: lightColor,
                      isScrollable: true,
                      tabs: spec
                          .map((v) => Tab(
                                text: v['name'],
                              ))
                          .toList(),
                    ),
                    preferredSize: Size(getSize(context).width, 50)),
              ),
              body: TabBarView(
                children: spec.map((v) => pageItem(v)).toList(),
              ),
            ),
          );
  }

  Widget pageItem(v) {
    return CupertinoScrollbar(
      child: ListView.builder(
        itemBuilder: (_, i) => item(i),
        itemCount: data.length,
        padding: EdgeInsets.all(15),
        itemExtent: 300,
      ),
    );
  }

  Widget item(int i) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: Text(data[i]['Headline']),
            alignment: Alignment.centerLeft,
          ),
          Container(
            height: 250,
            child: ListView.builder(
              itemBuilder: (_, x) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CachedNetworkImage(
                  imageUrl: data[i]['List'][x]['Url'],
                  placeholder: (context, url) => SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 25.0,
                      controller: AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 1200))),
                  width: 130,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
}
