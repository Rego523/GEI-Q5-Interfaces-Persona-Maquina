import 'package:flutter/material.dart';
import '../model/model.dart' as model;

class CurrencyProvider extends ChangeNotifier {
  List<String> _currencies = [];
  List<double> _conversions = [];
  double _inputValue = 0;

  CurrencyProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    try {
      List<String> currencies = await model.getAvailableCurrenciesNumber();
      currenciesList = currencies;
    } catch (error) {
      print('Error loading currencies: $error');
    }
  }

  Future<void> loadConversions() async {
    try {
      List<double> conversions = await model.fetchData(getCurrencyPairsString());
      print(conversions);
      conversionsList = conversions;
    } catch (error) {
      print('Error loading conversions: $error');
    }
  }

  void resetConversionsToZero() {
    _conversions = List.filled(_conversions.length, 0);
    notifyListeners();
  }

  void setConversionAtIndex(int index, double value) {
    if (index >= 0 && index < _conversions.length) {
      _conversions[index] = value;
      notifyListeners();
    }
  }

  // Getter para obtener toda la lista de monedas
  List<String> get currenciesList => _currencies;

  // Getter para obtener un elemento en concreto dado un índice
  String getCurrencyAtIndex(int index) {
    if (index >= 0 && index < _currencies.length) {
      return _currencies[index];
    } else {
      //CAMBIAR
      return 'Press + to add new currency';
    }
  }

  // Setter para actualizar toda la lista de monedas
  set currenciesList(List<String> currencies) {
    _currencies = currencies;
    notifyListeners();
  }

  set conversionsList(List<double> conversions) {
    _conversions = conversions;
    notifyListeners();
  }

  set inputValue(double input){
    _inputValue = input;
    notifyListeners();
  }

  double getInputValue(){
    return _inputValue;
  }


  // Función para añadir un nuevo elemento a la lista de monedas
  void addCurrency(String newCurrency) {
    if (!_currencies.contains(newCurrency)) {
      _currencies.add(newCurrency);
      resetConversionsToZero();
      notifyListeners();
    } else {
    }
  }

  void removeCurrency(int index) {
    if (_currencies.length > 2 && index >= 0 && index < _currencies.length) {
      _currencies.removeAt(index);
      resetConversionsToZero();
      notifyListeners();
    }
  }

  void updateCurrency(int index, String updatedCurrency) {
    if (index >= 0 && index < _currencies.length) {
      // Verificar si updatedCurrency ya está en la lista
      int updatedIndex = _currencies.indexOf(updatedCurrency);

      if (updatedIndex >= 0) {
        // Intercambiar las posiciones de los elementos
        String temp = _currencies[index];
        _currencies[index] = _currencies[updatedIndex];
        _currencies[updatedIndex] = temp;

        resetConversionsToZero();

        notifyListeners();
      } else {
        // Si updatedCurrency no está en la lista,actualizar el elemento en la posición dada
        _currencies[index] = updatedCurrency;

        resetConversionsToZero();

        notifyListeners();
      }
    }
  }


  String getCurrencyPairsString() {
    if (_currencies.length < 2) {
      return '';
    }
    return _currencies.sublist(1).map((currency) => '${_currencies.first}/$currency').join(',');
  }

  double getConversionAtIndex(int index) {
    if (index >= 0 && index < _conversions.length) {
      return _conversions[index];
    } else {
      return 0;
    }
  }



}

