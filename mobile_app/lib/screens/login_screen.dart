import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/errors/api_exception.dart';
import '../core/notifications/notification_service.dart';
import '../providers/auth_provider_riverpod.dart';
import '../providers/theme_provider.dart';
import '../shared/widgets/footer_section.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? from;
  const LoginScreen({super.key, this.from});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      // Perform login (shows spinner via authState.loading)
      await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      // Credentials confirmed! Show success & wait before redirect
      if (!mounted) return;
      NotificationService.showSuccess(
        'Login Successful!',
        'Welcome back! Redirecting you to the app...',
      );
      
      // **WAIT 2 seconds** for user to see the success message
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      // Now redirect
      final target = widget.from?.isNotEmpty == true ? widget.from! : '/';
      if (context.mounted) {
        context.go(target);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      NotificationService.showError('Login Failed', e.message);
    } catch (e) {
      if (!mounted) return;
      NotificationService.showError(
        'Login Failed',
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    
    return Scaffold(
      appBar: AppBar(centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  isDarkMode ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !authState.loading,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !authState.loading,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authState.loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: authState.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: authState.loading ? null : () => context.push('/register'),
                  child: const Text("Don't have an account? Create one"),
                ),
                if (authState.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                const FooterSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}