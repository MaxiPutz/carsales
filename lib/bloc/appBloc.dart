import 'dart:js';

import 'package:carsales/bloc/appEvent.dart';
import 'package:carsales/objects/dataBase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appState.dart';



class AppBloc extends Bloc<AppEvent, AppState> {
  late AppData appData;
  AppBloc() : super(AppState());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    print('test');
    print(event is AppEventUploadCar);
    if (event is AppEventInit){
      print('init');
      await this._initApp();
      yield AppStateInit();
    } else
    if (event is AppEventUpdateAvatar){
      print('update');
      for (var ele in this.appData.initData){
        await this.appData.getAvatar(ele);
        yield AppStateUpdateAvatars(appData.initData);
      }
      yield AppStateInitFinished(appData.initData);
    } else if (event is AppEventUploadPagePickImage){
      print('AppEventUploadPagePickImagererere');
      yield AppStateUploadPagePickedImage(event.pickedImage);
    } else if (event is AppEventUploadCar) {
      print('AppEventUploadCar');
      appData.uploadInitElement(event.car, event.bytes);
      yield AppStateInitFinished(appData.initData);
    } else if (event is AppEventModePagePickImage) {
      appData.updateDescription(event.car);
    } else if (event is AppEventModeShowImages) {
      yield AppStateShowPickedImages(event.img_bytes);
    } else if (event is AppEventUploadGalleryAndDiscription) {
      appData.uploadGallery(event.car, event.images_bytes);
      appData.updateDescription(event.car);
      yield AppStateShowPickedImages(event.car.picsBytes);
    }else if (event is AddEventInitModiPage){
      await appData.getPicFromGallery(event.car);
      yield AppStateInitModiPage();
    }



    else {
      yield AppState();
    }
  }

  void _updateAvatar(){

  }

  Future<void> _initApp()async{
    this.appData = AppData();
    await appData.getInitdata();
    return;
  }
}