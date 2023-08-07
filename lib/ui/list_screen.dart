import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movie_bloc/movie_bloc.dart';
import '../models/movie_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State createState() => _ListScreenState();
}

//bloc kullanirken aslinda statless widget mantikli olacaktir,
//ancak baslangic (initstate) islemleri icin statefull widget kullanildi.
class _ListScreenState extends State<ListScreen> {
  late MovieBloc _movieBloc;

  late TextEditingController _textEditingController;

  late List<MovieModel> _movieList;
  late List<MovieModel> _resultMovieList;

  @override
  void initState() {
    _resultMovieList = [];
    _movieBloc = MovieBloc();
    _textEditingController = TextEditingController();
    _textEditingController.text = "watchmen";
    _movieBloc.add(const GetMovieList(query: "watchmen"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filmler")),
      body: _buildListMovie(),
    );
  }

  Widget _buildListMovie() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _movieBloc,
        child: BlocListener<MovieBloc, MovieState>(
          listener: (context, state) {
            if (state is MovieError) {
              log("Error -> ${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieInitial) {
                return buildLoading();
              } else if (state is MovieLoading) {
                return buildLoading();
              } else if (state is MovieLoaded) {
                _movieList = state.movieModels;
                _resultMovieList = [];
                _resultMovieList.addAll(_movieList);
                return _buildCard(context);
              } else if (state is MovieError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _textBox(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .08,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: _textEditingController,
        onChanged: (searchText) => _movieBloc.add(GetMovieList(query: searchText)),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _textBox(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * .8,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: _resultMovieList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      height: 250,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(
                            "https://image.tmdb.org/t/p/w220_and_h330_face/${_resultMovieList[index].image ?? ""}",
                            width: 100,
                            height: 100,
                            errorBuilder: (c, o, s) {
                              return Image.network(
                                "https://img.freepik.com/free-vector/glitch-error-404-page-background_23-2148090410.jpg?w=2000",
                                height: 100,
                                width: 100,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            height: 45,
                            child: Text(_resultMovieList[index].name ?? "", style: const TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildLoading() => const Center(child: CircularProgressIndicator());
