import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier,RegisterFormState>((ref) {
  final registerUserCallBack = ref.watch(authProvider.notifier).registerUser; 
  return RegisterFormNotifier(registerUserCallBack: registerUserCallBack); 
});

class RegisterFormState {
  final bool isPosting;
  final bool isValid;
  final bool isFormPosted;
  final Email email;
  final bool isPasswordSame;
  final Password password;
  final String password2;
  final Name name;

  RegisterFormState({
    this.isPosting = false,
    this.isValid = false,
    this.isPasswordSame = true,
    this.isFormPosted = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.password2 = '',
    this.name = const Name.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isValid,
    bool? isPasswordSame,
    bool? isFormPosted,
    Email? email,
    Password? password,
    String? password2,
    Name? name,
  }) =>
      RegisterFormState(
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isPosting: isPosting ?? this.isPosting,
        isValid: isValid ?? this.isValid,
        isPasswordSame: isPasswordSame ?? this.isPasswordSame,
        email: email ?? this.email,
        password: password ?? this.password,
        password2: password2 ?? this.password2,
        name: name ?? this.name,
      );

  @override
  String toString() {
    return '''
      RegisterFormState: 
        isPosting: $isPosting,
        isFormPosted: $isFormPosted,
        isValid: $isValid,
        email: $email,
        password: $password
        password2: $password
        isPasswordSame: $isPasswordSame
    ''';
  }

  bool get isSamePassword => password.value == password2;
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String,String,String) registerUserCallBack;
  RegisterFormNotifier({required this.registerUserCallBack}) : super(RegisterFormState());

  onFullNameChanged(String name) {
    final newFullName = Name.dirty(name);
    state = state.copyWith(
        name: newFullName,
        isValid: Formz.validate([newFullName, state.email, state.password]));
  }

  onEmailChange(String email) {
    final newEmail = Email.dirty(email);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([newEmail, state.name, state.password]));
  }

  onPasswordChange(String password) {
    final newPassword = Password.dirty(password);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.name, state.email]));
  }

  onPassword2Change(String password2) {
    state = state.copyWith(
        password2: password2,
        isValid: Formz.validate([state.name, state.email, state.password]) && state.isSamePassword,
        isPasswordSame: state.isSamePassword);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    await registerUserCallBack(state.email.value, state.password.value,state.name.value);
    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final name = Name.dirty(state.name.value);
    final password2 = state.password2;

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      name: name,
      password2: password2,
      isPasswordSame: state.isSamePassword,
      isValid: Formz.validate([email, password, name]) && state.isSamePassword,
    );
  }
}
