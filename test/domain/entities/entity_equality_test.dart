import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

void main() {
  group('GameCategoryEntity Equatable & copyWith', () {
    const category1 = GameCategoryEntity(id: 1, description: 'Board Game');
    const category2 = GameCategoryEntity(id: 1, description: 'Board Game');
    const category3 = GameCategoryEntity(id: 2, description: 'Card Game');

    test('supports value equality', () {
      expect(category1, equals(category2));
      expect(category1 == category3, isFalse);
      expect(category1.hashCode, equals(category2.hashCode));
    });

    test('copyWith updates properties correctly', () {
      final updated = category1.copyWith(description: 'RPG');
      expect(updated.id, equals(1));
      expect(updated.description, equals('RPG'));
      expect(updated, isNot(equals(category1)));

      final identicalCopy = category1.copyWith();
      expect(identicalCopy, equals(category1));
    });
  });

  group('DifficultyEntity Equatable & copyWith', () {
    const diff1 = DifficultyEntity(id: 1, description: 'Easy');
    const diff2 = DifficultyEntity(id: 1, description: 'Easy');
    const diff3 = DifficultyEntity(id: 2, description: 'Hard');

    test('supports value equality', () {
      expect(diff1, equals(diff2));
      expect(diff1 == diff3, isFalse);
      expect(diff1.hashCode, equals(diff2.hashCode));
    });

    test('copyWith updates properties correctly', () {
      final updated = diff1.copyWith(id: 3, description: 'Expert');
      expect(updated.id, equals(3));
      expect(updated.description, equals('Expert'));

      final identicalCopy = diff1.copyWith();
      expect(identicalCopy, equals(diff1));
    });
  });

  group('GameEntity Equatable & copyWith', () {
    const game1 = GameEntity(id: 10, description: 'Catan');
    const game2 = GameEntity(id: 10, description: 'Catan');
    const game3 = GameEntity(id: 11, description: 'Carcassonne');

    test('supports value equality', () {
      expect(game1, equals(game2));
      expect(game1 == game3, isFalse);
      expect(game1.hashCode, equals(game2.hashCode));
    });

    test('copyWith updates properties correctly', () {
      final updated = game1.copyWith(description: 'Ticket to Ride');
      expect(updated.id, equals(10));
      expect(updated.description, equals('Ticket to Ride'));

      final identicalCopy = game1.copyWith();
      expect(identicalCopy, equals(game1));
    });
  });

  group('TableEntity Equatable & copyWith', () {
    const table1 = TableEntity(
      id: 1,
      numberTable: 5,
      stats: 'available',
      reserves: [100, 101],
      idShop: 2,
    );
    const table2 = TableEntity(
      id: 1,
      numberTable: 5,
      stats: 'available',
      reserves: [100, 101],
      idShop: 2,
    );
    const table3 = TableEntity(
      id: 2,
      numberTable: 6,
      stats: 'occupied',
      reserves: [],
      idShop: 2,
    );

    test('supports value equality', () {
      expect(table1, equals(table2));
      expect(table1 == table3, isFalse);
      expect(table1.hashCode, equals(table2.hashCode));
    });

    test('copyWith updates properties correctly', () {
      final updated = table1.copyWith(stats: 'reserved', numberTable: 8);
      expect(updated.id, equals(1));
      expect(updated.numberTable, equals(8));
      expect(updated.stats, equals('reserved'));
      expect(updated.reserves, equals([100, 101]));
      expect(updated.idShop, equals(2));

      final identicalCopy = table1.copyWith();
      expect(identicalCopy, equals(table1));
    });
  });

  group('ReviewEntity Equatable & copyWith', () {
    const review1 = ReviewEntity(
      id: 1,
      raiting: 5,
      review: 'Awesome!',
      writerId: 'u1',
      reviewedId: 'u2',
      shopReview: 1,
      userNameWriter: 'Alice',
      avatarIdWriter: 'a1',
      avatarWriter: null,
    );
    const review2 = ReviewEntity(
      id: 1,
      raiting: 5,
      review: 'Awesome!',
      writerId: 'u1',
      reviewedId: 'u2',
      shopReview: 1,
      userNameWriter: 'Alice',
      avatarIdWriter: 'a1',
      avatarWriter: null,
    );
    const review3 = ReviewEntity(
      id: 2,
      raiting: 3,
      review: 'Decent',
      writerId: 'u1',
      reviewedId: 'u2',
      shopReview: 1,
      userNameWriter: 'Alice',
      avatarIdWriter: 'a1',
      avatarWriter: null,
    );

    test('supports value equality', () {
      expect(review1, equals(review2));
      expect(review1 == review3, isFalse);
      expect(review1.hashCode, equals(review2.hashCode));
      expect(review1.rating, equals(5));
    });

    test('copyWith updates properties correctly', () {
      final updated = review1.copyWith(raiting: 4, review: 'Good');
      expect(updated.raiting, equals(4));
      expect(updated.rating, equals(4));
      expect(updated.review, equals('Good'));
      expect(updated.userNameWriter, equals('Alice'));

      final identicalCopy = review1.copyWith();
      expect(identicalCopy, equals(review1));
    });
  });

  group('ShopEntity Equatable & copyWith', () {
    const shop1 = ShopEntity(
      id: 1,
      name: 'Dice & Drinks',
      address: 'Gran Via 12',
      logo: null,
      averageRaiting: 4.8,
      logoId: 'logo1',
      ownerId: 'owner1',
      tablesShop: [1, 2, 3],
      gamesShop: [10, 20],
      latitude: 40.4168,
      longitude: -3.7038,
    );
    const shop2 = ShopEntity(
      id: 1,
      name: 'Dice & Drinks',
      address: 'Gran Via 12',
      logo: null,
      averageRaiting: 4.8,
      logoId: 'logo1',
      ownerId: 'owner1',
      tablesShop: [1, 2, 3],
      gamesShop: [10, 20],
      latitude: 40.4168,
      longitude: -3.7038,
    );
    const shop3 = ShopEntity(
      id: 2,
      name: 'Meeple House',
      address: 'Alcala 45',
      logo: null,
      averageRaiting: 4.0,
      logoId: 'logo2',
      ownerId: 'owner2',
      tablesShop: [],
      gamesShop: [],
      latitude: 40.4200,
      longitude: -3.7000,
    );

    test('supports value equality', () {
      expect(shop1, equals(shop2));
      expect(shop1 == shop3, isFalse);
      expect(shop1.hashCode, equals(shop2.hashCode));
      expect(shop1.averageRating, equals(4.8));
    });

    test('copyWith updates properties correctly', () {
      final updated = shop1.copyWith(name: 'Dice & Coffee', averageRaiting: 4.9);
      expect(updated.id, equals(1));
      expect(updated.name, equals('Dice & Coffee'));
      expect(updated.averageRaiting, equals(4.9));
      expect(updated.averageRating, equals(4.9));
      expect(updated.address, equals('Gran Via 12'));

      final identicalCopy = shop1.copyWith();
      expect(identicalCopy, equals(shop1));
    });
  });

  group('ReserveEntity Equatable & copyWith', () {
    const reserve1 = ReserveEntity(
      id: 1,
      freePlaces: 3,
      dayDate: '2026-11-15',
      horaInicio: '18:00',
      horaFin: '20:00',
      description: 'Catan casual game',
      requiredMaterial: 'None',
      difficultyId: 1,
      gameId: 10,
      gameName: 'Catan',
      tableId: 2,
      usersInTables: 1,
      users: null,
      shopId: 1,
      isEvent: false,
      userReserveId: 'u1',
    );
    const reserve2 = ReserveEntity(
      id: 1,
      freePlaces: 3,
      dayDate: '2026-11-15',
      horaInicio: '18:00',
      horaFin: '20:00',
      description: 'Catan casual game',
      requiredMaterial: 'None',
      difficultyId: 1,
      gameId: 10,
      gameName: 'Catan',
      tableId: 2,
      usersInTables: 1,
      users: null,
      shopId: 1,
      isEvent: false,
      userReserveId: 'u1',
    );
    const reserve3 = ReserveEntity(
      id: 2,
      freePlaces: 0,
      dayDate: '2026-11-16',
      horaInicio: '10:00',
      horaFin: '12:00',
      description: 'Tournament',
      requiredMaterial: 'Dice',
      difficultyId: 3,
      gameId: 11,
      gameName: 'Warhammer',
      tableId: 3,
      usersInTables: 4,
      users: null,
      shopId: 1,
      isEvent: true,
      userReserveId: 'u2',
    );

    test('supports value equality', () {
      expect(reserve1, equals(reserve2));
      expect(reserve1 == reserve3, isFalse);
      expect(reserve1.hashCode, equals(reserve2.hashCode));
    });

    test('copyWith updates properties correctly', () {
      final updated = reserve1.copyWith(freePlaces: 2, usersInTables: 2);
      expect(updated.id, equals(1));
      expect(updated.freePlaces, equals(2));
      expect(updated.usersInTables, equals(2));
      expect(updated.gameName, equals('Catan'));

      final identicalCopy = reserve1.copyWith();
      expect(identicalCopy, equals(reserve1));
    });
  });

  group('UserEntity Equatable & copyWith', () {
    const user1 = UserEntity(
      id: 'u1',
      email: 'alex@example.com',
      role: 2,
      name: 'Alex',
      username: 'alex99',
      avatar: null,
      averageRaiting: 4.5,
      reserveConfirmation: true,
      notifications: [1, 2],
    );
    const user2 = UserEntity(
      id: 'u1',
      email: 'alex@example.com',
      role: 2,
      name: 'Alex',
      username: 'alex99',
      avatar: null,
      averageRaiting: 4.5,
      reserveConfirmation: true,
      notifications: [1, 2],
    );
    const user3 = UserEntity(
      id: 'u2',
      email: 'bob@example.com',
      role: 1,
      name: 'Bob',
      username: 'bob123',
      avatar: null,
      averageRaiting: 3.0,
      reserveConfirmation: false,
      notifications: [],
    );

    test('supports value equality', () {
      expect(user1, equals(user2));
      expect(user1 == user3, isFalse);
      expect(user1.hashCode, equals(user2.hashCode));
      expect(user1.averageRating, equals(4.5));
    });

    test('copyWith updates properties correctly', () {
      final updated = user1.copyWith(name: 'Alexander', averageRaiting: 4.9);
      expect(updated.id, equals('u1'));
      expect(updated.name, equals('Alexander'));
      expect(updated.username, equals('alex99'));
      expect(updated.averageRaiting, equals(4.9));
      expect(updated.averageRating, equals(4.9));
      expect(updated.reserveConfirmation, isTrue);

      final identicalCopy = user1.copyWith();
      expect(identicalCopy, equals(user1));
    });
  });
}
