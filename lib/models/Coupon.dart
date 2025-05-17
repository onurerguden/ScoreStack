import '../models/Match.dart';

class CouponItem {
  final Match match;
  final int selectedResult;

  CouponItem({required this.match, required this.selectedResult});

  double getSelectedOdd() {
    switch (selectedResult) {
      case 1:
        return match.homeOdds;
      case 0:
        return match.drawOdds;
      case 2:
        return match.awayOdds;
      default:
        throw Exception("No such result error!");
    }
  }
}

class Coupon {
  final List<CouponItem> selectedMatches;
  final double totalOdd;
  final String title;

  Coupon({
    required this.selectedMatches,
    required this.totalOdd,
    required this.title,
  });

  factory Coupon.create(List<CouponItem> matches, {String title = "Coupon"}) {
    double total = 1.0;
    for (var item in matches) {
      total *= item.getSelectedOdd();
    }
    return Coupon(selectedMatches: matches, totalOdd: total, title: title);
  }
}
