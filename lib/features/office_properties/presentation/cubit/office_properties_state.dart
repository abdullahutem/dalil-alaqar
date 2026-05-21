import 'package:dalil_alaqar/features/office_properties/domain/entities/property_details_entity.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/office_property_entity.dart';
import '../../domain/entities/property_stats_entity.dart';

abstract class OfficePropertiesState extends Equatable {
  const OfficePropertiesState();

  @override
  List<Object?> get props => [];
}

class OfficePropertiesInitial extends OfficePropertiesState {
  const OfficePropertiesInitial();
}

class OfficePropertiesLoading extends OfficePropertiesState {
  const OfficePropertiesLoading();
}

class OfficePropertiesSuccess extends OfficePropertiesState {
  final List<OfficePropertyEntity> properties;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool isLoadingMore;
  final PropertyStatsEntity? stats;
  final bool isLoadingStats;
  final String? deleteSuccessMessage;
  final int? deletingPropertyId;

  const OfficePropertiesSuccess({
    required this.properties,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.isLoadingMore = false,
    this.stats,
    this.isLoadingStats = false,
    this.deleteSuccessMessage,
    this.deletingPropertyId,
  });

  OfficePropertiesSuccess copyWith({
    List<OfficePropertyEntity>? properties,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? isLoadingMore,
    PropertyStatsEntity? stats,
    bool? isLoadingStats,
    String? deleteSuccessMessage,
    int? deletingPropertyId,
  }) {
    return OfficePropertiesSuccess(
      properties: properties ?? this.properties,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      stats: stats ?? this.stats,
      isLoadingStats: isLoadingStats ?? this.isLoadingStats,
      deleteSuccessMessage: deleteSuccessMessage ?? this.deleteSuccessMessage,
      deletingPropertyId: deletingPropertyId,
    );
  }

  @override
  List<Object?> get props => [
    properties,
    currentPage,
    lastPage,
    total,
    isLoadingMore,
    stats,
    isLoadingStats,
    deleteSuccessMessage,
    deletingPropertyId,
  ];
}

class OfficePropertiesError extends OfficePropertiesState {
  final String message;

  const OfficePropertiesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OfficePropertiesLoadMoreError extends OfficePropertiesState {
  final String message;
  final List<OfficePropertyEntity> properties;
  final int currentPage;
  final int lastPage;
  final int total;

  const OfficePropertiesLoadMoreError({
    required this.message,
    required this.properties,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [
    message,
    properties,
    currentPage,
    lastPage,
    total,
  ];
}

class OfficePropertiesDeleteError extends OfficePropertiesState {
  final String message;
  final List<OfficePropertyEntity> properties;
  final int currentPage;
  final int lastPage;
  final int total;
  final PropertyStatsEntity? stats;

  const OfficePropertiesDeleteError({
    required this.message,
    required this.properties,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.stats,
  });

  @override
  List<Object?> get props => [
    message,
    properties,
    currentPage,
    lastPage,
    total,
    stats,
  ];
}

class PropertyDetailsInitial extends OfficePropertiesState {
  const PropertyDetailsInitial();
}

class PropertyDetailsLoading extends OfficePropertiesState {
  const PropertyDetailsLoading();
}

class PropertyDetailsSuccess extends OfficePropertiesState {
  final PropertyDetailsEntity property;

  const PropertyDetailsSuccess({required this.property});

  @override
  List<Object?> get props => [property];
}

class PropertyDetailsError extends OfficePropertiesState {
  final String message;

  const PropertyDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
