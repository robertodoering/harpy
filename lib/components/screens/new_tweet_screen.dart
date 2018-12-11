import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service_impl.dart';
import 'package:harpy/theme.dart';

class NewTweetScreen extends StatefulWidget {
  @override
  _NewTweetScreenState createState() => _NewTweetScreenState();
}

class _NewTweetScreenState extends State<NewTweetScreen> {
  TextEditingController _textEditingController;
  TweetService _tweetService;

  _NewTweetScreenState() {
    _textEditingController = TextEditingController();
    _tweetService = TweetServiceImpl();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: () => _createTweet())
          ],
          title: Text(
            "Harpy",
            style: HarpyTheme.theme.textTheme.title.copyWith(
              fontSize: 20.0,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: "What's going on?",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
            controller: _textEditingController,
            autofocus: true,
            maxLines: 10,
          ),
          NewTweetActionBar(),
        ],
      ),
    );
  }

  void _createTweet() {
    print(_textEditingController.text);
    _tweetService.createTweet(_textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class NewTweetActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[],
    );
  }
}
