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
        title: Text(
          "Settings",
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All saved coupons are deleted.'),
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