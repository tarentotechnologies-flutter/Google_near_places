import 'package:flutter/material.dart';
import 'package:google_nearby_places/places/nearbyplaces.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';



void main() => runApp(new Categories());

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String Categories;
  final TextEditingController _filter = new TextEditingController();
  var _textController = new TextEditingController();
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Near By Places");
  String searchAddr;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  AppBar(
      backgroundColor: Colors.green,
      centerTitle: true,
      title:appBarTitle,
//      leading: new IconButton(
//        icon: new Icon(Icons.arrow_back, color: Colors.orange),
//        onPressed: () => Navigator.of(context).pop(),
//      ),
      actions: <Widget>[
        new IconButton(icon: actionIcon,onPressed:(){
          setState(() {
            if ( this.actionIcon.icon == Icons.search){
              this.actionIcon = new Icon(Icons.close);
              this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchandNavigate,
                          iconSize: 30.0),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),

                  onChanged: (val) {
                    setState(() {
                      searchAddr = val;
                    });
                  }
              );}
            else {
              this.actionIcon = new Icon(Icons.search);
              this.appBarTitle = new Text("Location");
            }
          }
          );
        } ,),]
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.grey)
                    ]),
              )
            ],
          ),
          Container(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'List Of Places',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0),
                  )
                ],
              )),
          SizedBox(height: 10.0),
          GridView.count(
            crossAxisCount: 2,
            primary: false,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 4.0,
            shrinkWrap: true,
            children: <Widget>[
              _buildCard('atm', 1, "https://img.etimg.com/thumb/msid-69137816,width-300,imgsize-697593,resizemode-4/atm-bccl.jpg"),
              _buildCard('bank', 2, "https://images.cointelegraph.com/images/740_aHR0cHM6Ly9zMy5jb2ludGVsZWdyYXBoLmNvbS9zdG9yYWdlL3"
                  "VwbG9hZHMvdmlldy9jM2JkMTE2OWY4MGYwOTdmYTdmZjg0MWJhOWU5MzEwZS5qcGc=.jpg"),
              _buildCard('bakery', 3, "https://cdn-images-1.medium.com/max/1200/1*oUqIjw8wHvQtGfcKL9DQWw.jpeg"),
              _buildCard('bar', 4, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPKt12WUVCE8AlpwpQA_6XwmR6SJYEvXAz8SLRmcj2_iV1tqU1"),
              _buildCard('beauty_salon', 5, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxzUHGYL8OoSDqGO1x1rAErd41-petYMgGeOv8saDCcM5Mjvpm"),
              _buildCard('cafe', 6, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5QNzSMIrPoysvdJaX0Phimf_ADolG3Cz23kdDGAb4d0_0UHdU'),
              _buildCard('church', 7, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmjX-RobFJNZgQf6QOsMt_yVHhm-WYQwhL5-Ua8yzzOw1_ln99'),
              _buildCard('clothing_store', 8, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT52ffT8bsblg8xaOU_3da2rnGCAQFEG5-3u1RZFAyMUMloHN1q'),
              _buildCard('Doctor', 9, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23zOtgF_gvKpbbmoP1kTauWZYXnK4s7_uUR_L6J5Kw_UAG3n1'),
              _buildCard('electrician', 10, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS23zOtgF_gvKpbbmoP1kTauWZYXnK4s7_uUR_L6J5Kw_UAG3n1'),
              _buildCard('fire_station', 11, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjBZVaQDpGdm5FQAtLtqC66011HbNUNFska5oDPctJS0mukeDZ'),
              _buildCard('gas_station', 12, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDs_aaaUDatxArCHnjpHHm3j0Bu_uQ8eQzvncxIHp-crFq5L4e'),
              _buildCard('gym', 13, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9LZAOXnkcgjZAnVInBVzNm6ciIXYdTuB9oPEEGjj06zWBAEw'),
              _buildCard('hospital', 14, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKYDTXDqOGA8JipF9VxubUZcxkTHGFcNmYBFUjxtI-7PTryeNheg'),
              _buildCard('library', 15, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8aLE18G51IFq5TVmnBU7xdzoPBgU_53uBIOMzyMVTSwvHyB8x'),
              _buildCard('lodging', 16, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrhTNfTEWFzsJroljs-t3XlLftI6D9mnl7LBE69KBVVmdhBOo9Qg'),
              _buildCard('movie_theater', 17, 'https://whatson.melbourne.vic.gov.au/PublishingImages/Places/theatres-shows-436.jpg'),
              _buildCard('night_club', 18, 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Aerobarmiami.jpg/220px-Aerobarmiami.jpg'),
              _buildCard('park', 19, 'https://www.sandiego.gov/sites/default/files/legacy/park-and-recreation/graphics/missionhills.jpg'),
              _buildCard('post_office', 20, 'https://pbs.twimg.com/profile_images/1765155820/Post_Office_Logo_400x400.jpg'),
              _buildCard('restaurant', 21, 'https://pixel.nymag.com/imgs/daily/grub/2018/08/14/bony-midtown/Le-Bernadin.w700.h700.jpg'),
              _buildCard('school', 22, 'https://upload.wikimedia.org/wikipedia/commons/5/5f/Larkmead_School%2C_Abingdon%2C_Oxfordshire.png'),
              _buildCard('shopping_mall', 23, 'https://sordoniconstruction.com/wp-content/uploads/2018/01/shopping_mall.jpg'),
              _buildCard('stadium', 24, 'https://www.telegraph.co.uk/content/dam/football/2019/04/07/TELEMMGLPICT000193245536_trans_NvBQzQ'
                  'Njv4BqF9BD_fYQB0teZOF4IslN2U''i6L4XAoX9KJ12arlP6KhI.jpeg?imwidth=450'),
              _buildCard('supermarket', 25, 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/ASDA_in_Keighley.jpg/220px-ASDA_in_Keighley.jpg'),
              _buildCard('zoo', 26, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSwvPT3wTjdraIRGHCvmhwTYtl2lu1fGyDmfHF0iPdKg_aQoY_bA')
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(String name, int status, String image) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 7.0,

      child: Column(

        children: <Widget>[

          SizedBox(height: 20.0),

          Stack(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                      onTap: () {
                        //Insert event to be fired up when button is clicked here
                        //in this case, this increments our `countValue` variable by one.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            new Home(value: name),
                          ),
                        );
                      }
                  ),
                width: MediaQuery.of(context).size.width,
                height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(image),
                    ),
                  ),

                ),
//                GestureDetector(
//                    onTap: () {
//                      //Insert event to be fired up when button is clicked here
//                      //in this case, this increments our `countValue` variable by one.
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) =>
//                          new Home(value: name),
//                        ),
//                      );
//                    }
//                )
              ]),
//          SizedBox(height: 25.0),
          Expanded(
            child: GestureDetector(
              onTap: () => _changeCell(name),
              child: Container(
                width: 175.0,
                decoration: BoxDecoration(
                  color: status == 'Away' ? Colors.grey: Colors.green,
                  borderRadius: BorderRadius.only
                    (
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)
                  ),
                ),
                child: Center(
                    child: Center(
                      child: Text(name,
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Quicksand'
                        ),
                      ),

                    )
                ),

              ),

            ),

          )
        ],
      ),
    );

  }

  _changeCell(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        new Home(value: name),
      ),
    );
  }
  searchandNavigate() async {
    print('search');
    print(searchAddr);
    if (searchAddr != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  new Home(value: searchAddr)),
      );
    }
  }

}