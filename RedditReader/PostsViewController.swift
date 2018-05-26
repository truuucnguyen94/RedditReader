//
//  PostsViewController.swift
//  RedditReader
//
//  Created by Nguyen, Truc H. on 5/24/18.
//  Copyright © 2018 Nguyen, Truc H. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
  let jsonLoader = JSONLoader()
  var currentPage = 0

  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var nextPageButton: UIButton!
  @IBOutlet weak var previousPageButton: UIButton!
  @IBOutlet weak var postsCollectionView: PostsCollectionView!

  @IBAction func loadNextPage() {
    displayLoading()
    currentPage += 1
    jsonLoader.loadPosts(currentPage)
    previousPageButton.isEnabled = true
  }

  @IBAction func loadPreviousPage() {
    guard currentPage > 0 else { return }
    displayLoading()
    currentPage -= 1
    jsonLoader.loadPosts(currentPage)
    previousPageButton.isEnabled = currentPage > 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    jsonLoader.delegate = self
    displayLoading()
    jsonLoader.loadPosts()
  }

  private func displayLoading() {
    DispatchQueue.main.async { [weak self] in
      self?.loadingActivityIndicator.isHidden = false
      self?.loadingActivityIndicator.startAnimating()
    }
  }

  private func hideLoading() {
    DispatchQueue.main.async { [weak self] in
      self?.loadingActivityIndicator.isHidden = true
      self?.loadingActivityIndicator.stopAnimating()
    }
  }
}

extension PostsViewController: JSONLoaderDelegate {
  func finishedLoading(with error: Error) {
    hideLoading()
  }

  func finishedLoadingPosts(_ posts: [RedditPost]) {
    hideLoading()
    postsCollectionView.posts = posts
  }
}
