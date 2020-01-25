import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './parkingLot.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import '../provider/report.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingLotProvider with ChangeNotifier {
  List<ParkLot> _parkingLots = [
    ParkLot(
      id: '30#1',
      title: 'ตึกสามสิบปี#1',
      max: 3,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/parkingLot%2F30%231.jpg?alt=media&token=562a41d9-f87d-425e-9da5-301a651ab498',
      lat: '18.795484',
      lon: '98.952698',
      poly: [
        LatLng(18.795478, 98.952615),
        LatLng(18.795486, 98.952764),
        LatLng(18.795456, 98.952763),
        LatLng(18.795459, 98.952627),
        LatLng(18.795478, 98.952615),
      ].toList(),
      lifeTime: [
        1.0,
      ].toList(),
    ),
    ParkLot(
      id: '30#2',
      title: 'ตึกสามสิบปี#2',
      max: 10,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/parkingLot%2F30%232.jpg?alt=media&token=148927d0-ca2f-4ca2-8ce2-06768b9eab1d',
      lat: '18.795353',
      lon: '98.952700',
      poly: [
        LatLng(18.795478, 98.952615),
        LatLng(18.795486, 98.952764),
        LatLng(18.795456, 98.952763),
        LatLng(18.795459, 98.952627),
      ].toList(),
      lifeTime: [
        0.5,
      ].toList(),
    ),
    ParkLot(
      id: 'SUR#1',
      title: 'ตึกเซอร์เวย์#1',
      max: 10,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/parkingLot%2FSUR%231.jpg?alt=media&token=79b954db-0775-4c74-9a26-ca9dba63353d',
      lat: '18.795051',
      lon: '98.952685',
      poly: [
        LatLng(18.795478, 98.952615),
        LatLng(18.795486, 98.952764),
        LatLng(18.795456, 98.952763),
        LatLng(18.795459, 98.952627),
      ].toList(),
      lifeTime: [
        0.7,
      ].toList(),
    ),
    ParkLot(
      id: 'SUR#2',
      title: 'ตึกเซอร์เวย์#2',
      max: 12,
      imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/cparking-ecee0.appspot.com/o/parkingLot%2FSUR%232.jpg?alt=media&token=00bd71c9-dc89-4e71-8526-38cde35dde19',
      lat: '18.795033',
      lon: '98.952969',
      poly: [
        LatLng(18.795478, 98.952615),
        LatLng(18.795486, 98.952764),
        LatLng(18.795456, 98.952763),
        LatLng(18.795459, 98.952627),
      ].toList(),
      lifeTime: [
        2.0,
      ].toList(),
    ),
  ];
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
