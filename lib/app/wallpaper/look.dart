import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:us/tool/tool.dart';

class Look extends StatefulWidget {
  String url;

  Look(this.url);

  @override
  _LookState createState() => _LookState();
}

class _LookState extends State<Look> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: widget.url,
        child: CachedNetworkImage(
          imageUrl: widget.url,
          placeholder: (context, url) => SpinKitDoubleBounce(
              color: Colors.white,
              size: 25.0,
              controller: AnimationController(
                  vsync: this, duration: const Duration(milliseconds: 1200))),
          width: getSize(context).width,
          height: getSize(context).height,
        ));
  }
}
