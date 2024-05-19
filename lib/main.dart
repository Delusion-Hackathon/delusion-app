import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:delusion_drag_and_drop/api/node_post_query.dart';
import 'package:delusion_drag_and_drop/cable_color.dart';
import 'package:delusion_drag_and_drop/data/all_nodes.dart';
import 'package:delusion_drag_and_drop/data/cables.dart';
import 'package:delusion_drag_and_drop/data/endpoints.dart';
import 'package:delusion_drag_and_drop/utils/notification_util.dart';
import 'package:delusion_drag_and_drop/utils/url_launcher.dart';
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

class TopologyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MenuBarWidget(
      barStyle: MenuStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      barButtons: [
        BarButton(
          text: const Text('File', style: TextStyle(color: Colors.white)),
          submenu: SubMenu(
            menuItems: [
              const MenuButton(
                text: Text('Visualize'),
                onTap: myLaunchUrl,
              ),
              MenuButton(
                text: const Text('Save'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        insetPadding: const EdgeInsets.symmetric(horizontal: 350),
                        surfaceTintColor: Colors.white,
                        child: Container(
                          height: 500,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10, top: 10),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: const Icon(Icons.close, color: Colors.red,),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset('assets/images/alert.png'),
                              const Text("There are some errors in the topology", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),),
                              Text("Details:\n\t\t\t\t\t\tConnection ID: 76d00c4f-d550-4c9d-8dc7-97110de8cfc0\n\t\t\t\t\t\tDevice1: Phone\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tIP Address: 192.168.1.1\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tMAC: 0a:92:11:04:86:ec\n\t\t\t\t\t\tDevice2: Switch\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tIP Address: 192.168.12.3\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tMAC: b8:f6:36:f3:e9:a2")
                            ],
                          ),
                        ),
                      )
                  );
                },
                icon: const Icon(Icons.save),
                shortcutText: 'Ctrl+S',
              ),
              const MenuDivider(),
              MenuButton(
                text: const Text('Exit'),
                onTap: () {},
                icon: const Icon(Icons.exit_to_app),
                shortcutText: 'Ctrl+Q',
              ),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          // Left section (endpoint choices)
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.19,
            color: Colors.grey[200],
            child: EndpointChoices(),
          ),
          // Right section (canvas)
          Expanded(
            child: CanvasArea(),
          ),
        ],
      ),
    );
  }
}

class EndpointChoices extends StatefulWidget {
  @override
  State<EndpointChoices> createState() => _EndpointChoicesState();
}

