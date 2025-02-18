import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  final String review, cover, title;
  final int likes, added;
  final Color color;
  Feed(this.review, this.cover, this.title, this.likes, this.added, this.color) : super();
  
  @override
  State<Feed> createState() => _FeedState();
  
}

class _FeedState extends State<Feed> {
  bool like = false;
  bool add = false;
  Icon likeIcon = Icon(Icons.favorite_border);
  Icon addIcon = Icon(Icons.bookmark_add_outlined);
  Color likeColor = Colors.white;
  late int likeCount, addedCount;

  @override
  void initState(){
    super.initState();
    likeCount = widget.likes;
    addedCount = widget.added;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 76),
        child: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 400,
                    height: 80
                  ),
                  _review(),
                  SizedBox(
                    height: 20
                  ),
                  _cover(),
                  SizedBox(
                    height: 20
                  ),
                  _link(),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    _like(),
                    _add(),
                    _share()
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _review(){
    return Text(widget.review,
      style: TextStyle(
        fontSize: 32,
        color: Colors.black,
      ),
    );
  }

  Widget _cover(){
    return Container(
      height: 350,
      child: Image.network(widget.cover),
    );
  }

  Widget _link(){
    return TextButton.icon(
      onPressed: (){},
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.black),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        padding: WidgetStatePropertyAll(EdgeInsets.all(16)),
        overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
      ),
      icon: Icon(Icons.arrow_forward_ios),
      iconAlignment: IconAlignment.end, 
      label: Text(widget.title + " 더보기", 
        style: TextStyle(color: Colors.black, fontSize: 20)
      ),
    );
  }

  Widget _like(){
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: () {
            setState(() {
              if (!like){
                like = true;
                likeIcon = Icon(Icons.favorite);
                likeColor = Colors.red;
                likeCount++;
              }
              else {
                like = false;
                likeIcon = Icon(Icons.favorite_border);
                likeColor = Colors.white;
                likeCount--;
              }
            });
          },
          color: likeColor,
          style: ButtonStyle(
            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          ),
          icon: likeIcon,
          iconSize: 33,
        ),
        Text(likeCount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _add(){
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: () {
            setState((){
              if (!add){
                add = true;
                addIcon = Icon(Icons.bookmark_added);
                addedCount++;
              }
              else {
                add = false;
                addIcon = Icon(Icons.bookmark_add_outlined);
                addedCount--;
              }
            });
          },
          color: Colors.white,
          style: ButtonStyle(
            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          ),
          icon: addIcon,
          iconSize: 33,
        ),
        Text(addedCount.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _share(){
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: () {
            
          },
          color: Colors.white,
          style: ButtonStyle(
            overlayColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
          ),
          icon: Icon(Icons.send),
          iconSize: 33,
        ),
        Text("3",
         style: TextStyle(
          color: Colors.white,
          fontSize: 14,
         ),
        ),
      ],
    );
  }

}

