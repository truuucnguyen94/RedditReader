//
//  ImageUtility.swift
//  RedditReader
//
//  Created by Nguyen, Truc H. on 5/24/18.
//  Copyright © 2018 Nguyen, Truc H. All rights reserved.
//

import Foundation
import UIKit

class ImageUtility {
  static let shared = ImageUtility()
  let session = URLSession(configuration: .default)
  
  func loadImage(from post: RedditPost, to imageView: UIImageView) {
    if let image = post.thumbnailImage {
      DispatchQueue.main.async {
        imageView.image = image
      }
      return
    }

    guard let url = post.thumbnailUrl else { return }
    session.dataTask(with: url) { (data, response, error) in
      guard let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          return
      }
      DispatchQueue.main.async {
        let image = UIImage(data: data)
        imageView.image = image
        post.thumbnailImage = image
      }
    }.resume()
  }
}
