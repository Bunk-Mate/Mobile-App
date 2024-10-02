import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: 
      
        
    Column(
  children: [ const Spacer() , Image.network("https://media.tenor.com/aSkdq3IU0g0AAAAe/laughing-cat.png" , width: 500,height: 500 ,),Container(child: Text("Forgotten your password huh.." , style: TextStyle(fontSize: 20, fontFamily: GoogleFonts.lexend().fontFamily , color: Colors.white))),Container(child: const Text("Either do drugs and lock-in to remember that password or you can create a new account and start over.",style: TextStyle(color: Colors.white),),), const Spacer()],
        
    )
  );}
}