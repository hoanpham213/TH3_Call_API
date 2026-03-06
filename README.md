# TH3 - Cửa hàng đồ dùng điện tử
### Phạm Hải Hoàn - 2251172350

## Mô tả
Ứng dụng Flutter hiển thị sản phẩm điện tử & thời trang từ **FakeStore API** (https://fakestoreapi.com).

---

## Cấu trúc dự án

```
lib/
├── main.dart                          # Entry point
├── models/
│   └── product_model.dart             # Model: Product, Rating
├── services/
│   └── product_service.dart           # Gọi API (try-catch đầy đủ)
├── screens/
│   ├── home_screen.dart               # Màn hình chính (GridView + 3 states)
│   └── product_detail_screen.dart     # Màn hình chi tiết sản phẩm
└── widgets/
    ├── product_card.dart              # Card sản phẩm
    ├── loading_grid.dart              # Skeleton loading UI
    ├── error_view.dart                # Error UI + Retry button
    └── star_rating.dart               # Widget đánh giá sao
```

---

## Tính năng

### ✅ 3 Trạng thái bắt buộc:
| Trạng thái | Mô tả |
|---|---|
| **Loading** | Hiển thị `CircularProgressIndicator` + skeleton cards animation |
| **Success** | GridView 2 cột, card gọn gàng, text cắt gọn khi dài |
| **Error** | Icon lỗi, thông báo rõ ràng, nút **"Thử lại"** gọi lại API |

### ✅ Chức năng chính:
- Lấy dữ liệu từ **FakeStore API** (public REST API)
- Lọc sản phẩm theo **danh mục** (FilterChip)
- **Tìm kiếm** sản phẩm theo tên
- Xem **chi tiết** sản phẩm (ảnh, mô tả, giá, đánh giá)
- Nút **"Mua ngay"** với SnackBar phản hồi

### ✅ Xử lý lỗi:
- `SocketException` → mất kết nối internet
- `HttpException` → lỗi HTTP từ server
- `FormatException` → dữ liệu JSON không hợp lệ
- Timeout 10 giây

---

## Cài đặt & Chạy

```bash
# Cài dependencies
flutter pub get

# Chạy ứng dụng
flutter run
```

## Dependencies
```yaml
http: ^1.2.0           # Gọi API
cached_network_image   # Cache ảnh
shimmer                # Skeleton loading
```

---

## Giả lập lỗi để test Error State
Để test giao diện lỗi, thay URL trong `product_service.dart`:
```dart
// Thay dòng này:
static const String _baseUrl = 'https://fakestoreapi.com';
// Thành:
static const String _baseUrl = 'https://invalid-url-test.xyz';
```
Hoặc tắt WiFi/mạng rồi bấm nút **"Thử lại"**.
