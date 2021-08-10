import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:MOrder/views/DASHBOARD/mainDashboard.dart';
import 'package:http/http.dart' as http;
import 'package:MOrder/views/AUTH/supplier.dart';

class Profile extends StatefulWidget {
  final logoutAction;
  String name;
  String picture;

  Profile(this.logoutAction, this.name, this.picture);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Business> businessList = [];

  Business dropdownValue;
  String picture =
      "https://s.gravatar.com/avatar/66cb0e36c3955fcc2e0480a012436a4f?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fdm.png";

  Future<void> getMyBusiness() async {
    //GZxv8drDMXLPdkc

    final List<Business> business = [];

    var headers = {
      'X-AUTH-TOKEN':
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyODU3OTM3OSwiZXhwIjoxNjI4NjY1Nzc5LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.ZwOubU4BPm0NrjrjmYmHg1EN2nrpeEK6yw-f96jUZ66Mv2DCL6RziZtau0zVQkAEf-a4vVMOlBBCvMkaFM-w1DhVsTSMpd6oSWC2i1ke6ee2Pf_A1Iz9VkhuKvzXOrPz_X1A2vBVvORNdq6_RqQ6JJi3Ybq8YKRf8BwEwxtN1lRMymaSZdHfp0ifH92FVT5QefKgIPw9Nm4NuGEhYtgmwPoTi-JK04woCjOX0HLpJzf8D7pL1B2DdfbXHawd-Zu4aAHpZ5tJDy3-Jo2UITtmpWxiW4NIYgMa3C117Wdp5774Yr-wZVCwKXRXzVcrJp68hqOHvWYeVo6tlUok0WCl0Q',
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=B2E911507B6EE95774EC0246B10F5F5F'
    };

    var response = await http.post(
        Uri.parse(
            'https://central.msalesapp.com/central/modelng/performoperation/Federal/GetMyBuyingBusinesses'),
        body: json.encode({}),
        headers: headers);

    if (response.statusCode == 200) {
      var allBusiness = json.decode(response.body)["objects"]['Businesses'];

      for (int i = 0; i < allBusiness.length; i++) {
        business.add(Business.fromJson(allBusiness[i]));
      }
    } else {
      print(response.reasonPhrase);
    }

    print(response.body);
    setState(() {
      businessList = business;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyBusiness();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Hi Welcome",
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2.0),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(picture ?? ''),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                DropdownButton<Business>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (Business newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      // return mainDashBoard(newValue.id.toString());
                      return Supplier(newValue.id);
                    }));
                  },
                  items: businessList
                      .map<DropdownMenuItem<Business>>((Business value) {
                    return DropdownMenuItem<Business>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Business {
  final int id;
  final String name;
  final String registrationNumber;
  final String owner;
  final String creationTime;
  final String accountBalance;

  Business(
      {this.id,
      this.name,
      this.registrationNumber,
      this.owner,
      this.creationTime,
      this.accountBalance});

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
        id: json['id'],
        name: json['name'],
        registrationNumber: json['registrationNumber'],
        owner: json['owner'],
        creationTime: json['creationTime'],
        accountBalance: json['accountBalance']);
  }
}
