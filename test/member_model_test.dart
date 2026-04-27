import 'package:flutter_test/flutter_test.dart';
import 'package:member_core/data/models/member_model.dart';
import 'package:member_core/domain/entities/member.dart';

void main() {
  group('MemberModel Tests', () {
    final testDate = DateTime(2023, 3, 15);
    final testModel = MemberModel(
      id: 'MB001',
      name: 'Fauzi Fauzi',
      email: 'fauzi.f@tech.com',
      city: 'Jakarta',
      joinDate: testDate,
      membershipStatus: 'Gold',
    );

    test('should be a subclass of Member entity', () {
      expect(testModel, isA<Member>());
    });

    test('should construct MemberModel properly', () {
      expect(testModel.id, 'MB001');
      expect(testModel.name, 'Fauzi Fauzi');
      expect(testModel.email, 'fauzi.f@tech.com');
      expect(testModel.city, 'Jakarta');
      expect(testModel.joinDate, testDate);
      expect(testModel.membershipStatus, 'Gold');
    });

    test('should equate two identical MemberModels', () {
      final model2 = MemberModel(
        id: 'MB001',
        name: 'Fauzi Fauzi',
        email: 'fauzi.f@tech.com',
        city: 'Jakarta',
        joinDate: testDate,
        membershipStatus: 'Gold',
      );
      expect(testModel, equals(model2));
    });

    test('should differentiate different MemberModels', () {
      final model2 = MemberModel(
        id: 'MB002',
        name: 'Fauzi Fauzi',
        email: 'fauzi.f@tech.com',
        city: 'Jakarta',
        joinDate: testDate,
        membershipStatus: 'Gold',
      );
      expect(testModel, isNot(equals(model2)));
    });
  });
}
