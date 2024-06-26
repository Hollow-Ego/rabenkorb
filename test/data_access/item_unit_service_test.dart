import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/item_unit_service.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  late ItemUnitService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);

    di.registerSingleton<ItemUnitService>(ItemUnitService());
    sut = di<ItemUnitService>();
  });

  test('item units can be created', () async {
    const testName = "Liter";
    final id = await sut.createItemUnit(testName);
    final unit = await sut.getItemUnitById(id);

    expect(unit?.name, testName);
  });

  test('item units can be updated', () async {
    const testNameOne = "Liter";
    const testNameTwo = "Packages";
    final id = await sut.createItemUnit(testNameOne);

    var unit = await sut.getItemUnitById(id);
    expect(unit?.name, testNameOne);

    await sut.updateItemUnit(id, testNameTwo);

    unit = await sut.getItemUnitById(id);
    expect(unit?.name, testNameTwo);
  });

  test('item units can be deleted', () async {
    const testName = "Liter";
    final id = await sut.createItemUnit(testName);
    final unit = await sut.getItemUnitById(id);

    expect(unit?.name, testName);
  });

  test('item units can be watched', () async {
    const unitThree = "Gram";
    const unitThreeModified = "Kilogram";
    const unitOne = "Liter";
    const unitTwo = "Packages";
    const unitFour = "Pieces";

    const expectedValues = [
      [],
      [unitOne],
      [unitOne, unitTwo],
      [unitThree, unitOne, unitTwo],
      [unitThree, unitOne, unitTwo, unitFour],
      [unitThreeModified, unitOne, unitTwo, unitFour],
    ];

    expectLater(
      sut.watchItemUnits().map((li) => li.map((e) => e.name)),
      emitsInOrder(expectedValues),
    );

    // Delay creation of new items to ensure emissions are happening one by one
    const delay = Duration(milliseconds: 100);
    await sut.createItemUnit(unitOne);
    await Future.delayed(delay);

    await sut.createItemUnit(unitTwo);
    await Future.delayed(delay);

    final unitThreeId = await sut.createItemUnit(unitThree);
    await Future.delayed(delay);

    await sut.createItemUnit(unitFour);
    await Future.delayed(delay);

    await sut.updateItemUnit(unitThreeId, unitThreeModified);
  });

  tearDown(() async {
    await di<AppDatabase>().close();
    di.reset(dispose: true);
  });
}
