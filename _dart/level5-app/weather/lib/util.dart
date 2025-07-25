import 'package:http/http.dart' as http;
import 'dart:convert';
import 'id.dart';

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  Future getData() async {
    http.Response response = await http.get(Uri.parse(this.url));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

Future<dynamic> getCityLocation(city, {state = 'tx', country = 'usa'}) async {
  // https://openweathermap.org/api/geocoding-api
  var locationURL =
      'http://api.openweathermap.org/geo/1.0/direct?q=$city,$state,$country&appid=$apiKey';

  NetworkHelper networkHelper = NetworkHelper(locationURL);

  var weatherData = await networkHelper.getData();
  return [weatherData[0]['lat'], weatherData[0]['lon']];
}

Future<dynamic> getWeather(city, {state = 'tx', country = 'usa'}) async {
  var location = await getCityLocation(city, state: state, country: country);
  // https://openweathermap.org/api/one-call-api
  const exclude = "minutely,hourly,daily,alerts";
  const units = "imperial";
  var weatherURL =
      'https://api.openweathermap.org/data/2.5/onecall?lat=${location[0]}&lon=${location[1]}&exclude=$exclude&units=$units&appid=$apiKey';
  print(weatherURL);

  NetworkHelper networkHelper = NetworkHelper(weatherURL);

  var weatherData = await networkHelper.getData();
  return weatherData;
}
