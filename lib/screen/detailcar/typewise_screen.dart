// ignore_for_file: empty_catches, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:carlink/model/typecar_modal.dart';
import 'package:carlink/screen/addcar_screens/addcar_screen.dart';
import 'package:carlink/screen/detailcar/cardetails_screen.dart';
import 'package:carlink/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/bookrange_modal.dart';
import '../../model/carinfo_modal.dart';
import '../../utils/Dark_lightmode.dart';
import '../../utils/common_ematy.dart';
import '../../utils/config.dart';
import '../../utils/fontfameli_model.dart';
import '../../model/homeData_modal.dart';

class TypeWiseScreen extends StatefulWidget {
  final String typeId;
  final String typeCar;
  final CarInfo? carInfo;

  const TypeWiseScreen({super.key, required this.typeId, required this.typeCar,this.carInfo});

  @override
  State<TypeWiseScreen> createState() => _TypeWiseScreenState();
}

class _TypeWiseScreenState extends State<TypeWiseScreen> {
  Future<List<FeatureCar>> featuredcars2() async {
    // Access the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the collection reference
    CollectionReference carlistsRef = firestore.collection('featuredcars');

    QuerySnapshot querySnapshot = await carlistsRef.where("carType",isEqualTo:widget.typeCar).get();

    // Extract data from the query snapshot
    List<FeatureCar> featureCarList = querySnapshot.docs.map((doc) {
      return FeatureCar(
        bookeddate: List<Bookeddate>.from(doc["bookeddate"].map((x) => Bookeddate.fromFirebase(x))) ,

        id: doc["id"],
        carTitle: doc["carTitle"],
        carImg: List<String>.from(doc["carImg"]),
        carRating: doc["carRating"],
        carNumber: doc["carNumber"],
        totalSeat: doc["totalSeat"],
        carGear: doc["carGear"],
        carRentPrice: doc["carRentPrice"],
        priceType: doc["priceType"],
        engineHp: doc["engineHp"],
        fuelType: doc["fuelType"],
        carTypeTitle: doc["carTypeTitle"],
        carDesc: doc["carDesc"],
        pickLat: doc["pickLat"],
        pickLng: doc["pickLng"],
        pickAddress: doc["pickAddress"],
        carFacility: doc["carFacility"],
        isFavorite: doc["isFavorite"],
        typeId:'',
        cityId: '',
        brandId: '',
        minHrs: doc["minHrs"],
        totalKm:doc["totalKm"],
        facilityImg: '',
        carTypeImg: '',
        carBrandTitle: '',
        carBrandImg: '',
        carRentPriceDriver: '',
        carAc:doc['carAc'] ,
      );
    }).toList();

    return featureCarList;
  }

  Future<List<FeatureCartype>> featuredcars() async {
  // Access the Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the collection reference
  CollectionReference carlistsRef = firestore.collection('featuredcars');

  QuerySnapshot querySnapshot = await carlistsRef.where("carType",isEqualTo:widget.typeCar!).get();

  List<FeatureCartype> featureCarList = querySnapshot.docs.map((doc) {
    return FeatureCartype(

      id: doc["id"],
      carTitle: doc["carTitle"],
      carImg: List<String>.from(doc["carImg"]),
      carRating: doc["carRating"],
      carNumber: doc["carNumber"],
      totalSeat: doc["totalSeat"],
      carGear: doc["carGear"],
      carRentPrice: doc["carRentPrice"],
      priceType: doc["priceType"],
      engineHp: doc["engineHp"],
      fuelType: doc["fuelType"],
      carDistance:" doc[]",
    );
  }).toList();

  return featureCarList;
}

