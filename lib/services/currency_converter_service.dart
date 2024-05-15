import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CurrencyConverter{
  CurrencyConverter();

  Future<double> getConvert(String fromCurrencyCode, String toCurrencyCode, double amount) async {
    final Uri apiURL = Uri.parse('https://api.exchangeratesapi.net/v1/exchange-rates/convert?access_key=${dotenv.env["CONVERTER_API_KEY"]}&from=$fromCurrencyCode&to=$toCurrencyCode&amount=$amount');
    http.Response res = await http.get(apiURL);
    double result = 0;
    if(res.statusCode == 200){
      final body = jsonDecode(res.body);
      result = body['result'];
    }
    return result;
  }

  Future<double> getRate(String fromCurrencyCode, String toCurrencyCode) async {
    final Uri apiURL = Uri.parse('https://api.exchangeratesapi.net/v1/exchange-rates/latest?access_key=${dotenv.env["CONVERTER_API_KEY"]}&base=$fromCurrencyCode&currency_codes=$toCurrencyCode');
    http.Response res = await http.get(apiURL);
    double result = 0;
    if(res.statusCode == 200){
      final body = jsonDecode(res.body);
      result = body['rates'][toCurrencyCode];
    }
    return result;
  }
}