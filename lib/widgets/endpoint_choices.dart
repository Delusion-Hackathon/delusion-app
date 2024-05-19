import 'package:delusion_drag_and_drop/data/cables.dart';
import 'package:delusion_drag_and_drop/data/endpoints.dart';
import 'package:delusion_drag_and_drop/main.dart';
import 'package:flutter/material.dart';

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