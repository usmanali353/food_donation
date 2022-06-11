import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../Controllers/AccountController.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class ProfileScreen extends GetView<AccountController> {


  @override
  Widget build(BuildContext context) {
    if(controller.userData.value.name==null||controller.userData.value.role==null){
      controller.getUserInfo();
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color6
        ),
        backgroundColor: Color2,
        elevation: 8,
        centerTitle: true,
        title: Text("Profile", style: TextStyle(
            color: Color6, fontSize: 30, fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              //height: 650,
              width: MediaQuery.of(context).size.width,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage( "assets/charitylogo.png",)
              //   ),
              //     color: Color6,
              //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
              // ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
                ),

                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Color2.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(150)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                                color: Color2.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(150)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image:NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!=null?FirebaseAuth.instance.currentUser!.photoURL!:"https://www.nicepng.com/png/full/522-5226533_get-beyond-the-usual-suspects-profile-pic-icon.png")
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color2,
                            border: Border.all(color: Color1, width: 2),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: Center(
                          child: Obx(() => Text(controller.userData.value.name!=null?controller.userData.value.name!:"", style: TextStyle(
                              color: Color6, fontSize: 25, fontWeight: FontWeight.bold
                          ),
                          ),)
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(48), bottomLeft: Radius.circular(48))
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                                          child: Center(child: FaIcon(FontAwesomeIcons.userTie, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Obx(() => Text(Utils.getRoleName(controller.userData.value.role!=null?controller.userData.value.role!:0), style: TextStyle(
                                                color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                            ),
                                            ),)
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
                                          child: Center(child: FaIcon(FontAwesomeIcons.at, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child: Obx(() => Text(controller.userData.value.email!=null?controller.userData.value.email!:"",style: TextStyle(
                                                color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                            ),),
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
                                          child: Center(child: FaIcon(FontAwesomeIcons.phoneAlt, color: Color2,)),
                                        )),
                                    SizedBox(width: 5,),
                                    Expanded(
                                        flex: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Color1, width: 2)
                                          ),
                                          child: Center(
                                            child:Obx(() => Text(controller.userData.value.phone!=null?controller.userData.value.phone!:"", style: TextStyle(
                                                color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                            ),
                                            ),)
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
          ),
          Expanded(
            child: Container(
              //height: 650,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color2,
                //borderRadius: BorderRadius.only(bottomRight: Radius.circular(18), bottomLeft: Radius.circular(18))
              ),
              child: Center(
                  child: InkWell(
                    onTap: (){
                      controller.logOut();
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
                                flex: 5,
                                child: Container(
                                  color: Color2,
                                  child: Center(
                                    child: Text("Log Out", style: TextStyle(
                                        color: Color6, fontSize: 28, fontWeight: FontWeight.bold
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
                                  child: Center(child: FaIcon(FontAwesomeIcons.signOut, color: Color2,)),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
