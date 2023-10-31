import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier,LoginFormState>((ref) {
  return LoginFormNotifier();
});


// State
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isPosting: isPosting ?? this.isPosting,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
      LoginFormState: 
        isPosting: $isPosting,
        isFormPosted: $isFormPosted,
        isValid: $isValid,
        email: $email,
        password: $password
    ''';
  }
}

// Notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  onEmailChange(String email) {
    final newEmail = Email.dirty(email);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String password) {
    final newPassword = Password.dirty(password);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword,state.email])
    );
  }

  onFormSubmit(){
    _touchEveryField();

    if(!state.isValid) return;

    print(state);
  }

  _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email,password])
    );
  }
}


