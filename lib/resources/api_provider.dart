import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../models/movie_model.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = 'https://api.themoviedb.org/3/search/movie?api_key=ae304e3f4d3830d95075ae6914b55ddf&query=';

  Future<List<MovieModel>> fetchMovieList(String query) async {
    try {
      if (query.isEmpty || query.length < 2) {
        return [];
      }
      Response response = await _dio.get("$_url$query");
      List<MovieModel> movieModels = [];
      var extractedData = response.data["results"] as List<dynamic>;
      for (var element in extractedData) {
        movieModels.add(MovieModel(
          name: element["original_title"],
          image: element["poster_path"],
        ));
      }

      return movieModels;
    } catch (error, stacktrace) {
      log("Exception occurred: $error stackTrace: $stacktrace");
      return [MovieModel.withError("Connection issue")];
    }
  }
}