import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newstant/helper/data.dart';
import 'package:newstant/helper/news.dart';
import 'package:newstant/models/article_model.dart';
import 'package:newstant/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import './articles.dart';
import './category.dart';
import'package:intl/intl.dart';
class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> category = new List<CategoryModel>();
  List<ArticleModel> article = new List<ArticleModel>();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    category = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    article = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('News'),
            Text(
              'tant',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        elevation: 0,
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => getNews(),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 120,
                        child: ListView.builder(
                            itemCount: category.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CategoryTile(
                                imageUrl: category[index].imageUrl,
                                categoryName: category[index].categoryName,
                              );
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        child: ListView.builder(
                            itemCount: article.length,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BlogTile(
                                  imageUrl: article[index].urlToImage,
                                  title: article[index].title,
                                  desc: article[index].description,
                                  url: article[index].url,
                                  publishedAt:article[index].publishedAt);
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => Category(
                      category: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 160,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 160,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  final DateTime publishedAt;
  const BlogTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url,@required this.publishedAt});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => Articles(
                      articleUrl: url,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
           'Published on '+publishedAt.hour.toString()+':'+publishedAt.minute.toString(),style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
            SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}
