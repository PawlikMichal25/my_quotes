import 'package:my_quotes/domain/get_authors_use_case.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/commons/architecture/bloc.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:rxdart/rxdart.dart';

class AuthorsTabBloc extends Bloc {
  final GetAuthorsUseCase _getAuthorsUseCase;

  final _authors = BehaviorSubject<Resource<List<Author>>>();

  Stream<Resource<List<Author>>> get authorsStream => _authors.stream;

  AuthorsTabBloc(this._getAuthorsUseCase);

  @override
  void dispose() {
    _authors.close();
  }

  Future<void> loadAuthors() async {
    _authors.add(Resource.loading());
    final results = await _getAuthorsUseCase.execute();
    _authors.add(Resource.success(data: results));
  }
}
