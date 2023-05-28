//
//  AnimationManager.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 07/03/23.
//

import Foundation
import Lottie
import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewModel {
    
    // MARK: Private Properties
    private var currentIndex: Int? = 0
    private var images: [UIImage?] = [UIImage(named: "down_arrow"), UIImage(named: "down_arrow_green")]
    private var animationView: LottieAnimationView = LottieAnimationView(name: "loading_JSON")

    // MARK: Public Methods
    func startBlinkTimer(_ downArrow: UIImageView) {
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.currentIndex = ((self.currentIndex ?? 0) + 1) % self.images.count
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = .fade
            downArrow.layer.add(transition, forKey: nil)
            downArrow.image = self.images[self.currentIndex ?? 0]
        }
    }
    
    func animateUpAndDown(_ view: UIView) {
        UIView.animate(withDuration: 1, delay: 0 ,options: [.repeat, .autoreverse], animations: {
                view.transform = CGAffineTransform(translationX: 0, y: 14)
            }, completion: nil)
    }
    
    func stopLogoAnimation(_ view: UIView) {
        view.layer.removeAllAnimations()
        view.transform = .identity
    }
    
    func startLoadingAnimation(_ animationContainerView: UIView) {
        animationView.frame = animationContainerView.bounds
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.8
        animationContainerView.addSubview(animationView)
        animationView.play()
    }
    
    func stopLoadingAnimation() {
        DispatchQueue.main.async {
            self.animationView.stop()
        }
    }
    
    func addLayerGradient(_ mainView: UIView) {
        
        mainView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.purple.cgColor] // set the colors for the gradient
        gradientLayer.startPoint = CGPoint(x: 0.02, y: 0) // set the starting point to the left side of the view
        gradientLayer.endPoint = CGPoint(x: 1, y: 4) // set the ending point to the right side of the view
        mainView.layer.insertSublayer(gradientLayer, at: 0) // add the gradient layer to the view's layer
    }
    
    
    func loginWithEmail(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle login error
                completion(.failure(error))
            } else if let user = authResult?.user {
                // Login successful
                completion(.success(user))
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Error creating user, call completion with failure
                completion(.failure(error))
                return
            }
            
            if let user = authResult?.user {
                // User created successfully, call completion with success and user object
                completion(.success(user))
            } else {
                // User object is missing, call completion with failure
                let error = NSError(domain: "FirebaseAuthError", code: 0, userInfo: nil)
                completion(.failure(error))
            }
        }
    }
    
    func requestLogin(_ context: LoginViewController, _ loginMethod: LoginType, completion: @escaping (Result<UserType, Error>) -> Void) {
        
        if !NetworkManager.shared.isNetworkAvailable() {
            let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("No Network Available. \nPlease Check Internet Connection!", comment: "Error message")])

            completion(.failure(error))
            return
        }
        if loginMethod != .google, let email = context.emailTextField.text,
            let pwd = context.passwordTextField.text, pwd == "" || email == "" {
            let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Password and Email Fields Can't be Empty!", comment: "Error message")])

            completion(.failure(error))
            return
        }
        
        switch loginMethod {
            
        case .email:
            
            loginWithEmail(email: context.emailTextField.text ?? "", password: context.passwordTextField.text ?? "") { result in
                switch result {
                case .success(let user):
                    completion(.success(.firebaseUser(user)))
                    
                case .failure(let error):
                    // Login error, handle the error
                    completion(.failure(error))
                }
            }
        case .google:
            
            let clientID = "281366402228-f0vi7p1g1s8nvu5fm22vpqmf55i56t5q.apps.googleusercontent.com"
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
           
            GIDSignIn.sharedInstance.signIn(withPresenting: context) { signInResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let signInResult = signInResult {
                    let user = signInResult.user // Extract the user information from signInResult
                    completion(.success(.googleUser(user)))
                } else {
                    // Handle unexpected case where both result and error are nil
                    let error = NSError(domain: "GoogleSignInError", code: 0, userInfo: nil)
                    completion(.failure(error))
                }
            }
        case .signUp:
            createUser(withEmail: context.emailTextField.text ?? "", password: context.passwordTextField.text ?? "") { result in
                switch result {
                    
                case .success(let user):
                    completion(.success(.firebaseUser(user)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
