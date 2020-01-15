import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    var rs = await Request()
        .get('catalog/listAll', {'state': 1, 'type': 1}, type: 2);
    if (rs.data['code'] == 200) {
      list = rs.data['data'];
      setState(() {});
    }
    print(rs);
  }

  @override
  Widget build(BuildContext context) {
    if (list.length == 0) {
      getData();
    }
    return SafeArea(
      child: Material(
        color: defColor,
        child: ListView.builder(
          itemBuilder: (_, i) => item(i),
          itemCount: list.length,
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget item(int i) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: defColor2,
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            height: 100,
            width: getSize(context).width-30,
            imageUrl: imgUrl + list[i]['url'],
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(list[i]['chName'], style: TextStyle(fontSize: 18, color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
