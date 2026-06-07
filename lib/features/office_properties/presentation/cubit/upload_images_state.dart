import 'package:equatable/equatable.dart';
import '../../domain/entities/property_image_entity.dart';

abstract class UploadImagesState extends Equatable {
  const UploadImagesState();

  @override
  List<Object?> get props => [];
}

class UploadImagesInitial extends UploadImagesState {
  const UploadImagesInitial();
}

class UploadImagesLoading extends UploadImagesState {
  const UploadImagesLoading();
}

class UploadImagesSuccess extends UploadImagesState {
  final String message;
  final List<PropertyImageEntity> uploadedImages;

  const UploadImagesSuccess({
    required this.message,
    required this.uploadedImages,
  });

  @override
  List<Object?> get props => [message, uploadedImages];
}

class UploadImagesError extends UploadImagesState {
  final String message;

  const UploadImagesError({required this.message});

  @override
  List<Object?> get props => [message];
}
