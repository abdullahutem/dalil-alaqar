import 'package:dalil_alaqar/features/advertisements/domain/entities/slider_response_entity.dart';

abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderLoading extends SliderState {}

class SliderSuccess extends SliderState {
  final SliderResponseEntity sliderResponse;

  SliderSuccess(this.sliderResponse);
}

class SliderError extends SliderState {
  final String message;

  SliderError(this.message);
}
