import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/tweet.dart';
import 'package:harpy/api/twitter/services/tweets/cached_tweet_service_impl.dart';
import 'package:harpy/api/twitter/services/tweets/tweet_service.dart';
import 'package:harpy/components/shared/buttons.dart';
import 'package:harpy/stores/home_store.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/theme.dart';
import 'package:image_picker/image_picker.dart';

class NewTweetScreen extends StatefulWidget {
  @override
  _NewTweetScreenState createState() => _NewTweetScreenState();
}

class _NewTweetScreenState extends State<NewTweetScreen>
    with StoreWatcherMixin<NewTweetScreen> {
  TextEditingController _textEditingController;
  TweetService _tweetService;
  HomeStore _homeStore;

  _NewTweetScreenState() {
    _textEditingController = TextEditingController();
    _tweetService = CachedTweetServiceImpl();
  }

  @override
  void initState() {
    super.initState();

    _homeStore = listenToStore(Tokens.home);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    unlistenFromStore(_homeStore);
    super.dispose();
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

  void _createTweet() async {
    Tweet newTweet =
        await _tweetService.createTweet(_textEditingController.text);
    newTweet.full_text = _textEditingController.text;
    HomeStore.createTweet(newTweet);
    Navigator.pop(context);
  }
}

class NewTweetActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Row(
        children: <Widget>[
          _buildAction(
            iconData: Icons.image,
            activate: () async {
              var image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
            },
            deactivate: () {},
          ),
          SizedBox(
            width: 10.0,
          ),
//          _buildAction(
//            iconData: Icons.gif,
//            activate: () {},
//            deactivate: () {},
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
//          _buildAction(
//            iconData: Icons.table_chart,
//            activate: () {},
//            deactivate: () {},
//          ),
//          SizedBox(
//            width: 10.0,
//          ),
          _buildAction(
            iconData: Icons.location_on,
            activate: () {},
            deactivate: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
      {IconData iconData, VoidCallback activate, VoidCallback deactivate}) {
    return Column(
      children: <Widget>[
        TwitterButton(
          color: HarpyTheme.primaryColor,
          activate: activate,
          inactiveIconData: iconData,
          active: false,
          activeIconData: iconData,
          deactivate: deactivate,
          iconSize: 23.0,
        ),
      ],
    );
  }
}
