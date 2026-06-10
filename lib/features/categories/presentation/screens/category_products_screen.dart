import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/localization/localized_helper.dart';
import 'package:food_delivery/core/utils/price_formatter.dart';
import 'package:food_delivery/features/categories/domain/entities/category_products_entity.dart';
import 'package:food_delivery/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:food_delivery/features/categories/presentation/cubit/categories_state.dart';
import 'package:food_delivery/features/categories/presentation/cubit/category_products_cubit.dart';
import 'package:food_delivery/features/categories/presentation/cubit/category_products_state.dart';
import 'package:food_delivery/features/product/presentation/screens/product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final ScrollController _categoriesScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _categoriesScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch all categories and current category products when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<CategoryProductsCubit>().state
          is! CategoryProductsLoaded) {
        context.read<CategoriesCubit>().fetchCategories();
        context.read<CategoryProductsCubit>().fetchCategoryProducts(
          widget.categoryId,
          widget.categoryName,
        );
      }
    });

    return BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
      builder: (context, state) {
        final selectedCategoryName = state is CategoryProductsLoaded
            ? state.selectedCategoryName
            : state is CategoryProductsLoading
            ? state.selectedCategoryName
            : state is CategoryProductsError
            ? state.selectedCategoryName
            : widget.categoryName;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              selectedCategoryName,
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoryProductsState state) {
    // Initial loading state (first time)
    if (state is CategoryProductsLoading) {
      return SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context, ''),
            const SizedBox(height: 10),
            _buildCategoriesSection(context, state.selectedCategoryId),
            const SizedBox(height: 10),
            Expanded(child: _buildSkeletonGrid()),
          ],
        ),
      );
    }

    if (state is CategoryProductsError) {
      return SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context, ''),
            const SizedBox(height: 10),
            _buildCategoriesSection(context, state.selectedCategoryId),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: 48,
                          color: Colors.red[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.isArabic
                            ? 'لا يوجد اتصال بالإنترنت'
                            : "No internet connection",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.isArabic
                            ? 'لا توجد منتجات محفوظة لهذا التصنيف'
                            : "No products saved for this category",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<CategoryProductsCubit>()
                              .fetchCategoryProducts(
                                state.selectedCategoryId,
                                state.selectedCategoryName,
                              );
                        },
                        icon: const Icon(Icons.refresh, size: 20),
                        label: Text(
                          context.isArabic ? 'إعادة المحاولة' : "Retry",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is CategoryProductsLoaded) {
      final allProducts = state.categoryProducts.products;
      final filteredProducts = _filterProducts(allProducts, state.searchQuery);

      return SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context, state.searchQuery),
            const SizedBox(height: 10),

            // Categories horizontal list
            _buildCategoriesSection(context, state.selectedCategoryId),

            const SizedBox(height: 10),

            // Products Grid with loading overlay
            Expanded(
              child: state.isLoadingProducts
                  ? _buildSkeletonGrid()
                  : allProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.isArabic
                                ? 'لا توجد منتجات في هذا التصنيف'
                                : "No products in this category",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.isArabic
                                ? 'لا توجد نتائج للبحث'
                                : "No search results",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildProductsGrid(context, filteredProducts),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _onCategorySelected(
    BuildContext context,
    int categoryId,
    String categoryName,
    int categoryIndex,
  ) {
    context.read<CategoryProductsCubit>().fetchCategoryProducts(
      categoryId,
      categoryName,
    );
    _scrollToCategory(categoryIndex);
  }

  void _scrollToCategory(int index) {
    if (!_categoriesScrollController.hasClients) return;

    // Calculate the position to scroll to
    // Each category item has: width (variable) + margin (12) + padding (32)
    // We'll estimate ~120 pixels per item and center it
    const double estimatedItemWidth = 120.0;
    final double targetPosition =
        (index * estimatedItemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (estimatedItemWidth / 2);

    _categoriesScrollController.animateTo(
      targetPosition.clamp(
        0.0,
        _categoriesScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSearchChanged(BuildContext context, String query) {
    context.read<CategoryProductsCubit>().updateSearchQuery(query);
  }

  List<CategoryProductEntity> _filterProducts(
    List<CategoryProductEntity> products,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return products;
    }
    return products.where((product) {
      return product.nameAr.contains(searchQuery) ||
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.descriptionAr.contains(searchQuery) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // 🍔 CATEGORIES SECTION
  Widget _buildCategoriesSection(BuildContext context, int selectedCategoryId) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const SizedBox(
            height: 50,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is CategoriesLoaded) {
          final categories = state.categories;
          final pagination = state.pagination;
          final hasMorePages = pagination?.hasMorePages ?? false;

          return SizedBox(
            height: 50,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                // Load more categories when reaching the end
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 100 &&
                    hasMorePages &&
                    !state.isLoadingMore) {
                  context.read<CategoriesCubit>().loadMoreCategories();
                }
                return false;
              },
              child: ListView.builder(
                controller: _categoriesScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length + (hasMorePages ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the end if loading more
                  if (index == categories.length) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 40,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  final category = categories[index];
                  final isSelected = category.id == selectedCategoryId;

                  // Auto-scroll to selected category when categories are loaded
                  if (isSelected) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToCategory(index);
                    });
                  }

                  return GestureDetector(
                    onTap: () {
                      _onCategorySelected(
                        context,
                        category.id,
                        category.nameAr,
                        index,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[300]!,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          context.isArabic ? category.nameAr : category.name,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // 🔎 SEARCH BAR
  Widget _buildSearchBar(BuildContext context, String searchQuery) {
    // Update controller text if it differs from the current query
    if (_searchController.text != searchQuery) {
      _searchController.text = searchQuery;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
            hintText: context.isArabic
                ? 'ابحث عن منتج...'
                : "Search for a product...",
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, child) {
                return value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.search, color: AppColors.primary),
                        onPressed: () =>
                            _onSearchChanged(context, _searchController.text),
                        tooltip: context.isArabic ? 'بحث' : 'Search',
                      )
                    : const SizedBox.shrink();
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (query) => _onSearchChanged(context, query),
          onSubmitted: (query) => _onSearchChanged(context, query),
        ),
      ),
    );
  }

  // 🍱 PRODUCTS GRID
  Widget _buildProductsGrid(
    BuildContext context,
    List<CategoryProductEntity> products,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsScreen(productId: product.id),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Image + badge (Stack, fixed height) ──────────────────
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 170,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image
                        product.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl:
                                    product.thumbnailUrl ?? product.imageUrl!,
                                fit: BoxFit.fill,
                                memCacheHeight: 340,
                                memCacheWidth: 600,
                                fadeInDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                fadeOutDuration: const Duration(
                                  milliseconds: 100,
                                ),
                                placeholder: (context, url) => Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/logo.png',

                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.grey[100],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),

                        // Preparation time badge (top-right)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 11,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${product.preparationTime} د',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 2. Name & price — outside the Stack, below the image ────
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Product name
                        Text(
                          context.isArabic ? product.nameAr : product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Price — secondary, smaller
                        Text(
                          PriceFormatter.formatWithCurrency(
                            product.price,
                            product.currency!.symbol,
                            decimalPlaces: product.currency!.decimalPlaces,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 💀 SKELETON LOADING GRID
  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6, // Show 6 skeleton cards
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: _buildShimmer(
              child: Container(
                width: double.infinity,
                height: 110,
                color: Colors.grey[300],
              ),
            ),
          ),

          // Skeleton Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton Title
                _buildShimmer(
                  child: Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _buildShimmer(
                  child: Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Skeleton Price
                _buildShimmer(
                  child: Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Skeleton Time
                _buildShimmer(
                  child: Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer({required Widget child}) {
    return _ShimmerWidget(child: child);
  }
}

class _ShimmerWidget extends StatefulWidget {
  final Widget child;

  const _ShimmerWidget({required this.child});

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(opacity: _animation.value, child: child);
      },
      child: widget.child,
    );
  }
}
