//
//  Tweet.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var tweetDictionary: NSDictionary!

    // Tweet attributes
    var id: Int?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoriteCount: Int?
    var favorited: Bool?
    var retweetCount: Int?
    var retweeted: Bool?

    // Tweet relations
    var user: TwitterUser?
    var retweetSource: Tweet?
    var retweet: Tweet?

    // Meta
    var didReply = false

    init(tweetDictionary: NSDictionary) {
        self.tweetDictionary = tweetDictionary

        self.id = tweetDictionary["id"] as? Int
        self.text = tweetDictionary["text"] as? String

        self.createdAtString = tweetDictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(createdAtString!)

        self.favoriteCount = tweetDictionary["favorite_count"] as? Int ?? 0
        self.favorited = (tweetDictionary["favorited"] as? Int)! == 1
        self.retweetCount = tweetDictionary["retweet_count"] as? Int ?? 0
        self.retweeted = (tweetDictionary["retweeted"] as? Int)! == 1

        var userDictionary = tweetDictionary["user"] as NSDictionary
        user = TwitterUser(userDictionary: userDictionary)

        var retweetedStatus = tweetDictionary["retweeted_status"] as? NSDictionary
        if retweetedStatus != nil {
            self.retweetSource = Tweet(tweetDictionary: retweetedStatus!)
        }

        // TODO: figure out how to set didReply from the tweetDictionary
    }

    class func tweetsWithArray(tweetDictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = tweetDictionaries.map {
            (tweetDictionary: NSDictionary) -> Tweet in
            Tweet(tweetDictionary: tweetDictionary)
        }
        return tweets
    }

    class func create(status: String, asReplyTo replyTweet: Tweet?, withCompletion completion: (tweet: Tweet?, error: NSError?) -> Void) {
        // https://dev.twitter.com/rest/reference/post/statuses/update
        var params: [String:AnyObject] = [
            "status": status,
        ]
        if replyTweet != nil {
            params["in_reply_to_status_id"] = replyTweet!.id!
        }
        TwitterClient.sharedInstance.POST(
            TWITTER_API_STATUSES_UPDATE_RESOURCE,
            parameters: params,
            success: {
                (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweet = Tweet(tweetDictionary: response as NSDictionary)
                completion(tweet: tweet, error: nil)
                if replyTweet != nil {
                    replyTweet!.didReply = true
                }
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
                completion(tweet: nil, error: error)
            }
        )
    }

    func destroy(callback: (response: AnyObject!, error: NSError!) -> Void) {
        TwitterClient.sharedInstance.POST(
            "\(TWITTER_API_STATUSES_DESTROY_RESOURCE_PREFIX)\(self.id!)\(TWITTER_API_RESOURCE_SUFFIX)",
            parameters: nil,
            success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("Successfully destroyed tweet")
                callback(response: response, error: nil)
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
                NSLog("Failed to destroy tweet")
                callback(response: nil, error: error)
            }
        )
    }

    func wasRetweeted() -> Bool {
        var value = self.retweetSource != nil
        return value
    }

    func getSource() -> Tweet {
        var sourceTweet: Tweet
        if self.wasRetweeted() {
            sourceTweet = self.retweetSource!
        } else {
            sourceTweet = self
        }
        return sourceTweet
    }

    func toggleRetweet(callback: () -> Void) {
        self.retweeted! = !self.retweeted!
        if self.retweeted! == true {
            self.getSource().retweetCount! += 1
            self.retweet(callback)
        } else {
            self.unretweet(callback)
            self.getSource().retweetCount! -= 1
        }
    }

    func retweet(callback: () -> Void) {
        TwitterClient.sharedInstance.POST(
            "\(TWITTER_API_STATUSES_RETWEET_RESOURCE_PREFIX)\(self.id!)\(TWITTER_API_RESOURCE_SUFFIX)",
            parameters: nil,
            success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("Successfully retweeted")
                callback()
                var retweet = Tweet(tweetDictionary: response as NSDictionary)
                self.retweet = retweet
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
                NSLog("Failed to retweet")
                callback()
                // revert the optimistic API call
                self.getSource().retweetCount! -= 1
            }
        )
    }

    func unretweet(callback: () -> Void) {
        self.retweet?.destroy({
            (response: AnyObject!, error: NSError!) -> Void in
            callback()
            if response != nil {
                NSLog("Successfully unretweeted")
            } else if error != nil {
                NSLog("Failed to unretweet")
                // revert the optimistic API call
                self.getSource().retweetCount! += 1
            }
        })
    }

    func toggleFavorite(callback: () -> Void) {
        self.favorited! = !self.favorited!
        if self.favorited! == true {
            self.getSource().favoriteCount! += 1
            self.favorite(callback)
        } else {
            self.unfavorite(callback)
            self.getSource().favoriteCount! -= 1
        }
    }

    func favorite(callback: () -> Void) {
        var params: [String:AnyObject] = [
            "id" : self.id!,
        ]
        TwitterClient.sharedInstance.POST(
            TWITTER_API_FAVORITES_CREATE_RESOURCE,
            parameters: params,
            success: {
                (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("Successfully favorited")
                callback()
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
                NSLog("Failed to favorite")
                callback()
                // revert the optimistic API call
                self.getSource().favoriteCount! -= 1
            }
        )
    }

    func unfavorite(callback: () -> Void) {
        var params: [String:AnyObject] = ["id" : self.id!]
        TwitterClient.sharedInstance.POST(
            TWITTER_API_FAVORITES_DESTROY_RESOURCE,
            parameters: params,
            success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("Successfully unfavorited")
                callback()
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
                NSLog("Failed to favorite")
                callback()
                // revert the optimistic API call
                self.getSource().favoriteCount! += 1
            }
        )
    }

}

