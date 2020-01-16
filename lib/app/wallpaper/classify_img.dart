import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:us/app/wallpaper/look.dart';
import 'package:us/tool/request.dart';
import 'package:us/tool/tool.dart';

class ClassifyImg extends StatefulWidget {
  String title;
  String catalogIds;

  ClassifyImg(this.title, this.catalogIds);

  @override
  _ClassifyImgState createState() => _ClassifyImgState();
}

class _ClassifyImgState extends State<ClassifyImg>
    with TickerProviderStateMixin {
  List data = [];
  int page = 1;
  int all = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var rs = await Request().get('picture/search', queryParameters: {
      'catalogIds': widget.catalogIds,
      'page': page,
      'size': 60
    });
    if (rs.data['code'] == 200) {
      if (page == 1) {
        data = rs.data['data']['list'];
        all = rs.data['data']['totalPage'];
        print(all);
        _refreshController.refreshCompleted();
      } else {
        for (var v in rs.data['data']['list']) {
          data.add(v);
        }
        if (page == all) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      }
      page++;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.title),
        backgroundColor: defColor,
      ),
      body: data.length == 0
          ? Center(
              child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 30.0,
                controller: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 1200),
                ),
              ),
            )
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                page = 1;
                getData();
              },
              onLoading: () {
                getData();
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6),
                itemBuilder: (_, i) => _item(i),
                itemCount: data.length,
                padding: EdgeInsets.all(8),
              ),
            ),
    );
  }

  Widget _item(i) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => Look(imgUrl + data[i]['url'])));
      },
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imgUrl + data[i]['url'] + cs,
      ),
    );
  }
}
