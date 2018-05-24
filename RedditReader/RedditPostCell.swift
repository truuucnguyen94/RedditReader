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
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView! {
    didSet {
      thumbnailImageView.contentMode = .scaleToFill
    }
  }
  @IBOutlet weak var numberOfCommentsLabel: UILabel!

  @IBOutlet weak var thumbnailImageViewWidthConstraint: NSLayoutConstraint!

  var post: RedditPost? {
    didSet {
      titleLabel.text = post?.title
      authorLabel.text = post?.author
      dateLabel.text = post?.createdDate
      numberOfCommentsLabel.text = "\(post?.numberOfComments ?? 0) comments"
      if post?.thumbnailUrl != nil {
        loadImage()
        thumbnailImageViewWidthConstraint.constant = 180
      } else {
        thumbnailImageViewWidthConstraint.constant = 0
      }
    }
  }

  static func cellNib() -> UINib {
    return UINib(nibName: "RedditPostCell", bundle: Bundle.main)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    authorLabel.text = nil
    dateLabel.text = nil
    thumbnailImageView.image = nil
    numberOfCommentsLabel.text = nil
  }

  private func loadImage() {
    guard let post = post else { return }
    ImageUtility.shared.loadImage(from: post, to: thumbnailImageView)
  }
}
