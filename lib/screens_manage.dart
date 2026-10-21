import 'package:flutter/material.dart';
import 'app_state.dart';
import 'widgets.dart';

// 7. Inventory Management
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int tab = 0;
  String q = '';

  Widget _tab(String t, int i) => Expanded(
        child: GestureDetector(
          onTap: () => setState(() => tab = i),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tab == i ? context.pc : kBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: tab == i ? context.pc : kBorder),
            ),
            child: Text(t,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: tab == i ? Colors.white : kInk)),
          ),
        ),
      );

  void _addItem() {
    final n = TextEditingController(), p = TextEditingController(), st = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: n, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: p, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (UGX)')),
          TextField(controller: st, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (n.text.trim().isEmpty) return;
              AppState.I.addProduct(Product(n.text.trim(), 'Groceries',
                  int.tryParse(p.text) ?? 0, int.tryParse(st.text) ?? 0, 10,
                  Icons.inventory_2, const Color(0xFF6B7280)));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = AppState.I.products;
    var list = all.where((p) => p.name.toLowerCase().contains(q.toLowerCase())).toList();
    if (tab == 1) list = list.where((p) => p.stock <= p.reorder * 2).toList();
    return Scaffold(
      appBar: appBarX(context, 'Inventory'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Row(children: [
            _tab('Stock', 0), const SizedBox(width: 8),
            _tab('Low Stock', 1), const SizedBox(width: 8),
            _tab('Categories', 2),
          ]),
          const SizedBox(height: 10),
          SearchBox('Search inventory...', onChanged: (v) => setState(() => q = v)),
          const SizedBox(height: 4),
          Expanded(
            child: tab == 2
                ? ListView(children: [
                    for (final c in ['Beverages', 'Snacks', 'Groceries'])
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(c, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        trailing: Text('${all.where((p) => p.category == c).length} items',
                            style: const TextStyle(fontSize: 11, color: kGrey)),
                      ),
                  ])
                : list.isEmpty
                    ? const Center(child: Text('No items', style: TextStyle(fontSize: 12, color: kGrey)))
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: kBorder),
                        itemBuilder: (_, i) {
                          final p = list[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: [
                              ProductThumb(p.icon, p.color, size: 34),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(p.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  Text('Stock: ${p.stock}   Reorder: ${p.reorder}',
                                      style: const TextStyle(fontSize: 10, color: kGrey)),
                                ]),
                              ),
                              const Icon(Icons.chevron_right, size: 18, color: kGrey),
                            ]),
                          );
                        },
                      ),
          ),
        ]),
      ),
      floatingActionButton: tab == 2
          ? null
          : FloatingActionButton(
              mini: true,
              onPressed: _addItem,
              backgroundColor: context.pc,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
    );
  }
}

// 8. Customer Management
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String q = '';

  void _add() {
    final n = TextEditingController(), p = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Customer'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: n, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: p, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (n.text.trim().isEmpty) return;
              AppState.I.customers.add(Customer(n.text.trim(), p.text.trim()));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = AppState.I.customers
        .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: appBarX(context, 'Customers'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          SearchBox('Search customers...', onChanged: (v) => setState(() => q = v)),
          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: kBorder),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(children: [
                  const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFE5E7EB),
                      child: Icon(Icons.person, size: 18, color: kGrey)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(list[i].name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(list[i].phone, style: const TextStyle(fontSize: 10, color: kGrey)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: kGrey),
                ]),
              ),
            ),
          ),
          PrimaryButton('Add Customer', _add, icon: Icons.person_add_alt),
          const SizedBox(height: 14),
        ]),
      ),
    );
  }
}

