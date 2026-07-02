import 'package:alphalens_fend/data/models/company_model.dart';
import 'package:alphalens_fend/data/repositories/company/company_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _companyRepository;

  CompanyCubit(this._companyRepository) : super(CompanyInitial());

  Future<void> fetchCompanyDetails(String ticker) async {
  emit(CompanyLoading());

  try {
    // 1. This calls your repository method
    final data = await _companyRepository.getCompanyDetails(ticker);
    
    emit(CompanyLoaded(company: data));
    
  } catch (error) {
    // 3. Because the repository used 'rethrow', the error lands right here!
    print('Cubit caught the forwarded error: $error');
    
    // 4. Emit a failure state so your UI can show a clean error message
    emit(CompanyError(message: error.toString()));
  }
}

}
