import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/database/database.dart';
import 'package:rabenkorb/services/data_access/shopping_basket_service.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  late ShoppingBasketService sut;
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    di.registerSingleton<AppDatabase>(database);

    di.registerSingleton<ShoppingBasketService>(ShoppingBasketService());
    sut = di<ShoppingBasketService>();
  });

  test('shopping baskets can be created', () async {
    const testName = "Aldi";
    final id = await sut.createShoppingBasket(testName);
    final basket = await sut.getShoppingBasketById(id);

    expect(basket?.name, testName);
  });

  test('shopping baskets can be updated', () async {
    const testNameOne = "Aldi";
    const testNameTwo = "Lidl";
    final id = await sut.createShoppingBasket(testNameOne);

    var basket = await sut.getShoppingBasketById(id);
    expect(basket?.name, testNameOne);

    await sut.updateShoppingBasket(id, testNameTwo);

    basket = await sut.getShoppingBasketById(id);
    expect(basket?.name, testNameTwo);
  });

  test('shopping baskets can be deleted', () async {
    const testName = "Aldi";
    final id = await sut.createShoppingBasket(testName);
    final basket = await sut.getShoppingBasketById(id);

    expect(basket?.name, testName);
  });

  test('shopping baskets can be watched', () async {
    const basketOne = "Aldi";
    const basketTwo = "Lidl";
    const basketThree = "Rew";
    const basketThreeModified = "Rewe";
    const basketFour = "Edeka";

    const expectedValues = [
      [],
      [basketOne],
      [basketOne, basketTwo],
      [basketOne, basketTwo, basketThree],
      [basketOne, basketTwo, basketThree, basketFour],
      [basketOne, basketTwo, basketThreeModified, basketFour],
    ];

    expectLater(
      sut.watchShoppingBaskets().map((li) => li.map((e) => e.name)),
      emitsInOrder(expectedValues),
    );

    const delay = Duration(milliseconds: 100);
    await sut.createShoppingBasket(basketOne);
    await Future.delayed(delay);

    await sut.createShoppingBasket(basketTwo);
    await Future.delayed(delay);

    final basketThreeId = await sut.createShoppingBasket(basketThree);
    await Future.delayed(delay);

    await sut.createShoppingBasket(basketFour);
    await Future.delayed(delay);

    await sut.updateShoppingBasket(basketThreeId, basketThreeModified);
  });

  tearDown(() async {
    await di<AppDatabase>().close();
    di.reset(dispose: true);
  });
}
