import 'package:weather/util.dart';

Future<void> main(List<String> arguments) async {
  final city = 'austin'; // arguments.first;
  var location = await getCityLocation(city, state: 'tx', country: 'usa');
  print(location);
  var cityweather = await getWeather('austin', state: 'tx', country: 'usa');
  print(cityweather);
}
