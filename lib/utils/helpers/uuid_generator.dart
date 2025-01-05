import 'package:uuid/uuid.dart';

const _uuid = Uuid();

String generateUuid() {
  return _uuid.v4();
}
