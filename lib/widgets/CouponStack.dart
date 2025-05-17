import 'package:flutter/material.dart';
import '../models/Coupon.dart';


class CouponStack extends StatefulWidget {
  final PageController controller;
  final List<Coupon> coupons;

  const CouponStack({
    super.key,
    required this.controller,
    required this.coupons,
  });

  @override
  _CouponStackState createState() => _CouponStackState();
}

class _CouponStackState extends State<CouponStack> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.445,
      child: PageView.builder(
        controller: widget.controller,
        itemCount: widget.coupons.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              double value = 1.0;
              if (widget.controller.position.haveDimensions) {
                value = (widget.controller.page! - index).abs();
                value = (1 - (value * 0.2)).clamp(0.8, 1);
              }
              final coupon = widget.coupons[index];
              return Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SizedBox(
                        width: size.width * 0.9,
                        height: size.height * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 6),
                                  Image.asset(
                                    'assets/images/ScoreStackLogo4-removebg-preview.png',
                                    width: 29,
                                    height: 29,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${coupon.title} Coupon",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 29),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Divider(
                                  thickness: 1.3,
                                  color: Colors.lightGreen,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: coupon.selectedMatches.length,
                                  itemBuilder: (context, i) {
                                    final item = coupon.selectedMatches[i];
                                    final match = item.match;
                                    String prediction;
                                    switch (item.selectedResult) {
                                      case 1:
                                        prediction = '01';
                                        break;
                                      case 0:
                                        prediction = 'X';
                                        break;
                                      case 2:
                                        prediction = '02';
                                        break;
                                      default:
                                        prediction = '?';
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${match.homeTeamName} - ${match.awayTeamName}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            style: TextStyle(fontSize: 13.5),
                                            '${match.matchTime.day}/${match.matchTime.month} ${match.matchTime.hour}:${match.matchTime.minute.toString().padLeft(2, '0')}  |  Bet: $prediction  | Odd: ${item.getSelectedOdd().toStringAsFixed(2)}',
                                          ),
                                          Divider(thickness: 1.3),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Total Odd: ${coupon.totalOdd.toStringAsFixed(2)}x | ${coupon.selectedMatches.length} Matches',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

