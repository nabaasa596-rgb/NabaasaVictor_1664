import 'package:flutter/material.dart';
import 'widgets.dart';

// 1. Splash / Welcome
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const Spacer(flex: 3),
            Icon(Icons.shopping_cart, size: 72, color: context.pc),
            const SizedBox(height: 16),
            const Text('POS Retail Pro',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w800, color: kInk)),
            const SizedBox(height: 14),
            const Text('Manage your business\nanytime, anywhere',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: kGrey, height: 1.4)),
            const Spacer(flex: 4),
            PrimaryButton('Get Started',
                () => Navigator.pushReplacementNamed(context, '/login')),
            const SizedBox(height: 22),
            const Text('Version 1.0.0',
                style: TextStyle(fontSize: 11, color: kGrey)),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}

// 2. Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hide = true, remember = false;
  final email = TextEditingController(), pass = TextEditingController();

  void _go() => Navigator.pushReplacementNamed(context, '/home');

  InputDecoration _dec(String hint, IconData icon, {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: kGrey),
        prefixIcon: Icon(icon, size: 18, color: kGrey),
        suffixIcon: suffix,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kBorder)),
      );

  Widget _social(Widget icon, String text) => SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: _go,
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kBorder),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            icon,
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontSize: 13, color: kInk)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: kInk,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            onPressed: () => Navigator.pushReplacementNamed(context, '/')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Sign in to your account',
              style: TextStyle(fontSize: 12, color: kGrey)),
          const SizedBox(height: 18),
          TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec('Email or Phone', Icons.mail_outline)),
          const SizedBox(height: 12),
          TextField(
              controller: pass,
              obscureText: hide,
              decoration: _dec('Password', Icons.lock_outline,
                  suffix: IconButton(
                      icon: Icon(
                          hide ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 18),
                      onPressed: () => setState(() => hide = !hide)))),
          const SizedBox(height: 8),
          Row(children: [
            SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                    value: remember,
                    visualDensity: VisualDensity.compact,
                    onChanged: (v) => setState(() => remember = v ?? false))),
            const SizedBox(width: 6),
            const Text('Remember me', style: TextStyle(fontSize: 11)),
            const Spacer(),
            GestureDetector(
              onTap: () => info(context, 'Forgot password',
                  'A reset link will be sent to your email or phone.'),
              child: Text('Forgot password?',
                  style: TextStyle(fontSize: 11, color: context.pc)),
            ),
          ]),
          const SizedBox(height: 16),
          PrimaryButton('Login', _go),
          const SizedBox(height: 14),
          Row(children: const [
            Expanded(child: Divider()),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('OR', style: TextStyle(fontSize: 11, color: kGrey))),
            Expanded(child: Divider()),
          ]),
          const SizedBox(height: 14),
          _social(
              const Text('G',
                  style: TextStyle(
                      color: Color(0xFFEA4335),
                      fontWeight: FontWeight.w900,
                      fontSize: 16)),
              'Continue with Google'),
          const SizedBox(height: 10),
          _social(const Icon(Icons.apple, size: 20), 'Continue with Apple'),
          const SizedBox(height: 22),
          Center(
            child: Text.rich(TextSpan(
                style: const TextStyle(fontSize: 11, color: kGrey),
                children: [
                  const TextSpan(text: "Don't have an account?  "),
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: context.pc, fontWeight: FontWeight.w600)),
                ])),
          ),
        ]),
      ),
    );
  }
}
