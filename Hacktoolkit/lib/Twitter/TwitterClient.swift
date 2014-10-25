//
//  TwitterClient.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

let TWEET_LENGTH_LIMIT = 140

let TWITTER_API_CONSUMER_KEY = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_CONSUMER_KEY")
let TWITTER_API_CONSUMER_SECRET = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_CONSUMER_SECRET")
let TWITTER_API_TOKEN = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_TOKEN")
let TWITTER_API_TOKEN_SECRET = HTKUtils.getStringFromInfoBundleForKey("TWITTER_API_TOKEN_SECRET")

let TWITTER_API_BASE_URL = "https://api.twitter.com"
// oauth resources
let TWITTER_API_OAUTH1_REQUEST_TOKEN_RESOURCE = "/oauth/request_token"
let TWITTER_API_OAUTH1_AUTHENTICATE_RESOURCE = "/oauth/authenticate"
let TWITTER_API_OAUTH1_ACCESS_TOKEN_RESOURCE = "/oauth/access_token"
let TWITTER_API_OAUTH2_TOKEN_RESOURCE = "/oauth2/token"

// api resources
let TWITTER_API_RESOURCE_SUFFIX = ".json"
// account
let TWITTER_API_VERIFY_CREDENTIALS_RESOURCE = "/1.1/account/verify_credentials.json"
// timelines
let TWITTER_API_HOME_TIMELINE_RESOURCE = "/1.1/statuses/home_timeline.json"
let TWITTER_API_USER_TIMELINE_RESOURCE = "/1.1/statuses/user_timeline.json"
// statuses (tweets)
let TWITTER_API_STATUSES_UPDATE_RESOURCE = "/1.1/statuses/update.json"
let TWITTER_API_STATUSES_DESTROY_RESOURCE_PREFIX = "/1.1/statuses/destroy/"
let TWITTER_API_STATUSES_RETWEET_RESOURCE_PREFIX = "/1.1/statuses/retweet/"
// favorites
let TWITTER_API_FAVORITES_CREATE_RESOURCE = "/1.1/favorites/create.json"
let TWITTER_API_FAVORITES_DESTROY_RESOURCE = "/1.1/favorites/destroy.json"

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: TwitterUser?, error: NSError?) -> ())?

    var accessToken: String!
    var accessSecret: String!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: NSURL(string: TWITTER_API_BASE_URL)!,
                consumerKey: TWITTER_API_CONSUMER_KEY,
                consumerSecret: TWITTER_API_CONSUMER_SECRET
            )
        }
        return Static.instance
    }

    override init(baseURL: NSURL, consumerKey: String!, consumerSecret: String!) {
        super.init(baseURL: baseURL, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }

    // authenticatedSharedInstance uses the app's own access token and secret
    class var authenticatedSharedInstance : TwitterClient {
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

        var baseURL = NSURL(string: TWITTER_API_OAUTH1_AUTHENTICATE_RESOURCE)
        super.init(baseURL: baseURL, consumerKey: key, consumerSecret: secret)

        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

    func login(url: String, path: String, completion: (user: TwitterUser?, error: NSError?) -> Void) {
        // perform any logout actions before trying to log in
        self.logout()

        self.loginCompletion = completion

        // Fetch request token & redirect to authorization page
        self.fetchRequestTokenWithPath(
            TWITTER_API_OAUTH1_REQUEST_TOKEN_RESOURCE,
            method: "GET",
            callbackURL: NSURL(string:"\(url)://\(path)"),
            scope: nil,
            success: {
                (requestToken: BDBOAuthToken!) -> Void in
                NSLog("Got the request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }, failure: {
                (error: NSError!) -> Void in
                NSLog("Error getting the request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }

    func logout() {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    }

    func openURL(url: NSURL) {
        // called by AppDelegate.application(..., openURL: ...)
        self.fetchAccessTokenWithPath(
            TWITTER_API_OAUTH1_ACCESS_TOKEN_RESOURCE,
            method: "POST",
            requestToken: BDBOAuthToken(queryString: url.query),
            success: {
                (accessToken: BDBOAuthToken!) -> Void in
                NSLog("Got the access token")
                self.requestSerializer.saveAccessToken(accessToken)
                self.verifyCredentials()
            }, failure: {
                (error: NSError!) -> Void in
                NSLog("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }

    func verifyCredentials() {
        self.GET(
            TWITTER_API_VERIFY_CREDENTIALS_RESOURCE,
            parameters: nil,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = TwitterUser(userDictionary: response as NSDictionary)
                TwitterUser.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error verifying credentials")
                HTKNotificationUtils.displayNetworkErrorMessage()
            }
        )
    }

    // timelines

    func getHomeTimelineWithParams(params: [String:AnyObject]?, callback: (tweets: [Tweet]?, error: NSError?) -> Void) {
        // https://dev.twitter.com/rest/reference/get/statuses/home_timeline
        NSLog("Getting home timeline")
        TwitterClient.sharedInstance.GET(
            TWITTER_API_HOME_TIMELINE_RESOURCE,
            parameters: params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("Got home timeline")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                callback(tweets: tweets, error: nil)
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error getting home timeline")
                HTKNotificationUtils.displayNetworkErrorMessage()
                callback(tweets: nil, error: error)
            }
        )
    }

    func getTimelineForUsername(username: String, var params: [String:AnyObject]?, callback: (tweets: [Tweet]?, error: NSError?) -> Void) {
        // For documenation see: https://dev.twitter.com/rest/reference/get/statuses/user_timeline
        if params == nil {
            params = [String:AnyObject]()
        }
        params!["screen_name"] = username

        NSLog("Getting user timeline: \(username)")
        self.GET(
            TWITTER_API_USER_TIMELINE_RESOURCE,
            parameters: params,
            success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                NSLog("Got user timeline: \(username)")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                callback(tweets: tweets, error: nil)
            },
            failure: {
                (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
                callback(tweets: nil, error: error)
            }
        )
    }
}
