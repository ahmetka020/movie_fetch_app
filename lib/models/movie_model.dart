class MovieModel {
  String? name;
  String? image;
  String? error;

  MovieModel({
    this.name,
    this.image,
    this.error,
  });

  MovieModel.withError(String errorMessage) {
    error = errorMessage;
  }
}