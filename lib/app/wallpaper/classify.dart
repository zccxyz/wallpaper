import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:us/app/wallpaper/classify_img.dart';
import 'package:us/tool/request.dart';
import 'package:us/tool/tool.dart';

class Classify extends StatefulWidget {
  @override
  _ClassifyState createState() => _ClassifyState();
}

class _ClassifyState extends State<Classify> {
  int page = 1;
  List list = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var rs = await Request().get('catalog/listAll',
        queryParameters: {'state': 1, 'type': 1}, type: 2);
    if (rs.data['code'] == 200) {
      list = rs.data['data'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (list.length == 0) {
      getData();
    }
    return Container(
      color: defColor,
      child: SafeArea(
        child: Material(
          color: defColor,
          child: ListView.builder(
            itemBuilder: (_, i) => item(i),
            itemCount: list.length,
            padding: EdgeInsets.all(8),
            itemExtent: 120,
          ),
        ),
      ),
    );
  }

  Widget item(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => ClassifyImg(list[i]['chName'], list[i]['id']),
            ),
          );
        },
        child: ClipRRect(
          child: Container(
            height: 120,
            color: defColor2,
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  height: 120,
                  width: getSize(context).width - 16,
                  imageUrl: imgUrl + list[i]['url'] + cs,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Text(
                    list[i]['chName'],
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }
}
