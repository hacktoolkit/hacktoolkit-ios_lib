//
//  YelpBusinessResult.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class YelpBusinessResult {
    var businessDict: NSDictionary

    var id: String!
    var name: String!
    //    var displayPhone: String
    var imageUrl: String!
    //    // location
    ////    var address: String
    //    var city: String
    //    var state: String
    //    var zipcode: Int
    //    var country: String
    //    // urls
    //    var url: String
    //    var mobileUrl: String

    var categories: [YelpCategory]!
    var rating: Int!
    var ratingImageUrl: String!
    var reviewCount: Int!

    init(businessDict: NSDictionary) {
        self.businessDict = businessDict

        self.id = businessDict["id"] as? String
        self.name = businessDict["name"] as? String
        //        self.displayPhone = businessDict["display_phone"] as String
        self.imageUrl = businessDict["image_url"] as? String
        //
        //        // location
        //        var location = businessDict["location"] as NSDictionary
        //        self.city = location["city"] as String
        //        self.state = location["state_code"] as String
        //        self.zipcode = location["postal_code"] as Int
        //        self.country = location["country_code"] as String
        //
        //        // urls
        //        self.url = businessDict["url"] as String
        //        self.mobileUrl = businessDict["mobile_url"] as String

        var categoriesArray = businessDict["categories"] as? [NSArray]
        var categories = categoriesArray?.map({
            (categoryArray: NSArray) -> YelpCategory in
            YelpCategory(categoryArray: categoryArray)
        })
        self.categories = categories
        self.rating = businessDict["rating"] as? Int
        self.ratingImageUrl = businessDict["rating_img_url"] as? String
        self.reviewCount = businessDict["review_count"] as? Int
    }

    func getCategoriesAsString() -> String {
        let categoryStrings = self.categories.map({
            (category: YelpCategory) -> String in
            category.categoryName
        })
        let strValue = ", ".join(categoryStrings)
        return strValue
    }

    class func searchWithQuery(query: String, callback: ([YelpBusinessResult]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(
            query,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                // println(response)
                var results = (response as NSDictionary)["businesses"] as [NSDictionary]
                var businesses = results.map({
                    (businessDict: NSDictionary) -> YelpBusinessResult in
                    YelpBusinessResult(businessDict: businessDict)
                })
                callback(businesses, nil)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                // println(error)
                callback(nil, error)
            }
        )
    }
    /*
    {
    categories =             (
    (
    Thai,
    thai
    )
    );
    "display_phone" = "+1-415-674-7515";
    id = "sweet-lime-thai-cuisine-san-francisco";
    "image_url" = "http://s3-media1.fl.yelpcdn.com/bphoto/TC6RJbwMMDqkwTmxdoin5A/ms.jpg";
    "is_claimed" = 1;
    "is_closed" = 0;
    location =             {
    address =                 (
    "2100 Sutter St"
    );
    city = "San Francisco";
    "country_code" = US;
    "cross_streets" = "Steiner St & Pierce St";
    "display_address" =                 (
    "2100 Sutter St",
    "Lower Pacific Heights",
    "San Francisco, CA 94115"
    );
    neighborhoods =                 (
    "Lower Pacific Heights"
    );
    "postal_code" = 94115;
    "state_code" = CA;
    };
    "menu_date_updated" = 1402620068;
    "menu_provider" = eat24;
    "mobile_url" = "http://m.yelp.com/biz/sweet-lime-thai-cuisine-san-francisco";
    name = "Sweet Lime Thai Cuisine";
    phone = 4156747515;
    rating = 4;
    "rating_img_url" = "http://s3-media4.fl.yelpcdn.com/assets/2/www/img/c2f3dd9799a5/ico/stars/v1/stars_4.png";
    "rating_img_url_large" = "http://s3-media2.fl.yelpcdn.com/assets/2/www/img/ccf2b76faa2c/ico/stars/v1/stars_large_4.png";
    "rating_img_url_small" = "http://s3-media4.fl.yelpcdn.com/assets/2/www/img/f62a5be2f902/ico/stars/v1/stars_small_4.png";
    "review_count" = 214;
    "snippet_image_url" = "http://s3-media2.fl.yelpcdn.com/photo/QoZgYeVEdHG3w-dsd4w_Aw/ms.jpg";
    "snippet_text" = "I tried delivery for the first time. I had the vegan crispy roll, which had good flavor, but was very small in portion. It was much smaller than most spring...";
    url = "http://www.yelp.com/biz/sweet-lime-thai-cuisine-san-francisco";
    },*/
}
