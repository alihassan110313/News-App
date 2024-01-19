import 'dart:convert';

import 'package:zeige_news/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:zeige_news/NewsView.dart';
class Category extends StatefulWidget {

  String Query;
Category({required this.Query});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String url = "";
    if(query == "Top News"){
      url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";

    }else{
      url ="https://newsapi.org/v2/everything?q=$query&from=2024-01-01&sortBy=publishedAt&apiKey=9bb7bf6152d147ad8ba14cd0e7452f2f";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;

          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });

          if (i == 20) {
            break;
          }
        } catch (e) {
          print(e);
        }
        ;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        title: Text("ZEIGE NEWS"),
        centerTitle: true,
      ),
      body:    SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
SizedBox(width: 12,),
                    Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query, style: TextStyle( fontSize: 30,
                      ),),
                    ),
                  ],
                ),
              ),
              isLoading ? Container( height: MediaQuery.of(context).size.height -500 , child: Center(child: CircularProgressIndicator(),),) :
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: InkWell(
                    onTap: () {Navigator.push(context , MaterialPageRoute(builder: (context)=>NewsView(newsModelList[index].newsUrl)));},
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 1.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),

                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(

                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter
                                          )
                                      ),
                                      padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsModelList[index].newsHead,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,52)}...." : newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12)
                                            ,)
                                        ],
                                      )))
                            ],
                          )),
                    ));
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