//{
//    contributors = "<null>";
//    coordinates = "<null>";
//    "created_at" = "Tue Sep 30 19:57:18 +0000 2014";
//    entities =     {
//        hashtags =         (
//        );
//        media =         (
//            {
//                "display_url" = "pic.twitter.com/hATh2M5jDW";
//                "expanded_url" = "http://twitter.com/crunchbase/status/517040509525565440/photo/1";
//                id = 517040508623785984;
//                "id_str" = 517040508623785984;
//                indices =                 (
//                    122,
//                    144
//                );
//                "media_url" = "http://pbs.twimg.com/media/ByzlmmsCEAAhzHz.png";
//                "media_url_https" = "https://pbs.twimg.com/media/ByzlmmsCEAAhzHz.png";
//                sizes =                 {
//                    large =                     {
//                        h = 348;
//                        resize = fit;
//                        w = 408;
//                    };
//                    medium =                     {
//                        h = 348;
//                        resize = fit;
//                        w = 408;
//                    };
//                    small =                     {
//                        h = 290;
//                        resize = fit;
//                        w = 340;
//                    };
//                    thumb =                     {
//                        h = 150;
//                        resize = crop;
//                        w = 150;
//                    };
//                };
//                type = photo;
//                url = "http://t.co/hATh2M5jDW";
//            }
//        );
//        symbols =         (
//        );
//        urls =         (
//            {
//                "display_url" = "bit.ly/1rDF5kV";
//                "expanded_url" = "http://bit.ly/1rDF5kV";
//                indices =                 (
//                    99,
//                    121
//                );
//                url = "http://t.co/R68NqOUfwK";
//            }
//        );
//        "user_mentions" =         (
//        );
//    };
//    "extended_entities" =     {
//        media =         (
//            {
//                "display_url" = "pic.twitter.com/hATh2M5jDW";
//                "expanded_url" = "http://twitter.com/crunchbase/status/517040509525565440/photo/1";
//                id = 517040508623785984;
//                "id_str" = 517040508623785984;
//                indices =                 (
//                    122,
//                    144
//                );
//                "media_url" = "http://pbs.twimg.com/media/ByzlmmsCEAAhzHz.png";
//                "media_url_https" = "https://pbs.twimg.com/media/ByzlmmsCEAAhzHz.png";
//                sizes =                 {
//                    large =                     {
//                        h = 348;
//                        resize = fit;
//                        w = 408;
//                    };
//                    medium =                     {
//                        h = 348;
//                        resize = fit;
//                        w = 408;
//                    };
//                    small =                     {
//                        h = 290;
//                        resize = fit;
//                        w = 340;
//                    };
//                    thumb =                     {
//                        h = 150;
//                        resize = crop;
//                        w = 150;
//                    };
//                };
//                type = photo;
//                url = "http://t.co/hATh2M5jDW";
//            }
//        );
//    };
//    "favorite_count" = 1;
//    favorited = 0;
//    geo = "<null>";
//    id = 517040509525565440;
//    "id_str" = 517040509525565440;
//    "in_reply_to_screen_name" = "<null>";
//    "in_reply_to_status_id" = "<null>";
//    "in_reply_to_status_id_str" = "<null>";
//    "in_reply_to_user_id" = "<null>";
//    "in_reply_to_user_id_str" = "<null>";
//    lang = en;
//    place = "<null>";
//    "possibly_sensitive" = 0;
//    "retweet_count" = 6;
//    retweeted = 0;
//    source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
//    text = "Recent investments &amp; new startups indicate growing interest towards Google Glass in healthcare http://t.co/R68NqOUfwK http://t.co/hATh2M5jDW";
//    truncated = 0;
//    user =     {
//        "contributors_enabled" = 0;
//        "created_at" = "Wed Apr 02 01:07:12 +0000 2008";
//        "default_profile" = 0;
//        "default_profile_image" = 0;
//        description = "CrunchBase is the world\U2019s most comprehensive dataset of startup activity and it\U2019s accessible to everyone.";
//        entities =         {
//            description =             {
//                urls =                 (
//                );
//            };
//            url =             {
//                urls =                 (
//                    {
//                        "display_url" = "crunchbase.com";
//                        "expanded_url" = "http://www.crunchbase.com";
//                        indices =                         (
//                            0,
//                            22
//                        );
//                        url = "http://t.co/2sOf3bjuA7";
//                    }
//                );
//            };
//        };
//        "favourites_count" = 159;
//        "follow_request_sent" = 0;
//        "followers_count" = 31183;
//        following = 1;
//        "friends_count" = 22424;
//        "geo_enabled" = 1;
//        id = 14279577;
//        "id_str" = 14279577;
//        "is_translation_enabled" = 0;
//        "is_translator" = 0;
//        lang = en;
//        "listed_count" = 1083;
//        location = "San Francisco";
//        name = CrunchBase;
//        notifications = 0;
//        "profile_background_color" = C0DEED;
//        "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
//        "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
//        "profile_background_tile" = 0;
//        "profile_banner_url" = "https://pbs.twimg.com/profile_banners/14279577/1398278857";
//        "profile_image_url" = "http://pbs.twimg.com/profile_images/458740928761446401/O2mWKocb_normal.png";
//        "profile_image_url_https" = "https://pbs.twimg.com/profile_images/458740928761446401/O2mWKocb_normal.png";
//        "profile_link_color" = 2992A7;
//        "profile_sidebar_border_color" = C0DEED;
//        "profile_sidebar_fill_color" = DDEEF6;
//        "profile_text_color" = 333333;
//        "profile_use_background_image" = 1;
//        protected = 0;
//        "screen_name" = crunchbase;
//        "statuses_count" = 2171;
//        "time_zone" = "Pacific Time (US & Canada)";
//        url = "http://t.co/2sOf3bjuA7";
//        "utc_offset" = "-25200";
//        verified = 0;
//    };
//}
