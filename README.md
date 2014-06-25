TW33Tme
========
Twitter iOS Demo App

This is an iOS 7 demo app displaying twitter home timeline and supporting features like compose, retweet, and favorite using [Twitter API](https://dev.twitter.com/docs/api/1.1). It is created as part of [CodePath](http://codepath.com/) course work. (June 24, 2014)

Time spent: approximately 15 hours

Features
---------
#### Required
- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

#### Optional
- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.


Walkthrough
------------
![Video Walkthrough](TW33Tme-walkthrough.gif)

Credits
---------
* [Twitter API](https://dev.twitter.com/docs/api/1.1)
* [Icons](http://thenounproject.com)
  * http://thenounproject.com/term/refresh/2223/
  * http://thenounproject.com/term/arrow/16880/
  * http://thenounproject.com/term/star/3307/
* [DateTools](https://github.com/MatthewYork/DateTools)
* [Getting UITableViewCell with superview in iOS 7](http://stackoverflow.com/questions/18962771/getting-uitableviewcell-with-superview-in-ios-7)