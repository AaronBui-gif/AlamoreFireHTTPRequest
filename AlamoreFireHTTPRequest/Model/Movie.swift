//
//  Movie.swift
//  AlamoreFireHTTPRequest
//
//  Created by Huy Bui Thanh on 23/09/2022.
//

import Foundation
import SwiftUI

// MARK: Movie
struct Movie: Decodable, Hashable, Identifiable{
    let movieID: Int
    var id: Int { movieID }
    let title, publishedDate, categories, youtubeID: String
    let imageName: String
    let rating: Double
    let welcomeDescription, creator: String
    let castList: [CastList]
    let genreList: [GenreList]

    enum CodingKeys: String, CodingKey {
        case movieID = "movieId"
        case title, publishedDate, categories, youtubeID, imageName, rating
        case welcomeDescription = "description"
        case creator, castList, genreList
    }
    var image: Image {
        Image(imageName)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(publishedDate)
        hasher.combine(categories)
        hasher.combine(youtubeID)
        hasher.combine(welcomeDescription)
        hasher.combine(creator)

    }

}
extension Movie: Equatable {}

func ==(lhs: Movie, rhs: Movie) -> Bool {
    let areEqual = lhs.title == rhs.title &&
    lhs.publishedDate == rhs.publishedDate &&
    lhs.categories == rhs.categories &&
    lhs.youtubeID == rhs.youtubeID &&
    lhs.imageName == rhs.imageName

    return areEqual
}


// MARK: - CastList
struct CastList: Codable {
    let castID: Int
    let castName, castImage: String

    enum CodingKeys: String, CodingKey {
        case castID = "castId"
        case castName, castImage
    }
}

// MARK: - GenreList
struct GenreList: Codable {
    let genreID: Int
    let genreName: String

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case genreName
    }
}

struct MovieResponse: Decodable{
    let results: [Movie]
}
