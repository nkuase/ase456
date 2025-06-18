import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie/model/movie.dart';

class APIRunner {
  final String api_key = 'api_key=8361ad82497ec1cf55ca10b74f1d3750';
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String apiUpcoming = '/upcoming?';
  final String apiSearch = '/search/movie?';
  final String urlLanguage = '&language=en-US';

  Future<List?> runAPI(API) async {
    http.Response result = await http.get(Uri.parse(API));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      return moviesMap.map((i) => Movie.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<List?> getUpcoming() async {
    final String upcomingAPI = urlBase + apiUpcoming + api_key + urlLanguage;
    return runAPI(upcomingAPI);
  }

  Future<List?> searchMovie(String title) async {
    final String search = urlBase + apiSearch + api_key + '&query=' + title;
    return runAPI(search);
  }
}
