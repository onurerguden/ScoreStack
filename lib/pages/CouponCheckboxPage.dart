import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponCheckboxPage extends StatefulWidget {
  const CouponCheckboxPage({super.key});

  @override
  CheckboxState createState() => CheckboxState();
}

class CheckboxState extends State<CouponCheckboxPage> {
  bool isChecked = false;

  void skip() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        toolbarHeight: 75,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/ScoreStackLogo4-removebg-preview.png',
              width: 40,
            ),
            SizedBox(width: 2),
            const Text(
              "ScoreStack",
              style: TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 45),
          ],
        ),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.74,
              color: CupertinoColors.systemGrey3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Color(0xFF2C2C2C),
                        child: Row(
                          children: [
                            const SizedBox(width: 17.8),
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 28,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Warning About Coupons",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.045,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 28),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.dangerous, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Worldwide, up to 1 in 5 gambling addicts attempt suicide.",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.report_gmailerrorred_rounded, color: Color(0xFFFFC107)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "ScoreStack doesn’t promise any win. This app isn’t responsible for outcomes. Bet wisely.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.link, color: Colors.blue,),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "ScoreStack has no connection with betting companies. Coupons are based on statistics and are not advice to invest money.",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async {
                                    final Uri url = Uri.parse("https://www.gamblingtherapy.org/");
                                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Learn more about betting awareness",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4)
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  activeColor: Colors.lightGreen,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "I know betting has risks and ScoreStack isn’t responsible for what I choose to do.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: isChecked ? skip : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                              ),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
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
        ),
      ),
    );
  }
}