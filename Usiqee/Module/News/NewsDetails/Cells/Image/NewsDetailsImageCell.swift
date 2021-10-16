//
//  NewsDetailsImageCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit
import Firebase

protocol NewsDetailsImageCellDelegate: AnyObject {
    func didLoadImage(for cell: NewsDetailsImageCell, image: UIImage)
}
class NewsDetailsImageCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsImageCell"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentImage: UIImageView!
    @IBOutlet weak private var loading: UIActivityIndicatorView!

    // MARK: - Properties
    private weak var delegate: NewsDetailsImageCellDelegate?
    
    // MARK: - LifeCycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentImage.image = nil
        contentImage.sd_cancelCurrentImageLoad()
    }
    
    func configure(url: String, ratio: CGFloat? = nil, delegate: NewsDetailsImageCellDelegate? = nil) {
        self.delegate = delegate
        if let ratio = ratio {
            setImageRatio(ratio)
        }
        let storage = Storage.storage().reference(forURL: url)
        loading.startAnimating()
        contentImage.sd_setImage(with: storage, placeholderImage: nil) { [weak self] image, _, _, _ in
            guard let self = self,
                  let image = image else { return }
            self.loading.stopAnimating()
            DispatchQueue.main.async {
                self.delegate?.didLoadImage(for: self, image: image)
            }
        }
    }
    
    // MARK: - Private
    private func setImageRatio(_ ratio: CGFloat) {
        contentImage.heightAnchor.constraint(equalTo: contentImage.widthAnchor, multiplier: ratio).isActive = true
    }
}
