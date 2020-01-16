import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:us/tool/tool.dart';

class Look extends StatefulWidget {
  String url;

  Look(this.url);

  @override
  _LookState createState() => _LookState();
}

class _LookState extends State<Look> with TickerProviderStateMixin {
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defColor,
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.url,
            child: CachedNetworkImage(
              imageUrl: widget.url+cs,
              placeholder: (context, url) => SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 25.0,
                  controller: AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 1200))),
              width: getSize(context).width,
              height: getSize(context).height,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: getColor(74, 74, 63, o: .5),
              height: 85,
              padding: EdgeInsets.only(bottom: 40),
              width: getSize(context).width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          CupertinoIcons.back,
                          color: lightColor,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  Expanded(
                      child: Builder(
                    builder: (c) => load
                        ? CupertinoActivityIndicator()
                        : IconButton(
                            icon: Icon(
                              CupertinoIcons.down_arrow,
                              color: lightColor,
                              size: 30,
                            ),
                            onPressed: () {
                              download(c);
                            }),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void download(BuildContext c) async {
    setState(() {
      load = true;
    });
    var response = await Dio()
        .get(widget.url, options: Options(responseType: ResponseType.bytes));
    if (response.statusCode != 200) {
      Scaffold.of(c).showSnackBar(
          SnackBar(content: Text('请求出错' + response.statusCode.toString())));
    }
    await ImagePickerSaver.saveFile(
        fileData: Uint8List.fromList(response.data));
    Scaffold.of(c).showSnackBar(SnackBar(content: Text('下载成功')));
    setState(() {
      load = false;
    });
  }
}
