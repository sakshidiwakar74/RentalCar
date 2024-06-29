import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentalcar/components/bottompage.dart';
import 'package:rentalcar/screens/homescreen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Image.asset('assets/images/car0.png'),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Luxary Car Rental\nIn India.', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  SizedBox(height: 10,),
                  Text('Rent cars online today & enjoy the best deals\nrates and accessories', style: TextStyle(color: Colors.grey),),
                ],
              ),
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                side: BorderSide(color: Colors.black), // Optional: add a border
              ),
              minWidth: MediaQuery.of(context).size.width * 0.7,
              height: 50,
              color: Colors.white,
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomScreen()));
              },
              child: Text('Lets Go!', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
            )

          ],
        ),
      ),
    );
  }
}