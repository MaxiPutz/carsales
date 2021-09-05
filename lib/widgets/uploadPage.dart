import 'dart:typed_data';

import 'package:carsales/bloc/appBloc.dart';
import 'package:carsales/bloc/appEvent.dart';
import 'package:carsales/bloc/appState.dart';
import 'package:carsales/objects/dataBase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class UploadPage extends StatelessWidget {
  final  name = TextEditingController();
  final brand = TextEditingController();
  final fuel = TextEditingController();
  final ps = TextEditingController();

  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, AppState appState) {

        // init
        Widget image = ElevatedButton(
          onPressed: () async {
            var image = ImagePicker();
            var pickImage = await image.pickImage(source: ImageSource.gallery, imageQuality: 10);
            var bytes = await pickImage!.readAsBytes();
            this.bytes = bytes;
            context.read<AppBloc>().add(AppEventUploadPagePickImage(bytes));
          },
          child: Icon(Icons.add_a_photo),
        );

        if (appState is AppStateUploadPagePickedImage){
          image = Image.memory(appState.img);
        }



        return Scaffold(
          appBar: AppBar(
            title: Text('Upload form'),
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: image,
                  )
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: this.name,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: this.brand,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Marke',
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 20),
                          TextFormField(
                            controller: this.fuel,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Treibstoff',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: this.ps,
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'PS',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (this.bytes == null) {
                print(this.name);

                print(this.name.value.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Es ist kein Bild ausgewählt.')),
                );
                return;
              }
              var car = Car(
                  name: this.name.value.text,
                  ps: this.ps.value.text,
                  fuel: this.fuel.value.text,
                  brand: this.brand.value.text
              );

              car.avatar  = Image.memory(this.bytes!);
              context.read<AppBloc>().add(AppEventUploadCar(car, this.bytes!));
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class TextFromField {
}