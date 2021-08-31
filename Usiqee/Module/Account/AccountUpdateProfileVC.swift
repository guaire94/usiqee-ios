//
//  AccountUpdateProfileVC.swift
//  Usiqee
//
//  Created by Amine on 30/08/2021.
//

import UIKit
import Firebase

protocol AccountUpdateProfileVCDelegate: class {
    func didUpdateProfile()
}

class AccountUpdateProfileVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static var identifier = "AccountUpdateProfileVC"
        fileprivate static let imageContentType = "image/jpeg"
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var avatar: MImagePicker!
    @IBOutlet private weak var username: MTextField!
    @IBOutlet private weak var validButton: FilledButton!

    // MARK: - Variables
    weak var delegate: AccountUpdateProfileVCDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Privates
    private func setupView() {
        setupTranslation()
        setupUsername()
        setupValidateButton()
        avatar.parentViewController = self
        setupUserInformation()
    }
    
    private func setupTranslation() {
        username.placeHolder = L10N.user.form.username
        validButton.setTitle(L10N.editProfile.form.valid, for: .normal)
    }
    
    private func setupUsername() {
        username.delegate = self
        username.textContentType = .name
        username.returnKeyType = .done
    }
    
    private func setupValidateButton() {
        validButton.titleLabel?.font = Fonts.SignUp.valid
    }
    
    private func setupUserInformation() {
        guard let user = ManagerAuth.shared.user else {
            return
        }
        
        username.text = user.username
        if let url = URL(string: user.avatar) {
            avatar.loadImage(from: url)
        }
    }
    
    private func handleAvatarIsUploaded(username: String, avatar: String = "") {
        ServiceAuth.updateProfile(username: username, avatar: avatar)
        navigationController?.popViewController(animated: true)
        ManagerAuth.shared.updateUser(username: username, avatar: avatar)
        delegate?.didUpdateProfile()
    }
    
    private func upload(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
            let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = Constants.imageContentType
        
        FStorageReference.user(userId: userId).putData(data, metadata: metadata) { meta, error in
            FStorageReference.user(userId: userId).downloadURL { url, _ in
                completion(url)
            }
        }
    }
}

// MARK: - IBAction
extension AccountUpdateProfileVC {

    @IBAction func backToggle() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func updateToggle() {
        guard let user = ManagerAuth.shared.user,
              let username = username.text,
              !username.isEmpty else {
            showError(title: L10N.editProfile.title, message: L10N.editProfile.form.notEmptyError)
            return
        }
        
        validButton.loadingIndicator(show: true)
        guard avatar.didUpdateImage,
              let image = avatar.image else {
            handleAvatarIsUploaded(username: username, avatar: user.avatar)
            return
        }
        
        upload(image: image) { [weak self] url in
            guard let url = url?.absoluteString else {
                self?.handleAvatarIsUploaded(username: username)
                return
            }
            self?.handleAvatarIsUploaded(username: username, avatar: url)
        }
    }
}

// MARK: - UITextFieldDelegate
extension AccountUpdateProfileVC: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateToggle()
        return false
    }
}