class _EndpointChoicesState extends State<EndpointChoices> {
  final List<Map<String, String>> endpoints = EndpointsData.endpoints;
  final List<Map<String, dynamic>> cables = CablesData.cables;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: endpoints.length,
            itemBuilder: (context, index) {
              return Draggable<Map<String, String>>(
                data: endpoints[index],
                feedback: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Image.asset(
                          endpoints[index]['image']!, width: 50, height: 50),
                      Text(endpoints[index]['name']!),
                    ],
                  ),
                ),
                child: ListTile(
                  leading: Image.asset(
                      endpoints[index]['image']!, width: 50, height: 50),
                  title: Text(endpoints[index]['name']!),
                ),
              );
            },
          ),
        ),
        const Divider(),
        Container(
          height: 220,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 3 / 2,
            ),
            itemCount: cables.length,
            itemBuilder: (context, index) {
              final cable = cables[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentColor.colorChanger(cable['color']);
                  });
                  print(currentColor.cableColor);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5,
                        color: cable['color'] == currentColor.cableColor
                            ? currentColor.cableColor
                            : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    //color: cable['color'] == currentColor.cableColor ? currentColor.cableColor : null
                  ),
                  child: GridTile(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Image.asset(cable['image']!, fit: BoxFit.cover,
                              width: 50,
                              height: 50),
                          const SizedBox(width: 8.0),
                          Expanded(child: Text(cable['name']!)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CanvasArea extends StatefulWidget {
  @override
  _CanvasAreaState createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  List<Widget> endpointsOnCanvas = [];
  List<Offset> _points = [];
  List<Color> _lineColors = [];
  Offset? _startPoint;
  Offset? _endPoint;

  GlobalKey _globalKey = GlobalKey();
  Color? _startColor;
  Color? _endColor;

  Future<Color?> _getColorAtPoint(Offset offset) async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData != null) {
        int x = offset.dx.toInt();
        int y = offset.dy.toInt();
        int offsetIndex = ((y * image.width) + x) * 4;
        int r = byteData.getUint8(offsetIndex);
        int g = byteData.getUint8(offsetIndex + 1);
        int b = byteData.getUint8(offsetIndex + 2);
        int a = byteData.getUint8(offsetIndex + 3);
        return Color.fromARGB(a, r, g, b);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void _onPanStart(DragStartDetails details) async {
    _startPoint = details.localPosition;
    _startColor = await _getColorAtPoint(details.localPosition);
    setState(() {
      _endPoint = _startPoint;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _endPoint = details.localPosition;
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    _endColor = await _getColorAtPoint(_endPoint!);
    if (_startColor == const Color(0xfff44336) &&
        _endColor == const Color(0xfff44336)) {
      if (_startPoint != null && _endPoint != null) {
        setState(() {
          _points.add(_startPoint!);
          _points.add(_endPoint!);
          _lineColors.add(currentColor.cableColor);
          _startPoint = null;
          _endPoint = null;
        });
      }
    } else {
      setState(() {
        _startPoint = null;
        _endPoint = null;
      });
    }
    print('Start color: $_startColor, End color: $_endColor');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
        key: _globalKey,
        child: DragTarget<Map<String, String>>(
          onWillAccept: (data) => true,
          onAcceptWithDetails: (details) async {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition = renderBox.globalToLocal(details.offset);

            Node droppedNode = Node(
              name: details.data['name']!,
              description: '',
              nodeId: details.data['node_id']!,
              position: localPosition,
              ipAddress: '',
              macAddress: '',
              nodeType: '',
              status: '',
              osVersion: '',
              cpuUsage: 4.44,
              memoryUsage: 4.44,
              discUsage: 4.44,
              uptime: "",
            );
            final newNode = await NodeApiQuery().sendRequest(droppedNode);

            setState(() {
              endpointsOnCanvas.add(
                Positioned(
                  left: localPosition.dx,
                  top: localPosition.dy,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 20,),
                          JustTheTooltip(
                              tailLength: -110,
                              tailBaseWidth: 0,
                              triggerMode: TooltipTriggerMode.tap,
                              content: Container(
                                width: 187,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "${newNode.name}\nIP address: ${newNode
                                      .ipAddress}\nMAC: ${newNode.macAddress}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              child: const Icon(Icons.info)
                          ),
                        ],
                      ),
                      Image.asset(
                          details.data['image']!, width: 50, height: 50),
                      Text(details.data['name']!),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
            allNodes.addNode(newNode);
            print(newNode.toJson());
            print(allNodes.allNodes.length);
          },
          builder: (context, candidateData, rejectedData) {
            return CustomPaint(
              size: Size.infinite,
              painter: LinePainter(
                  _points, _startPoint, _endPoint, _lineColors),
              child: Stack(
                children: endpointsOnCanvas,
              ),
            );
          },
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final List<Color> lineColors;
  final Offset? startPoint;
  final Offset? endPoint;

  LinePainter(this.points, this.startPoint, this.endPoint, this.lineColors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length; i += 2) {
      paint.color = lineColors[i ~/ 2]; // Set color for this line
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    if (startPoint != null && endPoint != null) {
      paint.color =
          currentColor.cableColor; // Use current color for the line being drawn
      canvas.drawLine(startPoint!, endPoint!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Return true to repaint when drag updates
  }
}