import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:us/app/wallpaper/look.dart';
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getData('update');
  }

  void getData(String type) async {
    if (type == 'update') {
      page = 1;
    } else {
      page++;
    }
    print(type);
    var rs = await Request().get('wallpaper/list', {'p': page});
    if (rs.data['Code'] == 0) {
      if (page == 1) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      setState(() {
        if (type == 'update') {
          data = rs.data['Data'];
        } else {
          for (var v in rs.data['Data']) {
            data.add(v);
          }
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
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
    if(v['name'] != '所有专题') {
      return Container();
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () => getData('update'),
      onLoading: () => getData('load'),
      controller: _refreshController,
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
            child: Text(
              data[i]['Headline'],
              style: TextStyle(color: lightColor),
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            height: 250,
            child: ListView.builder(
              itemBuilder: (_, x) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Look(data[i]['List'][x]['Url'])));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Hero(
                    child: cacheImg(i, x),
                    tag: data[i]['List'][x]['Url'],
                  ),
                ),
              ),
              itemCount: data[i]['List'].length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  Widget cacheImg(i, x) {
    return CachedNetworkImage(
      imageUrl: data[i]['List'][x]['Url'],
      placeholder: (context, url) => SpinKitDoubleBounce(
          color: Colors.white,
          size: 20.0,
          controller: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 1200))),
      width: 130,
      height: 250,
      fit: BoxFit.cover,
    );
  }
}
