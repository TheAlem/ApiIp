import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryData {
  final String country;

  CountryData({
    required this.country,
  });

  factory CountryData.fromJson(String json) {
    return CountryData(
      country: json,
    );
  }
}

Future<CountryData> fetchCountryInfo() async {
  try {
    final response = await http.get(
      Uri.parse('https://ipapi.co/country_name/'),
      headers: {
        'Authorization': ' f3fe989e5d114257bfee8dc6beefe877',
      },
    ).timeout(
      const Duration(seconds: 10), // Tiempo de espera de 10 segundos
      onTimeout: () {
        // Se ejecuta si la solicitud se excede del tiempo límite
        throw TimeoutException('La solicitud se excedió del tiempo límite');
      },
    );

    if (response.statusCode == 200) {
      // Usamos directamente response.body sin json.decode
      return CountryData.fromJson(response.body.trim());
    } else {
      throw Exception(
          'Server responded with status code ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load country info: $e');
  }
}

class PageCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countryDataFuture = fetchCountryInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Info from API'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD21EE2), Color(0xFF960FD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.7),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<CountryData>(
        future: countryDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            CountryData countryData = snapshot.data!;
            return ListView(
              children: [
                CountryCardItem(
                  country: countryData.country,
                  firstColor: [255, 173, 216, 230], // Azul suave
                  secondColor: [255, 162, 221, 184], // Verde suave
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CountryCardItem extends StatelessWidget {
  final String country;
  final List<int> firstColor;
  final List<int> secondColor;

  const CountryCardItem({
    Key? key,
    required this.country,
    required this.firstColor,
    required this.secondColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        shadowColor: const Color.fromARGB(255, 30, 87, 145).withOpacity(0.7),
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(
                    firstColor[0], firstColor[1], firstColor[2], firstColor[3]),
                Color.fromARGB(secondColor[0], secondColor[1], secondColor[2],
                    secondColor[3]),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Country: $country",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
