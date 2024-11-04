import 'package:flutter/material.dart';

FooditemList fooditemList = FooditemList(foodItems: [
  FoodItem(
      id: 1,
      title: "BBQ Burger",
      hotel: "MC Donald",
      price: 301,
      imgURL: "assets/images/BBQ_Burger.jpg"),
  FoodItem(
    id: 2,
    title: "Kick Ass burger",
    hotel: "Dudleys",
    price: 101,
    imgURL: "/assets/images/kick_ass_burger.jpg",
  ),
  FoodItem(
    id: 3,
    title: "Perfect Crispy French Fries",
    hotel: "TinEats",
    price: 99,
    imgURL: "/assets/images/Perfect_French_fries.jpg",
  ),
  FoodItem(
    id: 4,
    title: "Pizza Burger",
    hotel: "Classic Burger zone",
    price: 199,
    imgURL: "/assets/images/Pizza_burger.jpg",
  ),
  FoodItem(
    id: 5,
    title: "Death By Cheese Pizza",
    hotel: "Curly Bread",
    price: 478,
    imgURL: "/assets/images/death_by_cheese.jpg",
  ),
  FoodItem(
    id: 6,
    title: "Virgin Mojito",
    hotel: "AlcoholFreeDrinks.nl",
    price: 549,
    imgURL: "/assets/images/virgin_mojito.jpg",
  ),
]);

class FooditemList {
  List<FoodItem> foodItems;

  FooditemList({required this.foodItems});
}

class FoodItem {
  int id;
  String title;
  String hotel;
  double price;
  String imgURL;
  int quantity;

  FoodItem(
      {required this.id,
      required this.title,
      required this.hotel,
      required this.price,
      required this.imgURL,
      this.quantity = 1});

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}
