import 'package:flutter/material.dart';
import 'app_state.dart';
import 'widgets.dart';

// 3. Home / Dashboard
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _tile(BuildContext c, IconData i, String t, String route) => Expanded(
        child: InkWell(
          onTap: () => Navigator.pushNamed(c, route),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBorder)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(i, color: c.pc, size: 24),
              const SizedBox(height: 6),
              Text(t, style: const TextStyle(fontSize: 11, color: kInk)),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = AppState.I;
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: s,
          builder: (_, __) => ListView(padding: const EdgeInsets.all(16), children: [
            Row(children: [
              const Expanded(
                child: Text('Good Morning,\nBusiness Owner',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800, height: 1.25)),
              ),
              const Icon(Icons.notifications_none, size: 22),
              const SizedBox(width: 10),
              CircleAvatar(
                  radius: 13,
                  backgroundColor: context.pc,
                  child: const Icon(Icons.person, size: 16, color: Colors.white)),
            ]),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: context.pc, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Sales",
                            style: TextStyle(color: Colors.white, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(money(s.todaySales),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        const Text('↑ 12%',
                            style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ]),
                ),
                const Icon(Icons.bar_chart, color: Colors.white70, size: 30),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              _tile(context, Icons.shopping_cart_outlined, 'New Sale', '/sale'),
              const SizedBox(width: 10),
              _tile(context, Icons.inventory_2_outlined, 'Inventory', '/inventory'),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _tile(context, Icons.people_outline, 'Customers', '/customers'),
              const SizedBox(width: 10),
              _tile(context, Icons.bar_chart, 'Reports', '/reports'),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Recent Transactions',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('View All', style: TextStyle(fontSize: 11, color: context.pc)),
            ]),
            const SizedBox(height: 8),
            for (final t in s.txns.take(3))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        color: t.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(t.icon, size: 15, color: t.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(t.title, style: const TextStyle(fontSize: 11))),
                  Text(money(t.amount),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 12),
                  Text(t.time, style: const TextStyle(fontSize: 10, color: kGrey)),
                ]),
              ),
          ]),
        ),
      ),
      bottomNavigationBar: const AppNavBar(0),
    );
  }
}

