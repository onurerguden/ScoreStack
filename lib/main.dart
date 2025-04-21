import 'package:flutter/material.dart';

void main() {
  runApp(ScoreStackApp());
}

class ScoreStackApp extends StatelessWidget {
  const ScoreStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,

        appBar: AppBar(
          toolbarHeight: 75,
          leading: Center(
            child:
            IconButton(onPressed: (){
              print("Settings Clicked");
              }, icon: Icon(Icons.settings,color : Colors.white,),
              iconSize: 40,
            ),
          ),
          title:Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 30,),
              Image.asset(
                'assets/images/ScoreStackLogo4-removebg-preview.png',
                width:40 ,
              ),
              SizedBox(width: 2,),
              const Text(
                "ScoreStack",style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
              ),
              ),
              SizedBox(
                width: 42,
              )
            ],
          ),

          centerTitle: true,
          backgroundColor: Color(0xFF2C2C2C),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFF2C2C2C),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                print("Maçlar");
              }, icon: Icon(
                Icons.sports_soccer,
                color :Colors.white,
                size: 40,
              )),
              SizedBox(width: 20,),
              IconButton(onPressed: (){
                print("Favoriler");
              }, icon: Icon(
                Icons.home,
                color :Colors.white,
                size: 40,
              )),
              SizedBox(width: 20,),
              IconButton(onPressed: (){
                print("Kuponlar");
              }, icon: Icon(
                Icons.star,
                color :Colors.white,
                size: 40,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
