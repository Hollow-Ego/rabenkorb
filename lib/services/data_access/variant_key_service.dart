import 'package:rabenkorb/database/database.dart';
import 'package:watch_it/watch_it.dart';

class VariantKeyService {
  final _db = di<AppDatabase>();

  Future<int> createVariantKey(String name) {
    return _db.variantKeysDao.createVariantKey(name);
  }

  Future<VariantKey?> getVariantKeyById(int id) {
    return _db.variantKeysDao.getVariantKeyWithId(id);
  }

  Future<int> deleteVariantKeyById(int id) {
    return _db.variantKeysDao.deleteVariantKeyWithId(id);
  }
}
