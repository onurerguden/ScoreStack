import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/CouponStack.dart';

class CouponsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController(
      viewportFraction: 0.65,
      initialPage: 1,
    );
    final List<String> coupons = [
      'Garanti',
      'Riskli',
      'Çok Riskli',
      'Favori Takım',
    ];

    final size = MediaQuery.of(context).size;
    final width = size.width * 0.95;
    final height = size.height * 0.74;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.topCenter,
              width: width,
              height: height,
              color: CupertinoColors.systemGrey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    color: Color(0xFF2C2C2C),
                    child: Text(
                      "Current Coupons",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CouponStack(controller: _controller, coupons: coupons),

                          Container(
                            height: 2,
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            color: Colors.black54,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green[800]!, width: 5),

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(16),
                                  ),
                                  onPressed: () {
                                    _controller.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_left_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                  ),
                                  onPressed: () {
                                    final currentIndex =
                                        _controller.page!.round() % coupons.length;
                                    final couponText = coupons[currentIndex];
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Saved: $couponText"),
                                        duration: Duration(microseconds: 800000),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Save Coupon!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(16),
                                  ),
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: Colors.white,
                                    size: 25,
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

