import 'package:drift/drift.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/database/tables/variant_keys.dart';

part 'variant_keys_dao.g.dart';

@DriftAccessor(tables: [VariantKeys])
class VariantKeysDao extends DatabaseAccessor<AppDatabase> with _$VariantKeysDaoMixin {
  VariantKeysDao(super.db);
}
