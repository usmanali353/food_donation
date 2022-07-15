import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Utils/Constants.dart';
import '../../Utils/Utils.dart';

class RatingList extends StatelessWidget {
  List<dynamic> rating=[];

  RatingList(this.rating);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color2,
        title: Text("Rating & Reviews",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(itemCount: rating.length, itemBuilder: (context, index){
          return Card(
              elevation: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Color1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Color2,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(2), bottomLeft:Radius.circular(2))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.solidStar, size: 30, color: Colors.amberAccent,),
                          SizedBox(height: 5,),
                          Text(rating[index]["rating"].toString(), style: TextStyle(
                              fontSize: 25,
                              color: Color6,
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                        child: Container(
                          //color: Colors.yellow,
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color2,
                                  border: Border.all(color: Color1, width: 1),
                                  //borderRadius: BorderRadius.circular(4)
                                ),
                                child: Center(
                                  child: Text(rating[index]["ratedByName"], style: TextStyle(
                                      color: Color6, fontSize: 22, fontWeight: FontWeight.bold
                                  ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),
                              Expanded(

                                child: Container(
                                  decoration: BoxDecoration(
                                    //color: Color6,
                                    border: Border.all(color: Color1, width: 1),
                                    //borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Color2,
                                          border: Border.all(color: Color1, width: 0.5),
                                          //borderRadius: BorderRadius.circular(4)
                                        ),
                                        child: Center(
                                          child: Text("Date: " + Utils.getFormattedDate(rating[index]["ratedOn"]), style: TextStyle(
                                              color: Color6, fontSize: 20, fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        ),
                                      ),
                                      Text(rating[index]["comment"],
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color2, fontSize: 15, fontWeight: FontWeight.bold
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    // Expanded(
                    //   child:
                    // ),
                  ],
                ),
              )
          );
        }),
      ),
    );
  }
}
