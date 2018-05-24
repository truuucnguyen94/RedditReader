//
//  PostsCollectionView.swift
//  RedditReader
//
//  Created by Nguyen, Truc H. on 5/24/18.
//  Copyright © 2018 Nguyen, Truc H. All rights reserved.
//

import Foundation
import UIKit

class PostsCollectionView: UICollectionView {
  var posts: [RedditPost] = [] {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.reloadData()
      }
    }
  }

  init() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    
    super.init(frame: .zero, collectionViewLayout: flowLayout)
    
    self.backgroundColor = .clear
    
    dataSource = self
    delegate = self
    self.register(RedditPostCell.self, forCellWithReuseIdentifier: "redditpost")
  }
  
  required init?(coder aDecoder: NSCoder) {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    super.init(coder: aDecoder)
    self.backgroundColor = .clear
    
    dataSource = self
    delegate = self
    self.register(RedditPostCell.self, forCellWithReuseIdentifier: "redditpost")
  }
}

extension PostsCollectionView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let post = posts[indexPath.row]
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "redditpost", for: indexPath) as? RedditPostCell {
      cell.post = post
      return cell
    }
    return UICollectionViewCell()
  }
}

extension PostsCollectionView: UICollectionViewDelegate {
  
}
