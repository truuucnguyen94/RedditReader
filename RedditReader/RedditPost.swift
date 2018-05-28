//
//  RedditPost.swift
//  RedditReader
//
//  Created by Nguyen, Truc H. on 5/24/18.
//  Copyright © 2018 Nguyen, Truc H. All rights reserved.
//

import Foundation
import UIKit

struct RedditPostKeys {
  static let title = "title"
  static let author = "author"
  static let thumbnailUrl = "thumbnail"
  static let createdDate = "created"
  static let numberOfComments = "num_comments"
}

class RedditPost {
  let title: String?
  let author: String?
  let numberOfComments: Int?

  var createdDate: String? {
    guard let createdDateUnix = createdDateUnix else { return nil }
    let date = NSDate(timeIntervalSince1970: TimeInterval(createdDateUnix))
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date as Date)
  }
  private let createdDateUnix: Int?

  var thumbnailImage: UIImage?
  var thumbnailUrl: URL? {
    guard let thumbnailUrlString = thumbnailUrlString, thumbnailUrlString.range(of: "thumbs") != nil else { return nil }
    return URL(string: thumbnailUrlString)
  }
  private let thumbnailUrlString: String?

  init(_ payload: JSONPayload) {
    title = payload[RedditPostKeys.title] as? String
    author = payload[RedditPostKeys.author] as? String
    thumbnailUrlString = payload[RedditPostKeys.thumbnailUrl] as? String
    createdDateUnix = payload[RedditPostKeys.createdDate] as? Int
    numberOfComments = payload[RedditPostKeys.numberOfComments] as? Int
  }
}
