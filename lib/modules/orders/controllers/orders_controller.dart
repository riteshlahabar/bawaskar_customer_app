import 'package:get/get.dart';

import '../../../app/data/models/order_model.dart';
import '../../../app/data/services/customer_api_service.dart';

class OrdersController extends GetxController {
  OrdersController(this._api);

  final CustomerApiService _api;
  final isLoading = false.obs;
  final orders = <OrderModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final response = await _api.orders();

dynamic payload =
    response['data'] ?? response;

if (payload is Map &&
    payload['orders'] != null) {
  payload = payload['orders'];
}

final List<dynamic> list;

if (payload is List) {
  list = payload;
} else if (payload is Map &&
    payload['data'] is List) {
  list = List<dynamic>.from(
    payload['data'] as List,
  );
} else if (payload is Map &&
    payload['items'] is List) {
  list = List<dynamic>.from(
    payload['items'] as List,
  );
} else {
  list = const [];
}

orders.assignAll(
  list
      .whereType<Map>()
      .map(
        (item) => OrderModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      ),
);
    } catch (_) {
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