// 9. Reports & Analytics
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int tab = 0, range = 0;

  Widget _seg(String t, bool sel, VoidCallback f) => Expanded(
        child: GestureDetector(
          onTap: f,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? context.pc : kBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: sel ? context.pc : kBorder),
            ),
            child: Text(t,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: sel ? Colors.white : kInk)),
          ),
        ),
      );

  Widget _bottomBtn(IconData i, String t) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: kBorder),
              borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(i, size: 16, color: context.pc),
            const SizedBox(width: 6),
            Text(t, style: const TextStyle(fontSize: 11)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = AppState.I;
    final totals = ['UGX 8,450,000', 'UGX 34,200,000', 'UGX 8,450,000'];
    final growth = ['↑ 15%', '↑ 9%', '↑ 15%'];
    return Scaffold(
      appBar: appBarX(context, 'Reports'),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
        Row(children: [
          _seg('Sales', tab == 0, () => setState(() => tab = 0)), const SizedBox(width: 8),
          _seg('Inventory', tab == 1, () => setState(() => tab = 1)), const SizedBox(width: 8),
          _seg('Customers', tab == 2, () => setState(() => tab = 2)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _seg('7 Days', range == 0, () => setState(() => range = 0)), const SizedBox(width: 8),
          _seg('30 Days', range == 1, () => setState(() => range = 1)), const SizedBox(width: 8),
          _seg('Custom', range == 2, () => setState(() => range = 2)),
        ]),
        const SizedBox(height: 12),
        if (tab == 0) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(color: kBorder),
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total Sales', style: TextStyle(fontSize: 11, color: kGrey)),
                  const SizedBox(height: 4),
                  Text(totals[range],
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(growth[range],
                      style: const TextStyle(fontSize: 10, color: Color(0xFF16A34A))),
                ]),
              ),
              Icon(Icons.bar_chart, color: context.pc, size: 26),
            ]),
          ),
          const SizedBox(height: 14),
          const Text('Sales Trend', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: Row(children: [
              const SizedBox(
                width: 30,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('10M', style: TextStyle(fontSize: 9, color: kGrey)),
                  Text('5M', style: TextStyle(fontSize: 9, color: kGrey)),
                  Text('0', style: TextStyle(fontSize: 9, color: kGrey)),
                  SizedBox(height: 14),
                ]),
              ),
              Expanded(
                child: Column(children: [
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: LinePainter(context.pc, const [0.42, 0.51, 0.48, 0.59, 0.54, 0.68, 0.82]),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    for (final d in ['Oct 10', '11', '12', '13', '14', '15', '16'])
                      Text(d, style: const TextStyle(fontSize: 9, color: kGrey)),
                  ]),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: [
            _bottomBtn(Icons.inventory_2_outlined, 'Top Products'),
            const SizedBox(width: 10),
            _bottomBtn(Icons.credit_card, 'Payment Methods'),
          ]),
        ],
        if (tab == 1) ...[
          _stat('Total Items', '${s.products.length}'),
          _stat('Units in Stock', '${s.products.fold<int>(0, (a, p) => a + p.stock)}'),
          _stat('Low Stock Items', '${s.products.where((p) => p.stock <= p.reorder * 2).length}'),
        ],
        if (tab == 2) ...[
          _stat('Total Customers', '${s.customers.length}'),
          _stat('New This Week', '3'),
          _stat('Returning Customers', '${s.customers.length - 1}'),
        ],
      ]),
    );
  }

  Widget _stat(String a, String b) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Text(a, style: const TextStyle(fontSize: 12, color: kGrey)),
          const Spacer(),
          Text(b, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        ]),
      );
}

class LinePainter extends CustomPainter {
  final Color color;
  final List<double> data;
  LinePainter(this.color, this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = kBorder..strokeWidth = 1;
    for (final f in [0.0, 0.5, 1.0]) {
      final y = size.height * (1 - f) - (f == 0 ? 1 : 0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final pts = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      pts.add(Offset(size.width * i / (data.length - 1) * 0.96 + 4,
          size.height * (1 - data[i])));
    }
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    final fill = Path.from(path)
      ..lineTo(pts.last.dx, size.height)
      ..lineTo(pts.first.dx, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.10));
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    for (final p in pts) {
      canvas.drawCircle(p, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter old) => old.color != color;
}
