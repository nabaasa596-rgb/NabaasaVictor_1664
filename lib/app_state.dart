import 'package:flutter/material.dart';

String num0(num v) {
  final s = v.round().toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

String money(num v) => 'UGX ${num0(v)}';

class Product {
  final String name, category;
  final int price, reorder;
  int stock;
  final IconData icon;
  final Color color;
  Product(this.name, this.category, this.price, this.stock, this.reorder,
      this.icon, this.color);
}

class Customer {
  final String name, phone;
  Customer(this.name, this.phone);
}

class Txn {
  final String title, time;
  final int amount;
  final IconData icon;
  final Color color;
  Txn(this.title, this.amount, this.time, this.icon, this.color);
}

/// App-wide state. Everything is kept locally in memory so the app keeps
/// working with no internet connection (offline ready).
class AppState extends ChangeNotifier {
  AppState._() {
    cart[products[0]] = 2; // Coca Cola x2
    cart[products[4]] = 1; // Chips x1
  }
  static final AppState I = AppState._();

  final ValueNotifier<Color> themeColor =
      ValueNotifier<Color>(const Color(0xFF1A6FE8));

  String businessName = 'My Store';
  String businessType = 'Retail Store';
  String payMethod = 'Cash';
  String customer = 'Walk-in Customer';
  int todaySales = 1250000;

  final List<Product> products = [
    Product('Coca Cola 500ml', 'Beverages', 2500, 50, 20,
        Icons.local_drink, const Color(0xFFB91C1C)),
    Product('Sprite 500ml', 'Beverages', 2500, 40, 20,
        Icons.local_drink, const Color(0xFF16A34A)),
    Product('Water 500ml', 'Beverages', 1500, 100, 30,
        Icons.water_drop, const Color(0xFF2563EB)),
    Product('Bread', 'Groceries', 3000, 30, 10,
        Icons.bakery_dining, const Color(0xFFD97706)),
    Product('Chips', 'Snacks', 2000, 45, 15,
        Icons.fastfood, const Color(0xFFCA8A04)),
  ];

  final List<Customer> customers = [
    Customer('John Mwangi', '+256 700 123 456'),
    Customer('Sarah Nakato', '+256 772 987 654'),
    Customer('David Kato', '+256 703 456 789'),
    Customer('Aisha Namuindwa', '+256 751 234 567'),
    Customer('Peter Ssemanda', '+256 787 654 321'),
  ];

  final List<Txn> txns = [
    Txn('Cash Sale', 45000, '10:24 AM', Icons.local_atm, const Color(0xFFEF4444)),
    Txn('Card Payment', 120000, '09:50 AM', Icons.credit_card, const Color(0xFF14B8A6)),
    Txn('Mobile Money', 80000, '09:15 AM', Icons.phone_android, const Color(0xFFEF4444)),
  ];

  final Map<Product, int> cart = {};

  int get subtotal =>
      cart.entries.fold(0, (a, e) => a + e.key.price * e.value);
  int get tax => (subtotal * 0.18).round();
  int get total => subtotal + tax;

  void add(Product p) {
    cart[p] = (cart[p] ?? 0) + 1;
    notifyListeners();
  }

  void remove(Product p) {
    final q = (cart[p] ?? 0) - 1;
    if (q <= 0) {
      cart.remove(p);
    } else {
      cart[p] = q;
    }
    notifyListeners();
  }

  void addProduct(Product p) {
    products.add(p);
    notifyListeners();
  }

  void setCustomer(String c) {
    customer = c;
    notifyListeners();
  }

  void setPay(String m) {
    payMethod = m;
    notifyListeners();
  }

  void setProfile(String name, String type, Color c) {
    businessName = name;
    businessType = type;
    themeColor.value = c;
    notifyListeners();
  }

  String _now() {
    final d = DateTime.now();
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m ${d.hour >= 12 ? 'PM' : 'AM'}';
  }

  void completeSale() {
    final t = total;
    for (final e in cart.entries) {
      e.key.stock = (e.key.stock - e.value).clamp(0, 1 << 30);
    }
    final title = payMethod == 'Cash'
        ? 'Cash Sale'
        : payMethod == 'Card'
            ? 'Card Payment'
            : payMethod == 'Mobile Money'
                ? 'Mobile Money'
                : 'Bank Transfer';
    final icon = payMethod == 'Cash'
        ? Icons.local_atm
        : payMethod == 'Card'
            ? Icons.credit_card
            : payMethod == 'Mobile Money'
                ? Icons.phone_android
                : Icons.account_balance;
    txns.insert(0, Txn(title, t, _now(), icon, const Color(0xFFEF4444)));
    todaySales += t;
    cart.clear();
    notifyListeners();
  }
}
