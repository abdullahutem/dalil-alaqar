import 'package:dalil_alaqar/features/advertisements/data/models/slide_model.dart';
import 'package:dalil_alaqar/features/advertisements/domain/entities/slider_response_entity.dart';

class SliderResponseModel extends SliderResponseEntity {
  SliderResponseModel({required super.slides, required super.count});

  factory SliderResponseModel.fromJson(Map<String, dynamic> json) {
    final slidesData = json['slides'] as List<dynamic>;
    final slides = slidesData
        .map((slide) => SlideModel.fromJson(slide as Map<String, dynamic>))
        .toList();

    return SliderResponseModel(slides: slides, count: json['count'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'slides': slides.map((slide) => (slide as SlideModel).toJson()).toList(),
      'count': count,
    };
  }
}
