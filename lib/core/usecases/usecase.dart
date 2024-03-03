import 'package:rick_and_morty/core/error/failure.dart';

abstract class UseCase<T, P> {
  Future<(Failure, List<T>)> call({required P params});
}
