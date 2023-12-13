import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '83979A83-EF22-4BFF-AB8A-F85F6EF38D07';

class CoinData {
  // Asynchronous method that returns a Future (the price data).
  Future getCoinData() async {
    // Create the url by combining the coinAPIURL with the currencies
    String requestURL = '$coinAPIURL/BTC/USD?apikey=$apiKey';

    // Convert the string URL to a Uri object
    Uri uri = Uri.parse(requestURL);

    // Make a GET request to the URL and wait for the response
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      // decode the JSON data that comes back from coinapi.io
      var decodedData = jsonDecode(response.body);
      // Get the last price of bitcoin with the key 'rate'
      var lastPrice = decodedData['rate'];

      return lastPrice;
    } else {
      // Handle any errors that occur during the request
      print(response.statusCode);
      // Throw an error if our request fails
      throw 'Problem with the get request';
    }
  }
}
