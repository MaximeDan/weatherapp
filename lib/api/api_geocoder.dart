import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiGeocoder{
  String baseUrlAdress = "http://api.openweathermap.org/geo/1.0/direct?";
  String baseUrlReverse = "http://api.openweathermap.org/geo/1.0/reverse?";
  String apiKey;
  ApiGeocoder({required this.apiKey});
  Future<String?> getAddressFromCoordinates({required double latitude, required double longitude})
  async {
    http.Request request = http.Request(
        'GET',
        Uri.parse("${baseUrlReverse}lat=${latitude}&lon=${longitude}&appid=${apiKey}")
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      List<dynamic> result = jsonDecode(data);
      return result.first["name"];
    }
    return null;
  }


  Future<Map<String,dynamic>?> getCoordinatesFromAddress({required String ville}) async {
    http.Request request = http.Request(
        'GET',
        Uri.parse("${baseUrlAdress}q=${ville}&appid=${apiKey}")
    );
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      List<dynamic> result = jsonDecode(body);
      return {
        "latitude" : result.first["lat"],
        "longitude" : result.first["lon"]
      };
    }
    return null;
  }
}