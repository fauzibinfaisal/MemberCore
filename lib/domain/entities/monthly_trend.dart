import 'package:equatable/equatable.dart';

class MonthlyTrend extends Equatable {
  final String month;
  final int count;

  const MonthlyTrend({
    required this.month,
    required this.count,
  });

  @override
  List<Object?> get props => [month, count];
}
