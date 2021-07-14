//
//  HomeModels.swift
//  Tags
//
//  Created by MG on 13.07.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation

enum HomeViewModel {
    
    // MARK: DTO
    struct DTO {
        
    }
    
    // MARK: - Parameters
    struct Parameters {
        let tag: String?
        let limit: Int?
        let offset: Int?
    }
    
    // MARK: - Response
    struct Response {
        
        // MARK: - Tags
        struct Tags: Codable {
            let hasMore: Bool?
            let nextOffset: Int?
            let results: [Result]?

            enum CodingKeys: String, CodingKey {
                case hasMore = "has_more"
                case nextOffset = "next_offset"
                case results
            }
        }

        // MARK: - Result
        struct Result: Codable {
            let deviationid: String?
            let url: String?
            let title, category, categoryPath: String?
            let isDownloadable, isMature, isFavourited, isDeleted: Bool?
            let author: Author?
            let stats: Stats?
            let publishedTime: Int?
            let allowsComments: Bool?
            let preview, content: Content?
            let thumbs: [Content]?

            enum CodingKeys: String, CodingKey {
                case deviationid, url, title, category
                case categoryPath = "category_path"
                case isDownloadable = "is_downloadable"
                case isMature = "is_mature"
                case isFavourited = "is_favourited"
                case isDeleted = "is_deleted"
                case author, stats
                case publishedTime = "published_time"
                case allowsComments = "allows_comments"
                case preview, content, thumbs
            }
        }

        // MARK: - Author
        struct Author: Codable {
            let userid, username: String?
            let usericon: String?
            let type: String?
        }

        // MARK: - Content
        struct Content: Codable {
            let src: String?
            let filesize, height, width: Int?
            let transparency: Bool?
        }

        // MARK: - Stats
        struct Stats: Codable {
            let comments, favourites: Int?
        }
    }
}
