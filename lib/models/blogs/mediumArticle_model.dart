import 'dart:convert';

class MediumArticle {
  String title;
  String link;
  String datePublished;
  String image;
  String author;
  String content;

  MediumArticle(
      {required this.title,
      required this.link,
      required this.datePublished,
      required this.image,
      required this.content,
      required this.author});

  factory MediumArticle.fromJson(Map<String, dynamic> jsonData) {
    return MediumArticle(
        title: jsonData['title'],
        link: jsonData['link'],
        datePublished: jsonData['datePublished'],
        image: jsonData['image'],
        content: jsonData['content'],
        author: jsonData['author']);
  }

  static Map<String, dynamic> toMap(MediumArticle music) => {
        'title': music.title,
        'link': music.link,
        'datePublished': music.datePublished,
        'image': music.image,
        'content': music.content,
        'author': music.author,
      };

  static String encode(List<MediumArticle> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => MediumArticle.toMap(music))
            .toList(),
      );

  static List<MediumArticle> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<MediumArticle>((item) => MediumArticle.fromJson(item))
          .toList();
}
