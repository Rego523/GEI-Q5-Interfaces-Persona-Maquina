import 'dart:convert';
import '../server_stub.dart' as stub;
import 'package:http/http.dart' as http;


Future<List<double>> fetchData(String conversions) async {
  var uri = Uri(
    scheme: 'https',
    host: 'fcsapi.com',
    path: "/api-v3/forex/latest",
    queryParameters: {
      'symbol': conversions,
      'access_key': 'xLDcq9CUnMhPZl3t4pMMpZa8x',
    },
  );
  //var response = await http.get(uri);
  var response = await stub.get(uri);
  var dataAsDartMap = jsonDecode(response.body);

  if (dataAsDartMap['msg'] == 'Successfully') {
    List<dynamic> responseData = dataAsDartMap['response'];
    List<double> valuesList = [];

    for (var entry in responseData) {
      var value = double.tryParse(entry['c'].toString());
      if (value != null) {
        valuesList.add(value);
      }
    }

    //print(valuesList);
    return valuesList;
  } else {
    print('Error en la respuesta: ${dataAsDartMap['msg']}');
    return [];
  }
}


Future<List<String>> getAvailableCurrenciesNumber() async{
  List<String> currenciesList = await stub.getAvailableCurrenciesNumber(2);

  return currenciesList;
}