import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // call get jason data function
    this.getJSONData();
  }

  Future<String> getJSONData() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    ////var url = "https://www.googleapis.com/books/v1/volumes?q={http}";
    var url = "https://unsplash.com/napi/photos/Q14J2k8VE3U/related";
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      ////var itemCount = jsonResponse['totalItems'];
      ////print("Number of books about http: $itemCount.");
      setState(() {
        data = jsonResponse['results'];
      });
      return "sucessful";
      //print("jsonResponse: $jsonResponse.");
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("test"),
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _buildImageColumn(data[index]);
      },
    );
  }

  Widget _buildImageColumn(item) => Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: item['urls']['small'],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            ListTile(
              title: Text(item['user']['name']),
              subtitle: Text(item['likes'].toString()),
              trailing: Icon(Icons.favorite),
            ),
          ],
        ),
      );
}
