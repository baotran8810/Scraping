import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Colors.green,
      scaffoldBackgroundColor: Colors.green[100],
      primaryColor: Colors.green,
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// Strings to store the extracted Article titles
  List<String> location = [
    "FOB(HCM)",
    "Đắk Lăk",
    "Lâm Đồng",
    "Gia Lai",
    "Đắk Nông",
    "Hồ Tiêu",
    "Tỷ giá USD/VND"
  ];

  List<String> price = [];
  List<String> priceChange = [];

// boolean to show CircularProgressIndication
// while Web Scraping awaits
  bool isLoading = false;

  Future<List<String>> extractData() async {
    price.clear();
    priceChange.clear();
    // Getting the response from the targeted url
    final response = await http.Client()
        .get(Uri.parse('https://giacaphe.com/gia-ca-phe-noi-dia/'));

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the responses
      var document = parser.parse(response.body);
      try {
        // Scraping the first article title
        var responseString = document.getElementById("gia_trong_nuoc")!;
        //For parse name
        // print(
        //     responseString.getElementsByClassName("gnd_market")[1].firstChild);
        //For parse data
        // print(responseString.getElementsByClassName("tdLast")[1].firstChild);

        for (int i = 0; i < 7; i++) {
          price.add(responseString
              .getElementsByClassName("tdLast")[i]
              .firstChild
              .toString());
          priceChange.add(responseString
              .getElementsByClassName("price_change")[i]
              .firstChild
              .toString());
        }
        print(price);
        print(priceChange);
        return price;
      } catch (e) {
        return ['', '', 'ERROR!'];
      }
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Scrap data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if isLoading is true show loader
              // else show Column of Texts

              MaterialButton(
                onPressed: () async {
                  // Setting isLoading true to show the loader
                  setState(() {
                    isLoading = true;
                  });
                  final response = await extractData();

                  setState(() {
                    // result1 = response[0];
                    // result2 = response[1];
                    // result3 = response[2];
                    isLoading = false;
                  });
                },
                child: const Text(
                  'Scrap Data',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
              )
            ],
          ),
        )),
      ),
    );
  }
}
