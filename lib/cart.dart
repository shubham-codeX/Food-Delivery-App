import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery/bloc/cartListBloc.dart';
import 'package:food_delivery/bloc/listStyleColorBloc.dart';
import 'package:food_delivery/bloc/provider.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:food_delivery/model/foodItem.dart';

class Cart extends StatelessWidget {
  // const Cart({super.key});
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    List<FoodItem> foodItems;

    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          foodItems = snapshot.data ?? [];
          return Scaffold(
            body: SafeArea(
              child: Container(
                child: CartBody(foodItems),
              ),
            ),
            bottomNavigationBar: BottomBar(foodItems),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BottomBar extends StatelessWidget {
  // const BottomBar({super.key});
  final List<FoodItem> foodItems;
  BottomBar(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          totalAmount(foodItems),
          Divider(
            height: 1,
            color: Colors.grey[700],
          ),
          persons(),
          nextButtonBar(),
        ],
      ),
    );
  }

  Container nextButtonBar() {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color(0xfffeb324),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "15 - 25 min",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          Text(
            "Next",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          )
        ],
      ),
    );
  }

  Container persons() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: <Widget>[
          Text(
            "Persons",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          CustomPersonWidget()
        ],
      ),
    );
  }

  Container totalAmount(List<FoodItem> foodItem) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Total: ",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
          ),
          Text(
            "\$${returnTotalAmount(foodItems)}",
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800]),
          )
        ],
      ),
    );
  }

  String returnTotalAmount(List<FoodItem> foodItems) {
    double totalAmount = 0.0;
    for (int i = 0; i < foodItems.length; i++) {
      totalAmount = totalAmount + foodItems[i].price * foodItems[i].quantity;
    }
    return totalAmount.toStringAsFixed(2);
  }
}

class CustomPersonWidget extends StatefulWidget {
  // const CustomPersonWidget({super.key});

  @override
  State<CustomPersonWidget> createState() => _CustomPersonWidgetState();
}

class _CustomPersonWidgetState extends State<CustomPersonWidget> {
  int noOfPersons = 1;
  double _buttonWidth = 30;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 280),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: TextButton(
              child: Text(
                "-",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                setState(() {
                  if (noOfPersons > 1) {
                    noOfPersons--;
                  }
                });
              },
            ),
          ),
          Text(
            noOfPersons.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: _buttonWidth,
            height: _buttonWidth,
            child: TextButton(
              child: Text(
                "+",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                setState(() {
                  if (noOfPersons >= 1) {
                    noOfPersons++;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartBody extends StatelessWidget {
  // const cartBody({super.key});
  final List<FoodItem> foodItems;

  CartBody(this.foodItems);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          title(),
          Expanded(
            flex: 1,
            child: foodItems.length > 0 ? foodItemList() : noItemContainer(),
          )
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text(
          "No more item added in cart",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20),
        ),
      ),
    );
  }

  ListView foodItemList() {
    return ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (builder, index) {
          return CartListItem(foodItem: foodItems[index]);
        });
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "My",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                ),
              ),
              Text(
                "Order",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  // const CartListItem({super.key});
  final FoodItem foodItem;

  CartListItem({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: foodItem,
        maxSimultaneousDrags: 1,
        child: DraggableChild(foodItem: foodItem),
        feedback: DraggableChildFeedback(foodItem: foodItem),
        childWhenDragging: foodItem.quantity > 1
            ? DraggableChild(foodItem: foodItem)
            : Container());
  }
}

class DraggableChild extends StatelessWidget {
  const DraggableChild({
    super.key,
    required this.foodItem,
  });

  final FoodItem foodItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(
        foodItem: foodItem,
      ),
    );
  }
}

class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    super.key,
    required this.foodItem,
  });

  final FoodItem foodItem;
  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return Opacity(
      opacity: 0.6,
      child: Material(
        child: StreamBuilder<Object>(
            stream: colorBloc.colorStream,
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.only(bottom: 25),
                child: ItemContent(foodItem: foodItem),
                decoration: BoxDecoration(
                    color: snapshot.data as Color? ?? Colors.white),
              );
            }),
      ),
    );
  }
}

class ItemContent extends StatelessWidget {
  // const ItemContent({super.key});
  final FoodItem foodItem;
  ItemContent({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              foodItem.imgURL,
              fit: BoxFit.fitHeight,
              height: 55,
              width: 80,
            ),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(text: foodItem.quantity.toString()),
                  TextSpan(text: ' x '),
                  TextSpan(text: foodItem.title)
                ]),
          ),
          Text(
            "\$${foodItem.quantity * foodItem.price}",
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  // const CustomAppBar({super.key});
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        DragTargetWidget(),
      ],
    );
  }
}

class DragTargetWidget extends StatefulWidget {
  const DragTargetWidget({super.key});

  @override
  State<DragTargetWidget> createState() => _DragTargetWidgetState();
}

class _DragTargetWidgetState extends State<DragTargetWidget> {
  final CartListBloc listBloc = BlocProvider.getBloc<CartListBloc>();
  final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();
  @override
  Widget build(BuildContext context) {
    return DragTarget<FoodItem>(
      onWillAcceptWithDetails: (foodItem) {
        colorBloc.setColor(Colors.red);
        return true;
      },
      onAcceptWithDetails: (foodItem) {
        listBloc.removeFromList(foodItem.data);
        colorBloc.setColor(Colors.white);
      },
      onLeave: (foodItem) {
        colorBloc.setColor(Colors.white);
      },
      builder: (context, incoming, rejected) {
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            CupertinoIcons.delete,
            size: 35,
          ),
        );
      },
    );
  }
}
