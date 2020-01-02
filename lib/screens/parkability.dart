// import 'package:cparking491/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../provider/report.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:numberpicker/numberpicker.dart';

//provider
import '../provider/report_provider.dart';
import 'package:provider/provider.dart';
import '../provider/parkingLotProvider.dart';

class Parkability extends StatefulWidget {
  static const routeName = '/park-ability';

  @override
  _ParkabilityState createState() => _ParkabilityState();
}

class _ParkabilityState extends State<Parkability> {
  var _editReport = Report(
    id: null,
    userName: '',
    lifeTime: 0,
    imageUrl: '',
  );

  File _image;
  String _uploadedFileURL;

  final _form = GlobalKey<FormState>();

  final _imageUrlFocusNode = FocusNode();

  final _lifeTimeFocusNode = FocusNode();

  var _isLoading = false;
  var _isUploadImage = false;

  int _currentValue = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState

    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _lifeTimeFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm(context) {
    final _isValid = _form.currentState.validate();

    if (!_isValid) {
      return;
    }

    _form.currentState.save();
    Provider.of<ReportsProvider>(context, listen: false).addReport(_editReport);
    Navigator.of(context).pop();
  }

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = _image;
    });
  }

  Future uploadFile(context, name) async {
    final snackBar = SnackBar(
      content: Text('Upload image complete'),
      duration: Duration(
        seconds: 1,
      ),
    );

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reports/${name}/${basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    setState(() {
      _isLoading = true;
    });
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
        _isLoading = false;
        _isUploadImage = true;
      });
    });
    // Navigator.of(context).pop();
    // Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context).settings.arguments as String;
    final parkingInfo =
        Provider.of<ParkingLotProvider>(context, listen: false).findById(name);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_isUploadImage) {
                _saveForm(context);
              }
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  'https://www.jll.co.th/content/dam/jll-com/images/global/hong-kongs-pricey-parking-spaces-carpark-HK-reszied-teaser.jpg.rendition/cq5dam.web.1280.1280.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null
                            ? Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.all(10),
                                child: new FloatingActionButton(
                                  elevation: 0,
                                  backgroundColor: Colors.grey,
                                  onPressed: getImage,
                                  tooltip: 'Add Image',
                                  child: new Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                        ),
                                        height: 200,
                                        width: 200,
                                        child: _uploadedFileURL != null
                                            ? Image.network(_uploadedFileURL)
                                            : Image.file(_image),
                                      ),
                                      _isLoading
                                          ? Padding(
                                              padding: EdgeInsets.all(10),
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FloatingActionButton(
                                                tooltip: "upload new image",
                                                onPressed: getImage,
                                                child: Icon(Icons.photo),
                                              ),
                                            ),
                                      RaisedButton(
                                        child: Text("Submit"),
                                        color: Color(0xff476cfb),
                                        onPressed: () {
                                          print("Uploading image");
                                          uploadFile(context, name);
                                        },
                                      ),
                                    ]),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Parkability: $_currentValue",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: NumberPicker.integer(
                      initialValue: _currentValue,
                      minValue: 0,
                      maxValue: int.parse(
                        parkingInfo.max.toStringAsFixed(0),
                      ),
                      onChanged: (newValue) =>
                          setState(() => _currentValue = newValue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
