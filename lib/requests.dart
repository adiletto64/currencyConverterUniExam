import 'package:dio/dio.dart';

class Currency {
  String symbol;
  String name;
  String code;

  Currency({required this.symbol, required this.name, required this.code});
}


const String apiKey = "dd35e340-3c70-11ec-b82e-23b516d7bf0e";
const host = "https://api.currencyapi.com";


Future<List<Currency>> getCurrencies() async {
  Dio dio = Dio();

  var response = await dio.get("$host/v3/currencies", options: Options(headers: {"apiKey": apiKey}));


  List<Currency> currencies = [];
  response.data["data"].forEach((_, currency) {
    currencies.add(Currency(symbol: currency["symbol"], name: currency["name"], code: currency["code"]));
  });

  return currencies;
}

Future<double> getExchange(String baseCode, String targetCode) async {
  Dio dio = Dio();

  var response = await dio.get("$host/v3/latest?base_currency=$baseCode&currencies=$targetCode", options: Options(headers: {"apiKey": apiKey}));


  return response.data["data"][targetCode]["value"];
}


