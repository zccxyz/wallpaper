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
  // https://claritywallpaper.com/clarity/api/special/ff8080816eaba6b0016f9c93a4803b8f
  List data = [];
  int page = 1;
  List catalogs = [
    /*{'name': '所有专题', 'id': ''},
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
    {'name': '免费', 'id': 'ff8080816e00e3c2016e1517ade34e31'},*/
  ];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int tabIndex = 0;
  bool show = false;
  Map<String, ScrollController> scrollAll = {};
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    getCatalog();
  }

  //专题分类
  void getCatalog() async {
    var rs = await Request()
        .get('catalog/listAll', queryParameters: {'state': 1, 'type': 2});
    if (rs.data['code'] == 200) {
      catalogs = rs.data['data'];
      if (_tabController == null) {
        _tabController =
            TabController(length: rs.data['data'].length, vsync: this);
        _tabController.addListener(() {
          int now = _tabController.index;
          tabIndex = now;
          if(catalogs[now]['spec'] == null) {
            getSpecAll(id: catalogs[now]['id']);
          }
        });
      }
      setState(() {});
      getSpecAll();
    }
  }

  //所有对应专题
  void getSpecAll({String id}) async {
    var rs;
    if (id != null && id != '') {
      rs = await Request().get('special/queryByCatalogAll?catalogIds=' + id);
    } else {
      rs = await Request().get('special/queryByCatalogAll');
    }
    _refreshController.refreshCompleted();
    if (rs.data['code'] == 200) {
      var i = 0;
      for (var v in rs.data['data']) {
        if (i == 0 || i == 1) {
          getSpecImg(v['id'], i);
          v['load'] = true;
        } else {
          v['load'] = false;
          v['imgData'] = [];
        }
        i++;
      }
      catalogs[tabIndex]['spec'] = rs.data['data'];
      if (id == null) {
        show = true;
      }
      setState(() {});
    }
  }

  //获取专题图片
  void getSpecImg(String specId, int specIndex) async {
    var rs = await Request().get('special/' + specId);
    if (rs.data['code'] == 200) {
      var catalog = catalogs[tabIndex];
      var spec = catalog['spec'][specIndex];
      spec['data'] = rs.data['data']['pictureList'];
      spec['load'] = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return !show
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
            length: catalogs.length,
            initialIndex: tabIndex,
            child: Scaffold(
              backgroundColor: defColor,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: Text("友视觉"),
                backgroundColor: defColor,
                bottom: PreferredSize(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: lightColor,
                        labelPadding: EdgeInsets.only(left: 8, right: 8),
                        unselectedLabelColor: defColor2,
                        labelColor: lightColor,
                        isScrollable: true,
                        tabs: catalogs
                            .map(
                              (v) => Container(
                                height: 30,
                                child: Center(child: Text(v['chName'])),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    preferredSize: Size(getSize(context).width, 40)),
              ),
              body: TabBarView(
                controller: _tabController,
                children: catalogs.map((v) => pageItem(v)).toList(),
              ),
            ),
          );
  }

  Widget pageItem(v) {
    if (v['spec'] == null) {
      return Container();
    }
    if (scrollAll['chName'] == null) {
      ScrollController sc = ScrollController();
      scrollAll['chName'] = sc;
      sc.addListener(() {
        int now = (sc.offset / 250).ceil() + 1;
        if(now <= (catalogs[tabIndex]['spec'].length - 1)) {
          /*Map spec = catalogs[tabIndex]['spec'][now];
          if (spec['load'] == null || spec['load'] == false) {
            //加载图片
            getSpecImg(spec['id'], now);
          }*/
          int i = 0;
          for(var v in catalogs[tabIndex]['spec']) {
            if(i <= now) {
              if (v['load'] == null || v['load'] == false) {
                //加载图片
                print(v['headline']);
                print(i);
                getSpecImg(v['id'], i);
              }
            }else{
              return;
            }
            i++;
          }
        }
      });
    }
    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: () => getSpecAll(id: v['id']),
      child: ListView.builder(
        controller: scrollAll['chName'],
        itemBuilder: (_, i) => item(i, v['spec']),
        itemCount: v['spec'].length,
        padding: EdgeInsets.all(8),
        itemExtent: 300,
      ),
    );
  }

  Widget item(int i, List spec) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: Text(
              spec[i]['headline'],
              style: TextStyle(
                  color: lightColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            height: 250,
            child: spec[i]['data'] != null && spec[i]['data'].length > 0
                ? ListView.builder(
                    itemBuilder: (_, x) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) =>
                                Look(imgUrl + spec[i]['data'][x]['url']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Hero(
                          child: cacheImg(spec[i]['data'][x]['url']),
                          tag: imgUrl + spec[i]['data'][x]['url'],
                        ),
                      ),
                    ),
                    itemCount: spec[i]['data'].length,
                    scrollDirection: Axis.horizontal,
                  )
                : Text(''),
          )
        ],
      ),
    );
  }

  Widget cacheImg(String url) {
    return ClipRRect(
      child: CachedNetworkImage(
        imageUrl: imgUrl + url + cs,
        placeholder: (context, url) => Container(
          width: 130,
          height: 250,
          child: Center(
            child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 18.0,
                controller: AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 1200))),
          ),
        ),
        width: 130,
        height: 250,
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }
}
