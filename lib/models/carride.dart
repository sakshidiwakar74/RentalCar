
class CarRide {
  final String id; // Unique ID for each CarRide entry
  final String carName;
  final double price;
  final String fromAddress;
  final String toAddress;
  final double distance;
  final String name;
  final String email;
  final String phoneNumber;
  final String carImage;

  CarRide({
    required this.id,
    required this.carName,
    required this.price,
    required this.fromAddress,
    required this.toAddress,
    required this.distance,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.carImage,
  });

  // Convert CarRide object to a Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carName': carName,
      'price': price,
      'fromAddress': fromAddress, // Store Address as a Map in SQLite
      'toAddress': toAddress, // Store Address as a Map in SQLite
      'distance': distance,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'carImage' : carImage,
    };
  }

  // Convert a Map to a CarRide object
  factory CarRide.fromMap(Map<String, dynamic> map) {
    return CarRide(
      id: map['id'],
      carName: map['carName'],
      price: map['price'],
      fromAddress: map['fromAddress'],
      toAddress: map['toAddress'],
      distance: map['distance'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      carImage: map['carImage'],
    );
  }
}