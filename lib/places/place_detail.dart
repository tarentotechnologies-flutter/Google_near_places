import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:async/async.dart';

const kGoogleApiKey = "AIzaSyDP6DhNRTYdhvPNFP5TfcY72gI91KeXSiA";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
class PlaceDetailWidget extends StatefulWidget {
  String placeId;

  PlaceDetailWidget(String placeId) {
    this.placeId = placeId;
  }

  @override
  State<StatefulWidget> createState() {
    return PlaceDetailState();
  }
}

class PlaceDetailState extends State<PlaceDetailWidget> {
  List<Marker> allMarkers = [];
  GoogleMapController mapController;
//  final Set<Marker> _markers = {};
  PlacesDetailsResponse place;
  bool isLoading = false;
  Position _currentPosition;
  String errorLoading;
  String kilometer;

  @override
  void initState() {
    fetchPlaceDetail();
    fetchcurrentlocation();
    super.initState();
//    final placeDetail = place.result;
//    final location = place.result.geometry.location;
//
//    final lat = location.lat;
//    final lng = location.lng;
//    final center = LatLng(lat, lng);
////    allMarkers.add(
////      Marker(
////        position: center,
////        markerId: MarkerId('myMarker'),
////        infoWindow: InfoWindow(
////            title: "${placeDetail.name}",
////            snippet: '${placeDetail.formattedAddress}'
////        ),
////        icon: BitmapDescriptor.defaultMarker,
////      ),
////    );
    allMarkers.add(Marker(

        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(40.7128, -74.0060)));
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyChild;
    String title;
    if (isLoading) {
      title = "Loading";
      bodyChild = Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else if (errorLoading != null) {
      title = "";
      bodyChild = Center(
        child: Text(errorLoading),
      );
    } else {
      final placeDetail = place.result;
      final location = place.result.geometry.location;

      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);


      title = placeDetail.name;
      bodyChild = Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Positioned(

                 height: MediaQuery.of(context).size.height,
//                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        myLocationEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(target: center,
                            zoom: 15.0
                        ),
//                       markers: Set.from(allMarkers),
                      ),
                    ),
    Padding(padding: EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: new RawMaterialButton(
          onPressed: (){
            print('jncjkfdnkjdnkdjv');
            final placeDetail = place.result;
            final location = place.result.geometry.location;
            final lat = location.lat;
            final lng = location.lng;
            final center = LatLng(lat, lng);
            mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat, lng),
                  zoom: 14.0,
                  bearing: 45.0,
                  tilt: 45.0),
            ));

          },
          child: new Icon(
            Icons.add_location,
            color: Colors.green,
            size: 27.0,
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
        ),
      ),

    )
                  ]
//              Positioned(
//            child: Container(
//            color: Colors.blue,
//            ),
//          )
              ),
            ),
          ),
          Expanded(
            child: buildPlaceDetailList(placeDetail),
          )
        ],

      );

    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.green,
        ),
        body: bodyChild);
  }

  void fetchPlaceDetail() async {
    setState(() {
      this.isLoading = true;
      this.errorLoading = null;
    });
    PlacesDetailsResponse place =
    await _places.getDetailsByPlaceId(widget.placeId);
    double calculateDistance(lat1, lon1, lat2, lon2){
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p))/2;
      return 12742 * asin(sqrt(a));
    }
    double totalDistance = calculateDistance(_currentPosition.longitude, _currentPosition.longitude,place.result.geometry.location.lat, place.result.geometry.location.lat);

    print(totalDistance);

    var km = totalDistance / 1000;
    print(km.toStringAsFixed(1) + " km");
    kilometer = km.toStringAsFixed(1) + " km";




    if (mounted) {
      setState(() {
        this.isLoading = false;
        if (place.status == "OK") {
          this.place = place;
        } else {
          this.errorLoading = place.errorMessage;
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final placeDetail = place.result;
    final location = place.result.geometry.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);
//    _markers.add(
//      Marker(
//        position: center,
//        infoWindow: InfoWindow(
//            title: "${placeDetail.name}",
//            snippet: '${placeDetail.formattedAddress}'
//        ),
//        icon: BitmapDescriptor.defaultMarker,
//      ),
//    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 15.0)));
  }

  String buildPhotoURL(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${kGoogleApiKey}";
  }

  ListView buildPlaceDetailList(PlaceDetails placeDetail) {
    List<Widget> list = [];
//    list.add(
//      Padding(
//          padding:
//          EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
//
//          child: new RawMaterialButton(
//            onPressed: (){
//
//            },
//            child: new Icon(
//              Icons.add_location,
//              color: Colors.green,
//              size: 35.0,
//            ),
//            shape: new CircleBorder(),
//            elevation: 2.0,
//            fillColor: Colors.white,
//            padding: const EdgeInsets.all(15.0),
//          ),
//      )
//
//    );
    if (placeDetail.photos != null) {
      final photos = placeDetail.photos;
      list.add(SizedBox(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.only(right: 1.0),
                    child: SizedBox(
                      height: 100,
                      child: Image.network(
                          buildPhotoURL(photos[index].photoReference)),
                    ));
              })));
    }

    list.add(
      Padding(
          padding:
          EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            placeDetail.name,
            style: Theme.of(context).textTheme.subtitle,
          )),
    );

    if (placeDetail.formattedAddress != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedAddress,
              style: Theme.of(context).textTheme.body1,
            )),
      );
    }

    if (placeDetail.types?.first != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 0.0),
            child: Text(
              placeDetail.types.first.toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.formattedPhoneNumber != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedPhoneNumber,
              style: Theme.of(context).textTheme.button,
            )),
      );
    }

    if (placeDetail.openingHours != null) {
      final openingHour = placeDetail.openingHours;
      var text = '';
      if (openingHour.openNow) {
        text = 'Opening Now';
      } else {
        text = 'Closed';
      }
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.website != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.website,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.rating != null) {
      list.add(
        Padding(
            padding:
            EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              "Rating: ${placeDetail.rating}",
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    list.add(
      Padding(
          padding:
          EdgeInsets.only(top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            kilometer,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            textAlign: TextAlign.right,
          )),
    );



    return ListView(
      shrinkWrap: true,
      children: list,
    );
  }

Future<void> fetchcurrentlocation() async {
  Position position;
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    final Geolocator geolocator = Geolocator()
      ..forceAndroidLocationManager = true;
    position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  } on PlatformException {
    position = null;
  }

  if (!mounted) {
    return;
  }

  setState(() {
    _currentPosition = position;
  });
}

}

