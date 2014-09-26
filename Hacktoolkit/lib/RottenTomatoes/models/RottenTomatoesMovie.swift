//
//  RottenTomatoesMovie.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class RottenTomatoesMovie {
    //    var movieDictionary: NSDictionary

    var id: String
    var title: String
    var year: Int
    var mpaaRating: String
    var synopsis: String
    // posters
    var thumbnailPosterUrl: String
    var profilePosterUrl: String
    var detailedPosterUrl: String
    var originalPosterUrl: String
    // ratings
    var criticsRating: String
    var criticsScore: Int
    var audienceRating: String
    var audienceScore: Int

    var imageCache = Dictionary<String, UIImage>()

    init(movieDictionary: NSDictionary) {
        //        self.movieDictionary = movieDictionary
        self.id = movieDictionary["id"] as? NSString ?? ""
        self.title = movieDictionary["title"] as? NSString ?? ""
        self.year = movieDictionary["year"] as? Int ?? 0
        self.mpaaRating = movieDictionary["mpaa_rating"] as? NSString ?? ""
        self.synopsis = movieDictionary["synopsis"] as? NSString ?? ""

        // movie posters
        let posters = movieDictionary["posters"] as NSDictionary
        self.thumbnailPosterUrl = posters["thumbnail"] as? NSString ?? ""
        self.profilePosterUrl = (posters["profile"] as? NSString ?? "").stringByReplacingOccurrencesOfString("_tmb", withString: "_pro")
        self.detailedPosterUrl = (posters["detailed"] as? NSString ?? "").stringByReplacingOccurrencesOfString("_tmb", withString: "_det")
        self.originalPosterUrl = (posters["original"] as? NSString ?? "").stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")

        // ratings
        let ratings = movieDictionary["ratings"] as NSDictionary
        self.criticsRating = ratings["critics_rating"] as? NSString ?? ""
        self.criticsScore = ratings["critics_score"] as? Int ?? 0
        self.audienceRating = ratings["audience_rating"] as? NSString ?? ""
        self.audienceScore = ratings["audience_score"] as? Int ?? 0
    }

    func getImageFromCache(imageUrl: String) -> UIImage? {
        var image = self.imageCache[self.thumbnailPosterUrl]
        return image
    }

    func storeImageToCache(imageUrl: String, image: UIImage) {
        self.imageCache[imageUrl] = image
    }

    func displayThumbnailPosterIn(imageView: UIImageView) {
        var urlRequest = NSURLRequest(URL: NSURL(string: self.thumbnailPosterUrl))
        imageView.setImageWithURLRequest(
            urlRequest,
            placeholderImage: nil,
            success: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                imageView.image = image
                self.storeImageToCache(self.thumbnailPosterUrl, image: image)
            },
            failure: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
            }
        )
    }

    func displayOriginalPosterIn(imageView: UIImageView) {
        var urlRequest = NSURLRequest(URL: NSURL(string: self.originalPosterUrl))
        imageView.setImageWithURLRequest(
            urlRequest,
            placeholderImage: self.getImageFromCache(self.thumbnailPosterUrl),
            success: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                imageView.image = image
                self.storeImageToCache(self.originalPosterUrl, image: image)
            },
            failure: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
            }
        )
    }
}
