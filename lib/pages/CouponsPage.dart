import 'package:flutter/material.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  State<CouponsPage> createState() => CouponsPageState();
}

class CouponsPageState extends State<CouponsPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(width: 58),
              IconButton(
                onPressed: () {
                  print("Previous coupon...");
                },
                icon: Icon(Icons.arrow_back_ios_sharp, size: 30),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  print("Selected coupon is saved.");
                },
                child: Text("Save coupon", style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  print("Next coupon...");
                },
                icon: Icon(Icons.arrow_forward_ios_sharp, size: 30),
              ),
            ],
          ),
          SizedBox(height: 35),
        ],
      ),
    );
  }
}