import 'package:hive/hive.dart';

part 'data_response.g.dart';

@HiveType(typeId: 1)
class DataResponse {
  @HiveField(0)
  final String? bank;
  @HiveField(1)
  final String? balance;
  @HiveField(2)
  final String? time;
  @HiveField(3)
  final String? content;
  @HiveField(4)
  final String? error;

  DataResponse({this.bank, this.balance, this.time, this.content, this.error});
}
