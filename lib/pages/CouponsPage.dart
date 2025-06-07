import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Match.dart';
import '../widgets/CouponStack.dart';
import '../models/Coupon.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SARP DEMİRTAS - 20220601016
//ONUR ERGÜDEN - 20220601030

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => CouponsPageState();
}

class CouponsPageState extends State<CouponsPage> {
  Map<String, int> costMap = {};
  late PageController controller;
  List<Coupon> coupons = [];
  String? currentCouponId;
  late Future<List<Coupon>> couponsFuture;

  void addCost() {
    if (currentCouponId == null) return;
    setState(() {
      costMap[currentCouponId!] = (costMap[currentCouponId!] ?? 0) + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    ensureInitialCouponId();
    controller = PageController(viewportFraction: 0.65, initialPage: 1);
    loadCostMap();
    couponsFuture = getCoupons();
  }

  void ensureInitialCouponId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.containsKey('couponIdCounter'))) {
      await prefs.setInt('couponIdCounter', 1);
    }
  }

  Future<void> loadCostMap() async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList('costMap') ?? [];
    setState(() {
      costMap = {
        for (var entry in list)
          entry.split(":")[0]: int.tryParse(entry.split(":")[1]) ?? 0,
      };
    });
  }

  String generateCouponKey(Coupon coupon) {
    return coupon.selectedMatches
        .map(
          (m) =>
              "${m.match.homeTeamName}_${m.match.awayTeamName}_${m.selectedResult}",
        )
        .join("|");
  }

  void incrementCost() async {
    if (currentCouponId == null) return;
    setState(() {
      costMap[currentCouponId!] = (costMap[currentCouponId!] ?? 0) + 1;
    });
    await saveCostMap();
  }

  void decrementCost() {
    if (currentCouponId == null) return;
    setState(() {
      costMap[currentCouponId!] = (costMap[currentCouponId!] ?? 1) - 1;
      if (costMap[currentCouponId!]! < 0) costMap[currentCouponId!] = 0;
    });
  }

  Future<void> saveCostMap() async {
    final p = await SharedPreferences.getInstance();
    final encoded = costMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    await p.setStringList(
      'costMap',
      encoded.entries.map((e) => '${e.key}:${e.value}').toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              width: size.width * 0.95,
              height: size.height * 0.72,
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
                      future: couponsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No coupons found."));
                        }

                        coupons = snapshot.data!;
                        if (currentCouponId == null && coupons.isNotEmpty) {
                          currentCouponId = generateCouponKey(
                            coupons[controller.initialPage],
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CouponStack(
                              controller: controller,
                              coupons: coupons,
                              onPageChanged: (index) {
                                setState(() {
                                  currentCouponId = generateCouponKey(
                                    coupons[index],
                                  );
                                });
                              },
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
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: decrementCost,
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor: Colors.red,
                                            padding: EdgeInsets.all(12),
                                            elevation: 4,
                                            side: BorderSide(
                                              color: Colors.red,
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.systemGrey6,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.green.shade900,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Coupon cost: ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "\$${costMap[currentCouponId] ?? 0}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[900],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: incrementCost,
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor: Colors.green,
                                            padding: EdgeInsets.all(12),
                                            elevation: 4,
                                            side: BorderSide(
                                              color: Colors.green,
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    height: 2,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    color: Colors.black54,
                                  ),
                                  SizedBox(height: 6),
                                  Row(
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
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () async {
                                          final currentIndex =
                                              controller.page!.round();
                                          final coupon = coupons[currentIndex];
                                          final key = generateCouponKey(coupon);

                                          final matchSummaries = coupon
                                              .selectedMatches
                                              .map((item) {
                                                final match = item.match;
                                                final prediction = item.selectedResult;
                                                String predictionStr;
                                                if (prediction == 1) {
                                                  predictionStr = "01"; 
                                                } else if (prediction == 2) {
                                                  predictionStr = "02"; 
                                                } else {
                                                  predictionStr = "X"; 
                                                }
                                                return "${match.homeTeamName} - ${match.awayTeamName} ($predictionStr)";
                                              })
                                              .join(", ");

                                          final prefs =
                                              await SharedPreferences.getInstance();

                                          int couponId =
                                              prefs.getInt('couponIdCounter') ??
                                              1;

                                          final currentCost = costMap[key] ?? 0;
                                          if (currentCost == 0) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Coupon cost must be greater than 0."),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            return;
                                          }
                                          prefs.setInt(
                                            'couponIdCounter',
                                            couponId + 1,
                                          );

                                          final formattedCoupon =
                                              "CouponID:$couponId|Cost:$currentCost|ODD:${coupon.totalOdd.toStringAsFixed(2)}|Matches:$matchSummaries";

                                          List<String> saved =
                                              prefs.getStringList(
                                                'savedCoupons',
                                              ) ??
                                              [];
                                          saved.add(formattedCoupon);
                                          await prefs.setStringList(
                                            'savedCoupons',
                                            saved,
                                          );

                                          final crList =
                                              prefs.getStringList(
                                                'couponResults',
                                              ) ??
                                              [];
                                          crList.add("$couponId:0");
                                          await prefs.setStringList(
                                            'couponResults',
                                            crList,
                                          );

                                          int totalExpenses =
                                              prefs.getInt('totalExpenses') ??
                                              0;
                                          totalExpenses += currentCost;
                                          await prefs.setInt(
                                            'totalExpenses',
                                            totalExpenses,
                                          );

                                          costMap[key] = 0;
                                          final encoded = costMap.map(
                                            (k, v) => MapEntry(k, v.toString()),
                                          );
                                          await prefs.setStringList(
                                            'costMap',
                                            encoded.entries
                                                .map(
                                                  (e) => '${e.key}:${e.value}',
                                                )
                                                .toList(),
                                          );

                                          setState(() {});
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Saved: ID $couponId | Odd ${coupon.totalOdd.toStringAsFixed(2)} | Cost \$$currentCost",
                                              ),
                                              duration: Duration(
                                                milliseconds: 1000,
                                              ),
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
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
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
