import 'dart:math';

import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/views/home_screen/search_screen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen2 extends StatefulWidget {
  const SearchScreen2({super.key});

  @override
  State<SearchScreen2> createState() => _SearchScreen2State();
}

class _SearchScreen2State extends State<SearchScreen2> {
  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    getStreamProduct();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var productSnapSHot in _allResults) {
        var name = productSnapSHot['p_name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(productSnapSHot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  getStreamProduct() async {
    var data = await FirebaseFirestore.instance
        .collection(productCollection)
        .orderBy('p_name')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    // _searchController.removeListener(_onSearchChanged);
    // _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getStreamProduct();
    super.didChangeDependencies();
  }

  changeScreen(String search) {
    Get.to(() => SearchScreen1(
          title: _searchController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: whiteColor,
          title: CupertinoSearchTextField(
            controller: _searchController,
            keyboardType: TextInputType.text,
          )
          // SizedBox(
          //   height: 50,
          //   child: TextFormField(
          //     controller: _searchController,
          //     decoration: InputDecoration(
          //         enabledBorder: const OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(20)),
          //         ),
          //         hintText: "Search...",
          //         suffixIcon: const Icon(Icons.search).onTap(() {
          //           if (_searchController.text == "") {
          //             InputDecoration(hintText: "Please fill Search...");
          //           } else {
          //             changeScreen(_searchController.text);
          //           }
          //         })),
          //   ),
          // )
          //CupertinoSearchTextField(
          //   controller: _searchController,
          //   onTap: changeScreen,
          // ),
          ),
      body: Container(
        color: whiteColor,
        child: ListView.builder(
            itemCount: _resultList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: "${_resultList[index]['p_name']}"
                    .text
                    .color(Colors.black)
                    .make()
                    .onTap(() {
                  Get.to(() => SearchScreen1(
                        title: _resultList[index]['p_name'],
                      ));
                }),
              );
            }),
      ),
    );
  }
}
