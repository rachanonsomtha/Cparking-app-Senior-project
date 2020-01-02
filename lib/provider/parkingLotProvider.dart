import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './parkingLot.dart';

class ParkingLotProvider with ChangeNotifier {
  List<ParkLot> _parkingLots = [
    ParkLot(
      id: '30#1',
      title: 'ตึกสามสิบปี#1',
      max: 3,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      lat: '18.795484',
      lon: '98.952698',
    ),
    ParkLot(
      id: '30#2',
      title: 'ตึกสามสิบปี#2',
      max: 10,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      lat: '18.795353',
      lon: '98.952700',
    ),
    ParkLot(
      id: 'SUR#1',
      title: 'ตึกเซอร์เวย์#1',
      max: 10,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      lat: '18.795051',
      lon: '98.952685',
    ),
    ParkLot(
      id: 'SUR#2',
      title: 'ตึกเซอร์เวย์#2',
      max: 12,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      lat: '18.795033',
      lon: '98.952969',
    ),
  ];

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
