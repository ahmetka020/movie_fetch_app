import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../models/movie_model.dart';
import '../../resources/api_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    final ApiRepository apiRepository = ApiRepository();

    on<GetMovieList>(transformer: debounce(const Duration(milliseconds: 1000)), (event, emit) async {
      try {
        emit(MovieLoading());
        final mList = await apiRepository.fetchMovieList(event.query);
        emit(MovieLoaded(mList));
      } on NetworkError {
        emit(const MovieError("Failed to fetch data. is your device online?"));
      }
    });
  }

  //Arama yaparken sürekli istek atmaması için eklendi (1000 ms debounce).
  EventTransformer<E> debounce<E>(Duration duration) {
    return (events, mapper) {
      return events.debounce(duration).switchMap(mapper);
    };
  }
}
