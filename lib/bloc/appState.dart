

import 'dart:typed_data';

import 'package:carsales/objects/dataBase.dart';

class AppState {}

class AppStateInit extends AppState{}
class AppStateUploadWidget extends AppState{}

class AppStateUpdateAvatars extends AppState{
  late List<Car> cars;
  AppStateUpdateAvatars(this.cars);
}

class AppStateInitFinished extends AppState {
  late List<Car> cars;
  AppStateInitFinished(this.cars);
}

class AppStateUploadPage extends AppState{}
class AppStateUploadPagePickedImage extends AppState{
  late Uint8List img;
  AppStateUploadPagePickedImage(this.img);
}

class AppStateShowPickedImages extends AppState {
  late List<Uint8List> img_bytes;
  AppStateShowPickedImages(this.img_bytes);
}
class AppStateInitModiPage extends AppState {}

