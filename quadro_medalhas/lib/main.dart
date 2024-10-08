import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadro_medalhas/medal_info.dart';
import 'package:quadro_medalhas/models/country.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quadro de Medalhas',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.purple,
            ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quadro de Medalhas - Olimpíadas de Paris 2024 (Índice C.A.)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String paisesUrl = 'https://apis.codante.io/olympic-games/countries';

  // @override
  // void initState() {
  //   super.initState();
  //   fetchCountries();
  // }

  void _atualizar() {
    setState(() {
      fetchCountries();
    });
  }

  Future<List<Country>> fetchCountries() async {

    final response = await http.get(
      Uri.parse('https://apis.codante.io/olympic-games/countries'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Country.fromJson(json)).toList();
    } else {
      throw Exception('Falha no carregamento dos dados.');
    }

    // // Simular um delay para testes
    // await Future.delayed(const Duration(seconds: 1));

    // // Retornar a lista dummy de países
    // return dummyCountries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchCountries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Sem dados disponíveis'),
            );
          } else {
            final countries = snapshot.data!;
            countries.sort(
              (a, b) {
                double pontuacaoA = a.goldMedals +
                    (a.silverMedals * 0.5) +
                    (a.bronzeMedals * 0.25);
                double pontuacaoB = b.goldMedals +
                    (b.silverMedals * 0.5) +
                    (b.bronzeMedals * 0.25);
                return pontuacaoB.compareTo(pontuacaoA);
              },
            );
            return Container(
              color: const Color.fromARGB(255, 242, 229, 255),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                    height: 1, color: Colors.grey[400]), // Adiciona um divisor
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 35,
                          child: Text('${index + 1}º',
                              style: const TextStyle(fontSize: 18)),
                        ),
                        Image.network(
                          country.flagUrl,
                          width: 50,
                        ),
                      ],
                    ),
                    title: Text(country.name),
                    subtitle: Text('Rank oficial: ${country.rank}º'),
                    // subtitle: Text(
                    //     'Ouro: ${country.goldMedals}, Prata: ${country.silverMedals}, Bronze: ${country.bronzeMedals}'),
                    trailing: MedalInfo(
                      goldMedals: country.goldMedals,
                      silverMedals: country.silverMedals,
                      bronzeMedals: country.bronzeMedals,
                      totalMedals: country.totalMedals,
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _atualizar,
        tooltip: 'Atualizar',
        child: const Icon(Icons.sync),
      ),
    );
  }
}
