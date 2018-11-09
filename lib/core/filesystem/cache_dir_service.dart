import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:path_provider/path_provider.dart';

class CacheDirectoryService extends DirectoryService {
  @override
  requestDirectory() async {
    return getTemporaryDirectory();
  }
}
