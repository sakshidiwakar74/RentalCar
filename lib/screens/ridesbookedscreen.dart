import 'package:flutter/material.dart';
import 'package:rentalcar/components/sqlitedb.dart';
import 'package:rentalcar/models/carride.dart';

class RidesBookedScreen extends StatefulWidget {
  const RidesBookedScreen({super.key});

  @override
  State<RidesBookedScreen> createState() => _RidesBookedScreenState();
}

class _RidesBookedScreenState extends State<RidesBookedScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<CarRide> _rideList = [];
  int index = 0;
  
  Future<void> getRideList() async{
    _rideList = await databaseHelper.getAllCarRides();
    setState(() {
      
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRideList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Number of rides booked', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {

          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${index+1}. Name of the user who has booked: ${_rideList[index].name}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.blue),),
                Text('Phone number of the user: ${_rideList[index].phoneNumber}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),),
                Text('Pickup location: ${_rideList[index].fromAddress}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),),
                Text('Drop location: ${_rideList[index].toAddress}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),),
                Text('Car name: ${_rideList[index].carName}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),),
                Text('Distance: ${_rideList[index].distance}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),)
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: _rideList.length,
      ),
    );
  }
}