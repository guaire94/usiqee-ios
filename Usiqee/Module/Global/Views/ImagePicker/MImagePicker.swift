//
//  MImagePicker.swift
//  Usiqee
//
//  Created by Amine on 01/05/2021.
//

import UIKit

class MImagePicker: UIView {

    // MARK: - Constants
    private enum Constants {
        static let identifier = "MImagePicker"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var avatar: UIImageView!
    
    // MARK:- Properties
    weak var parentViewController: UIViewController?
    var image: UIImage? {
        avatar.image
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupView() {
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = Colors.gray.cgColor
    }
}

// MARK: - IBActions
extension MImagePicker {
    @IBAction func onImageTapped() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: L10N.ImagePicker.LoadFromGallery, style: .default, handler: { _ in
            self.showPicker(from: .savedPhotosAlbum)
        }))
        alert.addAction(UIAlertAction(title: L10N.ImagePicker.takeAPhoto, style: .default, handler: { _ in
            self.showPicker(from: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: L10N.global.action.cancel, style: .destructive, handler: nil))
        
        parentViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func showPicker(from type: UIImagePickerController.SourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = type
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        parentViewController?.present(imagePickerVC, animated: true, completion: nil)
    }
}

extension MImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        avatar.image = image
    }
}
