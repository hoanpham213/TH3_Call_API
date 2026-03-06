// lib/services/product_service.dart
//
// Nguồn dữ liệu: Mock data nội bộ (mô phỏng gọi API qua Future.delayed)
// Trong thực tế có thể thay bằng http.get() đến REST API thực.

import 'dart:async';
import '../models/product_model.dart';

class ProductService {
  static const Duration _simulatedDelay = Duration(milliseconds: 1500);

  // ── Dữ liệu mock sản phẩm điện tử ─────────────────────────────────────────
  static final List<Map<String, dynamic>> _mockData = [
    // ===== LAPTOP =====
    {
      'id': 1,
      'title': 'MacBook Air M2 13 inch 2024',
      'brand': 'Apple',
      'price': 27990000.0,
      'originalPrice': 31990000.0,
      'description':
          'MacBook Air với chip Apple M2 mạnh mẽ, màn hình Liquid Retina 13.6 inch, thời lượng pin lên đến 18 giờ. Thiết kế siêu mỏng nhẹ, không quạt làm mát, hoàn hảo cho công việc di động.',
      'category': 'laptop',
      'imageUrl': 'https://cdn2.cellphones.com.vn/x/media/catalog/product/m/a/macbook-air-m2-starlight.png',
      'rating': {'rate': 4.8, 'count': 3241},
      'specs': ['Chip Apple M2 8 nhân', 'RAM 8GB Unified', 'SSD 256GB', 'Màn hình 13.6" 2560x1664', 'Pin 18 giờ', 'macOS Sonoma'],
      'inStock': true,
    },
    {
      'id': 2,
      'title': 'Dell XPS 15 9530 Intel Core i7',
      'brand': 'Dell',
      'price': 39990000.0,
      'originalPrice': 45000000.0,
      'description':
          'Laptop cao cấp Dell XPS 15 với màn hình OLED 15.6 inch sắc nét, hiệu năng mạnh mẽ từ Intel Core i7 thế hệ 13, RAM 16GB và SSD 512GB. Lý tưởng cho đồ họa và lập trình.',
      'category': 'laptop',
      'imageUrl': 'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/black/notebook-xps-15-9530-t-black-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402&chrss=full',
      'rating': {'rate': 4.6, 'count': 1854},
      'specs': ['Intel Core i7-13700H', 'RAM 16GB DDR5', 'SSD 512GB NVMe', 'Màn hình OLED 15.6" 3.5K', 'NVIDIA RTX 4060', 'Windows 11 Pro'],
      'inStock': true,
    },
    {
      'id': 3,
      'title': 'ASUS ROG Zephyrus G14 2024',
      'brand': 'ASUS',
      'price': 35490000.0,
      'originalPrice': 38990000.0,
      'description':
          'Laptop gaming mỏng nhẹ hàng đầu với AMD Ryzen 9 và NVIDIA RTX 4070. Màn hình 14 inch 165Hz cho trải nghiệm chơi game mượt mà. Thiết kế AniMe Matrix LED độc đáo trên nắp máy.',
      'category': 'laptop',
      'imageUrl': 'https://dlcdnwebimgs.asus.com/gain/A607E014-1A8D-42B4-8978-4E6F63F8FE40/w800',
      'rating': {'rate': 4.7, 'count': 2109},
      'specs': ['AMD Ryzen 9 8945HS', 'RAM 32GB DDR5', 'SSD 1TB NVMe', 'Màn hình 14" 165Hz WQXGA', 'NVIDIA RTX 4070', 'ROG Intelligent Cooling'],
      'inStock': true,
    },
    {
      'id': 4,
      'title': 'Lenovo ThinkPad X1 Carbon Gen 11',
      'brand': 'Lenovo',
      'price': 42500000.0,
      'originalPrice': 48000000.0,
      'description':
          'Laptop doanh nhân huyền thoại ThinkPad X1 Carbon siêu nhẹ chỉ 1.12kg, bền bỉ chuẩn MIL-SPEC. Intel Core i7, màn hình IPS 2.8K, bàn phím cơ học nổi tiếng của ThinkPad.',
      'category': 'laptop',
      'imageUrl': 'https://p1-ofp.static.pub/fes/cms/2022/09/08/0uz5azlgua3rk4lvmn5z3hg93cxkue726580.png',
      'rating': {'rate': 4.9, 'count': 987},
      'specs': ['Intel Core i7-1365U vPro', 'RAM 16GB LPDDR5', 'SSD 512GB', 'Màn hình 14" IPS 2.8K', 'Chỉ 1.12kg', 'Chuẩn MIL-SPEC-810H'],
      'inStock': true,
    },
    {
      'id': 5,
      'title': 'HP Pavilion 15 AMD Ryzen 5',
      'brand': 'HP',
      'price': 14990000.0,
      'originalPrice': 17500000.0,
      'description':
          'Laptop phổ thông giá tốt HP Pavilion 15 với AMD Ryzen 5, RAM 8GB, SSD 512GB. Phù hợp học tập, văn phòng cơ bản. Màn hình Full HD sắc nét, pin dùng cả ngày.',
      'category': 'laptop',
      'imageUrl': 'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/knowledgebase/images/c08234770.png',
      'rating': {'rate': 4.3, 'count': 5632},
      'specs': ['AMD Ryzen 5 7530U', 'RAM 8GB DDR4', 'SSD 512GB', 'Màn hình 15.6" FHD IPS', 'AMD Radeon Graphics', 'Windows 11 Home'],
      'inStock': true,
    },

    // ===== SMARTPHONE =====
    {
      'id': 6,
      'title': 'iPhone 15 Pro Max 256GB',
      'brand': 'Apple',
      'price': 33990000.0,
      'originalPrice': 34990000.0,
      'description':
          'iPhone 15 Pro Max với chip A17 Pro mạnh nhất từ trước đến nay, camera 48MP hệ thống ProRAW, màn hình Super Retina XDR 6.7 inch. Khung titanium cao cấp, cổng USB-C 3.0.',
      'category': 'smartphone',
      'imageUrl': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-7inch-naturaltitanium?wid=5120&hei=2880&fmt=p-jpg&qlt=80&.v=1692845702708',
      'rating': {'rate': 4.9, 'count': 8754},
      'specs': ['Chip A17 Pro 3nm', 'RAM 8GB', 'Bộ nhớ 256GB', 'Màn hình 6.7" ProMotion 120Hz', 'Camera 48MP + 12MP + 12MP', 'Pin 4422 mAh'],
      'inStock': true,
    },
    {
      'id': 7,
      'title': 'Samsung Galaxy S24 Ultra 512GB',
      'brand': 'Samsung',
      'price': 31990000.0,
      'originalPrice': 33990000.0,
      'description':
          'Samsung Galaxy S24 Ultra với bút S Pen tích hợp, camera 200MP zoom quang 5x, màn hình Dynamic AMOLED 2X 6.8 inch 120Hz. Chip Snapdragon 8 Gen 3 cực mạnh với AI Galaxy.',
      'category': 'smartphone',
      'imageUrl': 'https://images.samsung.com/vn/smartphones/galaxy-s24-ultra/images/galaxy-s24-ultra-highlights-color-titaniumyellow.jpg',
      'rating': {'rate': 4.8, 'count': 6321},
      'specs': ['Snapdragon 8 Gen 3', 'RAM 12GB', 'Bộ nhớ 512GB', 'Màn hình 6.8" QHD+ 120Hz', 'Camera 200MP + zoom 5x', 'S Pen tích hợp'],
      'inStock': true,
    },
    {
      'id': 8,
      'title': 'Xiaomi 14 Ultra 5G 256GB',
      'brand': 'Xiaomi',
      'price': 22990000.0,
      'originalPrice': 25990000.0,
      'description':
          'Xiaomi 14 Ultra với hệ thống camera Leica xịn nhất, ống kính 1 inch siêu lớn, chip Snapdragon 8 Gen 3, sạc nhanh 90W và sạc không dây 80W. Màn hình LTPO AMOLED 120Hz.',
      'category': 'smartphone',
      'imageUrl': 'https://i02.appmifile.com/mi-com-product/fly-birds/xiaomi-14-ultra/M/pc/2ec3d26a7ef2c33f2d9e2e8c76c5a9ee.png',
      'rating': {'rate': 4.7, 'count': 3145},
      'specs': ['Snapdragon 8 Gen 3', 'RAM 16GB', 'Bộ nhớ 256GB', 'Camera Leica 50MP 1-inch', 'Sạc nhanh 90W', 'Màn hình 6.73" LTPO 120Hz'],
      'inStock': true,
    },
    {
      'id': 9,
      'title': 'OPPO Reno 12 Pro 5G 256GB',
      'brand': 'OPPO',
      'price': 13490000.0,
      'originalPrice': 15990000.0,
      'description':
          'OPPO Reno 12 Pro với thiết kế mỏng đẹp, camera chân dung AI xuất sắc, sạc siêu nhanh SUPERVOOC 80W. Màn hình AMOLED cong 6.7 inch 120Hz cho trải nghiệm hình ảnh tuyệt vời.',
      'category': 'smartphone',
      'imageUrl': 'https://image.oppo.com/content/dam/oppo/product-asset-library/reno/reno12-pro-5g/overview/v1/assets/images/hero-img.png',
      'rating': {'rate': 4.5, 'count': 4218},
      'specs': ['MediaTek Dimensity 7300', 'RAM 12GB', 'Bộ nhớ 256GB', 'Màn hình 6.7" AMOLED 120Hz', 'Camera 50MP Sony IMX906', 'Sạc 80W SUPERVOOC'],
      'inStock': true,
    },
    {
      'id': 10,
      'title': 'Vivo V30 Pro 5G 256GB',
      'brand': 'Vivo',
      'price': 11990000.0,
      'originalPrice': 13990000.0,
      'description':
          'Vivo V30 Pro với camera ZEISS chuyên nghiệp, màn hình AMOLED cong 6.78 inch 120Hz, sạc FlashCharge 80W. Thiết kế sang trọng, pin 5000mAh cho ngày dài.',
      'category': 'smartphone',
      'imageUrl': 'https://cdn.vivo.com/image/2024/02/26/vivo-v30-pro-5g.png',
      'rating': {'rate': 4.4, 'count': 2876},
      'specs': ['Snapdragon 7 Gen 3', 'RAM 12GB', 'Bộ nhớ 256GB', 'Camera ZEISS 50MP', 'Màn hình 6.78" AMOLED', 'Sạc 80W FlashCharge'],
      'inStock': true,
    },

    // ===== TABLET =====
    {
      'id': 11,
      'title': 'iPad Pro M4 11 inch 256GB WiFi',
      'brand': 'Apple',
      'price': 23990000.0,
      'originalPrice': 26990000.0,
      'description':
          'iPad Pro M4 mỏng nhất từ trước đến nay chỉ 5.1mm, màn hình Ultra Retina XDR OLED tandem 11 inch siêu đẹp. Chip M4 cực mạnh, hỗ trợ Apple Pencil Pro và bàn phím Magic Keyboard.',
      'category': 'tablet',
      'imageUrl': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/ipad-pro-finish-unselect-gallery-1-202405?wid=5120&hei=2880&fmt=p-jpg&qlt=95',
      'rating': {'rate': 4.9, 'count': 2134},
      'specs': ['Chip Apple M4', 'RAM 8GB', 'Bộ nhớ 256GB', 'Màn hình 11" Ultra Retina XDR OLED', 'Chỉ 5.1mm mỏng', 'iPadOS 17'],
      'inStock': true,
    },
    {
      'id': 12,
      'title': 'Samsung Galaxy Tab S9 FE 128GB',
      'brand': 'Samsung',
      'price': 9490000.0,
      'originalPrice': 11490000.0,
      'description':
          'Samsung Galaxy Tab S9 FE với màn hình TFT LCD 10.9 inch sắc nét, kèm bút S Pen, hỗ trợ 5G, vỏ nhôm chắc chắn chống nước IP68. Lý tưởng cho học tập và giải trí.',
      'category': 'tablet',
      'imageUrl': 'https://images.samsung.com/vn/smartphones/galaxy-tab-s9-fe/images/galaxy-tab-s9-fe-front-back-mint.jpg',
      'rating': {'rate': 4.5, 'count': 3218},
      'specs': ['Exynos 1380', 'RAM 6GB', 'Bộ nhớ 128GB', 'Màn hình 10.9" TFT LCD', 'Kèm S Pen', 'Kháng nước IP68'],
      'inStock': true,
    },
    {
      'id': 13,
      'title': 'Xiaomi Pad 6 Pro 256GB',
      'brand': 'Xiaomi',
      'price': 10990000.0,
      'originalPrice': 12490000.0,
      'description':
          'Xiaomi Pad 6 Pro với màn hình 11 inch 144Hz sắc nét, chip Snapdragon 8+ Gen 1 mạnh mẽ, RAM 8GB, loa 4 speaker Dolby Atmos, sạc nhanh 67W. Trải nghiệm giải trí đỉnh cao.',
      'category': 'tablet',
      'imageUrl': 'https://i02.appmifile.com/mi-com-product/fly-birds/xiaomi-pad-6/pc/63614af3a8b1b52e97f413f77d28b9d3.png',
      'rating': {'rate': 4.6, 'count': 1987},
      'specs': ['Snapdragon 8+ Gen 1', 'RAM 8GB', 'Bộ nhớ 256GB', 'Màn hình 11" IPS 144Hz', '4 loa Dolby Atmos', 'Sạc 67W'],
      'inStock': true,
    },

    // ===== DESKTOP / PC =====
    {
      'id': 14,
      'title': 'iMac 24 inch M3 8GB 256GB 2023',
      'brand': 'Apple',
      'price': 39990000.0,
      'originalPrice': 43990000.0,
      'description':
          'iMac 24 inch với chip M3, màn hình Retina 4.5K 24 inch rực rỡ, webcam 12MP, loa 6 loa studio âm thanh vòm, thiết kế siêu mỏng 11.5mm. Trọn bộ phụ kiện Magic Keyboard và Magic Mouse.',
      'category': 'desktop',
      'imageUrl': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/imac-24-blue-selection-hero-202310?wid=904&hei=840&fmt=jpeg&qlt=90&.v=1697036534498',
      'rating': {'rate': 4.8, 'count': 1543},
      'specs': ['Chip Apple M3 8 nhân', 'RAM 8GB Unified', 'SSD 256GB', 'Màn hình 24" Retina 4.5K', '12MP Center Stage', '6 loa studio'],
      'inStock': true,
    },
    {
      'id': 15,
      'title': 'PC Gaming Intel Core i9 RTX 4090',
      'brand': 'Custom Build',
      'price': 89990000.0,
      'originalPrice': 95000000.0,
      'description':
          'Bộ máy tính gaming cao cấp cấu hình khủng: Intel Core i9-14900K, RTX 4090 24GB, RAM 64GB DDR5, SSD NVMe 2TB. Tản nhiệt AIO 360mm, case full tower RGB. Đáp ứng mọi tựa game AAA 4K.',
      'category': 'desktop',
      'imageUrl': 'https://cdn.mos.cms.futurecdn.net/N4uBzBmYdEnAEpHQtqNiGf.jpg',
      'rating': {'rate': 4.9, 'count': 432},
      'specs': ['Intel Core i9-14900K', 'RTX 4090 24GB GDDR6X', 'RAM 64GB DDR5 6000MHz', 'SSD 2TB PCIe 5.0', 'PSU 1200W Platinum', 'Case ASUS ROG'],
      'inStock': false,
    },
    {
      'id': 16,
      'title': 'Máy tính bàn HP All-in-One 24 inch',
      'brand': 'HP',
      'price': 18490000.0,
      'originalPrice': 21000000.0,
      'description':
          'HP All-in-One gọn nhẹ, màn hình cảm ứng 24 inch Full HD, Intel Core i5, RAM 8GB, SSD 512GB. Phù hợp văn phòng, gia đình. Tích hợp webcam HD và mic khử tiếng ồn.',
      'category': 'desktop',
      'imageUrl': 'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/knowledgebase/images/c08110044.png',
      'rating': {'rate': 4.4, 'count': 876},
      'specs': ['Intel Core i5-1235U', 'RAM 8GB DDR4', 'SSD 512GB', 'Màn hình 24" FHD cảm ứng', 'Intel Iris Xe', 'Webcam 5MP TrueVision'],
      'inStock': true,
    },

    // ===== ACCESSORY =====
    {
      'id': 17,
      'title': 'Apple AirPods Pro 2nd Gen (USB-C)',
      'brand': 'Apple',
      'price': 6490000.0,
      'originalPrice': 7490000.0,
      'description':
          'AirPods Pro thế hệ 2 với chip H2 mới, chống ồn chủ động ANC cải tiến 2 lần, âm thanh Spatial Audio, cổng sạc USB-C. Chống nước IP54, pin lên đến 30 giờ với case.',
      'category': 'accessory',
      'imageUrl': 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQD83?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=1660803972361',
      'rating': {'rate': 4.8, 'count': 9876},
      'specs': ['Chip Apple H2', 'ANC chủ động thế hệ 2', 'Spatial Audio + Dolby Atmos', 'Pin 6h (30h với case)', 'Chống nước IP54', 'Cổng USB-C'],
      'inStock': true,
    },
    {
      'id': 18,
      'title': 'Samsung Galaxy Watch 6 Classic 47mm',
      'brand': 'Samsung',
      'price': 8490000.0,
      'originalPrice': 9990000.0,
      'description':
          'Samsung Galaxy Watch 6 Classic với vòng bezel xoay huyền thoại, màn hình Super AMOLED 47mm, theo dõi sức khỏe toàn diện: ECG, huyết áp, SpO2. Wear OS 4 + One UI Watch 6.',
      'category': 'accessory',
      'imageUrl': 'https://images.samsung.com/vn/smartphones/galaxy-watch6-classic/images/galaxy-watch6-classic-47mm-front-graphite.jpg',
      'rating': {'rate': 4.7, 'count': 3254},
      'specs': ['Exynos W930', 'Màn hình 47mm Super AMOLED', 'Bezel xoay vật lý', 'ECG + Huyết áp + SpO2', 'Pin 2 ngày', 'Wear OS 4'],
      'inStock': true,
    },
    {
      'id': 19,
      'title': 'Logitech MX Master 3S Wireless',
      'brand': 'Logitech',
      'price': 2190000.0,
      'originalPrice': 2690000.0,
      'description':
          'Chuột không dây cao cấp Logitech MX Master 3S với cảm biến 8000 DPI, cuộn MagSpeed siêu trơn, kết nối đa thiết bị Bluetooth & USB. Sạc USB-C, pin 70 ngày.',
      'category': 'accessory',
      'imageUrl': 'https://resource.logitech.com/w_1600,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/mice/mx-master-3s/gallery/mx-master-3s-mouse-top-view-graphite.png',
      'rating': {'rate': 4.9, 'count': 7654},
      'specs': ['Cảm biến Darkfield 8000 DPI', 'MagSpeed cuộn siêu nhanh', 'Kết nối 3 thiết bị', 'Pin 70 ngày USB-C', 'Tương thích Mac & Windows', '7 nút lập trình'],
      'inStock': true,
    },
    {
      'id': 20,
      'title': 'Màn hình LG UltraWide 34 inch WQHD',
      'brand': 'LG',
      'price': 11990000.0,
      'originalPrice': 14490000.0,
      'description':
          'Màn hình cong ultrawide LG 34 inch tỉ lệ 21:9 WQHD 3440x1440, IPS Nano 144Hz, HDR10, FreeSync Premium. Lý tưởng cho làm việc đa nhiệm và gaming tầm trung.',
      'category': 'accessory',
      'imageUrl': 'https://gscs-b2c.lge.com/downloadFile?fileId=1hnSvY4gFbAbsWkAXCLVsA',
      'rating': {'rate': 4.6, 'count': 2341},
      'specs': ['34" WQHD 3440x1440', 'IPS Nano 144Hz', 'HDR10 + DCI-P3 98%', 'FreeSync Premium', 'USB-C 65W + HDMI 2.0', 'Cong 1800R'],
      'inStock': true,
    },

    // ===== TIVI =====
    {
      'id': 21,
      'title': 'Samsung Neo QLED 4K 55 inch 2024',
      'brand': 'Samsung',
      'price': 24990000.0,
      'originalPrice': 31990000.0,
      'description':
          'Tivi Samsung Neo QLED 4K 55 inch với công nghệ Quantum Matrix, bộ xử lý Neural Quantum 4K, âm thanh Dolby Atmos 40W, Smart TV Tizen OS 8.0. Hình ảnh sắc nét với HDR 2000 nit.',
      'category': 'tv',
      'imageUrl': 'https://images.samsung.com/vn/tvs/neo-qled-4k-tv/images/neo-qled-4k-tv-highlights-design-01-mo.jpg',
      'rating': {'rate': 4.7, 'count': 4321},
      'specs': ['Neo QLED 4K 55 inch', 'Quantum Matrix Technology', 'HDR 2000 nit', 'Âm thanh 40W Dolby Atmos', 'Tizen OS 8.0', '4K AI Upscaling'],
      'inStock': true,
    },
    {
      'id': 22,
      'title': 'LG OLED evo C3 65 inch 4K Smart TV',
      'brand': 'LG',
      'price': 42990000.0,
      'originalPrice': 55990000.0,
      'description':
          'LG OLED evo C3 với công nghệ OLED tự phát sáng mỗi điểm ảnh, đen tuyệt đối, màu sắc chính xác, độ sáng cải tiến. Chip α9 Gen6 AI, webOS 23, hỗ trợ 4 chuẩn HDR, HDMI 2.1 x4.',
      'category': 'tv',
      'imageUrl': 'https://gscs-b2c.lge.com/downloadFile?fileId=P9W4thJO5nZVacW5CdZhWA',
      'rating': {'rate': 4.9, 'count': 2109},
      'specs': ['OLED evo 65 inch 4K', 'Chip α9 Gen6 AI', 'HDMI 2.1 x4 @ 4K 120Hz', 'VRR + ALLM Gaming', 'Dolby Vision IQ + Atmos', 'webOS 23'],
      'inStock': true,
    },
  ];

  // ── Lấy tất cả sản phẩm (giả lập gọi mạng) ───────────────────────────────
  Future<List<Product>> fetchAllProducts() async {
    try {
      await Future.delayed(_simulatedDelay);
      return _mockData.map((e) => Product.fromJson(e)).toList();
    } on FormatException {
      throw Exception('Dữ liệu không hợp lệ!');
    } catch (e) {
      throw Exception('Lỗi tải sản phẩm: $e');
    }
  }

  // ── Lấy danh sách categories ──────────────────────────────────────────────
  Future<List<String>> fetchCategories() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final cats = _mockData.map((e) => e['category'] as String).toSet().toList();
      cats.sort();
      return cats;
    } catch (e) {
      throw Exception('Lỗi tải danh mục: $e');
    }
  }

  // ── Lấy sản phẩm theo category ────────────────────────────────────────────
  Future<List<Product>> fetchByCategory(String category) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return _mockData
          .where((e) => e['category'] == category)
          .map((e) => Product.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Lỗi lọc danh mục: $e');
    }
  }
}
