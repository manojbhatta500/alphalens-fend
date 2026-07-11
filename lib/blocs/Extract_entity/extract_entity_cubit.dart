import 'package:alphalens_fend/data/models/extract_entity_model.dart';
import 'package:alphalens_fend/data/repositories/company/extract_entity_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'extract_entity_state.dart';

class ExtractEntityCubit extends Cubit<ExtractEntityState> {

  final ExtractEntityRepository _extractEntityRepository;

  ExtractEntityCubit(this._extractEntityRepository) : super(ExtractEntityInitial());





  Future<void> fetchCompanyEntities(String ticker) async {

  emit(ExtractEntityLoading());
    final data = await _extractEntityRepository.getCompanyDetails(ticker);
    if  (data.entities!.isEmpty) {
      emit(ExtractEntityError('No data found for the given ticker.'));
      return;
    }
    emit(ExtractEntitySuccess(data));
  }
}
