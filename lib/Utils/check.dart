// int Convert(String a) {
//   int k = 1;
//   for (var i = 0; i < a.length; i++) {
//     k = k * 10000000 + a.codeUnitAt(i);
//   }
//   return k;
// }

// void main() {
//   String id1 = "on9JBmZFIvSre89MBiI9SxCeoGn2";
//   String id2 = "HbLgKYj78DOZga6a7cHRQU2u7mq1";

//   int generateHash(String s1, String s2) =>
//       (<String>[s1, s2]..sort()).join().hashCode;

//   String genHash(String s1, String s2) {
//     if (s1.compareTo(s2) > 0)
//       return md5
//           .convert(utf8.encode("$s1${s1.length}$s2${s2.length}"))
//           .toString();
//     else
//       return md5
//           .convert(utf8.encode("$s2${s2.length}$s1${s1.length}"))
//           .toString();
//   }

//   print(generateHash(id2, id1));

//   // int b = Convert(id2) + Convert(id1);

//   // print(b);

//   // int parseId1 = int.parse(id1, radix: 36);
//   // int parseId2 = int.parse(id2, radix: 36);
// //
//   // print(parseId1 + parseId2);
// }
