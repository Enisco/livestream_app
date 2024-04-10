// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:http/http.dart' as http;

const endpoint = "http://3.16.241.38:5000";

class ApiService {
  Future generateToken(String userId) async {
    final response = await http.get(Uri.parse('$endpoint/get_token/$userId'));

    if (response.statusCode == 200) {
      print(" __________ ${response.body} ");
      return response.body;
    } else {
      return "error";
    }
  }

  Future createLivestream(String userId, String callId) async {
    final response = await http.get(
      Uri.parse('$endpoint/create_livestream/$userId/$callId'),
    );

    if (response.statusCode == 200) {
      print(" __________ ${response.body} ");
      return response.body;
    } else {
      return "error";
    }
  }

  Future startRecordingLivestream( String callId) async {
    final response = await http.get(
      Uri.parse('$endpoint/start_recording/$callId'),
    );

    if (response.statusCode == 200) {
      print(" __________ ${response.body} ");
      return response.body;
    } else {
      return "error";
    }
  }

  Future endLiveGetRecording( String callId) async {
    final response = await http.get(
      Uri.parse('$endpoint/get_recording/$callId'),
    );

    if (response.statusCode == 200) {
      print(" __________ ${response.body} ");
      return response.body;
    } else {
      return "error";
    }
  }
}
