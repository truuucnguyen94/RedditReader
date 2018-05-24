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
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    self.backgroundColor = .clear
    self.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    dataSource = self
    delegate = self
    self.register(RedditPostCell.cellNib(), forCellWithReuseIdentifier: "redditpost")
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

extension PostsCollectionView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = frame.size.width - 10 - 10
    return CGSize(width: width, height: 180)
  }
}
