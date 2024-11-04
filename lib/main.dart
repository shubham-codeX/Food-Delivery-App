import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:food_delivery/bloc/cartListBloc.dart';
import 'package:food_delivery/bloc/listStyleColorBloc.dart';
import 'package:food_delivery/bloc/provider.dart';
import 'package:food_delivery/model/foodItem.dart';
import 'cart.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [Bloc((i) => CartListBloc()), Bloc((i) => ColorBloc())],
      dependencies: [], // add any dependencies if needed
      child: MaterialApp(
        title: "Food Delivery",
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              FirstHalf(),
              SizedBox(height: 45),
              for (var foodItem in fooditemList.foodItems)
                ItemContainer(foodItem: foodItem)
            ],
          ),
        ),
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  // const ItemContainer({super.key});
  final FoodItem foodItem;
  ItemContainer({required this.foodItem});

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToCart(foodItem);

        final snackbar = SnackBar(
          content: Text("${foodItem.title} added to the cart"),
          duration: Duration(milliseconds: 550),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      child: Items(
          hotel: foodItem.hotel,
          itemName: foodItem.title,
          itemPrice: foodItem.price,
          imgUrl: foodItem.imgURL,
          leftAligned: (foodItem.id % 2 == 0) ? true : false),
    );
  }
}

class Items extends StatelessWidget {
  // const Items({super.key});
  Items({
    required this.leftAligned,
    required this.hotel,
    required this.itemName,
    required this.imgUrl,
    required this.itemPrice,
  });
  final bool leftAligned;
  final String imgUrl;
  final String itemName;
  final String hotel;
  final double itemPrice;

  @override
  Widget build(BuildContext context) {
    double ContainerPadding = 45;
    double containerBorderRadius = 10;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : ContainerPadding,
            right: leftAligned ? ContainerPadding : 0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: leftAligned
                        ? Radius.circular(0)
                        : Radius.circular(containerBorderRadius),
                    right: leftAligned
                        ? Radius.circular(containerBorderRadius)
                        : Radius.circular(0),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: leftAligned ? 20 : 0,
                  right: leftAligned ? 0 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          itemName,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        )),
                        Text("\$$itemPrice",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18))
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black45, fontSize: 15),
                            children: [
                              TextSpan(text: "by "),
                              TextSpan(
                                  text: hotel,
                                  style: TextStyle(fontWeight: FontWeight.w700))
                            ]),
                      ),
                    ),
                    SizedBox(height: ContainerPadding)
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class FirstHalf extends StatelessWidget {
  const FirstHalf({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          SizedBox(height: 30),
          title(),
          SizedBox(height: 30),
          searchBar(),
          SizedBox(
            height: 30,
          ),
          categories(),
        ],
      ),
    );
  }

  Widget categories() {
    return Container(
      height: 185,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryListItem(
            CategoryIcon: Icons.bug_report,
            CategoryName: "Burgers",
            availability: 12,
            selected: true,
          ),
          CategoryListItem(
            CategoryIcon: Icons.bug_report,
            CategoryName: "Pizza",
            availability: 12,
            selected: false,
          ),
          CategoryListItem(
            CategoryIcon: Icons.bug_report,
            CategoryName: "Rolls",
            availability: 12,
            selected: false,
          ),
          CategoryListItem(
            CategoryIcon: Icons.bug_report,
            CategoryName: "Fries",
            availability: 12,
            selected: false,
          ),
          CategoryListItem(
            CategoryIcon: Icons.bug_report,
            CategoryName: "Drink",
            availability: 12,
            selected: false,
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.search,
          color: Colors.black45,
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
            child: TextField(
          decoration: InputDecoration(
            hintText: "Search...",
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            hintStyle: TextStyle(color: Colors.black87),
          ),
        )),
      ],
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 45),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Food",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
            Text(
              "Delivery",
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 30),
            )
          ],
        )
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  // const CustomAppBar({super.key});

  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.menu),
          StreamBuilder(
            stream: bloc.listStream,
            builder: (context, snapshot) {
              List<FoodItem>? foodItems = snapshot.data ?? [];

              int length = foodItems != null ? foodItems.length : 0;
              return buildGestureDetector(length, context, foodItems);
            },
          )
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      int length, BuildContext context, List<FoodItem> foodItem) {
    return GestureDetector(
      onTap: () {
        if (length > 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 30),
        child: Text(length.toString()),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.yellow[800], borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}

class CategoryListItem extends StatelessWidget {
  final IconData CategoryIcon;
  final String CategoryName;
  final int availability;
  final bool selected;

  CategoryListItem({
    required this.CategoryIcon,
    required this.CategoryName,
    required this.availability,
    required this.selected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: selected ? Color(0xfffeb324) : Colors.white,
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : (Colors.grey[200] ?? Colors.grey),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 15,
                  offset: Offset(25, 0),
                  spreadRadius: 5)
            ]),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? Colors.transparent : Colors.grey,
                        width: 1.5)),
                child: Icon(
                  CategoryIcon,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                CategoryName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              )
            ]));
  }
}
