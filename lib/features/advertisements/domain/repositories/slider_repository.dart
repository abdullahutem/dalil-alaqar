import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/advertisements/domain/entities/slider_response_entity.dart';

abstract class SliderRepository {
  Future<Either<Failure, SliderResponseEntity>> getSlides();
}
