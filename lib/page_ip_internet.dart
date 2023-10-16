import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IPData {
  final String ip;
  final String city;
  final String country;
  final String organization;

  IPData({
    required this.ip,
    required this.city,
    required this.country,
    required this.organization,
  });

  factory IPData.fromJson(Map<String, dynamic> json) {
    return IPData(
      ip: json['ip'] ?? '',
      city: json['city'] ?? '',
      country: json['country_name'] ?? '',
      organization: json['org'] ?? '',
    );
  }
}

Future<IPData> fetchIPInfo() async {
  try {
    final response = await http.get(
      Uri.parse('https://ipapi.co/8.8.8.8/json/'), // IP específica
      headers: {
        'Authorization':
            'f3fe989e5d114257bfee8dc6beefe877', // Reemplaza con tu clave de API
      },
    ).timeout(
      const Duration(seconds: 10), // Tiempo de espera de 10 segundos
      onTimeout: () {
        // Se ejecuta si la solicitud se excede del tiempo límite
        throw TimeoutException('La solicitud se excedió del tiempo límite');
      },
    );

    if (response.statusCode == 200) {
      return IPData.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Server responded with status code ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load IP info: $e');
  }
}

class PageIPInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ipDataFuture = fetchIPInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('IP Info for 8.8.8.8 from API'),
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
      body: FutureBuilder<IPData>(
        future: ipDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            IPData ipData = snapshot.data!;
            return ListView(
              children: [
                CardItem(
                  ip: ipData.ip,
                  city: ipData.city,
                  country: ipData.country,
                  organization: ipData.organization,
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

class CardItem extends StatelessWidget {
  final String ip;
  final String city;
  final String country;
  final String organization;
  final List<int> firstColor;
  final List<int> secondColor;

  const CardItem({
    Key? key,
    required this.ip,
    required this.city,
    required this.country,
    required this.organization,
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
                  "IP: $ip",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "City: $city",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Country: $country",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Organization: $organization",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
