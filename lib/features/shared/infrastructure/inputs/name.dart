import 'package:formz/formz.dart';

enum NameErrors { empty, length }

class Name extends FormzInput<String,NameErrors> {

  const Name.pure() : super.pure('');

  const Name.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if(isValid || isPure ) return null;

    if(displayError == NameErrors.empty) return 'El nombre es requerido';
    if(displayError == NameErrors.length) return 'El nombre debe contener 5 letras o más';

    return null;
  }

  @override
  NameErrors? validator(String value) {
    if(value.isEmpty || value.trim().isEmpty) return NameErrors.empty;
    if(value.length < 5) return NameErrors.length;
    return null;
  }
}