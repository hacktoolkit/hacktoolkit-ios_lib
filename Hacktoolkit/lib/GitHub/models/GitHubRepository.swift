//
//  GitHubRepository.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class GitHubRepository: GitHubResource {

    // Repository attributes
    var name: String!
    var fullName: String!
    var description: String!
    var url: String!
    var htmlUrl: String!
    var cloneUrl: String!
    var gitUrl: String!
    var sshUrl: String!
    var mirrorUrl: String!
    var homepage: String!
    var forksCount: Int!
    var stargazersCount: Int!
    var watchersCount: Int!
    var size: Int!
    //    "size": 108,
    //    "default_branch": "master",
    //    "open_issues_count": 0,
    //    "has_issues": true,
    //    "has_wiki": true,
    //    "has_pages": false,
    //    "has_downloads": true,
    //    "pushed_at": "2011-01-26T19:06:43Z",
    //    "created_at": "2011-01-26T19:01:12Z",
    //    "updated_at": "2011-01-26T19:14:43Z",

    // Repository relations
    var organizationOwner: GitHubOrganization!
    var userOwner: GitHubUser!
    var readme: GitHubRepositoryContent!

    init(repositoryDict: NSDictionary) {
        self.name = repositoryDict["name"] as? String
        self.fullName = repositoryDict["full_name"] as? String
        self.description = repositoryDict["description"] as? String
        self.url = repositoryDict["url"] as? String
        self.htmlUrl = repositoryDict["html_url"] as? String
        self.cloneUrl = repositoryDict["clone_url"] as? String
        self.gitUrl = repositoryDict["git_url"] as? String
        self.sshUrl = repositoryDict["ssh_url"] as? String
        self.mirrorUrl = repositoryDict["mirror_url"] as? String
        self.homepage = repositoryDict["homepage"] as? String
        self.forksCount = repositoryDict["forks_count"] as? Int
        self.stargazersCount = repositoryDict["stargazers_count"] as? Int
        self.watchersCount = repositoryDict["watchers_count"] as? Int
        self.size = repositoryDict["size"] as? Int

        if let ownerDict = repositoryDict["owner"] as? NSDictionary {
//            NSLog(ownerDict)
            var ownerType = ownerDict["type"] as? String
            if ownerType == "Organization" {
                var organizationOwner = GitHubOrganization(fromDict: ownerDict)
                self.organizationOwner = organizationOwner
            } else {
                var userOwner = GitHubUser(fromDict: ownerDict)
                self.userOwner = userOwner
            }
        }

        super.init()
    }

    override func getResourceURL() -> String {
        var resource = ""
        var ownerLogin = self.getOwnerLogin()
        if ownerLogin != "" {
            resource = "/repos/\(ownerLogin)/\(self.name)"
        }
        return resource
    }

    func getOwnerLogin() -> String {
        var ownerLogin = ""
        if self.organizationOwner != nil {
            ownerLogin = self.organizationOwner.login
        } else if self.userOwner != nil {
            ownerLogin = self.userOwner.login
        }
        return ownerLogin
    }

    func getReadme() {
        var resource = "\(self.getResourceURL())/readme"
        GitHubClient.sharedInstance.makeApiRequest(resource, callback: {
            (result: AnyObject) -> () in
            if let fileDict = result as? NSDictionary {
                NSLog("Got README")
                self.readme = GitHubRepositoryContent(forFile: fileDict)
            }
        })
    }

    func getReadmeUrl() -> String {
        var readmeUrl = "\(self.htmlUrl)/blob/master/README.md"
        return readmeUrl
    }
}

//{
//    "id": 1296269,
//    "owner": {
//        "login": "octocat",
//        "id": 1,
//        "avatar_url": "https://github.com/images/error/octocat_happy.gif",
//        "gravatar_id": "somehexcode",
//        "url": "https://api.github.com/users/octocat",
//        "html_url": "https://github.com/octocat",
//        "followers_url": "https://api.github.com/users/octocat/followers",
//        "following_url": "https://api.github.com/users/octocat/following{/other_user}",
//        "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
//        "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
//        "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
//        "organizations_url": "https://api.github.com/users/octocat/orgs",
//        "repos_url": "https://api.github.com/users/octocat/repos",
//        "events_url": "https://api.github.com/users/octocat/events{/privacy}",
//        "received_events_url": "https://api.github.com/users/octocat/received_events",
//        "type": "User",
//        "site_admin": false
//    },
//    "name": "Hello-World",
//    "full_name": "octocat/Hello-World",
//    "description": "This your first repo!",
//    "private": false,
//    "fork": true,
//    "url": "https://api.github.com/repos/octocat/Hello-World",
//    "html_url": "https://github.com/octocat/Hello-World",
//    "clone_url": "https://github.com/octocat/Hello-World.git",
//    "git_url": "git://github.com/octocat/Hello-World.git",
//    "ssh_url": "git@github.com:octocat/Hello-World.git",
//    "svn_url": "https://svn.github.com/octocat/Hello-World",
//    "mirror_url": "git://git.example.com/octocat/Hello-World",
//    "homepage": "https://github.com",
//    "language": null,
//    "forks_count": 9,
//    "stargazers_count": 80,
//    "watchers_count": 80,
//    "size": 108,
//    "default_branch": "master",
//    "open_issues_count": 0,
//    "has_issues": true,
//    "has_wiki": true,
//    "has_pages": false,
//    "has_downloads": true,
//    "pushed_at": "2011-01-26T19:06:43Z",
//    "created_at": "2011-01-26T19:01:12Z",
//    "updated_at": "2011-01-26T19:14:43Z",
//    "permissions": {
//        "admin": false,
//        "push": false,
//        "pull": true
//    }
//}
