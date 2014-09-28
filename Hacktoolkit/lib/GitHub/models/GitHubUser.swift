//
//  GitHubUser.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class GitHubUser: GitHubResource {

    // User attributes
    var login: String!
    var id: Int!
    var avatar_url: String!
    var gravatar_id: String!
    var url: String!
    var html_url: String!
    var followers_url: String!
    var following_url: String!
    var gists_url: String!
    var starred_url: String!
    var subscriptions_url: String!
    var organizations_url: String!
    var name: String!
    var company: String!
    var blog: String!
    var location: String!
    var email: String!
    var bio: String!
    var public_repos: Int!
    var public_gists: Int!
    var followers: Int!
    var following: Int!
    init() {
        
    }

    init(fromDict userDict: NSDictionary) {
        self.login = userDict["login"] as? String
        self.id = userDict["id"] as? Int
        self.avatar_url = userDict["avatar_url"] as? String
        self.gravatar_id = userDict["gravatar_id"] as? String
        self.url = userDict["url"] as? String
        self.html_url = userDict["html_url"] as? String
        self.followers_url = userDict["followers_url"] as? String
        self.following_url = userDict["following_url"] as? String
        self.gists_url = userDict["gists_url"] as? String
        self.starred_url = userDict["starred_url"] as? String
        self.subscriptions_url = userDict["subscriptions_url"] as? String
        self.organizations_url = userDict["organizations_url"] as? String
        self.name = userDict["name"] as? String
        self.company = userDict["company"] as? String
        self.blog = userDict["blog"] as? String
        self.location = userDict["location"] as? String
        self.email = userDict["email"] as? String
        self.bio = userDict["bio"] as? String
        self.public_repos = userDict["public_repos"] as? Int
        self.public_gists = userDict["public_gists"] as? Int
        self.followers = userDict["followers"] as? Int
        self.following = userDict["following"] as? Int
    }
}

//{
//    "login": "octocat",
//    "id": 1,
//    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
//    "gravatar_id": "somehexcode",
//    "url": "https://api.github.com/users/octocat",
//    "html_url": "https://github.com/octocat",
//    "followers_url": "https://api.github.com/users/octocat/followers",
//    "following_url": "https://api.github.com/users/octocat/following{/other_user}",
//    "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
//    "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
//    "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
//    "organizations_url": "https://api.github.com/users/octocat/orgs",
//    "repos_url": "https://api.github.com/users/octocat/repos",
//    "events_url": "https://api.github.com/users/octocat/events{/privacy}",
//    "received_events_url": "https://api.github.com/users/octocat/received_events",
//    "type": "User",
//    "site_admin": false,
//    "name": "monalisa octocat",
//    "company": "GitHub",
//    "blog": "https://github.com/blog",
//    "location": "San Francisco",
//    "email": "octocat@github.com",
//    "hireable": false,
//    "bio": "There once was...",
//    "public_repos": 2,
//    "public_gists": 1,
//    "followers": 20,
//    "following": 0,
//    "created_at": "2008-01-14T04:33:35Z",
//    "updated_at": "2008-01-14T04:33:35Z"
//}
