//
//  JSONLoader.swift
//  RedditReader
//
//  Created by Nguyen, Truc H. on 5/24/18.
//  Copyright © 2018 Nguyen, Truc H. All rights reserved.
//

import Foundation

/// Errors that can be thrown from the JSONLoader
enum JSONLoaderError: Error {
  case cannotComposeUrl
  case requestError
}

/// Delegate protocol to handle loading completions
protocol JSONLoaderDelegate: class {
  func finishedLoadingPosts(_ posts: [RedditPost])
  func finishedLoading(with error: Error)
}

/// Typealias for JSONPayload
public typealias JSONPayload = [String: Any]

/// JSONLoader class that keeps track of pagination / loading next pages given a page index
class JSONLoader {
  /// Keys for parsing the JSONPayload
  struct Keys {
    static let kind = "kind"
    static let listingKind = "Listing"
    static let data = "data"
    static let children = "children"
    static let after = "after"
  }

  // MARK: - Delegate variable
  weak var delegate: JSONLoaderDelegate?

  // MARK: - Private Variables
  private let session = URLSession(configuration: .default)
  private let baseUrl = "http://www.reddit.com/top/.json"
  private let paginationSize = 25
  private var loadedPosts: [RedditPost] = []
  private var nextPageID: String?

  // MARK: - Public Methods
  func loadPosts(_ pageNumber: Int = 0) {
    let previousPostIndex = pageNumber > 0 ? ((pageNumber - 1) * paginationSize) + (paginationSize - 1) : -1
    let endPostIndex = previousPostIndex + paginationSize
    if endPostIndex < loadedPosts.count {
      // Next page has already been loaded
      delegate?.finishedLoadingPosts(Array(loadedPosts[previousPostIndex + 1...endPostIndex]))
      return
    }

    let endpointForRequest: String
    if previousPostIndex > 0, let afterId = nextPageID {
      endpointForRequest = composeAfterUrl(afterId)
    } else {
      endpointForRequest = baseUrl
    }

    guard let url = URL(string: endpointForRequest) else {
      delegate?.finishedLoading(with: JSONLoaderError.cannotComposeUrl)
      return
    }

    session.dataTask(with: url) { [weak self] (data, response, error) in
      guard let strongSelf = self else { return }
      guard let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
        strongSelf.delegate?.finishedLoading(with: JSONLoaderError.requestError)
          print("Encountered error fetching reddit posts: \(String(describing: error))")
        return
      }

      do {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
          let posts = strongSelf.parseJson(json) {
          strongSelf.loadedPosts += posts
          strongSelf.loadPosts(pageNumber)
        }
      }
    }.resume()
  }

  // MARK: - Private Methods
  private func composeAfterUrl(_ id: String) -> String {
    return "\(baseUrl)?after=\(id)"
  }

  private func parseJson(_ json: [String: Any]?) -> [RedditPost]? {
    guard let kind = json?[Keys.kind] as? String,
      kind == Keys.listingKind,
    let data = json?[Keys.data] as? [String: Any],
      let children = data[Keys.children] as? [[String: Any]] else { return nil }
    nextPageID = data[Keys.after] as? String
    return children.map { $0[Keys.data] as? [String: Any] }.compactMap { $0 }.map { RedditPost($0) }
  }
}
