import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Dsn>> fetchDosens(http.Client client) async {
  final response =
      await client.get('https://rmrizkifauzan.000webhostapp.com/readDatajson1.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseDosens, response.body);
}

// A function that converts a response body into a List<Mhs>.
List<Dsn> parseDosens(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Dsn>((json) => Dsn.fromJson(json)).toList();
}

class Dsn {
  final String nidn;
  final String nama_dosen;
  final String jenjang_akademik;
  final String pendidikan_terakhir;
  final String home_base;

  Dsn({this.nidn, this.nama_dosen, this.jenjang_akademik, this.pendidikan_terakhir, this.home_base});

  factory Dsn.fromJson(Map<String, dynamic> json) {
    return Dsn(
      nidn: json['nidn'] as String,
      nama_dosen: json['nama_dosen'] as String,
      jenjang_akademik: json['jenjang_akademik'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
      home_base: json['home_base'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Dosen';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Dsn>>(
        future: fetchDosens(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? DosensList(DosenData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DosensList extends StatelessWidget {
  final List<Dsn> DosenData;

  DosensList({Key key, this.DosenData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
             ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nidn, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama_dosen, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: DosenData.length,
      itemBuilder: (context, index) {
        return viewData(DosenData,index);
      },
    );
  }
}