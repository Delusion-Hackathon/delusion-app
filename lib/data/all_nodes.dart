import 'node.dart';

class AllNodes {
  List<Node> allNodes = [];

  void addNode(Node node) {
    allNodes.add(node);
  }

  Node? getNode(nodeId) {
    for (int i = 0; i < allNodes.length; i++) {
      if (allNodes[i].nodeId == nodeId) {
        return allNodes[i];
      }
    }
    return null;
  }
}