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
      title: 'Конвертер валюты',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Roboto"
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Конвертер валюты"),
        ),
        body: const MyHomePage()
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
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
      padding: const EdgeInsets.only(top: 70, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Конвертер валюты", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),

          SizedBox(height: 100,),

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

          SizedBox(height: 30,),

          Text("Курс:", style: TextStyle(fontSize: 20),),

          Text(
              "${exchangeRate?.toStringAsFixed(2) ?? "..."}",
              style: TextStyle(fontSize: 60)
          )
        ],
      ),
    );
  }
}
