import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/ipo_service.dart';
import '../data/iporesponse.dart';
import '../presentation/providers/ipo_provider.dart';

class IpoRepository {
  final IpoService ipoService;

  IpoRepository(this.ipoService);

  Future<IpoResponse> getIpoDataFromRepository() async {
    print("my repository called!!!");
    return await ipoService.fetchIpoDataFromService();
  }
}

final ipoRepositoryProvider = Provider<IpoRepository>((ref) {
  final service = ref.read(ipoServiceProvider);
  return IpoRepository(service);
});
