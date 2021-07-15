import 'package:flutter/material.dart';
import 'package:MOrder/views/DASHBOARD/mainDashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Supplier extends StatefulWidget {
  @override
  _SupplierState createState() => _SupplierState();
}

class _SupplierState extends State<Supplier> {
  Future<List<SupplierDetail>> GetMySuppliers() async {
    final List<SupplierDetail> suppliers = [];

    var headers = {
      'X-AUTH-TOKEN':
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkJEU2pBYnRPYWhFMEQtSjFmTXZ6MyJ9.eyJodHRwczovL3d3dy5tc2FsZXMuY29tL2VtYWlsIjoiZHVsYW5qYW5zZWpAZ21haWwuY29tIiwiaHR0cHM6Ly93d3cubXNhbGVzLmNvbS9lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDYwNzAwYzgyMGE0YjU1MDA2OTJkYjgyOSIsImF1ZCI6WyJodHRwOi8vcHVibGljLmFwaS5tc2FsZXNhcHAuY29tIiwiaHR0cHM6Ly9tc2FsZXMuYXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTYyNjI2MTk2NCwiZXhwIjoxNjI2MzQ4MzY0LCJhenAiOiJCN0ZObXV2ZVRjZG4zZWthcVQ3eU1PZUs0Szgwd1FpOCIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.UPXiHvXEUzbmlZuptO6WJ99zrkfZtKkWPTBV08jQX_LV9lOc1vsqMXlrsBIlMuUMGsME7XYfnb19HLZi-AMQwA5UgXmTfnS-Oj_Z4dA7cWWGqdUdkbm9M_bDrlCIK3mN0aiqBCm06v4v7XPGDQ8SCLXefhpCJW5ZsHVNjFi_g-WVxx0XZ-ZFkrhDBUApkkFXDoKiTAwTCGI_rQfAkHvaDeJ98ArzLPYi60EylqRqWzhbYVXZQOrPfzaQyYJw3P0XBdve1ejACUVATzCunuYyUBwvjUQeqZV3bucb2OdQmAtQv99wuq8cogMksKo26QzNP2iTE8eGwkPDnWmVM3Ro-Q',
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=B2E911507B6EE95774EC0246B10F5F5F'
    };

    var response = await http.post(
        Uri.parse(
            'https://central.msalesapp.com/central/modelng/performoperation/Federal/GetMySuppliers'),
        body: json.encode({}),
        headers: headers);

    if (response.statusCode == 200) {
      var allSuppliers = json.decode(response.body)["objects"]['Partnerships'];
      print(allSuppliers);

      for (int i = 0; i < allSuppliers.length; i++) {
        suppliers.add(SupplierDetail.fromJson(allSuppliers[i]));
      }
    } else {
      print(response.reasonPhrase);
    }
    return suppliers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Supplier"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
        child: ListView.separated(
          itemCount: 25,
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_){
                      return mainDashBoard("1");
                      //return Supplier();
                    }
                ));
              },
              title: Text('item $index'),
            );
          },
        )
      )
    );
  }
}

class SupplierDetail {
  final int id;
  final String name;

  SupplierDetail({this.id, this.name});

  factory SupplierDetail.fromJson(Map<String, dynamic> json) {
    return SupplierDetail(id: json['id'], name: json['name']);
  }
}
