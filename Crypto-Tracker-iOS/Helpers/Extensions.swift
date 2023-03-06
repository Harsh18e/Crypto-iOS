//
//  Extensions.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import Foundation
import UIKit

extension Double {
    func roundedStringWithTwoDecimals() -> String {
        return String(format: "%.2f", self)
    }
}

extension UIView {
    
    // MARK: - Class Methods
    class func getNibName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    class func getCellIdentifier() -> String {
        return getNibName()
    }
}

extension UIImageView {
    func downloadImage(from url: URL, _ isSame: Bool)
    {
        if !isSame {
            return
        }
        contentMode = .scaleToFill
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                print("error occured !!")
                return
            }
            guard let imageData = data, let image = UIImage(data: imageData) else {
                    print("Error converting image data to UIImage")
                    return
                }
            DispatchQueue.main.async {
                    self.image = image
                }
        
        }.resume()
    }
}

extension UITableView {
    func registerNib(_ viewClass: UIView.Type) {
        let nib = UINib(nibName: viewClass.getNibName(), bundle: nil)
        register(nib, forCellReuseIdentifier: viewClass.getCellIdentifier())
    }
}

extension UIViewController {
    static func getIdentifier() -> String {
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        return className
    }
}

@IBDesignable
public class CustomUIView: UIView {

    // MARK: - Variable
    private var gShadowOffsetWidth = 0
    private var gShadowOffsetHeight = 0
    
    // MARK: - Initialization
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
       
       // MARK: - UI Setup
       public override func prepareForInterfaceBuilder() {
           setupView()
       }
       
       func setupView() {
           self.layer.cornerRadius = cornerRadius
           self.layer.shadowColor = shadowColor.cgColor
           self.layer.shadowRadius = shadowRadius
           self.layer.shadowOpacity = shadowOpacity
           self.layer.borderWidth = borderWidth
           self.layer.borderColor = borderColor.cgColor
       }
    
    // MARK: - IBInspectables
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = shadowOpacity

            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBInspectable var shadowColor: UIColor = .white {
           didSet {
               layer.shadowColor = shadowColor.cgColor
           }
       }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
           didSet {
               layer.shadowRadius = shadowRadius
           }
       }
    
    @IBInspectable var shadowOWidth: Int = 0 {
        didSet {
            gShadowOffsetWidth = shadowOWidth
            layer.shadowOffset = CGSize(width: gShadowOffsetWidth, height: gShadowOffsetHeight)
        }
    }
    
    @IBInspectable var shadowOHeight: Int = 0 {
        didSet {
            gShadowOffsetHeight = shadowOHeight
            layer.shadowOffset = CGSize(width: gShadowOffsetWidth, height: gShadowOffsetHeight)
        }
    }
}
