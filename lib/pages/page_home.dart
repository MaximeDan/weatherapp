import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_geocoder.dart';
import '../models/device_info.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String key = "cities";
  List<String> cities = [];
  String? chosenCity;
  @override
  void initState() {
    getSharedPrefCities();
    print(DeviceInfo.city);
    super.initState();
  }

  void getSharedPrefCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList("cities");
    if (list != null) {
      setState(() {
        cities = list;
      });
    }
  }

  void addCity(String value) async {
    if (cities.contains(value)) {
      //Pas de Doublon
      return;
    }
    cities.add(value); //Ajout de la ville à la liste Dart déjà
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // on remplace la clef "villes" par la liste Dart (on met à jour)
    await prefs.setStringList(key, cities);
    getSharedPrefCities();
  }

  void delete(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cities.remove(value);
    await prefs.setStringList(key, cities);
    getSharedPrefCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Mes Villes'),
            ),
            ElevatedButton(
              child: Text("Ajouter une ville"),
              onPressed: () async {
                ApiGeocoder geocoder =
                ApiGeocoder(apiKey: "a928e63f1313dbe5f0127b7e6fece3f2");
                Map<String, dynamic>? coordinates =
                await geocoder.getCoordinatesFromAddress(ville: "Bangkok");
                print(coordinates);
              },
            ),
            ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(cities[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
