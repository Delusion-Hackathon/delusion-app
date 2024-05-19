import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:delusion_drag_and_drop/api/node_post_query.dart';
import 'package:delusion_drag_and_drop/utils/cable_color.dart';
import 'package:delusion_drag_and_drop/data/all_nodes.dart';
import 'package:delusion_drag_and_drop/data/cables.dart';
import 'package:delusion_drag_and_drop/data/endpoints.dart';
import 'package:delusion_drag_and_drop/utils/notification_util.dart';
import 'package:delusion_drag_and_drop/utils/url_launcher.dart';
import 'package:delusion_drag_and_drop/widgets/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import 'package:menu_bar/menu_bar.dart';

import 'data/node.dart';

void main() {
  runApp(MyApp());
}

CableColor currentColor = CableColor();
AllNodes allNodes = AllNodes();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TopologyApp(),
      ),
    );
  }
}
