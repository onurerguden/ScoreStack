class Coupon {
  final String id;
  final List<String> matchids;
  final double totalOdd;
  final DateTime couponCreationTime;

  Coupon({
    required this.id,
    required this.matchids,
    required this.totalOdd,
    required this.couponCreationTime
});

  Map<String, dynamic> save() {
    return {
      'id': id,
      "matchids": matchids,
      "totalOdd": totalOdd,
      "couponCreationTime": couponCreationTime
    };
  }

  factory Coupon.fromJson(Map<String, dynamic> file) {
    return Coupon(
      id: file['id'],
      matchids: file['matchids'],
      totalOdd: file['totalOdd'],
      couponCreationTime: file['couponCreationTime'],
    );
  }
}