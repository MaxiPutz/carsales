import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

class AppData {
  var ref = firebase_storage.FirebaseStorage.instance
      .refFromURL('gs://carsales-18b1c.appspot.com/');
  var refNoSql = FirebaseFirestore.instance;

  List<Car> initData = [];

  Future<List<Car>> getInitdata() async {
    if (initData.isNotEmpty){
      return initData;
    }
    var user = (await refNoSql.collectionGroup('init').get())
        .docs
        .map((e) => e.data())
        .toList();
    print(user);

    this.initData = user
        .map((e) => Car(
            name: e['name'],
            brand: e['brand'],
            fuel: e['fuel'],
            ps: e['ps'],
            id: e['id']))
        .toList();

    print(user);

    return this.initData;
  }

  Future<Image?> getAvatar(Car car) async {
    if (car.avatar != null){
      return car.avatar;
    }
    var uri = await ref.child('images').child(car.id).child('avatar.png').getDownloadURL();
    car.avatar = Image.network(uri);
    return car.avatar;
  }

  Future<List<Image>> getPicFromGallery(Car car)async {
    if (car.pics.isNotEmpty){
      return car.pics;
    }
    var arr = await ref.child('images').child(car.id).child('gallery')
        .listAll();

    List<String> uris = [];
    //= arr.items.map((element) async => (await element.getDownloadURL())).toList();

    for (var ele in arr.items){
      uris.add(await ele.getDownloadURL());
    }

    car.pics.addAll(uris.map((e) => Image.network(e)));
    return car.pics;
  }


  void uploadCarInformation (Car car, List<Uint8List> images) async {
    var temp = await this.refNoSql.collection('init').where('id', isEqualTo: car.id).get();
    print (temp.metadata );
  }

  void uploadInitElement(Car car, Uint8List data) async {
    this.refNoSql.collection('init').add(car.toMap());
    this.initData.add(car);
    car.avatar = Image.memory(data);
    this.ref.child('images').child(car.id).child('avatar.png').putData(data);
  }

  void uploadGallery (Car car, List<Uint8List> picsBytes) {
    for (var index=0; index<picsBytes.length; index++){
      var bytes = picsBytes[index];
      this.ref
          .child('images')
          .child(car.id)
          .child('gallery').child(index.toString() + '.png').putData(bytes);
    }
  }


  void updateDescription(Car car) async {
    var description = car.description;
    var temp = await  this.refNoSql.collection('init').where('id', isEqualTo: car.id).get();

    print (temp.docs.first.id );
    var temp2 = await this.refNoSql.collection('init').doc(temp.docs.first.id).update(
        {
          'description': description
        }
    );


    this.initData.where((ele) => ele.id == car.id).first.description = description;
    this.initData.forEach((element) => print(element.description));
  }
}

class Car {
  late String name;
  late String brand;
  late String fuel;
  late String ps;
  late String id;
  Image? avatar;
  late String description;
  late List<Image> pics;
  late List<Uint8List> picsBytes;

  Car(
      {String? id,
      String? ps,
      String? fuel,
      String? brand,
      required String name}) {
    this.name = name;
    this.brand = (brand == null) ? '' : brand;
    this.fuel = (fuel == null) ? '' : fuel;
    this.ps = (ps == null) ? '' : ps;
    this.id = (id == null) ? Uuid().v1() : id;
    this.pics = [];
    this.description = '';
    this.picsBytes = [];
  }



  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map.addAll({
      "name": this.name,
      'brand': this.brand,
      'ps': this.ps,
      'fuel': this.fuel,
      'id': this.id
    });
    return map;
  }
}
