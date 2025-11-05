import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/api_exception.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

// Auth state class
class AuthState {
  final UserModel? user;
  final bool loading;
  final String? error;
  final bool showWelcome; // Flag to trigger welcome message

  AuthState({
    this.user,
    this.loading = false,
    this.error,
    this.showWelcome = false,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? loading,
    String? error,
    bool? showWelcome,
  }) {
    return AuthState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      showWelcome: showWelcome ?? this.showWelcome,
    );
  }

  // Helper to clear user
  AuthState cleared() => AuthState(loading: false, error: null, showWelcome: false);
}

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(loading: true, error: null);

    final token = await _repo.getStoredToken();
    if (token != null && token.isNotEmpty) {
      try {
        final user = await _repo.getUser();
        state = AuthState(user: user, loading: false);
        if (kDebugMode) {
          print('✅ Auth restored: ${user.email}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Auth restore failed: $e');
        }
        await _repo.logout();
        state = AuthState(loading: false);
      }
    } else {
      state = AuthState(loading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);

    try {
      if (kDebugMode) {
        print('[@Auth] login start for $email');
      }
      final user = await _repo.login(email: email, password: password);
      state = AuthState(user: user, loading: false, showWelcome: true);
      if (kDebugMode) {
        print('✅ Login successful: ${user.email}');
      }
    } on ApiException catch (e) {
      state = AuthState(loading: false, error: e.message);
      if (kDebugMode) {
        print('❌ Login failed: ${e.message}');
      }
      rethrow;
    } catch (e) {
      state = AuthState(loading: false, error: 'Unexpected error: $e');
      if (kDebugMode) {
        print('❌ Login error: $e');
      }
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      if (kDebugMode) {
        print('[@Auth] register start for $email');
      }
      final user = await _repo.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      state = AuthState(user: user, loading: false, showWelcome: true);
      if (kDebugMode) {
        print('✅ Registration successful: ${user.email}');
      }
    } on ApiException catch (e) {
      state = AuthState(loading: false, error: e.message);
      if (kDebugMode) {
        print('❌ Registration failed: ${e.message}');
      }
      rethrow;
    } catch (e) {
      state = AuthState(loading: false, error: 'Unexpected error: $e');
      if (kDebugMode) {
        print('❌ Registration error: $e');
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(loading: true);

    try {
      if (kDebugMode) {
        print('[@Auth] logout start');
      }
      await _repo.logout();
      if (kDebugMode) {
        print('✅ Logout successful');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Logout error (proceeding anyway): $e');
      }
    } finally {
      state = AuthState(loading: false);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearWelcome() {
    state = state.copyWith(showWelcome: false);
  }
}

// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
