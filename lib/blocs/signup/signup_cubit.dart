import 'package:alphalens_fend/data/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
// Fix: Ensure this points exactly two levels up to find data folder

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupInitial());

  Future<void> registerNewUser({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());
    try {
      await _authRepository.registerUser(
        username: username,
        email: email,
        password: password,
      );
      
      emit(SignupSuccess('✨ Account created successfully!'));
    } catch (e) {
      final displayError = e.toString().replaceAll('Exception: ', '');
      // Fix: Changed from named parameter to positional argument to match the state change above
      emit(SignupFailure(displayError)); 
    }
  }
}