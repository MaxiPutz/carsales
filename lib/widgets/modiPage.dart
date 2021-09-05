
import 'dart:typed_data';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:carsales/bloc/appBloc.dart';
import 'package:carsales/bloc/appEvent.dart';
import 'package:carsales/bloc/appState.dart';
import 'package:carsales/objects/dataBase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ModiPage extends StatelessWidget {
  late Car car;
  late List<Uint8List> listBytes;
  ModiPage(this.car);

  @override
  Widget build(BuildContext context) {
    Widget avatar = ((this.car.avatar != null) ? this.car.avatar : CircularProgressIndicator())!;
    this.listBytes = [];
    this.listBytes.addAll(this.car.picsBytes);
    context.read<AppBloc>().add(AddEventInitModiPage(this.car));


    return BlocBuilder<AppBloc, AppState>(
        builder: (context, AppState appState) {

          if (appState is AppStateInitModiPage){

          }

          if (appState is AppStateShowPickedImages) {
            appState.img_bytes.forEach((element) {
              car.pics.add(Image.memory(element));
            });
            listBytes.addAll(appState.img_bytes);
            appState.img_bytes = [];
          }



          return Scaffold(
            appBar: AppBar(
              title: Text('modi page')
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Hero(
                      tag: this.car.id,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: car.avatar,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Gallery(this.car.pics.map((e) => e as Widget).toList(), car),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white10,
                          hintText: "Hier ist Platz für eine Beschreibung",
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
            // persistentFooterButtons: [
            //   ElevatedButton(onPressed: () {  }, child: Text('load images'),
            //
            //   )
            // ],
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                context.read<AppBloc>().add(AppEventUploadGalleryAndDiscription(this.car, this.listBytes));
              },
              child: Icon(Icons.add_to_photos),
            ),
          );
        });
  }
}


class Gallery extends StatelessWidget {
  late List<Widget> images;
  late Car car;
  List<Uint8List>? imgs_bytes;
  Gallery(this.images, this.car);
  @override
  Widget build(BuildContext context) {
    images.add(
      ElevatedButton(
          onPressed: () async {
            var result = await FilePicker.platform.pickFiles(allowMultiple: true);
            if (result == null) return;
            var files = result.files.map((e) => e.bytes!).toList();

            context.read<AppBloc>().add(AppEventModeShowImages(files));
          },
          child: Icon(Icons.image)
      )
    );
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
                  (context, int i) {
                return this.images[i];
              },
              childCount: this.images.length
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,

          ),
        )
      ],
    );
  }
}


