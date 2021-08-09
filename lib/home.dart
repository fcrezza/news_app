import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:news_app/article.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>> articles;

  @override
  void initState() {
    super.initState();
    articles = fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Headlines',
          style: TextStyle(color: Colors.black87),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black87,
              ),
              onPressed: () {})
        ],
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: articles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Article> data = snapshot.data as List<Article>;
            return ListView.separated(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final Article article = data[index];
                const String placeholderImage =
                    "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png";

                return ListTile(
                    title: CachedNetworkImage(
                      imageUrl: article.urlToImage ?? placeholderImage,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(article.title),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 40.0,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }

  Future<List<Article>> fetchTopHeadlines() async {
    final url = Uri.parse("https://newsapi.org/v2/top-headlines?country=id");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: dotenv.env['NEWS_API_SECRET']!
    });

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<Article> articles = (responseBody["articles"])
          .map<Article>((article) => Article.fromJson(article))
          .toList();
      return articles;
    } else {
      throw Exception("Upss, something went wrong");
    }
  }
}
