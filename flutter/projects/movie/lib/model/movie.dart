class Movie {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;

  Movie(
      {required this.id,
      required this.title,
      required this.voteAverage,
      required this.releaseDate,
      required this.overview,
      required this.posterPath});

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'] as int;
    this.title = parsedJson['title'] as String;
    this.voteAverage = (parsedJson['vote_average'] as double);
    this.releaseDate = parsedJson['release_date'] as String;
    this.overview = parsedJson['overview'] as String;
    this.posterPath = parsedJson['poster_path'] as String;
  }
}
