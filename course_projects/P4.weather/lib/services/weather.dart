import 'location.dart';
import 'networking.dart';

// 1c8816ba7bf255bcb06664ac735cac0ec <- This is a dummy key
const apiKey = 'USE your key';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

//https://api.openweathermap.org/data/2.5/weather';
// '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=imperial'
class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    var str = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=imperial';
    print(str);
    NetworkHelper networkHelper = NetworkHelper(str);

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    print(location);

    await location.getCurrentLocation();

    var str =
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=imperial';
    try {
      NetworkHelper networkHelper = NetworkHelper(str);

      var weatherData = await networkHelper.getData();
      print(weatherData);
      return weatherData;
    } catch (e) {
      print('Error! $e');
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
