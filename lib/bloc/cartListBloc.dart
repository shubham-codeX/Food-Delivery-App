import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:food_delivery/bloc/provider.dart';
import 'package:food_delivery/model/foodItem.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class CartListBloc extends BlocBase {
  // Stream<int> counter; // observable (Stream)

  CartListBloc();
  var _listController = BehaviorSubject<List<FoodItem>>.seeded([]);
  CartProvider provider = CartProvider();
  //output
  Stream<List<FoodItem>> get listStream => _listController.stream;
  //input
  Sink<List<FoodItem>> get listSink => _listController.sink;

  //Business Logic
  addToList(FoodItem foodItem) {
    listSink.add(provider.addToList(foodItem));
  }

  removeFromList(FoodItem foodItem) {
    listSink.add(provider.removeFromList(foodItem));
  }

  @override
  void dispose() {
    // will be called automatically
    _listController.close();
    super.dispose();
  }
}
