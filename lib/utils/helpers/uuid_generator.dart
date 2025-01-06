import 'package:uuid/uuid.dart';

class UuidGenerator {
  static final Uuid _uuid = Uuid();

  static String generate() {
    return _uuid.v4();
  }

  static String generateWithPrefix(String prefix) {
    return '${prefix}_${_uuid.v4()}';
  }
}
