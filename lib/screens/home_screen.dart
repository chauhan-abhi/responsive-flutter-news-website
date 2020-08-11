import 'package:news_website/models/article_model.dart';
import 'package:news_website/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  _fetchArticles() async {
    List<Article> articles = 
      await APIService().fetchArticlesBySection('technology');
      setState(() {
        _articles = articles;
      });
  }

  _buildArticleGrid(MediaQueryData mediaQuery) {
    List<GridTile> tiles = [];
    _articles.forEach((article) {
      tiles.add(_buildArticleTile(article, mediaQuery));
     });

     return Padding(
       padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
       child: GridView.count(
         // 4 items in one row can be made responsive
         crossAxisCount: 4,
         mainAxisSpacing: 30.0,
         crossAxisSpacing: 30.0,
         shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
         children: tiles,
         ),
     );
  }

  _launchUrl(String url) async {
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  _buildArticleTile(Article article, MediaQueryData mediaQuery) {
    return GridTile(
      child: GestureDetector(
        onTap: () => _launchUrl(article.url),
        child: Column(
          children: <Widget>[
            Container(
              height: 250.0,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(article.imageUrl),
                  fit: BoxFit.cover
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              height: 120.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0,1),
                    blurRadius: 6.0
                    )
                ],
              ),
              child: Text(
                article.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
                maxLines: 2,
              ),
            )  
          ],
        ),
      ),
    );  
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 80.0),
          Center(
            child: Text(
              'The New York Times \nTop Tech Articles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5
              ),
            ),
          ),
          SizedBox(height: 15.0),
          _articles.length > 0 
            ? _buildArticleGrid(mediaQuery)
            : Center(
              child: CircularProgressIndicator(),
              )
        ]
      ),
    );
  }
}