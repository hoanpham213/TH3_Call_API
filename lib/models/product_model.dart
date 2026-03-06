// lib/models/product_model.dart

class Product {
  final int id;
  final String title;
  final String brand;
  final double price;
  final double originalPrice;
  final String description;
  final String category;
  final String imageUrl;
  final Rating rating;
  final List<String> specs;
  final bool inStock;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.specs,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      specs: List<String>.from(json['specs'] as List),
      inStock: json['inStock'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'brand': brand,
        'price': price,
        'originalPrice': originalPrice,
        'description': description,
        'category': category,
        'imageUrl': imageUrl,
        'rating': {'rate': rating.rate, 'count': rating.count},
        'specs': specs,
        'inStock': inStock,
      };

  String get categoryLabel {
    switch (category) {
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
        return category;
    }
  }

  String get formattedPrice => _formatVND(price);
  String get formattedOriginalPrice => _formatVND(originalPrice);

  int get discountPercent {
    if (originalPrice <= price) return 0;
    return ((originalPrice - price) / originalPrice * 100).round();
  }

  static String _formatVND(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} tỷ ₫';
    } else if (amount >= 1000000) {
      final millions = (amount / 1000000).floor();
      final remainder = ((amount % 1000000) / 100000).floor();
      if (remainder == 0) return '$millions triệu ₫';
      return '$millions.$remainder triệu ₫';
    }
    return '${amount.toStringAsFixed(0)} ₫';
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}
