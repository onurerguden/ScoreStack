import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Match.dart';
import '../widgets/CouponStack.dart';
import '../models/Coupon.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  State<CouponsPage> createState() => CouponsPageState();
}

class CouponsPageState extends State<CouponsPage> {

  int cost = 0;

  void addCost() async {
    setState(() {
      cost += 1;
    });
    final p = await SharedPreferences.getInstance();
    await p.setInt('cost', cost);
  }

  void initState() {
    super.initState();
    loadCost();
  }

  Future<void> loadCost() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      cost = p.getInt('cost') ?? 0;
    });
  }

  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: 0.65,
      initialPage: 1,
    );

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
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFF2C2C2C),
                    child: Row(
                      children: [
                        SizedBox(width: 28.8),
                        Icon(
                          Icons.request_quote,
                          color: Colors.white,
                          size: 28,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Current Coupons",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: 46.8),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Coupon>>(
                      future: getCoupons(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: Colors.green,),);
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No coupons found."));
                        }

                        final coupons = snapshot.data!;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CouponStack(
                              controller: controller,
                              coupons: coupons,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total spent: \$${cost.toString()}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: addCost,
                                    child: const Text("Add Cost", style: TextStyle(color: Colors.white),),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[800]
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              color: Colors.black54,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 8,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: size.width * 0.12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.green[800]!,
                                  width: 5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[800],
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(12),
                                    ),
                                    onPressed: () {
                                      controller.previousPage(
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final currentIndex = controller.page!.round();
                                      final coupon = coupons[currentIndex]; // 🔸 coupon burada tanımlanıyor

                                      final matchSummaries = coupon.selectedMatches.map((item) {
                                        final match = item.match;
                                        final prediction = item.selectedResult;

                                        String predictionStr;
                                        if (prediction == 1) predictionStr = "1";
                                        else if (prediction == 0) predictionStr = "X";
                                        else predictionStr = "2";

                                        return "${match.homeTeamName} - ${match.awayTeamName} ($predictionStr)";
                                      }).join(" | ");

                                      final couponText = "ODD: ${coupon.totalOdd.toStringAsFixed(2)} → $matchSummaries";

                                      final prefs = await SharedPreferences.getInstance();
                                      List<String> saved = prefs.getStringList('savedCoupons') ?? [];

                                      if (!saved.contains(couponText)) {
                                        saved.add(couponText);
                                        await prefs.setStringList('savedCoupons', saved);
                                      }

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Saved: $couponText"),
                                          duration: Duration(milliseconds: 1000),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Save Coupon!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[800],
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(12),
                                    ),
                                    onPressed: () {
                                      controller.nextPage(
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
                        );
                      },
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