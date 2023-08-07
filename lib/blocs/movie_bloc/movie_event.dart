part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  final String query;
  const MovieEvent({required this.query});

  @override
  List<Object> get props => [];
}

class GetMovieList extends MovieEvent {
  const GetMovieList({required super.query});
}