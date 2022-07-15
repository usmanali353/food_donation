import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/AdminController.dart';
import '../../Controllers/DonorController.dart';
import '../../Controllers/ReceiverController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class PaidDonationsDetails extends StatelessWidget{
  List<dynamic> paidDonations=[];
  String? openedFrom;
  int? index;

  PaidDonationsDetails(this.index,this.openedFrom);

  @override
  Widget build(BuildContext context) {
    if(paidDonations.length==0){
      if(openedFrom=="Donor"){
          this.paidDonations.addAll(Get.find<DonorController>().filteredPaidDonations);
      }else if(openedFrom=="Receiver"){
          this.paidDonations.addAll(Get.find<ReceiverController>().filteredPaidDonations);
      }else{
        this.paidDonations.addAll(Get.find<AdminController>().filteredPaidDonations);
      }
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        elevation: 8,
        centerTitle: true,
        title: Text("Details", style: TextStyle(
            color: Color6, fontSize: 30, fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: Container(
        //color: Color2,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                //height: 650,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    //color: Color6,
                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
                ),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      decoration: BoxDecoration(
                          //color: Color2,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(paidDonations[index!].singleImage)
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(

                      width: MediaQuery.of(context).size.width,
                      height: 410,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48)),
                        //color: Color6,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    //color: Color6,
                                    border: Border.all(color: Color1, width: 2),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 90,
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Color2,
                                          border: Border.all(color: Color1, width: 1),
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: Center(
                                        child: Text("Name", style: TextStyle(
                                            color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Center(
                                      child: Text(paidDonations[index!].description,
                                        maxLines: 3,
                                        //textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color2, fontSize: 22, fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  //color: Color1,
                                  //border: Border.all(color: Color1, width: 1),
                                  //borderRadius: BorderRadius.circular(4)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.sitemap, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              //color: Color6,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(Utils.getCategoryName(paidDonations[index!].category), style: TextStyle(
                                                color: Color2, fontSize: 25, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  //color: Color1,
                                  //border: Border.all(color: Color1, width: 1),
                                  //borderRadius: BorderRadius.circular(4)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.users, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              //color: Color6,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(paidDonations[index!].personsQuantity.toString(), style: TextStyle(
                                                color: Color2, fontSize: 25, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),

                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  //color: Color1,
                                  //border: Border.all(color: Color1, width: 1),
                                  //borderRadius: BorderRadius.circular(4)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.hourglassStart, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              //color: Color6,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(paidDonations[index!].availableUpTo, style: TextStyle(
                                                color: Color2, fontSize: 25, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),

                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  //color: Color1,
                                  //border: Border.all(color: Color1, width: 1),
                                  //borderRadius: BorderRadius.circular(4)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.moneyBill, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              //color: Color6,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(paidDonations[index!].price.toString(), style: TextStyle(
                                                color: Color2, fontSize: 25, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),

                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  //color: Color1,
                                  //border: Border.all(color: Color1, width: 1),
                                  //borderRadius: BorderRadius.circular(4)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color1,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color2, width: 2)
                                          ),
                                          child: Center(child: FaIcon(FontAwesomeIcons.mapLocationDot, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              //color: Color6,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Text(paidDonations[index!].address, style: TextStyle(
                                                color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          ),

                                        )),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),

            ),
            Visibility(
              visible: openedFrom=="Receiver"||openedFrom=="Admin",
              child: Expanded(
                child: InkWell(
                  onTap: ()async{
                    await launchUrl(
                        Uri.parse("tel://${this.paidDonations[index!].phone}")  );
                  },
                  child: Container(
                    //height: 650,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      //color: Color2,
                      //borderRadius: BorderRadius.only(bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 8,
                            color: Color1,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color2,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Color1, width: 2)
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        color: Color2,
                                        child: Center(
                                          child: Text("Contact", style: TextStyle(
                                              color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color1,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Color2, width: 2)
                                        ),
                                        child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2,)),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Visibility(
                          visible: openedFrom=="Receiver"||openedFrom=="Admin",
                          child: Expanded(
                            child: InkWell(
                              onTap: ()async{
                                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                if(!serviceEnabled){
                                  Utils.showError(context,"Please Enable Location Services");
                                  return;
                                }
                                Geolocator.checkPermission().then((permission){
                                  if(permission == LocationPermission.denied){
                                    Geolocator.requestPermission().then((permission){
                                      if(permission!= LocationPermission.denied){
                                        Geolocator.getCurrentPosition().then((position)async{
                                          final availableMaps = await MapLauncher.installedMaps;
                                          availableMaps.first.showDirections(
                                              destination: Coords(this.paidDonations[index!].lat,this.paidDonations[index!].lng),
                                              origin: Coords(position.latitude,position.longitude),
                                              destinationTitle: "Hospital",
                                              originTitle: "Mobile Market"
                                          );
                                        });
                                      }
                                    });
                                    return;
                                  }else if(permission == LocationPermission.deniedForever){
                                    Utils.showError(context,"You have to give location permission from setting of your device");
                                    return;
                                  }

                                });
                                Geolocator.getCurrentPosition().then((position)async{
                                  final availableMaps = await MapLauncher.installedMaps;
                                  List<Placemark> p = await placemarkFromCoordinates(position.latitude,position.longitude);

                                  Placemark place = p[0];
                                  availableMaps.first.showDirections(
                                      destination: Coords(this.paidDonations[index!].lat,this.paidDonations[index!].lng),
                                      origin: Coords(position.latitude,position.longitude),
                                      destinationTitle: paidDonations[index!].address,
                                      originTitle: "${place.name},${place.subLocality}, ${place.locality}, ${place.country}"
                                  );
                                });

                              },
                              child: Card(
                                elevation: 8,
                                color: Color1,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Color2,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Color1, width: 2)
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            color: Color2,
                                            child: Center(
                                              child: Text("Location", style: TextStyle(
                                                  color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                              ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color1,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Color2, width: 2)
                                            ),
                                            child: Center(child: FaIcon(FontAwesomeIcons.mapLocationDot, color: Color2,)),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )

          ],
        ),


      ),
    );
  }

}