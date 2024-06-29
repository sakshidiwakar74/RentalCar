import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rentalcar/screens/bookingscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _carName = [
    'Audi',
    'Ferrari',
    'BMW',
    'Porsche',
    'Lamborgini'
  ];
  final List<String> _rating = [
    '4.9',
    '3.8',
    '5.0',
    '4.2',
    '4.7'
  ];
  List<double> randomNumbers = [];
  List<bool> favorite = [
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    Random random = Random();
    randomNumbers = List.generate(5, (index) {
      double number = 200 + random.nextDouble() * (500 - 200);
      return double.parse(number.toStringAsFixed(2));
    });
  }
  @override
  Widget build(BuildContext context) {

    return Material(
      child: SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.white54,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 20,),
                            Column(
                              children: [
                                Text('Your location', style: TextStyle(color: Colors.grey),),
                                Text('Milan Italy', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),)
                             ],)
                          ],
                        ),
              
                        Row(
                            
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 10),
                              CircleAvatar(child: Icon(Icons.person),),
                            ],
                          ) 
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Brands', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
                  const Gap(10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 30);
                      },
                      
                      itemCount: 5,
                      itemBuilder: (context, index){
                        return Container(
                          
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // shadow color
                                spreadRadius: 2, // spread radius
                                blurRadius: 7, // blur radius
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            image: DecorationImage(image: AssetImage('assets/logos/logo$index.png')),
                            color: Colors.white54,
                          ),
                        );
                      } 
                     ),
                  ),
                  const SizedBox(height: 50),
                  const Text('Available cars near you', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
                  const Gap(10),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 30);
                      },
                      
                      itemCount: 5,
                      itemBuilder: (context, index){
                        
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(carName: _carName[index], price: randomNumbers[index], image: 'assets/images/image$index.png')));
                          },
                          child: Container(
                            //child:Text('Lamborgini', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3), // shadow color
                                  spreadRadius: 1, // spread radius
                                  blurRadius: 7, // blur radius
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              image: DecorationImage(image: AssetImage('assets/images/image$index.png')),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white54,
                            ),
                            //child:Text('Lamborgini', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Text(_carName[index], 
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 20, fontWeight: 
                                    FontWeight.bold),
                                )),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: (){
                                      favorite[index] = true;
                                      setState(() {
                                        
                                      });
                                    },
                                    icon: Icon(Icons.favorite, color: favorite[index]? Colors.red: Colors.black,),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  bottom: 10,
                                  child: Row(
                                    
                                    children: [
                                      Text('\$ ${randomNumbers[index]}/day',
                                      style: const TextStyle(
                                      color: Colors.black, 
                                      fontSize: 18, fontWeight: 
                                      FontWeight.bold), 
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Row(
                          
                                        children: [
                                          const Icon(Icons.star, color: Colors.black, size: 20,),
                                          Text(_rating[index], 
                                          style: const TextStyle(
                                          color: Colors.black, 
                                          fontSize: 18, fontWeight: 
                                          FontWeight.bold), 
                                          ),
                                        ],
                                      ),
                                    ],
                                  ), 
                                ),
                              ],
                            ),
                            
                          ),
                        );
                      } 
                     ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  
                  const Text('Promo', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
                  const Gap(10),
                  SizedBox(
                    height: 200,
                    width: 420,
                    child: Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // shadow color
                            spreadRadius: 2, // spread radius
                            blurRadius: 7, // blur radius
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        image: const DecorationImage(image: AssetImage('assets/images/image4.png')),
                        color: Colors.white54,
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