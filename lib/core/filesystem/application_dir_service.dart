import 'package:harpy/core/filesystem/directory_service.dart';
import 'package:path_provider/path_provider.dart';

class ApplicationDirectoryService extends DirectoryService {
  @override
  requestDirectory() async {
    return getApplicationDocumentsDirectory();
  }
}
