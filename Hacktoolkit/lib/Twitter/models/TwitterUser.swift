//
//  TwitterUser.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

var _currentTwitterUser: TwitterUser?
let TWITTER_CURRENT_USER_KEY = "kTwitterCurrentUserKey"
let TWITTER_USER_DID_LOGIN_NOTIFICATION = "twitterUserDidLoginNotification"
let TWITTER_USER_DID_LOGOUT_NOTIFICATION = "twitterUserDidLogoutNotification"

class TwitterUser: NSObject {
    var userDictionary: NSDictionary

    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var location: String?

    init(userDictionary: NSDictionary) {
        self.userDictionary = userDictionary

        name = userDictionary["name"] as? String
        screenname = userDictionary["screen_name"] as? String
        profileImageUrl = userDictionary["profile_image_url"] as? String
        tagline = userDictionary["description"] as? String
        location = userDictionary["location"] as? String
    }

    class var currentUser: TwitterUser? {
        get {
            if _currentTwitterUser == nil {
                var data = HTKUtils.getDefaults(TWITTER_CURRENT_USER_KEY) as? NSData
                if data != nil {
                    var userDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentTwitterUser = TwitterUser(userDictionary: userDictionary)
                }
            }
            return _currentTwitterUser
        }

        set (user) {
            _currentTwitterUser = user
            if _currentTwitterUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.userDictionary, options: nil, error: nil)
                HTKUtils.setDefaults(TWITTER_CURRENT_USER_KEY, withValue: data)
            } else {
                HTKUtils.setDefaults(TWITTER_CURRENT_USER_KEY, withValue: nil)
            }
        }
    }

    func logout() {
        TwitterUser.currentUser = nil
        TwitterClient.sharedInstance.logout()
        NSNotificationCenter.defaultCenter().postNotificationName(TWITTER_USER_DID_LOGOUT_NOTIFICATION, object: nil)
    }
}

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

