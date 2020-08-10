import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_website/models/article_model.dart';

class APIService {
  final String _baseUrl = 'api.nytimes.com';
  static const String API_KEY = 'pgEr3OsD4z8w7DP9EzCrrnw9Vv7C3zGA';


  Future<List<Article>> fetchArticlesBySection(String section) async {
    Map<String, String> params = {
      'api-key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
       '/svc/topstories/v2/$section.json',
       params,
      );
      try {
        var response = await http.get(uri);
        Map<String, dynamic> data = json.decode(response.body);
        List<Article> articles = [];
        data['results'].forEach(
          (articleMap) => articles.add(Article.fromMap(articleMap))
        );
        return articles;

      } catch (err) {
        throw err.toString();
      }
  }

}