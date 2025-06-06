import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        backgroundColor: Colors.green[800]
      ),
      body: ListView(
        children: [
      ListTile(
      leading: const Icon(Icons.star_outline, color: Colors.orange),
      title: Text(
        'Delete all favorite teams',
        style: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('favorites');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All favorite teams have been cleared.'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              'Delete all saved coupons',
              style: TextStyle(color: Colors.white),),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('savedCoupons');
              await prefs.remove('couponResultStates');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All saved coupons are deleted.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exposure_zero, color: Colors.yellow),
            title: Text(
              'Reset profit only',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('totalProfitLoss');
              await prefs.remove('couponResults');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profit information has been reset.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.restart_alt, color: Colors.lightBlueAccent),
            title: Text(
              'Reset all coupon data',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('savedCoupons');
              await prefs.remove('totalExpenses');
              await prefs.remove('couponIdCounter');
              await prefs.remove('couponResultStates');
              await prefs.remove('totalProfitLoss');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All coupon data has been reset.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      )
    );
  }
}