// ignore_for_file: empty_constructor_bodies, unused_field

class OrderController {
  static final OrderController _session = OrderController._internal();
  String? fuelType;
  int? quantity;
  String? phoneno;
  String? address;
  String? carno;

  factory OrderController() {
    return _session;
  }

  OrderController._internal() {}
}
