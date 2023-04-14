import 'dart:convert';

import 'package:crypto/crypto.dart';

class Functions {
  static String genHash(String s1, String s2) {
    if (s1.compareTo(s2) > 0)
      return md5
          .convert(utf8.encode("$s1${s1.length}$s2${s2.length}"))
          .toString();
    else
      return md5
          .convert(utf8.encode("$s2${s2.length}$s1${s1.length}"))
          .toString();
  }
}
