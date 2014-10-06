//
//  HTKImageUtils.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class HTKImageUtils {
    var imageCache = [String: UIImage]()

    class var sharedInstance : HTKImageUtils {
    struct Static {
        static var token : dispatch_once_t = 0
        static var instance : HTKImageUtils? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = HTKImageUtils()
        }
        return Static.instance!
    }

    func displayImageUrl(imageUrl: String, imageView: UIImageView) {
        var urlRequest = NSURLRequest(URL: NSURL(string: imageUrl))
        imageView.setImageWithURLRequest(
            urlRequest,
            placeholderImage: nil,
            success: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                imageView.image = image
                self.storeImageToCache(imageUrl, image: image)
            },
            failure: {
                (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                HTKNotificationUtils.displayNetworkErrorMessage()
            }
        )
    }

    func storeImageToCache(imageUrl: String, image: UIImage) {
        self.imageCache[imageUrl] = image
    }

    class func getLocalImage(resource: String, ofType imageType: String) -> UIImage {
        var imagePath = NSBundle.mainBundle().pathForResource(resource, ofType: imageType)
        var image = UIImage(contentsOfFile: imagePath!)
        return image
    }
}
