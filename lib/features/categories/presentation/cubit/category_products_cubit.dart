import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/features/categories/domain/usecases/get_category_products.dart';
import 'package:food_delivery/features/categories/presentation/cubit/category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final GetCategoryProducts getCategoryProductsUseCase;

  CategoryProductsCubit({required this.getCategoryProductsUseCase})
    : super(CategoryProductsInitial());

  Future<void> fetchCategoryProducts(
    int categoryId,
    String categoryName,
  ) async {
    final currentState = state;

    // If we already have loaded state, show loading indicator within the loaded state
    if (currentState is CategoryProductsLoaded) {
      emit(
        currentState.copyWith(
          isLoadingProducts: true,
          selectedCategoryId: categoryId,
          selectedCategoryName: categoryName,
          searchQuery: '', // Clear search when switching categories
        ),
      );
    } else {
      // First time loading
      emit(
        CategoryProductsLoading(
          selectedCategoryId: categoryId,
          selectedCategoryName: categoryName,
        ),
      );
    }

    final result = await getCategoryProductsUseCase.call(categoryId);

    result.fold(
      (failure) {
        print('❌ Category Products Error: ${failure.errorMessage}');
        emit(
          CategoryProductsError(
            message: failure.errorMessage,
            selectedCategoryId: categoryId,
            selectedCategoryName: categoryName,
          ),
        );
      },
      (categoryProducts) {
        print(
          '✅ Category Products Loaded: ${categoryProducts.products.length} products',
        );
        emit(
          CategoryProductsLoaded(
            categoryProducts: categoryProducts,
            selectedCategoryId: categoryId,
            selectedCategoryName: categoryName,
            isLoadingProducts: false,
          ),
        );
      },
    );
  }

  void updateSearchQuery(String query) {
    final currentState = state;
    if (currentState is CategoryProductsLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }
}
