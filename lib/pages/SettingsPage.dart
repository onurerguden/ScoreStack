import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//SARP DEMİRTAS - 20220601016
//ONUR ERGÜDEN - 20220601030

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2C),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Settings Page",
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 35),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Settings for Application',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('savedCoupons');
                              await prefs.remove('couponResultStates');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'All saved coupons are deleted.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Delete all saved coupons',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('totalProfitLoss');
                              await prefs.remove('couponResults');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Profit information has been reset.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.exposure_zero,
                                color: Colors.yellow,
                              ),
                              title: Text(
                                'Reset profit only',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('savedCoupons');
                              await prefs.remove('totalExpenses');
                              await prefs.remove('couponIdCounter');
                              await prefs.remove('couponResultStates');
                              await prefs.remove('totalProfitLoss');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'All coupon data has been reset.',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.restart_alt,
                                color: Colors.lightBlueAccent,
                              ),
                              title: Text(
                                'Reset all coupon data',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.self_improvement, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Settings for Your Life',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                () => launchUrl(
                                  Uri.parse('https://www.yesilay.org.tr'),
                                ),
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.volunteer_activism,
                                color: Colors.tealAccent,
                              ),
                              title: Text(
                                'Yeşilay - Türkiye',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'https://www.yesilay.org.tr',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                () => launchUrl(
                                  Uri.parse('https://www.begambleaware.org'),
                                ),
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.public,
                                color: Colors.blueAccent,
                              ),
                              title: Text(
                                'BeGambleAware - Global',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'https://www.begambleaware.org',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                () => launchUrl(
                                  Uri.parse('https://www.gamblingtherapy.org'),
                                ),
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.favorite,
                                color: Colors.pinkAccent,
                              ),
                              title: Text(
                                'Gambling Therapy - Global',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'https://www.gamblingtherapy.org',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF424242),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                () => launchUrl(
                                  Uri.parse(
                                    'https://www.responsiblegambling.org',
                                  ),
                                ),
                            splashColor: Colors.white24,
                            highlightColor: Colors.white10,
                            child: ListTile(
                              leading: Icon(
                                Icons.shield,
                                color: Colors.deepPurpleAccent,
                              ),
                              title: Text(
                                'Responsible Gambling Council',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'https://www.responsiblegambling.org',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
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
    );
  }
}
