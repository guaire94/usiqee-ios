//
//  PreAuthVC.swift
//  Usiqee
//
//  Created by Amine on 01/05/2021.
//

import UIKit
import AuthenticationServices
import Firebase
import GoogleSignIn

protocol PreAuthVCDelegate: class {
    func didSignIn()
}

class PreAuthVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var signUpButton: FilledButton!
    @IBOutlet weak private var signInWithAppleButton: FilledButton!
    @IBOutlet weak private var signInWithGoogleButton: FilledButton!
    @IBOutlet weak private var separatorLabel: UILabel!
    @IBOutlet weak private var signInButton: UIButton!

    // MARK: - Variables
    weak var delegate: PreAuthVCDelegate?
    fileprivate var currentNonce: String?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperTracking.track(item: .preAuth)
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SignInVC.Constants.identifier {
            guard let signInVC = segue.destination as? SignInVC else {
                return
            }
            
            signInVC.delegate = self
        } else if segue.identifier == SignUpVC.Constants.identifier {
            guard let signUpVC = segue.destination as? SignUpVC else {
                return
            }
            
            signUpVC.delegate = self
        }
    }
    
    // MARK: - Private
    private func setupView() {
        setupSignUpButton()
        setupSignInWithAppleButton()
        setupSignInWithGoogleButton()
        setupSignInButton()
        setupSeparator()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupSeparator() {
        separatorLabel.font = Fonts.PreAuth.separator
        separatorLabel.text = L10N.preAuth.separator
    }
    
    private func setupSignUpButton() {
        signUpButton.layer.cornerRadius = 25
        signUpButton.titleLabel?.font = Fonts.PreAuth.signUp
        signUpButton.setTitle(L10N.preAuth.signUpWithMail, for: .normal)
    }
    
    private func setupSignInWithAppleButton() {
        guard #available(iOS 13, *) else {
            signInWithAppleButton.isHidden = true
            return
        }
        
        signInWithAppleButton.layer.cornerRadius = 25
        signInWithAppleButton.color = .black
        signInWithAppleButton.titleLabel?.font = Fonts.PreAuth.signUp
        signInWithAppleButton.setTitle(L10N.preAuth.signInWithApple, for: .normal)
    }
    
    private func setupSignInWithGoogleButton() {
        signInWithGoogleButton.layer.cornerRadius = 25
        signInWithGoogleButton.color = .white
        signInWithGoogleButton.titleLabel?.font = Fonts.PreAuth.signUp
        signInWithGoogleButton.setTitle(L10N.preAuth.signInWithGoogle, for: .normal)
    }
    
    private func setupSignInButton() {
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        signInButton.setBackgroundColor(Colors.gray.withAlphaComponent(0.7))
        signInButton.titleLabel?.font = Fonts.PreAuth.signIn
        signInButton.setTitle(L10N.preAuth.signIn, for: .normal)
    }
    
    private func handleSignIn(mail: String, username: String) {
        ServiceAuth.signUp(mail: mail, avatar: "", username: username)
        (UIApplication.shared.delegate as? AppDelegate)?.registerForPushNotifications()
        navigationController?.dismiss(animated: true, completion: nil)
        delegate?.didSignIn()
        ManagerAuth.shared.didChangeStatus()
    }
}

// MARK: - IBActions
extension PreAuthVC {
    @IBAction func onDismissToggle() {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 13, *)
    @IBAction func signInWithAppleToggle() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        signInWithAppleButton.loadingIndicator(show: true)
    }
    
    @IBAction func signInWithGoogleToggle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
          guard error == nil, let authentication = user?.authentication, let idToken = authentication.idToken else { return }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            
            signInWithGoogleButton.loadingIndicator(show: true, color: .black)
            Auth.auth().signIn(with: credential) { authResult, error in
                self.signInWithGoogleButton.loadingIndicator(show: false)
                guard error == nil, let authResult = authResult else {
                    self.showError(title: L10N.signIn.title, message: error?.localizedDescription ?? "")
                    return
                }
                
                let mail = authResult.user.email ?? ""
                let username = authResult.user.displayName ?? ""
                
                HelperTracking.track(item: .preAuthSignInWithGmail)
                self.handleSignIn(mail: mail, username: username)
            }
        }
    }
}

// MARK: - SignInVCDelegate
extension PreAuthVC: SignInVCDelegate {
    func didSignIn() {
        dismiss(animated: true, completion: nil)
        delegate?.didSignIn()
    }
}

// MARK: - SignUpVCDelegate
extension PreAuthVC: SignUpVCDelegate {
    func didSignUp() {
        dismiss(animated: true, completion: nil)
        delegate?.didSignIn()
    }
}

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension PreAuthVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.showError(title: L10N.signIn.title, message: L10N.signIn.error.withApple)

                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                self.signInWithAppleButton.loadingIndicator(show: false)
                guard error == nil, let authResult = authResult else {
                    self.showError(title: L10N.signIn.title, message: error?.localizedDescription ?? "")
                    return
                }
                
                let mail = authResult.user.email ?? ""
                let username = appleIDCredential.fullName?.username ?? ""
                                
                HelperTracking.track(item: .preAuthSignInWithApple)
                self.handleSignIn(mail: mail, username: username)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInWithAppleButton.loadingIndicator(show: false)
        showError(title: L10N.signIn.title, message: error.localizedDescription)
    }
    
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
@available(iOS 13.0, *)
extension PreAuthVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
