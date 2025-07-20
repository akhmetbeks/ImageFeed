//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 19.05.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var labelViewCell: UILabel!
    @IBOutlet var buttonCell: UIButton!
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        self.imageViewCell.image = nil
        self.imageViewCell.kf.cancelDownloadTask()
    }
}
