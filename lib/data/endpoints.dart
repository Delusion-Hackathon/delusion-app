import 'package:uuid/uuid.dart';

class EndpointsData {
  static const uuid = Uuid();
  static final List<Map<String, String>> endpoints = [
    {'name': 'Phone', 'image': 'assets/images/phone2.png', 'node_id':  uuid.v4()},
    {'name': 'Switch', 'image': 'assets/images/switch.png', 'node_id':  uuid.v4()},
    {'name': 'Router', 'image': 'assets/images/router.png', 'node_id':  uuid.v4()},
    {'name': 'Modem', 'image': 'assets/images/DSL_modem.png', 'node_id':  uuid.v4()},
    {'name': 'Data center', 'image': 'assets/images/data_center.png', 'node_id':  uuid.v4()},
    {'name': 'Internet', 'image': 'assets/images/internet.png', 'node_id':  uuid.v4()},
    {'name': 'Cell tower', 'image': 'assets/images/cell_tower.png', 'node_id':  uuid.v4()},
    {'name': 'Antenna', 'image': 'assets/images/antennas.png', 'node_id':  uuid.v4()},
  ];
}
