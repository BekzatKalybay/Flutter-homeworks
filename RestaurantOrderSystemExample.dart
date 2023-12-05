class MenuItem {
  String name;
  double price;

  MenuItem(this.name, this.price);
}

Map<MenuItem, int> createOrder(List<MenuItem> items, List<int> quantities) {
  Map<MenuItem, int> order = {};
  for (var i = 0; i < items.length; i++) {
    order[items[i]] = quantities[i];
  }
  return order;
}

double calculateTotal(Map<MenuItem, int> order, {double taxRate = 0.1, List<Function>? discounts}) {
  double subtotal = 0;
  order.forEach((item, quantity) {
    subtotal += item.price * quantity;
  });

  if (discounts != null) {
    discounts.forEach((discount) {
      subtotal = discount(subtotal);
    });
  }

  double total = subtotal * (1 + taxRate);
  return total;
}

void main() {
  var menuItems = [
    MenuItem('Паста', 12.99),
    MenuItem('Стейк', 19.99),
    MenuItem('Салат', 7.99),
  ];

  var order = createOrder(menuItems, [2, 1, 3]);

  List<Function> discounts = [
    (subtotal) => subtotal * 0.9,
    (subtotal) => subtotal - 5,
  ];

  double total = calculateTotal(order, taxRate: 0.1, discounts: discounts);

  print('Заказ:');
  order.forEach((item, quantity) {
    print('${item.name}: $quantity x \$${item.price}');
  });
  print('-----------------------');
  print('Итоговая стоимость: \$${total.toStringAsFixed(2)}');
}
