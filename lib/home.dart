import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/RecipeView.dart';
import 'package:food_recipe_app/model.dart';
import 'package:food_recipe_app/search.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List reciptCatList = [
    {
      "imgUrl":
          "https://media.istockphoto.com/id/638000936/photo/vegan-and-vegetarian-indian-cuisine-hot-spicy-dishes.jpg?s=612x612&w=0&k=20&c=ISxBGeKALq9c11v05BbNw2XtRzQaGn4BddU8BHF9ANk=",
      "heading": "Veg Food"
    },
    {
      "imgUrl":
          "https://static01.nyt.com/images/2020/07/10/well/10well-newsletter/10well-newsletter-superJumbo.jpg",
      "heading": "Sweet Food"
    },
    {
      "imgUrl":
          "https://media.istockphoto.com/id/1400292359/photo/ice-cream-cones-bouquet.jpg?b=1&s=170667a&w=0&k=20&c=WWRPlrH9XrlZ74wkUhiK5S6nzm9O0vjRDpSJ-CHAC70=",
      "heading": "Ice-Cream"
    },
    {
      "imgUrl":
          "https://media.istockphoto.com/id/931308812/photo/selection-of-american-food.jpg?s=612x612&w=0&k=20&c=7-2Glc2qVkrWdLaqXwLnNoJLUvc2vMz_QpDTKDcmYiY=",
      "heading": "Fast Food"
    },
    {
      "imgUrl":
          "https://i.pinimg.com/736x/20/92/48/2092483fde63dc2c9e3f2a0038c8af1f.jpg",
      "heading": "Non Veg Food"
    }
  ];
  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=51909a48&app_key=0c72ad295bbe9557a2060977838648ee";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    //log(data.toString());
    data["hits"].forEach((Element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(Element["recipe"]);
      recipeList.add(recipeModel);
      setState(() {
        isLoading = false;
      });
      log(recipeList.toString());
    });
    recipeList.forEach((Recipe) {
      print(Recipe.applable);
      print(Recipe.appcalories);
      print(Recipe.appimgUrl);
      print(Recipe.appurl);
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipe("Chicken");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.brown,
                  Colors.red,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank Search");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          search(searchController.text))));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blue,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Cook New Recipe....."),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHAT DO YOU WANT TO EAT TODAY",
                        style: TextStyle(fontSize: 33, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New..!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                            recipeList[index].appurl)));
                              },
                              child: Card(
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        recipeList[index].appimgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.black26),
                                          child: Text(
                                            recipeList[index].applable,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                    ),
                                    Positioned(
                                        right: 0,
                                        width: 80,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department,
                                                  size: 17,
                                                ),
                                                Text(recipeList[index]
                                                    .appcalories
                                                    .toString()
                                                    .substring(0, 6)),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                      itemCount: reciptCatList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => search(
                                          reciptCatList[index]["heading"])));
                            },
                            child: Card(
                              margin: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      reciptCatList[index]["imgUrl"],
                                      fit: BoxFit.cover,
                                      width: 200,
                                      height: 250,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    top: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration:
                                          BoxDecoration(color: Colors.black26),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            reciptCatList[index]["heading"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
