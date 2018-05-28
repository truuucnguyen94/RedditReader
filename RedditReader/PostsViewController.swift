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
  @IBOutlet weak var currentPageLabel: UILabel!

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
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    displayLoading()
    jsonLoader.loadPosts(currentPage)
  }

  private func displayLoading() {
    DispatchQueue.main.async { [weak self] in
      self?.loadingActivityIndicator.isHidden = false
      self?.loadingActivityIndicator.startAnimating()
      self?.currentPageLabel.isHidden = true
    }
  }

  private func hideLoading() {
    DispatchQueue.main.async { [weak self] in
      self?.loadingActivityIndicator.isHidden = true
      self?.loadingActivityIndicator.stopAnimating()
      self?.currentPageLabel.text = "\((self?.currentPage ?? 0) + 1)"
      self?.currentPageLabel.isHidden = false
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

// MARK: - App Preservation
extension PostsViewController {
  private struct PreservationKeys {
    static let currentPage = "CurrentPage"
  }

  override func decodeRestorableState(with coder: NSCoder) {
    super.decodeRestorableState(with: coder)
    let restoredCurrentPage = coder.decodeInteger(forKey: PreservationKeys.currentPage)

    self.currentPage = restoredCurrentPage
    previousPageButton.isEnabled = currentPage > 0
  }

  override func encodeRestorableState(with coder: NSCoder) {
    super.encodeRestorableState(with: coder)
    coder.encode(currentPage, forKey: PreservationKeys.currentPage)
  }
}
