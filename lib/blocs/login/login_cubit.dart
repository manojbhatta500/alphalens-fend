import 'package:alphalens_fend/utils/token_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:alphalens_fend/data/repositories/auth/auth_repository.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final token = await _authRepository.loginUser(
        username: username,
        password: password,
      );
      await TokenStorage.saveToken(token); // Save token securely
      emit(LoginSuccess(token));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}