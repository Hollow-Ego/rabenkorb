import 'package:drift/drift.dart';

@DataClassName('VariantKey')
class VariantKeys extends Table {
  IntColumn get id => integer().autoIncrement()();
}