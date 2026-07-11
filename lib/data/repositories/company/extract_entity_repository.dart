


import 'package:alphalens_fend/data/models/extract_entity_model.dart';
import 'package:alphalens_fend/utils/api_client.dart';

class ExtractEntityRepository {

  final ApiClient _apiClient;

  ExtractEntityRepository(this._apiClient);



  Future<ExtarctEntityModel> getCompanyDetails(String ticker) async {
    try {
      final response = await _apiClient.get('/api/company/$ticker/entity-cards');
      return ExtarctEntityModel.fromJson(response.data as Map<String, dynamic>);    
      }catch (e) {
      rethrow;
    }
  }
}