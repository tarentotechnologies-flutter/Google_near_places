import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nearby_places/places/place_detail.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:google_nearby_places/modal/distance.dart';
const kGoogleApiKey = "*************" ;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

void main() {
  runApp(MaterialApp(
    title: "PlaceZ",
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  final String value;

  Home({Key key, this.value}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController mapController;
  List<PlacesSearchResult> places = [];
  List<distancs> kilometercal =  new List();
  bool isLoading = false;
  String errorMessage;
  double centerlat;
  double centerlong;
  final Map<String, Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    print('${widget.value}');
  }

  @override
  Widget build(BuildContext context) {
    Widget expandedChild;
    if (isLoading) {
      expandedChild = Center(child: CircularProgressIndicator(value: null));
    } else if (errorMessage != null) {
      expandedChild = Center(
        child: Text(errorMessage),
      );
    } else {
      expandedChild = buildPlacesList();
    }

    return Scaffold(
        key: homeScaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('${widget.value}'" " + 'Near Me'),
          actions: <Widget>[
            isLoading
                ? IconButton(
              icon: Icon(Icons.timer),
              onPressed: () {},
            )
                : IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                refresh();
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _handlePressButton();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: SizedBox(
                  height: 200.0,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0), zoom: 12
                    ),
//                    markers: _markers,
                  )
              ),
            ),

           Expanded(child: expandedChild)
          ],
        ));
  }

  void refresh() async {
    final center = await getUserLocation();

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    getNearbyPlaces(center);
  }
  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;




    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    refresh();
  }

  Future<LatLng> getUserLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final lat = position.latitude;
      final lng = position.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      return null;
    }
  }

  void getNearbyPlaces(LatLng center) async {

    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500, type: "${widget.value}");

    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((f) {
//          print(LatLng(f.geometry.location.lat, f.geometry.location.lng));
          final lat1 = f.geometry.location.lat;
          final long1 = f.geometry.location.lng;
          double calculateDistance(lat1, lon1, lat2, lon2){
            var p = 0.017453292519943295;
            var c = cos;
            var a = 0.5 - c((lat2 - lat1) * p)/2 +
                c(lat1 * p) * c(lat2 * p) *
                    (1 - c((lon2 - lon1) * p))/2;
            return 12742 * asin(sqrt(a));
          }

          double totalDistance = calculateDistance(lat1, long1, center.latitude, center.longitude);
//          print('total');
          setState(() {
            kilometercal.add(
              new distancs(totalDistance));

          });
          final marker = Marker(
            markerId: MarkerId('office.name'),
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
          infoWindow: InfoWindow(
                  title: "${f.name}",
                  snippet: '${f.types?.first}'
              ),
          );

//           _markers.add(
//            Marker(
//              position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
////              infoWindow: InfoWindow(
////                  title: "${f.name}",
////                  snippet: '${f.types?.first}'
////              ),
//              icon: BitmapDescriptor.defaultMarker,
//            ),
//          );
//         _markers.add(
//            Marker(
//              position:  LatLng(f.geometry.location.lat, f.geometry.location.lng),
//              infoWindow: InfoWindow(
//                  title: "${f.name}",
//                  snippet: '${f.types?.first}'
//              ),
//              icon: BitmapDescriptor.defaultMarker,
//
//            ),
//
//          );

        });
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.fullscreen,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);

      showDetailPlace(p.placeId);
    } catch (e) {
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }
  }

  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
        )
      ];
      if (f.formattedAddress != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.formattedAddress,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ));
      }

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.vicinity,
            style: Theme.of(context).textTheme.body1,
          ),
        ));
      }

      if (f.types?.first != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: Theme.of(context).textTheme.caption,
          ),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showDetailPlace(f.placeId);
            },
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return ListView(shrinkWrap: true, children: placesWidget);
  }
    }




