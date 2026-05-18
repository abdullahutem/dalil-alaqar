import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/advertisements/domain/entities/slider_response_entity.dart';
import 'package:dalil_alaqar/features/advertisements/domain/repositories/slider_repository.dart';

class GetSlidesUseCase {
  final SliderRepository repository;

  GetSlidesUseCase(this.repository);

  Future<Either<Failure, SliderResponseEntity>> call() async {
    return await repository.getSlides();
  }
}
