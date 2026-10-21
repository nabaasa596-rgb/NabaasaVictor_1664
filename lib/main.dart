import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens_auth.dart';
import 'screens_sales.dart';
import 'screens_manage.dart';
import 'screens_settings.dart';

void main() => runApp(const PosApp());

class PosApp extends StatelessWidget {
  const PosApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: AppState.I.themeColor,
      builder: (_, color, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'POS Retail Pro',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: color).copyWith(primary: color),
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/products': (_) => const ProductsScreen(),
          '/sale': (_) => const NewSaleScreen(),
          '/payment': (_) => const PaymentScreen(),
          '/inventory': (_) => const InventoryScreen(),
          '/customers': (_) => const CustomersScreen(),
          '/reports': (_) => const ReportsScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/offline': (_) => const OfflineScreen(),
          '/profile': (_) => const BusinessProfileScreen(),
        },
      ),
    );
  }
}
