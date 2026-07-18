import 'package:alphalens_fend/data/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {

    final AuthRepository _authRepository;

  OtpCubit(this._authRepository) : super(OtpInitial());





  Future<void> verifyOtpToken({
    required String email,
    required String otp,
  }) async {
    // 1. Emit the loading state to trigger the visual spinner UI
    emit(OtpLoading());

    try {
      // 2. Dispatch network request payload directly to the repository pipeline
      final successMessage = await _authRepository.verifyOtp(
        email: email,
        otp: otp,
      );

      // 3. Emit success state when the 200 payload returns completely intact
      emit(OtpSuccess(message: successMessage));
      
    } catch (e) {
      // 4. Extract the clean exception string text stripped down by the repository layer
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // 5. Propagate the structural failure state straight up to the frontend UI layer
      emit(OtpFailed(message: errorMessage));
    }
  }
}
