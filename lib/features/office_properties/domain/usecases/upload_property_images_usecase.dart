import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/upload_images_response_entity.dart';
import '../repositories/office_properties_repository.dart';

class UploadPropertyImagesUseCase {
  final OfficePropertiesRepository repository;

  UploadPropertyImagesUseCase(this.repository);

  Future<Either<Failure, UploadImagesResponseEntity>> call({
    required int propertyId,
    required List<String> imagePaths,
  }) async {
    return await repository.uploadPropertyImages(
      propertyId: propertyId,
      imagePaths: imagePaths,
    );
  }
}
