//
//  Tweet.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var tweetDictionary: NSDictionary!

    var user: TwitterUser?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?

    init(tweetDictionary: NSDictionary) {
        self.tweetDictionary = tweetDictionary

        var userDictionary = tweetDictionary["user"] as NSDictionary
        user = TwitterUser(userDictionary: userDictionary)
        self.text = tweetDictionary["text"] as? String
        self.createdAtString = tweetDictionary["created_at"] as? String

        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.createdAt = formatter.dateFromString(createdAtString!)
    }

    class func tweetsWithArray(tweetDictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = tweetDictionaries.map {
            (tweetDictionary: NSDictionary) -> Tweet in
            Tweet(tweetDictionary: tweetDictionary)
        }
        return tweets
    }
}
