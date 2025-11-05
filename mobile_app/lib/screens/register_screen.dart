import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/api_exception.dart';
import '../core/notifications/notification_service.dart';
import '../core/auth/auth_flow.dart';
import '../providers/auth_provider_riverpod.dart';
import '../providers/theme_provider.dart';
import '../shared/widgets/footer_section.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String? from;
  const RegisterScreen({super.key, this.from});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final target = widget.from != null && widget.from!.isNotEmpty ? widget.from! : '/';
      await AuthFlow.runSuccess(
        context: context,
        action: () => ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmController.text,
        ),
        successTitle: 'Account Created!',
        successBody: 'Welcome ${_nameController.text.trim()}! Your account has been created successfully.',
        navigateTo: target,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      NotificationService.showError(
        'Registration Failed',
        e.message,
      );
    } catch (e) {
      if (!mounted) return;
      NotificationService.showError(
        'Registration Failed',
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
      appBar: AppBar(
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Image.asset(
                  isDarkMode ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textInputAction: TextInputAction.next,
                  enabled: !authState.loading,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your name';
                    if (v.trim().length < 2) return 'Name is too short';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                  textInputAction: TextInputAction.next,
                  enabled: !authState.loading,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (v.length < 8) return 'At least 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !authState.loading,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirm your password';
                    if (v != _passwordController.text) return 'Passwords do not match';
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
                      : const Text('Create account', style: TextStyle(fontSize: 16)),
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