// 4. Product / Item Selection
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String cat = 'All', q = '';
  @override
  Widget build(BuildContext context) {
    final s = AppState.I;
    final list = s.products
        .where((p) =>
            (cat == 'All' || p.category == cat) &&
            p.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: appBarX(context, 'Products'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          SearchBox('Search products...', onChanged: (v) => setState(() => q = v)),
          const SizedBox(height: 10),
          Row(children: [
            for (final c in ['All', 'Beverages', 'Snacks', 'Groceries']) ...[
              Pill(c, cat == c, () => setState(() => cat = c)),
              const SizedBox(width: 8),
            ]
          ]),
          const SizedBox(height: 6),
          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: kBorder),
              itemBuilder: (_, i) {
                final p = list[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    ProductThumb(p.icon, p.color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(money(p.price),
                                style: const TextStyle(fontSize: 11)),
                            Text('Stock: ${p.stock}',
                                style: const TextStyle(fontSize: 10, color: kGrey)),
                          ]),
                    ),
                    InkWell(
                      onTap: () {
                        s.add(p);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text('${p.name} added to sale'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                                label: 'VIEW',
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/sale')),
                          ));
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: context.pc,
                            borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

// 5. Create Sale / Checkout
class NewSaleScreen extends StatelessWidget {
  const NewSaleScreen({super.key});

  Widget _row(String a, String b, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Text(a,
              style: TextStyle(
                  fontSize: bold ? 13 : 11,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
                  color: bold ? kInk : kGrey)),
          const Spacer(),
          Text(b,
              style: TextStyle(
                  fontSize: bold ? 13 : 11,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
        ]),
      );

  Widget _stepBtn(IconData i, VoidCallback f) => InkWell(
      onTap: f, child: Padding(padding: const EdgeInsets.all(4), child: Icon(i, size: 12)));

  Future<void> _pickCustomer(BuildContext c) async {
    final s = AppState.I;
    final names = ['Walk-in Customer', ...s.customers.map((e) => e.name)];
    final r = await showModalBottomSheet<String>(
      context: c,
      builder: (_) => ListView(shrinkWrap: true, children: [
        for (final n in names)
          ListTile(title: Text(n), onTap: () => Navigator.pop(c, n)),
      ]),
    );
    if (r != null) s.setCustomer(r);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppState.I;
    return Scaffold(
      appBar: appBarX(context, 'New Sale'),
      body: ListenableBuilder(
        listenable: s,
        builder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.person_outline, size: 18),
                const SizedBox(width: 8),
                Text(s.customer, style: const TextStyle(fontSize: 12)),
                const Spacer(),
                GestureDetector(
                    onTap: () => _pickCustomer(context),
                    child: Text('Change',
                        style: TextStyle(fontSize: 11, color: context.pc))),
              ]),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: s.cart.isEmpty
                  ? const Center(
                      child: Text('Cart is empty. Add items from Products.',
                          style: TextStyle(fontSize: 12, color: kGrey)))
                  : ListView(children: [
                      for (final e in s.cart.entries)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(children: [
                            ProductThumb(e.key.icon, e.key.color, size: 34),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.key.name,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600)),
                                    Text(money(e.key.price),
                                        style: const TextStyle(fontSize: 10)),
                                    const SizedBox(height: 4),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kBorder),
                                          borderRadius: BorderRadius.circular(4)),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _stepBtn(Icons.remove, () => s.remove(e.key)),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                              child: Text('${e.value}',
                                                  style: const TextStyle(fontSize: 10)),
                                            ),
                                            _stepBtn(Icons.add, () => s.add(e.key)),
                                          ]),
                                    ),
                                  ]),
                            ),
                            Text(money(e.key.price * e.value),
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                    ]),
            ),
            const Divider(color: kBorder),
            _row('Subtotal', money(s.subtotal)),
            _row('Tax (18%)', money(s.tax)),
            const Divider(color: kBorder),
            _row('Total', money(s.total), bold: true),
            const SizedBox(height: 8),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('Payment Method',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
            const SizedBox(height: 6),
            Row(children: [
              for (final m in const [
                ['Cash', Icons.local_atm],
                ['Card', Icons.credit_card],
                ['Mobile Money', Icons.phone_android],
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => s.setPay(m[0] as String),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: s.payMethod == m[0] ? context.pc : kBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: s.payMethod == m[0] ? context.pc : kBorder),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(m[1] as IconData,
                              size: 13,
                              color: s.payMethod == m[0] ? Colors.white : kInk),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(m[0] as String,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: s.payMethod == m[0] ? Colors.white : kInk)),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
            ]),
            const SizedBox(height: 10),
            PrimaryButton('Complete Sale', () {
              if (s.cart.isEmpty) {
                info(context, 'Cart is empty', 'Add products before completing a sale.');
              } else {
                Navigator.pushNamed(context, '/payment');
              }
            }),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }
}

// 6. Payment Methods
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppState.I;
    final methods = [
      ['Cash', 'Cash', Icons.payments, const Color(0xFF16A34A)],
      ['Card', 'Credit / Debit Card', Icons.credit_card, const Color(0xFF2563EB)],
      ['Mobile Money', 'Mobile Money (MTN/Airtel)', Icons.phone_android, const Color(0xFFCA8A04)],
      ['Bank Transfer', 'Bank Transfer', Icons.account_balance, const Color(0xFF374151)],
    ];
    return Scaffold(
      appBar: appBarX(context, 'Payment'),
      body: ListenableBuilder(
        listenable: s,
        builder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                  border: Border.all(color: kBorder),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(children: [
                const Text('Total Amount',
                    style: TextStyle(fontSize: 11, color: kGrey)),
                const SizedBox(height: 4),
                Text(money(s.total),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(height: 14),
            for (final m in methods)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => s.setPay(m[0] as String),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: kBorder),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      ProductThumb(m[2] as IconData, m[3] as Color, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(m[1] as String,
                              style: const TextStyle(fontSize: 12))),
                      Icon(
                          s.payMethod == m[0]
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 20,
                          color: s.payMethod == m[0] ? context.pc : kGrey),
                    ]),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            PrimaryButton('Pay Now', () {
              if (s.cart.isEmpty) {
                info(context, 'Nothing to pay', 'The cart is empty.');
                return;
              }
              final amount = s.total;
              final method = s.payMethod;
              s.completeSale();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  icon: const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 48),
                  title: const Text('Payment Successful'),
                  content: Text('${money(amount)} received via $method.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.popUntil(context, (r) => r.settings.name == '/home' || r.isFirst);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              );
            }),
          ]),
        ),
      ),
    );
  }
}
