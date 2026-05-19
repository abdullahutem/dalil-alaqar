import 'package:dalil_alaqar/features/governorates/domain/entities/governorate_entity.dart';

class GovernoratesResponseEntity {
  final bool success;
  final String message;
  final List<GovernorateEntity> governorates;

  GovernoratesResponseEntity({
    required this.success,
    required this.message,
    required this.governorates,
  });
}
