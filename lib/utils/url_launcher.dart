import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('http://104.248.129.103:3000/');

Future<void> myLaunchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}