import 'package:delusion_drag_and_drop/utils/url_launcher.dart';
import 'package:delusion_drag_and_drop/widgets/canvas_area.dart';
import 'package:delusion_drag_and_drop/widgets/endpoint_choices.dart';
import 'package:flutter/material.dart';
import 'package:menu_bar/menu_bar.dart';

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