import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/variant_keys.dart';

part 'variant_keys_dao.g.dart';

@DriftAccessor(tables: [VariantKeys])
class VariantKeysDao extends DatabaseAccessor<AppDatabase> with _$VariantKeysDaoMixin {
  VariantKeysDao(super.db);

  Future<int> createVariantKey(String name) {
    return into(variantKeys).insert(const VariantKeysCompanion());
  }

  Future<VariantKey?> getVariantKeyWithId(int id) {
    return (select(variantKeys)..where((li) => li.id.equals(id))).getSingleOrNull();
  }

  Future<int> deleteVariantKeyWithId(int id) {
    return (delete(variantKeys)..where((li) => li.id.equals(id))).go();
  }
}
