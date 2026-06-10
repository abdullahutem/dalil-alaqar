import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/params/params.dart';
import '../../domain/usecases/get_categories.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategories getCategories;

  CategoriesCubit({required this.getCategories}) : super(CategoriesInitial());

  Future<void> fetchCategories({bool refresh = false}) async {
    if (refresh || state is! CategoriesLoaded) {
      emit(CategoriesLoading());
    }

    final result = await getCategories(params: CategoriesParams(page: 1));

    result.fold(
      (failure) => emit(CategoriesError(message: failure.errorMessage)),
      (categoriesEntity) => emit(
        CategoriesLoaded(
          categories: categoriesEntity.categories,
          pagination: categoriesEntity.pagination,
        ),
      ),
    );
  }

  Future<void> loadMoreCategories() async {
    final currentState = state;
    if (currentState is! CategoriesLoaded) return;

    final pagination = currentState.pagination;
    if (pagination == null || !pagination.hasMorePages) return;

    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getCategories(
      params: CategoriesParams(page: pagination.currentPage + 1),
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
        // Optionally show error without changing the state
      },
      (categoriesEntity) {
        final updatedCategories = [
          ...currentState.categories,
          ...categoriesEntity.categories,
        ];
        emit(
          CategoriesLoaded(
            categories: updatedCategories,
            pagination: categoriesEntity.pagination,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
