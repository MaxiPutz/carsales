import 'dart:io';
import 'package:carsales/widgets/uploadPage.dart';
import 'package:provider/provider.dart';
import 'package:carsales/bloc/appBloc.dart';
import 'package:carsales/bloc/appEvent.dart';
import 'package:carsales/objects/dataBase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;

class UploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      onPressed: () {
        // context.read<AppBloc>().add(AppEventUploadWidget())
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadPage()),
        );
      }  ,
      child: Icon(Icons.upload_rounded),
    );
  }

  void upload() async{
    var image = ImagePicker();

    var pickImage = await image.pickImage(source: ImageSource.gallery, imageQuality: 10);
    var bytes = await pickImage!.readAsBytes();

    var temp = Image.memory(bytes);

    AppData().uploadInitElement(Car(name: 'care'),  bytes ) ;
  }
}
