part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}
class SignupLoading extends SignupState {}
class SignupSuccess extends SignupState {
  final String message;
  SignupSuccess(this.message);
}
class SignupFailure extends SignupState {
  final String errorMessage;
  SignupFailure(this.errorMessage); 
}