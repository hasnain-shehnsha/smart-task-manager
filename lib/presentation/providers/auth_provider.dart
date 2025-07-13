import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  AuthState({this.user, this.isLoading = false, this.error});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;
  AuthNotifier(this._auth) : super(AuthState(isLoading: false)) {
    _auth.authStateChanges().listen((user) {
      state = AuthState(user: user, isLoading: false);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      state = AuthState(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      state = AuthState(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = AuthState(user: null, isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(firebaseAuthProvider));
});
