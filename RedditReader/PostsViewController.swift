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

  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var nextPageButton: UIButton!
  @IBOutlet weak var previousPageButton: UIButton!
  @IBOutlet weak var postsCollectionView: PostsCollectionView!

  @IBAction func loadNextPage() {
    displayLoading()
    // Check if we currently have the next 25 posts, if not then load and display
    hideLoading()
  }

  @IBAction func loadPreviousPage() {
    displayLoading()
    // Use previous 25 posts and reload collection view
    hideLoading()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    jsonLoader.delegate = self
    jsonLoader.loadPosts()
  }

  private func displayLoading() {
    loadingActivityIndicator.isHidden = false
    loadingActivityIndicator.startAnimating()
  }

  private func hideLoading() {
    loadingActivityIndicator.isHidden = true
    loadingActivityIndicator.stopAnimating()
  }
}

extension PostsViewController: JSONLoaderDelegate {
  func finishedLoading(with error: Error) {}

  func finishedLoadingPosts(_ posts: [RedditPost]) {
    postsCollectionView.posts = posts
  }
}
