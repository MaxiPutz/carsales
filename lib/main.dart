import 'dart:io';
import 'package:carsales/bloc/appBloc.dart';
import 'package:carsales/bloc/appEvent.dart';
import 'package:carsales/bloc/appState.dart';
import 'package:carsales/objects/dataBase.dart';
import 'package:carsales/widgets/cardWidget.dart';
import 'package:carsales/widgets/uploadButton.dart';
import 'package:carsales/widgets/uploadPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase/firebase.dart' as fb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  Bloc.observer = BlocObserver();
  AppData().getInitdata();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (BuildContext context) => AppBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Widget img = Text("show img");
  late List<Car> cars;


  Widget myCardList (List<Car> cars) {
    var temp = cars.map((e) => CardWidget(e)).toList();

    return CustomScrollView(
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
              (context, int i) {
                return temp[i];
              },
            childCount: temp.length
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    context.read<AppBloc>().add(AppEventInit());
    var isInit = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('car sales'),
      ),
      body: BlocBuilder<AppBloc, AppState> (
        builder: (context, AppState appState) {
          print('bloc');
          if (appState is AppStateInit){
            print('init00');
            context.read<AppBloc>().add(AppEventUpdateAvatar());
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (appState is AppStateUpdateAvatars) {
            this.cars = appState.cars;
            return myCardList(appState.cars);
          }else if (appState is AppStateInitFinished) {
            this.cars = appState.cars;
            print('appstate finished');
            isInit = true;
            return myCardList(appState.cars);
          } else if (appState is AppStateUploadWidget) {
            return UploadPage();
          } else if (appState is AppStateUploadPagePickedImage) {
            return myCardList(this.cars);
          }

          if (isInit) {
            return myCardList(this.cars);
          }else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: UploadButton(),
    );
    
   



  /*
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            img,
            ElevatedButton(
                onPressed: () async {
                  // var ref = firebase_storage.FirebaseStorage.instance
                  //     .ref("images/download.jpeg");

                  // gs://carsales-18b1c.appspot.com/images/download.jpeg
                  var ref = firebase_storage.FirebaseStorage.instance
                      .refFromURL('gs://carsales-18b1c.appspot.com/')
                      .child('images/corsa');

                  var uri = await ref.getDownloadURL();

                  var file = Image.network(uri.toString());

                  // var data = await ref.getData();
                  // Image file = await Image.memory(data!);

                  setState(() {
                    this.img = file;
                  });
                },
                child: Text("Show Img in Storage")),
          ],
        ),
      ),
      floatingActionButton: UploadButton()
      // FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );

   */
  }
  void _incrementCounter() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    AppData().uploadInitElement(
        Car(name: 'corsa', brand: 'opel'), result.files.first.bytes!);

    // var result = await FilePicker.platform.pickFiles(allowMultiple: false);
    // if (result == null) return;
    //
    // var ref = firebase_storage.FirebaseStorage.instance
    //     .refFromURL('gs://carsales-18b1c.appspot.com/')
    //     .child('images/corsa');

    // // var ref = firebase_storage.FirebaseStorage.instance.ref("images/corsa");

    // ref.putData(result.files.first.bytes!);
    // // CollectionReference users = FirebaseFirestore.instance.collection("users");

    // // var file = await this
    // //     ._fileFromImageUrl("https://i.auto-bild.de/mdb/large/12/c-c04.jpeg");

    // // print("test");

    // // users.add({"full_name": "max", "company": "voxi", "file": file}).then(
    // //     (value) {
    // //   print(value);
    // // }).catchError((err) => print(err));

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<Object> _fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse((url)));

    // final documentDirectory = await getApplicationDocumentsDirectory();

    // final file = File(path.join(documentDirectory.path, 'imagetest.jpeg'));

    // file.writeAsBytesSync(response.bodyBytes);

    return response.bodyBytes;
  }
}
