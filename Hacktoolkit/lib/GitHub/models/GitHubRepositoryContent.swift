//
//  GitHubRepositoryContent.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

enum GitHubRepositoryContentType {
    case File
    case Directory
}

class GitHubRepositoryContent: GitHubResource {
    // represents a file or directory

    var contentType: GitHubRepositoryContentType

    // Content attributes
    var path: String!
    var htmlUrl: String!

    init(forFile fileDict: NSDictionary) {
        self.contentType = GitHubRepositoryContentType.File
        self.path = fileDict["path"] as? String
        self.htmlUrl = fileDict["html_url"] as? String
    }
}

//{
//    "type": "file",
//    "encoding": "base64",
//    "size": 5362,
//    "name": "README.md",
//    "path": "README.md",
//    "content": "encoded content ...",
//    "sha": "3d21ec53a331a6f037a91c368710b99387d012c1",
//    "url": "https://api.github.com/repos/pengwynn/octokit/contents/README.md",
//    "git_url": "https://api.github.com/repos/pengwynn/octokit/git/blobs/3d21ec53a331a6f037a91c368710b99387d012c1",
//    "html_url": "https://github.com/pengwynn/octokit/blob/master/README.md",
//    "_links": {
//        "git": "https://api.github.com/repos/pengwynn/octokit/git/blobs/3d21ec53a331a6f037a91c368710b99387d012c1",
//        "self": "https://api.github.com/repos/pengwynn/octokit/contents/README.md",
//        "html": "https://github.com/pengwynn/octokit/blob/master/README.md"
//    }
//}
