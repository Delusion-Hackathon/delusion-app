import 'dart:convert';
import 'package:delusion_drag_and_drop/data/node.dart';
import 'package:http/http.dart' as http;

import 'api_provider.dart';

class NodeApiQuery {

  Future<Node> sendRequest(node) async {
    const url = "${ApiProvider.BaseURL}users/nodes/";

    final headers = {
      'Content-Type': 'application/json',
    };

    final body =jsonEncode(node.toJson());

    print(body);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    final data = json.decode(response.body);
    Node newNode = Node.fromJson(data);
    return newNode;
  }
}