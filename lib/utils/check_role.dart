import 'package:login/core/shared/local_network.dart';

bool checkTeacherRole() {
  final role = CashNetwork.getCashData(key: 'role');
  return role == 'teacher';
}
