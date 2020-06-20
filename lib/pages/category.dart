import 'package:flutter/material.dart';
import 'package:newstant/models/article_model.dart';
import '../helper/news.dart';
import './articles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
class Category extends StatefulWidget {
  final String category;
  Category({this.category});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<ArticleModel> article = new List<ArticleModel>();
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNews newsClass = CategoryNews();
    await newsClass.getCategoryNews(widget.category);
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
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=>Navigator.pop(context,false),
        ),
        title: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('News'),
                Text(
                  'tant',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                widget.category.toLowerCase(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ])
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),
            ),
          )
        ],
        elevation: 0,
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => getCategoryNews(),
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: <Widget>[
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
                    ])),
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
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: TextStyle(color: Colors.white54),
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
