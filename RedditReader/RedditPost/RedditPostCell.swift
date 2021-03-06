//
//  RedditPostCell.swift
//  RedditReader
//
//  Created by Nguyen, Truc H. on 5/24/18.
//  Copyright © 2018 Nguyen, Truc H. All rights reserved.
//

import Foundation
import UIKit

class RedditPostCell: UICollectionViewCell {
  // MARK: - IBOutlet Properties
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var authorLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var numberOfCommentsLabel: UILabel!
  @IBOutlet private weak var thumbnailImageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet private weak var stackViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private weak var thumbnailImageView: UIImageView! {
    didSet {
      thumbnailImageView.contentMode = .scaleToFill
    }
  }

  // MARK: - Internal Properties
  var post: RedditPost? {
    didSet {
      titleLabel.text = post?.title
      authorLabel.text = "By \"\(post?.author ?? "anonymous")\""
      dateLabel.text = post?.createdDate
      numberOfCommentsLabel.text = "\(post?.numberOfComments ?? 0) comments"
      setupConstraints(hidingImage: post?.thumbnailUrl == nil)
    }
  }

  static func cellNib() -> UINib {
    return UINib(nibName: "RedditPostCell", bundle: Bundle.main)
  }

  static func reuseIdentifier() -> String {
    return "redditpost"
  }

  // MARK: - Lifecycle methods
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    authorLabel.text = nil
    dateLabel.text = nil
    thumbnailImageView.image = nil
    numberOfCommentsLabel.text = nil
  }

  // MARK: - Private methods
  private func loadImage() {
    guard let post = post else { return }
    ImageUtility.shared.loadImage(from: post, to: thumbnailImageView)
  }

  private func setupConstraints(hidingImage: Bool) {
    if hidingImage {
      thumbnailImageViewWidthConstraint.constant = 0
      stackViewLeadingConstraint.constant = 0
    } else {
      loadImage()
      thumbnailImageViewWidthConstraint.constant = 160
      stackViewLeadingConstraint.constant = 10
    }
  }
}
