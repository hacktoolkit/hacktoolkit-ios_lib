//
//  Tweet.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class Tweet {
    var tweetDictionary: NSDictionary!

    var text: String!

    init(tweetDictionary: NSDictionary) {
        self.tweetDictionary = tweetDictionary

        self.text = tweetDictionary["text"] as? String
    }
}
