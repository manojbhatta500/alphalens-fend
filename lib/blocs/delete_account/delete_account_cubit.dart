import 'package:alphalens_fend/data/repositories/auth/auth_repository.dart';
import 'package:alphalens_fend/utils/token_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {

  final AuthRepository _authRepository;

  DeleteAccountCubit(this._authRepository) : super(DeleteAccountInitial());


   Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      final success = await _authRepository.deleteAccount();
      if (success) {
        await TokenStorage.deleteToken();
        emit(DeleteAccountSuccess());
      } else {
        emit(DeleteAccountFailure('Account deletion failed. Please try again.'));
      }
    } catch (e) {
  emit(DeleteAccountFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

}
