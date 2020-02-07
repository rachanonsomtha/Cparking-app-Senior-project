import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './parkingLot.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParkingLotProvider with ChangeNotifier {
  List<ParkLot> _parkingLots = [
    ParkLot(
      id: '301',
      title: 'ลานจอดหน้าตึก30ปี#1',
      max: 3,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/30%231.jpg?alt=media&token=28ca734c-55b6-480a-a7ea-28a81743fdb4',
      lat: '18.795430',
      lon: '98.952698',
      poly: [
        LatLng(18.795452, 98.952580),
        LatLng(18.795443, 98.952728),
        LatLng(18.795420, 98.952724),
        LatLng(18.795426, 98.952577),
        LatLng(18.795452, 98.952580),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
    ParkLot(
      id: '302',
      title: 'ลานจอดหน้าตึก30ปี#2',
      max: 10,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/30%232.jpg?alt=media&token=156a6a36-5736-4a6a-b7de-c780dfe1ff92',
      lat: '18.795353',
      lon: '98.952700',
      poly: [
        LatLng(18.795376, 98.952570),
        LatLng(18.795374, 98.952798),
        LatLng(18.795335, 98.952802),
        LatLng(18.795334, 98.952568),
        LatLng(18.795376, 98.952570),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
    ParkLot(
      id: 'SUR1',
      title: 'ลานจอดอาจารย์โยธา#1',
      max: 10,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/SUR%231.jpg?alt=media&token=2b300451-4815-4787-8a43-1f843c05be12',
      lat: '18.795051',
      lon: '98.952685',
      poly: [
        LatLng(18.795091, 98.952610),
        LatLng(18.795075, 98.952846),
        LatLng(18.795028, 98.952840),
        LatLng(18.795038, 98.952612),
        LatLng(18.795091, 98.952610),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
    ParkLot(
      id: 'SUR2',
      title: 'ลานจอดอาจารย์โยธา#2',
      max: 12,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/SUR%232.jpg?alt=media&token=bfa057bd-045d-4204-b31c-b79c9e6a4aa5',
      lat: '18.795033',
      lon: '98.952969',
      poly: [
        LatLng(18.795068, 98.952916),
        LatLng(18.795078, 98.953072),
        LatLng(18.795028, 98.953065),
        LatLng(18.795018, 98.952924),
        LatLng(18.795068, 98.952916),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
    ParkLot(
      id: 'FEILD1',
      title: 'ลานจอดสนามฮ้อกกี้#1',
      max: 19,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/FEILD%231.jpg?alt=media&token=a6b92650-99a9-4db9-8c7c-3a361475a8a9',
      lat: '18.794916',
      lon: '98.952638',
      poly: [
        LatLng(18.794916, 98.952638),
        LatLng(18.794863, 98.953141),
        LatLng(18.794798, 98.953119),
        LatLng(18.794853, 98.952598),
        LatLng(18.794916, 98.952638),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
    ParkLot(
      id: 'VIT1',
      title: 'ลานจอดตึกประลอง#1',
      max: 20,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/VIT%231.jpg?alt=media&token=8d761dac-c294-4b2e-84d3-a99bf10b5261',
      lat: '18.795263',
      lon: '98.951819',
      poly: [
        LatLng(18.795263, 98.951819),
        LatLng(18.795265, 98.951888),
        LatLng(18.795169, 98.951890),
        LatLng(18.795172, 98.951824),
        LatLng(18.795263, 98.951819),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
    ParkLot(
      id: 'VIT2',
      title: 'ลานจอดตึกประลอง#2',
      max: 15,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/VIT%232.jpg?alt=media&token=9dd573a1-5197-44cc-94d2-a320cc7de883',
      lat: '18.795417',
      lon: '98.951893',
      poly: [
        LatLng(18.795417, 98.951893),
        LatLng(18.795209, 98.951899),
        LatLng(18.795207, 98.951943),
        LatLng(18.795423, 98.951949),
        LatLng(18.795417, 98.951893),
      ].toList(),
      color: Colors.grey,
      lifeTime: [
        15,
        29,
        20,
        28,
        7,
        11,
        12,
        5,
        5,
        13,
        8,
        19,
        16,
        17,
        5,
        13,
        16,
        7,
        7,
        6,
        26,
        28,
        30,
        19,
        11,
        5,
        22,
        9,
        17,
        24,
        17,
        29,
        11,
        17,
        28,
        18,
        28,
        16,
        13,
        14,
        21,
        28,
        23,
        7,
      ].toList(),
    ),
  ];
  String setMinute(int time) {
    //Real envi

    String min;
    if (time <= 30) {
      min = '0';
    }
    if (time >= 31) {
      min = '30';
    }

    return min;
  }

  Future<void> getColor() async {
    String url;
    final time = DateTime.now();

    String hour = (time.hour).toString();
    String minute = setMinute(time.minute);
    _parkingLots.forEach((lot) async {
      url =
          'https://cparking-ecee0.firebaseio.com/avai/${lot.id}/14/0.json';
      final response = await http.get(url);
      // print(lot.color);
      final decodeData = json.decode(response.body) as Map<String, dynamic>;
      double _parkingMax = lot.max;

      lot.color = setColor(int.parse(decodeData['mean']), _parkingMax);
    });
  }

  Color setColor(int avai, double max) {
    double factor;
    Color colorFactor;
    factor = avai / max;
    if (factor >= 0.3) {
      colorFactor = Colors.red;
      if (factor >= 0.5) {
        colorFactor = Colors.yellow;
        if (factor >= 0.8) {
          colorFactor = Colors.green;
        }
      }
    }
    return colorFactor;
  }

  Future<String> getLocImage(String title) async {
    var imageFile;
    StorageReference ref =
        FirebaseStorage.instance.ref().child('parkingLot/$title.jpg');
    StorageUploadTask uploadTask = ref.putFile(imageFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    return url;
  }

  ParkLot findById(String id) {
    return _parkingLots.firstWhere((lot) => lot.id == id);
  }

  List<ParkLot> get parkingLots {
    return [..._parkingLots];
  }

  int get parkingLotsCount {
    return _parkingLots.length;
  }
}
