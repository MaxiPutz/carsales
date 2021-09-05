import 'dart:js';

import 'package:carsales/objects/dataBase.dart';
import 'package:carsales/widgets/modiPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  late Car car;
  CardWidget(this.car);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ModiPage(this.car))),
      child: Card(
        child: Container(
          child: Column(
            children: [
              ListTile(
                leading: Text(this.car.name),
                title: Text(this.car.brand),
                subtitle: Text(this.car.fuel)
              ),
              AspectRatio(aspectRatio: 3,
                child: Hero(
                  tag: this.car.id,
                  child: Container(
                      child: (this.car.avatar != null) ? this.car.avatar : CircularProgressIndicator()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}