import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Team.dart';
import '../widgets/TeamTile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//SARP DEMİRTAS - 20220601016
//ONUR ERGÜDEN - 20220601030

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int totalExpenses = 0;
  double totalProfitLoss = 0;
  List<Team> favoriteTeams = [];
  List<String> savedCoupons = [];
  Map<String, int> couponResults = {};

  @override
  void initState() {
    super.initState();
    fetchFavorites();
    fetchSavedCoupons();
    loadTotalExpenses();
    loadCouponResults();
    loadTotalProfitLoss();
  }

  Future<void> fetchFavorites() async {
    final collection =
        await FirebaseFirestore.instance.collection('team').get();
    final allteams =
        collection.docs.map((doc) {
          final data = doc.data();
          return Team.fromMap(data, reference: doc.reference);
        }).toList();

    final prefs = await SharedPreferences.getInstance();
    final favoriteNames = prefs.getStringList('favorites') ?? [];

    setState(() {
      favoriteTeams =
          allteams.where((team) => favoriteNames.contains(team.name)).toList();
    });
  }

  Future<void> fetchSavedCoupons() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCoupons = prefs.getStringList('savedCoupons') ?? [];
    });

    await loadCouponResults();
  }

  Future<void> loadTotalExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt('totalExpenses') ?? 0;
    setState(() {
      totalExpenses = total;
    });
  }

  Future<void> loadTotalProfitLoss() async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getDouble('totalProfitLoss') ?? 0.0;
    setState(() {
      totalProfitLoss = total;
    });
  }

  Future<void> loadCouponResults() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('couponResults') ?? [];
    Map<String, int> results = {};
    for (var entry in list) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        results[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }
    setState(() {
      couponResults = results;
    });
  }

  Future<void> saveCouponResults() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list =
        couponResults.entries.map((e) => "${e.key}:${e.value}").toList();
    await prefs.setStringList('couponResults', list);
  }

  Future<void> updateCouponResultState(
    String couponId,
    int status,
    double cost,
    double odd,
  ) async {
    int? prevStatus = couponResults[couponId];
    double prevEffect = 0;
    if (prevStatus == 1) {
      prevEffect = cost * odd;
    } else if (prevStatus == 2)
      prevEffect = -cost;

    totalProfitLoss -= prevEffect;

    double newEffect = 0;
    if (status == 1) {
      newEffect = cost * odd;
    } else if (status == 2)
      newEffect = -cost;

    totalProfitLoss += newEffect;

    setState(() {
      couponResults[couponId] = status;
      totalProfitLoss = totalProfitLoss;
    });
    await saveCouponResults();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalProfitLoss', totalProfitLoss);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Color profitColor =
        totalProfitLoss > 0
            ? Colors.green
            : totalProfitLoss < 0
            ? Colors.red
            : Colors.amber;

    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Profile Page",
          style: TextStyle(
            fontSize: screenWidth * 0.058,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 6),
                Text(
                  "Favorite Teams",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.005),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey3,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amberAccent, width: 5),
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child:
                    favoriteTeams.isEmpty
                        ? Center(
                          child: Text(
                            "No favorites yet.",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                        : ListView.builder(
                          itemCount: favoriteTeams.length,
                          itemBuilder: (context, index) {
                            return TeamTile(
                              team: favoriteTeams[index],
                              showStar: false,
                            );
                          },
                        ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Icon(Icons.local_activity, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "Saved Coupons",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.005),
            Container(
              height: MediaQuery.of(context).size.height * 0.33,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey3,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green, width: 5),
              ),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child:
                  savedCoupons.isEmpty
                      ? Center(
                        child: Text(
                          "No saved coupons.",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                      : ListView.builder(
                        itemCount: savedCoupons.length,
                        itemBuilder: (context, index) {
                          final parts = savedCoupons[index].split('|');
                          final id = parts[0].split(':')[1];
                          final costStr = parts[1].split(':')[1];
                          final oddStr = parts[2].split(':')[1];
                          final matches =
                              parts[3]
                                  .split(':')[1]
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList();
                          final cost = double.tryParse(costStr) ?? 0.0;
                          final odd = double.tryParse(oddStr) ?? 0.0;
                          int state = couponResults[id] ?? 0;
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.008,
                            ),
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Coupon #$id",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Cost: \$$costStr",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.037,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ODD: $oddStr",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.037,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[400],
                                  thickness: 1,
                                  height: 12,
                                ),
                                ...matches.map(
                                  (match) => Text(
                                    match,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await updateCouponResultState(
                                              id,
                                              0,
                                              cost,
                                              odd,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                state == 0
                                                    ? Colors.amber
                                                    : Colors.grey[300],
                                            foregroundColor:
                                                state == 0
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          child: Icon(
                                            Icons.help_outline,
                                            size: 22,
                                            weight: 900,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await updateCouponResultState(
                                              id,
                                              1,
                                              cost,
                                              odd,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                state == 1
                                                    ? Colors.green
                                                    : Colors.grey[300],
                                            foregroundColor:
                                                state == 1
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 22,
                                            weight: 900,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await updateCouponResultState(
                                              id,
                                              2,
                                              cost,
                                              odd,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                state == 2
                                                    ? Colors.red
                                                    : Colors.grey[300],
                                            foregroundColor:
                                                state == 2
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 22,
                                            weight: 900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.blueAccent),
                SizedBox(width: 6),
                Text(
                  "Profile Stats",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              margin: EdgeInsets.only(top: screenHeight * 0.005),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey3,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 5),
              ),
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        "Total Spent: \$${totalExpenses.toString()}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.040,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        "Profit/Loss: \$${totalProfitLoss.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.040,
                          color: profitColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
