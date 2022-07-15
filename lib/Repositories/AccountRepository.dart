
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_donation/IRepositories/IAccountRepository.dart';
import 'package:food_donation/Ui/Admin/AdminDashboard.dart';
import 'package:food_donation/Ui/Auth/RegisterScreen.dart';
import 'package:food_donation/Ui/Donor/DonorHome.dart';
import 'package:food_donation/Ui/Receiver/ReceiverHome.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ui/Auth/SplashScreen.dart';
import '../Models/userData.dart';
import '../Utils/Constants.dart';
import '../Utils/Locator.dart';
import '../Utils/Utils.dart';

class AccountRepository extends IAccountRepository{
  @override
  Future registerInFirebase(BuildContext context,UserData user) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
    return null;
  }

  @override
  Future signIn(BuildContext context,String email, String password) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
    return null;

  }

  @override
  Future resetPassword(BuildContext context, String email) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Utils.showSuccess(context,"Password Reset Email has been sent");
    } on FirebaseAuthException catch (e) {
      throw e;
    }
    return null;
  }

  @override
  Future signInWithGoogle(BuildContext context) async{
    try{
      final GoogleSignInAccount? googleSignInAccount =await locator<GoogleSignIn>().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

    }on FirebaseAuthException catch (e){
      Utils.showError(context,e.message!);
      throw e;
    }
    return null;

  }

  @override
  Future registerInDatabase(BuildContext context, UserData user) async{
    try{
       FirebaseFirestore.instance.collection("UserData").doc(user.userId).set(user.toJson()).then((value){
        SharedPreferences.getInstance().then((prefs){
          print(UserData.userToJson(user));
          prefs.setString("user_data", UserData.userToJson(user));
          if(user.role==1){
            Get.offAll(()=>DonorHome());
          }else if(user.role==2){
            Get.offAll(()=>ReceiverHome());
          }
        });
      });
    }catch(e){
      throw e;
    }
    return null;
  }

  @override
  Future getUserInfo(BuildContext context, String userId) async{
    try{
      await FirebaseFirestore.instance.collection("UserData").doc(userId).get().then((documentSnap){
        if(documentSnap.exists){
          UserData user = UserData.fromJson(documentSnap.data()!);
          SharedPreferences.getInstance().then((prefs){
            print(UserData.userToJson(user));

            if(user.isBlocked==null||!user.isBlocked!){
              prefs.setString("user_data", UserData.userToJson(user));
              if(user.role==1){
                Get.offAll(()=>DonorHome());
              }else if(user.role==2){
                Get.offAll(()=>ReceiverHome());
              }else if(user.role==3){
                Get.offAll(()=>AdminDashboard());
              }
            }else{
              Utils.showError(context,"Your Account is Blocked");
            }

          });
        }else{
          Get.to(()=>RegisterScreen());
        }
      });
    } on FirebaseException catch(e){
      throw e;
    }
    return null;
  }

  @override
  Future logOut() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
     if(FirebaseAuth.instance.currentUser!=null&&FirebaseAuth.instance.currentUser?.providerData[0].providerId=="google.com"){
       await locator<GoogleSignIn>().signOut();
     }
    await FirebaseAuth.instance.signOut();
    prefs.remove("user_data");
    Get.offAll(()=>SplashScreen());
  }

  @override
  Future getUserInfoById(BuildContext context, String userId) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> docSnap= await FirebaseFirestore.instance.collection("UserData").doc(userId).get();
      if(docSnap.exists){
        UserData user = UserData.fromJson(docSnap.data()!);
        showDialog(
//barrierDismissible: false,
            context: context,
            builder:(BuildContext context){
              return Dialog(
//backgroundColor: Colors.transparent,
                  child: Container(
                      height:300,
                      width: 950,
                      child: Scaffold(
                          //backgroundColor: Colors.white.withOpacity(0.1),
                          body: Container(
                              height:300,
                              width: 950,
                              child: Column(
                                children: [
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
                                          child: Text(user.name!=null?user.name!:"", style: TextStyle(
                                              color: Color6, fontSize: 25, fontWeight: FontWeight.bold
                                          ),
                                          ),
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
                                                    child: Text(Utils.getRoleName(user.role!=null?user.role!:0), style: TextStyle(
                                                        color: Color2, fontSize: 20, fontWeight: FontWeight.bold
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
                                                  child:Text(user.email!=null?user.email!:"",style: TextStyle(
                                                      color: Color2, fontSize: 17, fontWeight: FontWeight.bold
                                                  ),),
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
                                                child: Center(child: FaIcon(FontAwesomeIcons.phoneFlip, color: Color2,)),
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
                                                    child:Text(user.phone!=null?user.phone!:"", style: TextStyle(
                                                        color: Color2, fontSize: 20, fontWeight: FontWeight.bold
                                                    ),
                                                    ),
                                                ),

                                              )),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              )
                          )

                      )
//ordersDetailPopupLayout(orderList[index])
                  )
              );
            });
      }
    }catch(e){
      throw e;
    }

  }


  @override
  Future<List<UserData>> getUsersByRole(BuildContext context, int roleId) async{
    List<UserData> users=[];
    try{
      QuerySnapshot<Map<String,dynamic>> snapshots=await FirebaseFirestore.instance.collection("UserData").where("role",isEqualTo: roleId).get();
      if(snapshots.docs.length>0){
        for(int i=0;i<snapshots.docs.length;i++){
          UserData u=UserData.fromJson(snapshots.docs[i].data());
          u.userId=snapshots.docs[i].id;
          users.add(u);
        }
        log("Users Length"+users.length.toString());
        return users;
      }else{
        Utils.showError(context,"No Users Found");
      }

    }catch(e){
      throw e;
    }
    return users;
  }

  @override
  Future blockUser(String userId,bool isBlocked) async{
    try{
     await FirebaseFirestore.instance.collection("UserData").doc(userId).update({"isBlocked":isBlocked});
    }catch(e){
      throw e;
    }
  }


}