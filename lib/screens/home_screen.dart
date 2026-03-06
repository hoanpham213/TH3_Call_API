// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/loading_grid.dart';
import '../widgets/error_view.dart';
import 'product_detail_screen.dart';

// Enum quản lý trạng thái
enum ViewState { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _service = ProductService();

  // Trạng thái hiển thị
  ViewState _viewState = ViewState.loading;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = ['Tất cả'];
  String _selectedCategory = 'Tất cả';
  String _errorMessage = '';

  // Controller tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // === GỌI API ===
  Future<void> _loadData() async {
    setState(() {
      _viewState = ViewState.loading;
      _errorMessage = '';
    });

    try {
      // Gọi đồng thời sản phẩm và categories
      final results = await Future.wait([
        _service.fetchAllProducts(),
        _service.fetchCategories(),
      ]);

      final products = results[0] as List<Product>;
      final categories = results[1] as List<String>;

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = ['Tất cả', ...categories];
        _viewState = ViewState.success;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _viewState = ViewState.error;
      });
    }
  }

  // === LỌC THEO CATEGORY ===
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      final query = _searchController.text.toLowerCase();
      _applyFilter(category, query);
    });
  }

  // === TÌM KIẾM ===
  void _onSearch(String query) {
    setState(() {
      _applyFilter(_selectedCategory, query.toLowerCase());
    });
  }

  void _applyFilter(String category, String query) {
    List<Product> result = _allProducts;

    if (category != 'Tất cả') {
      result = result.where((p) => p.category == category).toList();
    }

    if (query.isNotEmpty) {
      result = result
          .where((p) => p.title.toLowerCase().contains(query))
          .toList();
    }

    _filteredProducts = result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'TH3 - Phạm Hải Hoàn - 2251172350',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          if (_viewState == ViewState.success)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Tải lại',
            ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {},
          ),
        ],
        bottom: _viewState == ViewState.success
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.2),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_viewState) {
      // ===== TRẠNG THÁI ĐANG TẢI =====
      case ViewState.loading:
        return const LoadingGrid();

      // ===== TRẠNG THÁI LỖI =====
      case ViewState.error:
        return ErrorView(message: _errorMessage, onRetry: _loadData);

      // ===== TRẠNG THÁI THÀNH CÔNG =====
      case ViewState.success:
        return Column(
          children: [
            // Filter categories
            _buildCategoryFilter(),

            // Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Hiển thị ${_filteredProducts.length} sản phẩm',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),

            // Grid sản phẩm
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.70,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
    }
  }

  Widget _buildCategoryFilter() {
    final theme = Theme.of(context);

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;

          return FilterChip(
            label: Text(
              _categoryDisplayName(cat),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => _filterByCategory(cat),
            backgroundColor: theme.colorScheme.surface,
            selectedColor: theme.colorScheme.primary,
            checkmarkColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy sản phẩm nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _searchController.clear();
              _filterByCategory('Tất cả');
            },
            child: const Text('Xóa bộ lọc'),
          ),
        ],
      ),
    );
  }

  String _categoryDisplayName(String cat) {
    switch (cat) {
      case 'Tất cả':
        return '🏪 Tất cả';
      case 'laptop':
        return '💻 Laptop';
      case 'smartphone':
        return '📱 Điện thoại';
      case 'tablet':
        return '📟 Máy tính bảng';
      case 'desktop':
        return '🖥️ Máy tính bàn';
      case 'accessory':
        return '🎧 Phụ kiện';
      case 'tv':
        return '📺 Tivi';
      default:
        return cat;
    }
  }
}
