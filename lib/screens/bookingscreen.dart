import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:rentalcar/components/sqlitedb.dart';
import 'package:rentalcar/models/address.dart';
import 'package:rentalcar/models/carride.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  List<String> carName;
  List<double> price;
  List<String>image;
  final int index;
   BookingScreen(
      {super.key,
      required this.carName,
      required this.price,
      required this.image,
      required this.index
      });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  TextEditingController pickuplocation = TextEditingController();
  TextEditingController droplocation = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Address? selectedPickupAddress;
  Address? selectedDropAddress;
  bool isPickUpActive = false;
  double rideDistance = 0.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Address> allAddresses = [];
  List<Address> filteredAddresses = [];
  bool isLoading = true;
  int currentIndex = 0;

  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    loadAddresses().whenComplete(() => log(filteredAddresses.toString()));
  }

  Future<void> loadAddresses() async {
    String jsonString = await rootBundle.loadString('assets/addressinfo.json');
    List<Address> addresses = parseAddresses(jsonString);
    setState(() {
      allAddresses = addresses;
      //filteredAddresses = addresses;
      isLoading = false;
    });
  }

  List<Address> parseAddresses(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return (jsonData['addresses'] as List)
        .map((addressJson) => Address.fromMap(addressJson))
        .toList();
  }

  void filterAddresses(String query) {
    if (query.isEmpty) {
      filteredAddresses = allAddresses;
    } else {
      filteredAddresses = allAddresses
          .where((address) =>
              address.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  void selectAddress(Address address) {
    if (isPickUpActive) {
      pickuplocation.text = address.address;
      selectedPickupAddress = address;
    } else {
      droplocation.text = address.address;
      selectedDropAddress = address;
    }
    filteredAddresses = [];
  }

  Future<void> fetchRoute(Address from, Address to) async {
  String url =
      'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}?overview=false';

  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // Parse the JSON response to extract route information
      rideDistance = jsonResponse['routes'][0]['distance'];
      
      // print('Route distance: ${jsonResponse['routes'][0]['distance']} meters');
      // print('Route duration: ${jsonResponse['routes'][0]['duration']} seconds');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to load route information: $e');
  }
}

void _showBookingConfirmationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Booking Confirmation'),
        content: Text('Your ride has been booked successfully!'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                   if (details.delta.dx > 0) {
                    // Swiped right
                    if (currentIndex > 0) {
                      setState(() {
                        currentIndex--;
                      });
                    }
                  } else if (details.delta.dx < 0) {
                    // Swiped left
                    if (currentIndex < widget.carName.length - 1) {
                      setState(() {
                        currentIndex++;
                      });
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      
                      children: [
                        currentIndex < widget.carName.length-1?
                        const Positioned(
                          top: 200,
                          right: 10,
                          child: Icon(Icons.arrow_forward_sharp, size: 30),
                        ) : const SizedBox(),
                        currentIndex > 0?
                        const Positioned(
                          top: 200,
                          left: 10,
                          child: Icon(Icons.arrow_back_sharp, size: 30, color: Colors.black),
                        ) : const SizedBox(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.carName[currentIndex],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite,
                                      size: 30,
                                    )),
                              ],
                            ),
                            Container(
                              height: 400,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: AssetImage(widget.image[currentIndex])),
                                color: Colors.white54,
                              ),
                            ),
                            const Text(
                              'Renter Point',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Gap(20),
                            nameController.text.isEmpty && emailController.text.isEmpty && phoneController.text.isEmpty
                                ? ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: MediaQuery.of(context).size.height*0.7,
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        controller: nameController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Name'),
                                                        validator: (value) {
                                                          if (value == null &&
                                                              value!.isEmpty) {
                                                            return 'Please enter your name';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        controller: emailController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Email'),
                                                        validator: (value) {
                                                          if (value == null &&
                                                              value!.isEmpty) {
                                                            return 'Please enter your email';
                                                          }
                                                          // Add email format validation if needed
                                                          return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        controller: phoneController,
                                                        decoration: const InputDecoration(
                                                            labelText:
                                                                'Phone Number'),
                                                        validator: (value) {
                                                          if (value == null &&
                                                              value!.isEmpty) {
                                                            return 'Please enter your phone number';
                                                          }
                                                          // Add phone number format validation if needed
                                                          return null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      // Submit logic, e.g., save data, send API request
                                                      // Close the bottom sheet
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Submit'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Open Bottom Sheet'),
                                  )
                                : SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 12),
                                          child: CircleAvatar(
                                            child: Icon(Icons.person),
                                            maxRadius: 30.0,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nameController.text,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              emailController.text,
                                              style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 150,
                                        ),
                                        const Icon(Icons.explore, size: 50),
                                      ],
                                    ),
                                ),
                            const Gap(20),
                            const Text(
                              'Specifications',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Gap(20),
                            Row(
                              children: [
                                const Icon(Icons.stop_circle_rounded),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        isPickUpActive = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      filterAddresses(value);
                                    },
                                    controller: pickuplocation,
                                    decoration: const InputDecoration(
                                      hintText: 'Pickup location',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    onTap: () {
                                      isPickUpActive = false;
                                    },
                                    onChanged: (value) {
                                      filterAddresses(value);
                                    },
                                    controller: droplocation,
                                    decoration: const InputDecoration(
                                      hintText: 'Where you want to go',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredAddresses.length,
                              itemBuilder: (context, index) {
                                final address = filteredAddresses[index];
                                return ListTile(
                                  title: Text(address.address),
                                  onTap: () {
                                    selectAddress(address);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$ ${widget.price[currentIndex].toString()}/day",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black),
                          ),
                          height: 50,
                          onPressed: () async {
                            if(selectedDropAddress != null && selectedPickupAddress != null && selectedDropAddress != selectedPickupAddress){
                              await fetchRoute(selectedDropAddress!, selectedPickupAddress!);
                              //if(nameController.text.isNotEmpty && emailController.text.isNotEmpty && phoneController.text.isEmpty) {
                                CarRide carRide = CarRide(
                                id: const Uuid().v4(), 
                                carName: widget.carName[currentIndex], 
                                price: widget.price[currentIndex], 
                                fromAddress: selectedPickupAddress?.address ?? '', 
                                toAddress: selectedDropAddress?.address ?? '', 
                                distance: rideDistance, 
                                name: nameController.text, 
                                email: emailController.text, 
                                phoneNumber: phoneController.text, 
                                carImage: widget.image[currentIndex]
                                );
                                await databaseHelper.insertCarRide(carRide);
                                _showBookingConfirmationDialog();
                              //}
                            }
                          },
                          child: const Text('Book Now',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



