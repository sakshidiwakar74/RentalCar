class Address {
  final String address;
  final double latitude;
  final double longitude;

  Address({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  // Convert Address object to a Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Convert a Map to an Address object
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}