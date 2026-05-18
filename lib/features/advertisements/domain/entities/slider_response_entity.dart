import 'package:dalil_alaqar/features/advertisements/domain/entities/slide_entity.dart';

class SliderResponseEntity {
  final List<SlideEntity> slides;
  final int count;

  SliderResponseEntity({required this.slides, required this.count});
}
