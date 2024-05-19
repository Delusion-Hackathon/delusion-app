import 'dart:ui';

class Node {
  final String name;
  final String nodeId;
  final String description;
  final Offset position;
  final String macAddress;
  final String nodeType;
  final String status;
  final String osVersion;
  final double cpuUsage;
  final double memoryUsage;
  final double discUsage;
  final String uptime;
  final String ipAddress;



  Node(
      {
    required this.name,
    required this.nodeId,
    required this.description,
    required this.position,
    required this.ipAddress,
    required this.macAddress,
    required this.nodeType,
    required this.status,
    required this.osVersion,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.discUsage,
    required this.uptime
  }
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'node_id': nodeId,
      'position_x': position.dx,
      'position_y': position.dy,
      'macAddress': macAddress,
      'node_type': nodeType,
      'status': status,
      'os_version': osVersion,
      'cpu_usage': cpuUsage,
      'memory_usage': memoryUsage,
      'disc_usage': discUsage,
      'uptime': uptime,
    };
  }

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      name: json['name'] as String,
      nodeId: json['id'].toString(), // Converting id to String
      description: json['description'] as String,
      position: Offset(
        double.parse(json['position_x'].toString()), // Parsing position_x
        double.parse(json['position_y'].toString()), // Parsing position_y
      ),
      ipAddress: json['ip_address'] as String,
      macAddress: json['mac_address'] as String,
      nodeType: json['node_type'] as String,
      status: json['status'].toString(), // Converting status to String
      osVersion: json['os_version'] as String,
      cpuUsage: (json['cpu_usage'] as num).toDouble(),
      memoryUsage: (json['memory_usage'] as num).toDouble(),
      discUsage: (json['disk_usage'] as num).toDouble(), // Correcting 'disk_usage' key
      uptime: json['uptime'].toString(), // Parsing uptime to double
    );
  }
}
