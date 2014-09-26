//
//  RottenTomatoesClient.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

let ROTTEN_TOMATOES_API_BOX_OFFICE_MOVIES_URL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=\(ROTTEN_TOMATOES_API_KEY)&limit=30&country=us"
let ROTTEN_TOMATOES_API_TOP_RENTALS_URL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=\(ROTTEN_TOMATOES_API_KEY)&limit=30"

enum RottenTomatoesApiMovieType  {
    case Movies
    case DVDs
}

var ROTTEN_TOMATOES_MOVIE_CACHE = Dictionary<String, RottenTomatoesMovie>()

class RottenTomatoesClient {

    class func getMovies(movieType:RottenTomatoesApiMovieType, callback: ([RottenTomatoesMovie]) -> ()) {
        var apiUrl:String
        switch movieType {
        case .Movies:
            apiUrl = ROTTEN_TOMATOES_API_BOX_OFFICE_MOVIES_URL
        case .DVDs:
            apiUrl = ROTTEN_TOMATOES_API_TOP_RENTALS_URL
        }
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(apiUrl))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) in
            var errorValue: NSError? = nil
            let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue)
            if parsedResult != nil {
                let moviesResultDictionary = parsedResult! as NSDictionary
                let movieDictionaries = moviesResultDictionary["movies"] as? [NSDictionary]
                var movies = movieDictionaries?.map({
                    (movieDictionary: NSDictionary) -> RottenTomatoesMovie in
                    let movie = RottenTomatoesClient.getMovieInstance(movieDictionary as NSDictionary)
                    return movie
                })
                callback(movies!)
            } else {
                HTKNotificationUtils.displayNetworkErrorMessage()
            }
        })
    }

    class func getMovieInstance(movieDictionary: NSDictionary) -> RottenTomatoesMovie {
        let movieId = movieDictionary["id"] as NSString
        var movie: RottenTomatoesMovie?
        if let movieInstance = ROTTEN_TOMATOES_MOVIE_CACHE[movieId] {
            movie = movieInstance
        } else {
            movie = RottenTomatoesMovie(movieDictionary: movieDictionary)
            ROTTEN_TOMATOES_MOVIE_CACHE[movieId] = movie
        }
        return movie!
    }
}
