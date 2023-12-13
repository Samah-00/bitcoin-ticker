import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

import 'package:bitcoin_api/crypto_card.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String bitcoinValueInUSD = '?';
  // Map to store the values of all three cryptocurrencies
  Map<String, String> coinValues = {};
  // A variable to keep track of when we're waiting on the request to complete.
  bool isWaiting = false;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          // Save the selected currency to the property selectedCurrency
          selectedCurrency = value!;
          // Call getData() when the picker/dropdown changes
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          // Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          // Call getData() when the picker/dropdown changes
          getData();
        });
      },
      children: pickerItems,
    );
  }

   Column makeCards() {
   List<CryptoCard> cryptoCards = [];
   for (String crypto in cryptoList) {
     cryptoCards.add(
       CryptoCard(
         cryptoCurrency: crypto,
         selectedCurrency: selectedCurrency,
         value: isWaiting ? '?' : coinValues[crypto] ?? 'N/A',
       ),
     );
   }
   return Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: cryptoCards,
   );
 }

  // Async method that awaits the coin data from coin_data.dart
  void getData() async {
    isWaiting = true;
    try {
      Map<String, String> data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
