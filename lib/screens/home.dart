import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../model/bottomSheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../provider/parkingLotProvider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screeen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Modal modal = new Modal();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = <Marker>[];
  List<Polyline> polylines = <Polyline>[];

  LocationData currentLocation;
  BitmapDescriptor pinLocationIcon;
  bool maptype = true;
  MapType mapType;

<<<<<<< HEAD
  bool _isLoading = false;
  bool _isInit = true;

=======
>>>>>>> parent of 5d40ea5... 5/2/63
  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goMyLoc() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = await getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 18,
    )));
  }

  void getParkingData() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'images/Webp.net-resizeimage.png')
        .then((onValue) {
      setState(() {
        pinLocationIcon = onValue;
      });
    }).then((_) {
      final parkingLots = Provider.of<ParkingLotProvider>(context);
      final lots = parkingLots.parkingLots;
      for (int i = 0; i < parkingLots.parkingLotsCount; i++) {
        markers.add(
          Marker(
            // icon: pinLocationIcon,
            icon: pinLocationIcon,
            markerId: MarkerId(lots[i].id),
            position: LatLng(
              double.parse(lots[i].lat),
              double.parse(lots[i].lon),
            ),
            infoWindow: InfoWindow(
              title: lots[i].title,
              snippet: '${lots[i].title} คณะวิศวกรรมศาสตร์',
            ),
            onTap: () => modal.mainBottomSheet(context, lots[i].id),
          ),
        );
      }
    });
  }

  void getPolyLine() {
    final parkingData = Provider.of<ParkingLotProvider>(context);
    final lots = parkingData.parkingLots;

    for (int i = 0; i < parkingData.parkingLotsCount; i++) {
      polylines.add(Polyline(
          // onTap: () => modal.mainBottomSheet(context, lots[i].id),
          color: Colors.yellow,
          width: 10,
          points: lots[i].poly,
          polylineId: PolylineId(lots[i].id.toString())));
    }
  }

  @override
<<<<<<< HEAD
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ParkingLotProvider>(context).getColor().then((_) {
        getParkingData().then((_) async {
          await getPolyLine().then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
      setState(() {
        _isInit = false;
      });
    }

=======
  void didChangeDependencies() {
    getPolyLine();
    // TODO: implement didChangeDependencies
    getParkingData();
>>>>>>> parent of 5d40ea5... 5/2/63
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changeMapType() {
    maptype
        ? setState(() {
            mapType = MapType.satellite;
          })
        : setState(() {
            mapType = MapType.normal;
          });

    maptype = !maptype;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('C-Parking'),
        ),
        drawer: AppDrawer(),
        // drawer: AppDrawer(),
        body: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            GoogleMap(
              // myLocationEnabled: true,
              polylines: Set.from(polylines),
              markers: Set.from(markers),
              mapType: mapType,
              initialCameraPosition: CameraPosition(
                target: LatLng(18.795484, 98.952698),
                zoom: 18,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                child: Icon(Icons.place),
                onPressed: _goMyLoc,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                child: Icon(Icons.map),
                onPressed: changeMapType,
              ),
            ),
          ],
        ));
  }
}
