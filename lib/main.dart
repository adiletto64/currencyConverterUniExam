import 'package:exam/data.dart';
import 'package:exam/requests.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Валюты"),
        ),
        body: const MyHomePage()
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Currency> currencies = [];

  String? baseCurrency;
  String? targetCurrency;
  double? exchangeRate;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {

    setState(() {

      currencyData.forEach((_, currency) {
        currencies.add(Currency(symbol: currency["symbol"].toString(), name: currency["name"].toString(), code: currency["code"].toString()));
      });

      baseCurrency = currencies[0].code;
      targetCurrency = currencies[1].code;
    });
  }

  void check() {
    if (baseCurrency != null && targetCurrency != null) {
      if (baseCurrency == targetCurrency) {
        return;
      }

      print("Загрузка курса... ${baseCurrency} -> ${targetCurrency}");

      getExchange(baseCurrency!, targetCurrency!).then((value) {
        setState(() {
          exchangeRate = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
              value: baseCurrency,
              items: currencies.map((c) => DropdownMenuItem(child: Text(c.name), value: c.code)).toList(),
              onChanged: (me) { setState(() {
                baseCurrency = me;
              }); check(); }
          ),

          DropdownButton<String>(
              value: targetCurrency,
              items: currencies.map((c) => DropdownMenuItem(child: Text(c.name), value: c.code)).toList(),
              onChanged: (me) { setState(() {
                targetCurrency = me;
              }); check(); }
          ),

          Text(
              "Курс: ${exchangeRate?.toStringAsFixed(2) ?? "неизвестно"}",
              style: TextStyle(fontSize: 30)
          )
        ],
      ),
    );
  }
}
