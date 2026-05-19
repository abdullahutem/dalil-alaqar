import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/offer_types/data/models/offer_types_response_model.dart';

abstract class OfferTypesRemoteDataSource {
  Future<OfferTypesResponseModel> getOfferTypes();
}

class OfferTypesRemoteDataSourceImpl implements OfferTypesRemoteDataSource {
  final ApiConsumer apiConsumer;

  OfferTypesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfferTypesResponseModel> getOfferTypes() async {
    final response = await apiConsumer.get(EndPoints.offerTypes);
    return OfferTypesResponseModel.fromJson(response);
  }
}
