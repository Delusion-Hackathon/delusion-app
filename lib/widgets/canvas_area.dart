import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:delusion_drag_and_drop/api/node_post_query.dart';
import 'package:delusion_drag_and_drop/data/node.dart';
import 'package:delusion_drag_and_drop/main.dart';
import 'package:delusion_drag_and_drop/utils/line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

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