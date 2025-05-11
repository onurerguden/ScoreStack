import 'package:cloud_firestore/cloud_firestore.dart';

class CouponService {
  final FirebaseFirestore fbconnector = FirebaseFirestore.instance;

  Future<void> createCoupons(List<Map<String, dynamic>> matches) async {
    if (matches.isEmpty) return;

    final couponCollection = fbconnector.collection("coupons");
    final currentCoupons = await couponCollection.get();
    for (var doc in currentCoupons.docs) {
      await doc.reference.delete();
    }

    matches.sort((a, b) => (a["odd"] as num).compareTo(b["odd"] as num));

    final guaranteed = matches.take(3).toList();
    final normal = matches.sublist(1, 4);
    final risky = matches.reversed.take(3).toList();

    await uploadCoupon("Guaranteed", guaranteed);
    await uploadCoupon("Normal", normal);
    await uploadCoupon("Risky", risky);
  }

  Future<void> uploadCoupon(
    String title,
    List<Map<String, dynamic>> matches,
  ) async {
    final averageOdd =
        matches.map((m) => m["odd"] as num).reduce((a, b) => a + b) /
        matches.length;

    await fbconnector.collection("coupons").add({
      "title": title,
      "matches": matches,
      "odds": averageOdd,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
