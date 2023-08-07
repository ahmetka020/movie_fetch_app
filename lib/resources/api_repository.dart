import '../models/movie_model.dart';
import 'api_provider.dart';
import 'api_repository.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<List<MovieModel>> fetchMovieList(String query) {
    return _provider.fetchMovieList(query);
  }
}

class NetworkError extends Error {}