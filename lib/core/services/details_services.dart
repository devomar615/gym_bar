import 'package:flutter/material.dart';class DetailsServices extends ChangeNotifier {  Color _backgroundColor;  Color get backgroundColor => _backgroundColor;  set backgroundColor(Color value) {    _backgroundColor = value;    notifyListeners();  }}