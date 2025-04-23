import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  CustomAppBar({super.key,});

  Widget build(BuildContext context){
    return AppBar(
      toolbarHeight: 75,
      leading: Center(
        child: IconButton(
          onPressed: () {
            print("Settings button is clicked.");
          },
          icon: Icon(Icons.settings, color: Colors.white),
          iconSize: 40,
        ),
      ),
      title:
      Row(
        mainAxisAlignment:  MainAxisAlignment.center,
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
              fontSize: 35,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),

      backgroundColor: Color(0xFF2C2C2C),
      actions: [
        IconButton(
          onPressed: (){
            print("profile button clicked");
          },
          icon: Icon(Icons.account_circle,color: Colors.white,),
          iconSize: 40,
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(75);
}