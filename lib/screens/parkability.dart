// import 'package:cparking491/widgets/drawer.dart';
// import 'dart:html';

import 'package:provider/provider.dart';
import '../provider/report.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:transparent_image/transparent_image.dart';
import '../loader/color_loader_3.dart';
import '../provider/parkingLot.dart';
//provider
import '../provider/report_provider.dart';
import 'package:provider/provider.dart';
import '../provider/parkingLotProvider.dart';
import '../provider/auth.dart';

class Parkability extends StatefulWidget {
  static const routeName = '/park-ability';

  @override
  _ParkabilityState createState() => _ParkabilityState();
}

class _ParkabilityState extends State<Parkability> {
  var _editReport = Report(
    id: null,
    userName: 'non', // temporary
    lifeTime: 0,
    dateTime: '',
    imageUrl: '',
    isPromoted: false,
    availability: 0,
    score: 0,
    loc: '',
    imgName: '',
  );

  File _image;
  String _uploadedFileURL;
  String _locImage;

  final _form = GlobalKey<FormState>();

  final _imageUrlFocusNode = FocusNode();

  final _lifeTimeFocusNode = FocusNode();

  var _isLoading = false;
  var _isUploadImage = false;
  var _locPicloaded = false;
  var _isPickedImage = false;

  int _currentValue = 0; // Number slider value

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm(context, name) async {
    // final _isValid = _form.currentState.validate();

    // if (!_isValid) {
    //   return;
    // }
    setState(() {
      _isLoading = true;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Confirmed?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('Do you confirmed your reports?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Discard'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          _isLoading
              ? CircularProgressIndicator()
              : FlatButton(
                  child: Text('Confirmed'),
                  onPressed: () {},
                )
        ],
      ),
    );
    // Navigator.of(context).pop();
  }

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = _image;
      // print(_image);
    });
  }

  int getAndSetlifeTime() {
    var dateTime = DateTime.now();

    //Real envi
    // var hourMark = dateTime.hour;
    // var minuteMark = dateTime.minute;
    // var weekDay = dateTime.weekday;
    // Developing environment
    var hourMark = 8;
    var minuteMark = 20;
    var weekDay = 5;

    int row, col, alpha;

    if (hourMark >= 7) {
      row = 0;
      if (hourMark >= 8) {
        row = 1;
        if (hourMark >= 9) {
          row = 2;
          if (hourMark >= 10) {
            row = 3;
            if (hourMark >= 11) {
              row = 4;
              if (hourMark >= 12) {
                row = 5;
                if (hourMark >= 13) {
                  row = 6;
                  if (hourMark >= 14) {
                    row = 7;
                    if (hourMark >= 15) {
                      row = 8;
                      if (hourMark >= 16) {
                        row = 9;
                        if (hourMark >= 17) {
                          row = 10;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    if (minuteMark >= 0) {
      col = 0;
      if (minuteMark >= 16) {
        col = 1;
        if (minuteMark >= 31) {
          col = 2;
          if (minuteMark >= 46) {
            col = 3;
          }
        }
      }
    }

    // if (weekDay >= 1) {
    //   alpha = 1;
    //   if (weekDay >= 2) {
    //     alpha = 2;
    //     if (weekDay >= 3) {
    //       alpha = 3;
    //       if (weekDay >= 4) {
    //         alpha = 4;
    //         if (weekDay >= 5) {
    //           alpha = 5;
    //         }
    //       }
    //     }
    //   }
    // }

    return col + (row * 4);
  }

  Future uploadFile(context, name, currentReportCount, ParkLot lot) async {
    try {
      var imagename = UniqueKey().toString();

      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('reports/$name/$imagename');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      setState(() {
        _isLoading = true;
      });
      await uploadTask.onComplete;
      setState(() {
        _isLoading = false;
      });
      storageReference.getDownloadURL().then((fileURL) {
        print(getAndSetlifeTime());
        setState(() {
          _uploadedFileURL = fileURL;
          _editReport = Report(
            id: _editReport.id,
            userName: _editReport.userName,
            lifeTime: lot.lifeTime[getAndSetlifeTime()],
            dateTime: _editReport.dateTime,
            imageUrl: _uploadedFileURL,
            isPromoted: _editReport.isPromoted,
            availability: _editReport.availability,
            score: _editReport.score,
            loc: _editReport.loc,
            imgName: imagename,
          );
          // print(_uploadedFileURL);
          // print(_uploadedFileURL + "eiei");
        });
      }).then((_) async {
        await Provider.of<ReportsProvider>(context, listen: false)
            .addReport(
          _editReport,
          currentReportCount,
        )
            .then((_) {
          _showDialog();
          // Scaffold.of(context).showSnackBar(snackBar);
        });
      });
// print('File Uploaded');
      _image = null;
      _currentValue = 0;
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    // Navigator.of(context).pop();
    // Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Report complete"),
          content: new Text("Thank you for your time"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getAndSetlifeTime();
    final name = ModalRoute.of(context).settings.arguments as String;
    final historyData = Provider.of<ReportsProvider>(context);
    Provider.of<ReportsProvider>(context).fetchReportFromLocation(name);
    int currentReportCount = historyData.locReportsCount;

    final parkingInfo =
        Provider.of<ParkingLotProvider>(context, listen: false).findById(name);
    final authData = Provider.of<Auth>(context, listen: false);
    final report = Provider.of<ReportsProvider>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    // final locUrl = Provider.of<ParkingLotProvider>(context, listen: false)
    //     .getLocImage(name);
    // print(locUrl.toString());
    return Scaffold(
      backgroundColor: Color.fromRGBO(67, 66, 114, 100),
      appBar: AppBar(
        title: Text(parkingInfo.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: ColorLoader3(
                dotRadius: 5,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: screenSize.height / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(parkingInfo.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 3,
                        color: Colors.white,
                      ),
                      Text(
                        'Press to upload your image',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
                                    child: FloatingActionButton(
                                      elevation: 1,
                                      backgroundColor: Colors.grey,
                                      onPressed: getImage,
                                      tooltip: 'Add Image',
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            height: 200,
                                            width: 200,
                                            child: Image.file(
                                              _image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ]),
                                  ),
                          ],
                        ),
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 3,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Parkability: $_currentValue",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: NumberPicker.integer(
                            initialValue: _currentValue,
                            minValue: 0,
                            maxValue: int.parse(
                              parkingInfo.max.toStringAsFixed(0),
                            ),
                            onChanged: (newValue) {
                              _editReport = Report(
                                id: _editReport.id,
                                userName: _editReport.userName,
                                lifeTime: _editReport.lifeTime,
                                dateTime: _editReport.dateTime,
                                imageUrl: _editReport.imageUrl,
                                isPromoted: _editReport.isPromoted,
                                availability: newValue,
                                score: _editReport.score,
                                loc: name,
                                imgName: _editReport.imgName,
                              );
                              // print(_editReport.imageUrl);
                              setState(() => _currentValue = newValue);
                            }),
                      ),
                      Center(
                        child: FlatButton(
                          color: Colors.grey,
                          onPressed: () async {
                            await uploadFile(
                                context, name, currentReportCount, parkingInfo);
                          },
                          child: Text('Confirm report'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
