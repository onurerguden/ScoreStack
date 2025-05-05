import 'package:flutter/material.dart';

class CouponStack extends StatefulWidget {
  final PageController controller;
  final List<String> coupons;

  CouponStack({required this.controller, required this.coupons});

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
      height: size.height * 0.45,
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
              return Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: size.width * 0.65,
                        height: size.height * 0.55,
                        child: Center(
                          child: Text(
                            widget.coupons[index],
                            style: TextStyle(
                              fontSize: size.width * 0.06,
                            ),
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