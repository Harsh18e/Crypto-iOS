//
//  AnimationManager.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 07/03/23.
//

import Foundation
import Lottie
import UIKit

class AnimationManager {
    
    // MARK: Private Properties
    private var currentIndex: Int? = 0
    private var images: [UIImage?] = [UIImage(named: "down_arrow"), UIImage(named: "down_arrow_green")]
    private var animationView: LottieAnimationView!

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
        animationView = LottieAnimationView(name: "loading_JSON")
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
}
