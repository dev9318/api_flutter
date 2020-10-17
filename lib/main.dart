import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Data {
  final int userId;
  final int id;
  final String title;


  Data({this.userId, this.id, this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  String search = '';
  List<Data> list = [];

  void _getData() async{
    String url = 'https://jsonplaceholder.typicode.com/albums';
    print(1);
    Response response = await get(url);
    print(2);
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
     list = parsed.map<Data>((json) => Data.fromJson(json)).toList();

    setState(() {
      list = list;
    });
  }
  void _putData() async{
    String url = 'https://jsonplaceholder.typicode.com/posts';
    Response response = await post(url,
        headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': search,
      }));
    setState(() {
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0){
            return Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    hintText: 'Type your search',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'search',
                  ),
                  validator: (val) => val.isEmpty ? 'Enter your search' : null,
                  onChanged: (val) {
                    setState(() => search = val.trim());
                  }
              ),
            );
          }
          return Card(
            child: Text(list[index].title),
          );
        },
        itemCount: 1+list.length,
      ),
      /*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              txt,
            ),
            FloatingActionButton(
              onPressed: _putData,
              child: Icon(Icons.add),
            ),
          ],
        ),
      )*/
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Load data',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
