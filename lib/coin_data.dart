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
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    // Loop through the cryptoList and request the data for each of them in turn
    for (String crypto in cryptoList) {
      // Create the url by combining the coinAPIURL with the currency and crypto
      String requestURL = '$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey';
      // Convert the string URL to a Uri object
      Uri uri = Uri.parse(requestURL);
      // Make a GET request to the URL and wait for the response
      http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        // Create a new key value pair with the key being the crypto symbol
        // and the value being the lastPrice of that crypto currency
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        // Handle any errors that occur during the request
        print(response.statusCode);
        // Throw an error if our request fails
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
