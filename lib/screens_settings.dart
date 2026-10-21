import 'package:flutter/material.dart';
import 'app_state.dart';
import 'widgets.dart';

// 10. Settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <List<dynamic>>[
      [Icons.storefront_outlined, 'Business Profile', '/profile'],
      [Icons.credit_card, 'Payment Settings', ''],
      [Icons.inventory_2_outlined, 'Inventory Settings', ''],
      [Icons.people_outline, 'User Management', ''],
      [Icons.settings_outlined, 'App Preferences', '/offline'],
      [Icons.shield_outlined, 'Security & Privacy', ''],
      [Icons.info_outline, 'About', ''],
    ];
    return Scaffold(
      appBar: appBarX(context, 'Settings'),
      body: ListenableBuilder(
        listenable: AppState.I,
        builder: (_, __) => ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF6B7280),
                  child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Business Owner',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                Text('owner@business.com',
                    style: TextStyle(fontSize: 10, color: kGrey)),
              ]),
            ]),
          ),
          const Divider(color: kBorder, height: 1),
          for (final it in items) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(it[0] as IconData, size: 18, color: kInk),
              title: Text(it[1] as String, style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.chevron_right, size: 18, color: kGrey),
              onTap: () {
                final r = it[2] as String;
                if (r.isNotEmpty) {
                  Navigator.pushNamed(context, r);
                } else if (it[1] == 'Security & Privacy') {
                  info(context, 'Security & Privacy',
                      'Data is stored on this device and protected by login. Follows data-protection and privacy best practice.');
                } else if (it[1] == 'About') {
                  info(context, 'About', 'POS Retail Pro  •  Version 1.0.0');
                } else {
                  info(context, it[1] as String, 'This section can be configured here.');
                }
              },
            ),
            const Divider(color: kBorder, height: 1),
          ],
        ]),
      ),
      bottomNavigationBar: const AppNavBar(4),
    );
  }
}

// 11. Offline Mode
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            left: 4,
            top: 4,
            child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () => Navigator.maybePop(context)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                      color: Color(0xFFE5E7EB), shape: BoxShape.circle),
                  child: const Icon(Icons.wifi_off, size: 34, color: kGrey),
                ),
                const SizedBox(height: 14),
                const Text("You're Offline",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                const Text(
                    'No internet connection detected.\nYou can still process sales, view\ncached data and manage inventory.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: kGrey, height: 1.5)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                      color: kBg,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kBorder)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.check_circle, size: 14, color: kInk),
                    SizedBox(width: 6),
                    Text('Working Offline',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// 12. Customization (Business Profile)
class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});
  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  late final TextEditingController name =
      TextEditingController(text: AppState.I.businessName);
  late String type = AppState.I.businessType;
  late Color color = AppState.I.themeColor.value;
  static const colors = [
    Color(0xFF8B2FE0),
    Color(0xFF1A6FE8),
    Color(0xFF22C55E),
    Color(0xFFFACC15),
    Color(0xFFF59E0B),
  ];

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
      );

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorder));
    return Scaffold(
      appBar: appBarX(context, 'Business Profile'),
      body: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
        _label('Business Name'),
        TextField(
          controller: name,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
              isDense: true, border: border, enabledBorder: border,
              contentPadding: const EdgeInsets.all(12)),
        ),
        _label('Business Type'),
        DropdownButtonFormField<String>(
          initialValue: type,
          isDense: true,
          style: const TextStyle(fontSize: 12, color: kInk),
          decoration: InputDecoration(
              isDense: true, border: border, enabledBorder: border,
              contentPadding: const EdgeInsets.all(12)),
          items: const ['Retail Store', 'Restaurant', 'Pharmacy', 'Supermarket', 'Salon', 'Other']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => type = v ?? type),
        ),
        _label('Logo'),
        Row(children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.image_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => info(context, 'Logo', 'Choose a logo image from your gallery.'),
            child: Text('Change', style: TextStyle(fontSize: 11, color: context.pc)),
          ),
        ]),
        _label('Theme Color'),
        Row(children: [
          for (final c in colors)
            GestureDetector(
              onTap: () => setState(() => color = c),
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: color == c ? Border.all(color: kInk, width: 2) : null,
                ),
              ),
            ),
          const Spacer(),
          const Icon(Icons.chevron_right, size: 18, color: kGrey),
        ]),
        const SizedBox(height: 28),
        PrimaryButton('Save', () {
          AppState.I.setProfile(name.text.trim().isEmpty ? 'My Store' : name.text.trim(), type, color);
          Navigator.pop(context);
        }),
        const SizedBox(height: 16),
      ]),
    );
  }
}
