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
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var numberOfCommentsLabel: UILabel!

  var post: RedditPost?

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    authorLabel.text = nil
    dateLabel.text = nil
    thumbnailImageView.image = nil
    numberOfCommentsLabel.text = nil
  }
}
