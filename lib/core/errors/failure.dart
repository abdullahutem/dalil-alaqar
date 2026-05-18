class Failure {
  final String errMessage;
  Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});
}

class CacheFailure extends Failure {
  CacheFailure({String? message})
    : super(errMessage: message ?? 'Cache error occurred');
}

class NetworkFailure extends Failure {
  NetworkFailure({String? message})
    : super(errMessage: message ?? 'Network error occurred');
}
