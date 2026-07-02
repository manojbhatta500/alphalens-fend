import 'package:alphalens_fend/data/models/company_model.dart';
import 'package:alphalens_fend/utils/api_client.dart';

class CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepository(this._apiClient);

  Future<CompanyModel> getCompanyDetails(String ticker) async {
    try {
      final response = await _apiClient.get('/api/company/$ticker');
      
      return CompanyModel.fromJson(response.data as Map<String, dynamic>);    
      }catch (e) {
      rethrow;
    }
  }
  
}