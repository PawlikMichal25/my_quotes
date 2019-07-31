import 'package:my_quotes/db/dao.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/commons/bloc.dart';
import 'package:my_quotes/commons/resource.dart';
import 'package:rxdart/rxdart.dart';

class AuthorsTabBloc extends Bloc {
  final Dao dao;

  final _authors = BehaviorSubject<Resource<List<Author>>>();

  Stream<Resource<List<Author>>> get authorsStream => _authors.stream;

  AuthorsTabBloc({this.dao}) : assert(dao != null);

  @override
  void dispose() {
    _authors.close();
  }

  Future<void> loadAuthors() async {
    _authors.add(Resource.loading());
    final results = await dao.getAllAuthors();
    _authors.add(Resource.success(data: results));
  }
}
