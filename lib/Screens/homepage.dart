import 'package:digitalveins/Entities/api_manger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}


class _State extends State<HomePage> {

  Map<String, dynamic> data = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title:Text("Home Page"),
        ) ,
        body: Padding(

          padding: EdgeInsets.all(10),

          child: data == null ? Text("Loading...") :
          Column(
            children: [
              Text("Categories",style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 25
              ),),
              SizedBox(height: 30,),
              Expanded(
                flex: 1,
                  child:
                  ListView.builder(
                      itemCount:data['categories'].length,
                      itemBuilder: (BuildContext context , int index){
                            return Column(
                              children: [
                                Center(
                                  child: Text(  data['categories'][index]['name'],style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black
                                  ),),
                                ),
                                Container(margin: EdgeInsets.only(top:5.0),),
                                Row(
                                  children: [
                                    Text("Description: ",style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15
                                    )),
                                    Expanded(
                                      child: Text(data['categories'][index]['description'],style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black
                                        )),
                                    )
                                  ],
                                ),
                                Image.network(data['categories'][index]['image'] ),
                                Divider(),
                              ],
                            );
                        }
                  ),
              ),

              Text("products",style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25
              ),),
              SizedBox(height: 30,),
              Expanded(
                flex: 1,
                child:ListView.builder(
                    itemCount:data['products'].length,
                    itemBuilder: (BuildContext context , int index){
                      return Column(
                        children: [
                          Center(
                            child: Text(  data['products'][index]['name'],style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black
                              ),),
                          ),
                          Container(margin: EdgeInsets.only(top:5.0),),
                          Row(
                            children: [
                              Text("Description: ",style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15
                              )),
                              Expanded(child:  Text(data['products'][index]['description'],style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black
                              )) )

                            ],
                          ),
                          Image.network(data['products'][index]['image'] ),
                          Container(margin: EdgeInsets.only(top:5.0),),
                          Center(
                            child:Text(  data['products'][index]['price'],style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),),),
                          Divider(),
                        ],
                      );
                    }
                ),
              ),


            ],
          ),
        )
    );
  }

  @override
  void initState() {
    getData("https://www.goomlah.com/public/api/").then((value) {
      setState(() {
        data=value;
      });
    });
  }
}