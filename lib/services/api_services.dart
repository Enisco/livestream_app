// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:http/http.dart' as http;

const endpoint = "http://3.16.241.38:5000/get_token/";

class ApiService {
  Future generateToken(String userId) async {
    final response = await http.get(Uri.parse('$endpoint/$userId'));

    if (response.statusCode == 200) {
      print(" __________ ${response.body} ");
      return response.body;
    } else {
      return "error";
    }
  }
}
