import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/pages/page_home.dart';

import 'api/api_geocoder.dart';
import 'models/device_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Location location = Location();
  bool _serviceEnabled = await location.serviceEnabled();
  if(!_serviceEnabled){
    _serviceEnabled = await location.requestService();
    if(!_serviceEnabled){
      return;
    }
  }
  PermissionStatus _permissionGranted = await
  location.hasPermission();
  if(_permissionGranted == PermissionStatus.denied){
    _permissionGranted = await location.requestPermission();
    if(_permissionGranted != PermissionStatus.granted){
      return;
    }
  }
  LocationData _locationData = await location.getLocation();
  print("Location = ${_locationData.latitude},${_locationData.longitude}");
  DeviceInfo.locationData = _locationData;


  if(_locationData != null) {
    ApiGeocoder geocoder = ApiGeocoder(apiKey: "a928e63f1313dbe5f0127b7e6fece3f2");
    String? ville = await geocoder.getAddressFromCoordinates(
        latitude: _locationData.latitude!,
        longitude: _locationData.longitude!);
    DeviceInfo.city = ville;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

