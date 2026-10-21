import 'package:flutter/material.dart';

const kInk = Color(0xFF111827);
const kGrey = Color(0xFF6B7280);
const kBorder = Color(0xFFE5E7EB);
const kBg = Color(0xFFF5F7FA);

extension Ctx on BuildContext {
  Color get pc => Theme.of(this).colorScheme.primary;
}

PreferredSizeWidget appBarX(BuildContext c, String title) => AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: kInk,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 20),
        onPressed: () => Navigator.maybePop(c),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  const PrimaryButton(this.text, this.onTap, {super.key, this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.pc,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
            Text(text,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        ),
      );
}

class SearchBox extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const SearchBox(this.hint, {super.key, this.onChanged});
  @override
  Widget build(BuildContext context) => TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: kBg,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: kGrey),
          prefixIcon: const Icon(Icons.search, size: 18, color: kGrey),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kBorder)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kBorder)),
        ),
      );
}

class Pill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const Pill(this.text, this.selected, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? context.pc : kBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? context.pc : kBorder),
          ),
          child: Text(text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : kInk)),
        ),
      );
}

class AppNavBar extends StatelessWidget {
  final int index;
  const AppNavBar(this.index, {super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      [Icons.home_filled, 'Home', '/home'],
      [Icons.shopping_cart_outlined, 'Sales', '/products'],
      [Icons.inventory_2_outlined, 'Inventory', '/inventory'],
      [Icons.people_outline, 'Customers', '/customers'],
      [Icons.more_horiz, 'More', '/settings'],
    ];
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, border: Border(top: BorderSide(color: kBorder))),
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (i == index) return;
                    if (i == 0) {
                      Navigator.popUntil(context, (r) => r.isFirst || r.settings.name == '/home');
                    } else {
                      Navigator.pushNamed(context, items[i][2] as String);
                    }
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(items[i][0] as IconData,
                        size: 20, color: i == index ? context.pc : kGrey),
                    const SizedBox(height: 2),
                    Text(items[i][1] as String,
                        style: TextStyle(
                            fontSize: 10,
                            color: i == index ? context.pc : kGrey,
                            fontWeight: i == index
                                ? FontWeight.w700
                                : FontWeight.w500)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProductThumb extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const ProductThumb(this.icon, this.color, {super.key, this.size = 40});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: size * 0.55),
      );
}

void info(BuildContext c, String title, String body) => showDialog(
      context: c,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))
        ],
      ),
    );
