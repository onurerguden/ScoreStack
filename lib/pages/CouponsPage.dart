import 'package:flutter/material.dart';

class CouponsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController(
      viewportFraction: 0.65,
      initialPage: 1,
    );
    final List<String> coupons = ['Garanti', 'Riskli', 'Çok Riskli','Favori Takım'];

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CouponCarousel(controller: _controller, coupons: coupons),
            SizedBox(height: 31,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                    child: Icon(Icons.keyboard_arrow_left_outlined, color: Colors.white,size: 25,),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: () {
                      final currentIndex = _controller.page!.round() % coupons.length;
                      final couponText = coupons[currentIndex];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Saved: $couponText"), duration: Duration(microseconds: 800000),),
                      );
                    },
                    child: Text(
                      "Save Coupon!",
                      style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                    child: Icon(Icons.keyboard_arrow_right_outlined, color: Colors.white,size: 25,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CouponCarousel extends StatefulWidget {
  final PageController controller;
  final List<String> coupons;

  CouponCarousel({required this.controller, required this.coupons});

  @override
  _CouponCarouselState createState() => _CouponCarouselState();
}

class _CouponCarouselState extends State<CouponCarousel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: PageView.builder(
        controller: widget.controller,
        itemCount: 4,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              double value = 1.0;
              if (widget.controller.position.haveDimensions) {
                value = (widget.controller.page! - index).abs();
                value = (1 - (value * 0.2)).clamp(0.8, 1);
              }
              return Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Card(
                      elevation: 16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: 420,
                        height: 420,
                        child: Center(
                          child: Text(
                            widget.coupons[index],
                            style: TextStyle(fontSize: 24),
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
