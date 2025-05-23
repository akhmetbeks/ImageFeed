//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 22.05.2025.
//

import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let image {
            imageView.image = image
            imageView.frame.size = image.size
        }
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
