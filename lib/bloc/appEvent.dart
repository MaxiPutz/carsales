import 'dart:typed_data';

import 'package:carsales/objects/dataBase.dart';
import 'package:flutter/cupertino.dart';

abstract class AppEvent{}

class AppEventInit extends AppEvent{}
class AppEventFireBase extends AppEvent{}
class AppEventUpdateAvatar extends AppEvent{}
class AppEventUploadCar extends AppEvent{
  late Car car;
  late Uint8List bytes;
  AppEventUploadCar(this.car, this.bytes);
}
class AppEventUploadPagePickImage extends AppEvent{
  late Uint8List pickedImage;
  AppEventUploadPagePickImage(this.pickedImage);
}

class AppEventModePagePickImage extends AppEvent {
  late Car car;
  late String description;
  AppEventModePagePickImage(this.car, this.description);
}

class AppEventModeShowImages extends AppEvent {
  late List<Uint8List> img_bytes;
  AppEventModeShowImages(this.img_bytes);
}

class AppEventUploadGalleryAndDiscription extends AppEvent {
  late Car car;
  late List<Uint8List> images_bytes;
  AppEventUploadGalleryAndDiscription(this.car, this.images_bytes);
}

class AddEventInitModiPage extends AppEvent {
  late Car car;
  AddEventInitModiPage(this.car);
}