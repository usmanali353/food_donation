import 'package:flutter/material.dart';
import 'package:food_donation/IRepositories/IAdminRepository.dart';
import 'package:food_donation/Utils/Utils.dart';
import 'package:get/get.dart';
import '../IRepositories/IAccountRepository.dart';
import '../Models/Counts.dart';
import '../Models/Donation.dart';
import '../Utils/Constants.dart';
import '../Utils/Locator.dart';
import 'AccountController.dart';

class AdminController extends GetxController{
  Rx<dynamic> counts=Counts().obs;
  var usersList=[].obs;
  var requestListForAdmin=[].obs;
  var donationListForAdmin=[].obs;
  var filteredList=[].obs;
  var filteredPaidDonations=[].obs;
  Rx<bool> isDashboardLoading=false.obs;
  Rx<bool> userListLoading=false.obs;
  Rx<bool> foodRequestsLoading=false.obs;
  Rx<bool> donationsLoading=false.obs;
  Rx<bool> fetchingPricedDonation=false.obs;
  var pricedDonations=[].obs;
  late IAdminRepository adminRepository;
  late IAccountRepository accountRepository;
  var _selected=[].obs;
  List<String> categories=["Cooked Food","Fruits","Vegetables","Sweets","Chocolates","Cakes","Biscuits","Milk","Grains","Mix Items","Others",];
   @override
  void onInit() {
     adminRepository=locator<IAdminRepository>();
     accountRepository=locator<IAccountRepository>();
    super.onInit();
  }
  void getDashboardCount(BuildContext context){
     Utils.isInternetAvailable().then((isConnected){
       if(isConnected){
         isDashboardLoading.value=true;
         adminRepository.getDashboardCounts(context).then((dashboardCounts){
           counts.value=dashboardCounts;
           isDashboardLoading.value=false;
         }).catchError((error){
           isDashboardLoading.value=false;
           Utils.showError(context, error.toString());
         });
       }else{
         Utils.showError(context,"Your Device is not connected to Network");
       }
     });

  }
  Future getUsersByRole(BuildContext context,int roleId)async{
     Utils.isInternetAvailable().then((isConnected){
       if(isConnected){
         userListLoading.value=true;
         usersList.clear();
          accountRepository.getUsersByRole(context, roleId).then((users){
           userListLoading.value=false;
           usersList.assignAll(users);
         }).catchError((error){
           userListLoading.value=false;
           Utils.showError(context,error.toString());
         });
       }else{
         Utils.showError(context,"Your Device is not connected to Network");
       }
     });
  }
  Future getRequestsByType(BuildContext context,int typeId)async{
     Utils.isInternetAvailable().then((isConnected){
       if(isConnected){
         filteredList.clear();
         requestListForAdmin.clear();
         foodRequestsLoading.value=true;
         adminRepository.getRequestsByType(context, typeId).then((value){
           foodRequestsLoading.value=false;
           requestListForAdmin.assignAll(value);
           filteredList.assignAll(value);
         }).catchError((error){
           Utils.showError(context, error.toString());
           foodRequestsLoading.value=false;
         });
       }else{
         Utils.showError(context,"Your Device is not connected to Network");
       }
     });
  }
  Future getDonationsByStatus(BuildContext context,int typeId)async{
    Utils.isInternetAvailable().then((isConnected){
      if(isConnected){
        filteredList.clear();
        donationListForAdmin.clear();
        donationsLoading.value=true;
        adminRepository.getDonationsByType(context, typeId).then((value){
          donationsLoading.value=false;
          donationListForAdmin.assignAll(value);
          filteredList.assignAll(value);
        }).catchError((error){
          Utils.showError(context, error.toString());
          donationsLoading.value=false;
        });
      }else{
        Utils.showError(context,"Your Device is not connected to Network");
      }
    });
  }
  Widget buildChips(BuildContext context,String type) {
    List<Widget> chips =[];

    for (int i = 0; i < categories.length; i++) {
      _selected.add(false);
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(categories[i], style: TextStyle(color: Color6, fontWeight: FontWeight.bold)),
        // avatar: FlutterLogo(),
        elevation: 5,
        pressElevation: 5,
        //shadowColor: Colors.teal,
        backgroundColor: Color2,
        selectedColor: Color1,
        onSelected: (bool selected) {
          for(int j=0;j<_selected.length;j++){
            if(_selected[j]){
              _selected[j]=false;
            }
          }
          _selected[i] = selected;
          if(_selected[i]){

            Utils.isInternetAvailable().then((result){
              if(result){
                filteredList.clear();
                if(type=="Food Requests"){
                  for(Donation d in requestListForAdmin){
                    if(d.category==i+1){
                      filteredList.add(d);
                    }
                  }
                }else{
                  for(Donation d in donationListForAdmin){
                    if(d.category==i+1){
                      filteredList.add(d);
                    }
                  }
                }

              }else{
                Utils.showError(context, "Network Error");
              }
            });
          }else{
            if(type=="Food Requests"){
              filteredList.clear();
              filteredList.assignAll(requestListForAdmin);
            }else{
              filteredList.clear();
              filteredList.assignAll(donationListForAdmin);
            }
            // WidgetsBinding.instance
            //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          }


        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: filterChip
      ));
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }
  void getUserInfoById(BuildContext context,String userId){
    Get.find<AccountController>().accountRepository.getUserInfoById(context, userId).then((userInfo){

    }).catchError((error){
      Utils.showError(context, error.toString());
    });
  }
  Future getPricedDonation(BuildContext context)async{
    Utils.isInternetAvailable().then((isConnected)async{
      if(isConnected){
        fetchingPricedDonation.value=true;
        await adminRepository.getPricedDonationAdmin(context).then((donationList){
          pricedDonations.clear();
          filteredPaidDonations.clear();
          pricedDonations.assignAll(donationList);
          filteredPaidDonations.assignAll(donationList);
          fetchingPricedDonation.value=false;
        }).catchError((error){
          Utils.showError(context,error.toString());
          fetchingPricedDonation.value=false;
        });
      }else{
        Utils.showError(context,"Device is Not Connected to Internet");
      }
    });
  }
  Widget buildChipsForPaidDonation(BuildContext context) {
    List<Widget> chips =[];

    for (int i = 0; i < categories.length; i++) {
      _selected.add(false);
      FilterChip filterChip = FilterChip(
        selected: _selected[i],
        label: Text(categories[i], style: TextStyle(color: Color6, fontWeight: FontWeight.bold)),
        // avatar: FlutterLogo(),
        elevation: 5,
        pressElevation: 5,
        //shadowColor: Colors.teal,
        backgroundColor: Color2,
        selectedColor: Color1,
        onSelected: (bool selected) {
          for(int j=0;j<_selected.length;j++){
            if(_selected[j]){
              _selected[j]=false;
            }
          }
          _selected[i] = selected;
          if(_selected[i]){

            Utils.isInternetAvailable().then((result){
              if(result){
                filteredPaidDonations.clear();
                for(Donation d in pricedDonations){
                  if(d.category==i+1){
                    filteredPaidDonations.add(d);
                  }
                }
              }else{
                Utils.showError(context, "Network Error");
              }
            });
          }else{
            filteredPaidDonations.clear();
            filteredPaidDonations.assignAll(pricedDonations);
            // WidgetsBinding.instance
            //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
          }


        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: filterChip
      ));
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  Future blockUser(BuildContext context,String userId,bool isBlocked)async{
    accountRepository.blockUser(userId, isBlocked).then((value){

    }).catchError((error){
      Utils.showError(context,error.toString());
    });
  }
}