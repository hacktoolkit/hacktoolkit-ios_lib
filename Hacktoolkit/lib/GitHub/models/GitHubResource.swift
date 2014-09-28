//
//  GitHubResource.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class GitHubResource {
    var inflated = false
    var onInflated: ((GitHubResource) -> ())!

    init(onInflated: ((GitHubResource) -> ())? = nil) {
        self.onInflated = onInflated
        self.inflate()
    }

    func inflate() {
        var resource = self.getResourceURL()
        if resource != "" {
            GitHubClient.sharedInstance.makeApiRequest(resource, callback: self.inflater)
        }
    }

    // get the relative path URL for this resource
    func getResourceURL() -> String {
        return ""
    }

    func inflater(result : AnyObject) {
        self.inflated = true
        if self.onInflated != nil {
            self.onInflated(self)
        }
    }
}
