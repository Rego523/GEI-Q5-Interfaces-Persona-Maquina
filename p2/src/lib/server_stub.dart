import 'dart:async';

import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;


// Available currencies:
// EUR
// USD
// JPY
// DKK
// GBP
// SEK
// CHF
// NOK
// RUB
// TRY
// AUD
// BRL
// CAD
// CNY
// INR
// MXN
// ZAR

class StubResponse {
  final bool ok;
  final int statusCode;
  final String body;
  StubResponse(this.ok, this.statusCode, this.body);
}

// Constante para definir si se debe usar la API o el Stub
const bool useApi = false;


Future<StubResponse> get(Uri uri) async {
  print("-- Using stub server ---");

  // UNCOMMENT THIS LINE WHEN USING THE STUB IN A FLUTTER PROJECT
  var stringData = await rootBundle.loadString('assets/exchangeRates.json');

  // COMMENT THESE TWO LINES WHEN USING THE STUB
  //var file = File("assets/exchangeRates.json"); // COMMENT IN FLUTTER PROJECT
  //var stringData = await file.readAsString();   // COMENNT IN FLUTTER PROJECT


  var staticData = jsonDecode(stringData);


  var response = [];
  var symbolAsString = uri.queryParameters['symbol'];
  if (symbolAsString != null) {
    var symbolList = symbolAsString.split(",");
    for (var symbol in symbolList) {
      var currencies = symbol.split("/");
      var exchangeRates = staticData[currencies[0]];
      if (exchangeRates != null) {
        var data = exchangeRates["response"]
            .firstWhere((exchangeRate) => exchangeRate["s"] == symbol, orElse: () => {});
        if (data.isNotEmpty) {
          response.add(data);
        }
      }
    }
  }
  var body = {};
  if (response.isNotEmpty) {
    body = {
      "status": true,
      "code": 200,
      "msg": "Successfully",
      "response": response,
      "info": staticData["EUR"]["info"]
    };
  } else {
    body = {
      "status": false,
      "code": 113,
      "msg":
      "Sorry, Something wrong, or an invalid value. Please try again or check your required parameters.",
      "info": {"credit_count": 0}
    };
  }
  var rng = Random();
  return Future.delayed(Duration(seconds: rng.nextInt(5))).then((value) => StubResponse(true, 200, jsonEncode(body)));
}


Future<List<String>> getAvailableCurrenciesNumber(int numberOfCurrencies) async {
  if (useApi) {
    return await getAvailableCurrenciesNumberAPI(numberOfCurrencies);
  } else {
    return await getAvailableCurrenciesNumberStub(numberOfCurrencies);
  }
}

Future<List<String>> getAvailableCurrencies() async {
  if (useApi) {
    return await getAvailableCurrenciesAPI();
  } else {
    return await getAvailableCurrenciesStub();
  }
}

Future<List<String>> getAvailableCurrenciesNumberStub(int numberOfCurrencies) async {
  List<String> availableCurrencies = [];

  var stringData = await rootBundle.loadString('assets/exchangeRates.json');
  var staticData = jsonDecode(stringData);

  int count = 0;
  for (var currency in staticData.keys) {
    availableCurrencies.add(currency);
    count++;

    if (count == numberOfCurrencies) {
      break;
    }
  }

  print(availableCurrencies);
  return availableCurrencies;
}

Future<List<String>> getAvailableCurrenciesStub() async {
  List<String> availableCurrencies = [];

  var stringData = await rootBundle.loadString('assets/exchangeRates.json');
  var staticData = jsonDecode(stringData);

  for (var currency in staticData.keys) {
    availableCurrencies.add(currency);
  }
  return availableCurrencies;
}


Future<List<String>> getAvailableCurrenciesNumberAPI(int numberOfCurrencies) async {
  try {
    Map<String, dynamic> jsonData = await fetchDataFromApi();

    if (jsonData.containsKey('response') && jsonData['response'] is List) {
      Set<String> uniqueCurrencies = Set();

      for (var entry in jsonData['response']) {
        if (entry.containsKey('symbol')) {
          String currencyCode = entry['symbol'].split('/')[0];
          uniqueCurrencies.add(currencyCode);

          if (uniqueCurrencies.length >= numberOfCurrencies) {
            break;
          }
        }
      }

      return uniqueCurrencies.toList();
    } else {
      throw Exception('Invalid or missing "response" key in API data');
    }
  } catch (e) {
    print('$e');
    rethrow;
  }
}

Future<List<String>> getAvailableCurrenciesAPI() async {
  try {
    Map<String, dynamic> jsonData = await fetchDataFromApi();

    if (jsonData.containsKey('response') && jsonData['response'] is List) {
      Set<String> uniqueCurrencies = Set();

      for (var entry in jsonData['response']) {
        if (entry.containsKey('symbol')) {
          String currencyCode = entry['symbol'].split('/')[0];
          uniqueCurrencies.add(currencyCode);
        }
      }

      return uniqueCurrencies.toList();
    } else {
      throw Exception(jsonData);
    }
  } catch (e) {
    print('$e');
    rethrow;
  }
}

Future<Map<String, dynamic>> fetchDataFromApi() async {
  String apiUrl = 'https://fcsapi.com/api-v3/forex/list?type=forex&access_key=xLDcq9CUnMhPZl3t4pMMpZa8x';

  try {
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('code') && jsonData['code'] == 200) {
        return jsonData;
      } else if (jsonData.containsKey('msg')) {
        throw Exception('API error: ${jsonData['msg']}');
      } else {
        throw Exception('Invalid or missing "code" in API data');
      }
    } else {
      print("La excepción de código ha saltado");
      throw Exception('API error: ${response.statusCode}');
    }
  } catch (e) {
    if (e is http.ClientException) {
      throw Exception('No internet connection');
    } else {
      rethrow;
    }
  }
}

