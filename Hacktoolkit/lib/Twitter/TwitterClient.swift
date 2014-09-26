//
//  TwitterClient.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

let TWITTER_API_CONSUMER_KEY = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_CONSUMER_KEY")
let TWITTER_API_CONSUMER_SECRET = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_CONSUMER_SECRET")
let TWITTER_API_TOKEN = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_TOKEN")
let TWITTER_API_TOKEN_SECRET = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_TOKEN_SECRET")

let TWITTER_API_OAUTH1_AUTHENTICATE_URL = "https://api.twitter.com/oauth/authenticate"
let TWITTER_API_OAUTH2_TOKEN_URL = "https://api.twitter.com/oauth2/token"
let TWITTER_API_USER_TIMELINE_URL = "https://api.twitter.com/1.1/statuses/user_timeline.json"

class TwitterClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class var sharedInstance : TwitterClient {
    struct Static {
        static var token : dispatch_once_t = 0
        static var instance : TwitterClient? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = TwitterClient(
                consumerKey: TWITTER_API_CONSUMER_KEY,
                consumerSecret: TWITTER_API_CONSUMER_SECRET,
                accessToken: TWITTER_API_TOKEN,
                accessSecret: TWITTER_API_TOKEN_SECRET
            )
        }
        return Static.instance!
    }

    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret

        var baseUrl = NSURL(string: TWITTER_API_OAUTH1_AUTHENTICATE_URL)
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret)

        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

    func getTimelineForUsername(username: String, callback: ([Tweet]) -> Void) {
        // For documenation see: https://dev.twitter.com/rest/reference/get/statuses/user_timeline
        var parameters = [
            "screen_name" : username,
        ]

        self.GET(
            TWITTER_API_USER_TIMELINE_URL,
            parameters: parameters,
            success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweetDictionaries = response as [NSDictionary]
                var tweets = tweetDictionaries.map {
                    (tweetDictionary: NSDictionary) -> Tweet in
                    Tweet(tweetDictionary: tweetDictionary)
                }
                callback(tweets)
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
            }
        )
    }
}