  late String finalId;
  bool isLoading = true;
  TypeModal? tCar;
  CarInfo? carInfo;
  Future typeCar(lats, longs, uid, cityId) async {
    //List<FeatureCartype> featureCar =await featuredcars();
    List<FeatureCar> featureCar2 =await featuredcars2();

    // Map body = {
    //   "type_id": widget.typeId,
    //   "lats": lats,
    //   "longs": longs,
    //   "uid": uid,
    //   "cityid": cityId,
    // };
   //  try{
    //   var response = await http.post(Uri.parse(Config.baseUrl+Config.typeWise), body: jsonEncode(body), headers: {
    //     'Content-Type': 'application/json',
    //   });
    //   if(response.statusCode == 200){
        setState(() {

          tCar = TypeModal(responseCode: "", result: "result", responseMsg: "responseMsg", featureCar: featureCar2
          );
          // carInfo=CarInfo(carinfo:featureCar2 , galleryImages: [], responseCode: '', result: '', responseMsg: '');

          isLoading = false;
        });
    //     var data = jsonDecode(response.body.toString());
    //     return data;
    //   } else {}
     //}catch(e) {}
  }
  var currencies;
  Future getvalidate() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var id = jsonDecode(sharedPreferences.getString('UserLogin')!);
    // var lat = jsonDecode(sharedPreferences.getString('lats')!);
    // var long = jsonDecode(sharedPreferences.getString('longs')!);
    // var dId = sharedPreferences.getString('lId');
    // currencies = jsonDecode(sharedPreferences.getString('bannerData')!);
    typeCar("string", "long", "id['id']", "dId");
  }

  @override
  void initState() {
    getvalidate();
    super.initState();

  }

  late ColorNotifire notifire;
  int inDex = 0;
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return  Scaffold(
      backgroundColor: notifire.getbgcolor,
      appBar: AppBar(
        backgroundColor: notifire.getbgcolor,
        iconTheme: IconThemeData(color: notifire.getwhiteblackcolor),
        elevation: 0,
        centerTitle: true,
        title:isLoading ? const SizedBox() : Text(widget.typeCar, style: TextStyle(fontFamily: FontFamily.europaBold, fontSize: 15, color: notifire.getwhiteblackcolor,),),
      ),
      body:isLoading ? loader() : Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: tCar!.featureCar.isNotEmpty ? ListView.builder(
                itemCount: tCar?.featureCar.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  inDex = index;
                  return InkWell(
                    onTap: () {
                      Get.to(CarDetailsScreen(id: tCar!.featureCar[index].id, currency: '\$', carInfo:CarInfo(carinfo:tCar!.featureCar[index] , galleryImages: tCar!.featureCar[index].carImg, responseCode: "responseCode", result: "result", responseMsg: "responseMsg")));
                    },
                    child: Container(
                      height: 250,
                      width: Get.size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: notifire.getCarColor,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 204,
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(image: NetworkImage('${Config.imgUrl}${tCar?.featureCar[index].carImg[0].toString().split("\$;").elementAt(0)}'), fit: BoxFit.cover)
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: const [0.6, 0.8, 1.5],
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.9),
                                        Colors.black.withOpacity(0.9),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      blurTitle(title: tCar!.featureCar[index].carTitle, context: context),
                                      blurRating(rating: tCar!.featureCar[index].carRating, color: Colors.black, context: context),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  bottom: 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(tCar!.featureCar[index].carNumber, style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                      Text('${"\$"}${tCar!.featureCar[index].carRentPrice}', style: const TextStyle(fontFamily: FontFamily.europaBold, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              carTool(image: 'assets/engine.png', title: '${tCar!.featureCar[index].engineHp} ${'hp'.tr}'),
                              carTool(image: 'assets/manual-gearbox.png', title: tCar!.featureCar[index].carGear == '0' ? 'Automatic'.tr : 'Manual'.tr),
                              carTool(image: 'assets/petrol.png',title: tCar!.featureCar[index].fuelType == '0' ? 'Petrol'.tr : tCar!.featureCar[index].fuelType == '1' ? 'Diesel'.tr : tCar!.featureCar[index].fuelType == '2' ? 'Electric'.tr : tCar!.featureCar[index].fuelType == '3' ? 'CNG'.tr : 'Petrol & CNG'.tr),
                              carTool(image: 'assets/seat.png', title: '${tCar!.featureCar[index].totalSeat} ${'Seats'.tr}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ) : ematyCar(title: 'Type Car'.tr,colors: notifire.getwhiteblackcolor),
            ),
          ],
        ),
      ),
    );
  }
  Widget carTool({required String image, required String title}){
    return Row(
      children: [
        Image.asset(image, height: 20, width: 20,color: notifire.getwhiteblackcolor),
        const SizedBox(width: 4),
        Text(title, style:  TextStyle(fontFamily: FontFamily.europaWoff, color: notifire.getwhiteblackcolor, fontSize: 13)),
      ],
    );
  }
}
