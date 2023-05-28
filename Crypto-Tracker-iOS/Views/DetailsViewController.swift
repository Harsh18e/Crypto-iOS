//
//  DetailsViewController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 26/03/23.
//

import Foundation
import UIKit


class DetailsViewController: UIViewController {
    
    
    @IBAction func seeMoreDetails(_ sender: Any) {
        
        guard let data = viewModel?.getCoinData(index ?? 1) else {
            return
        }
        let presentedVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: MoreDetailsViewController.self)) as! MoreDetailsViewController
        presentedVC.modalPresentationStyle = .overCurrentContext
        presentedVC.modalTransitionStyle = .flipHorizontal
        presentedVC.setData(data,viewModel)
        dismiss(animated: true) {
            self.navController?.pushViewController(presentedVC, animated: true)
            self.navController?.modalTransitionStyle = .coverVertical
        //    self.present(self.navController!, animated: true)
        }
    }
    
    @IBOutlet private weak var containerView: CustomUIView!
    @IBOutlet private weak var priceHistoryButton: CustomUIButton!
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var coinShortNameLabel: UILabel!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var marketCapLabel: UILabel!
    
    @IBOutlet weak var descScrollView: UIScrollView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    private weak var viewModel: PrimaryViewModel?
    private var index: Int?
    private weak var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.detailsDelegate = self
        containerView.backgroundColor = .nightGray
        priceHistoryButton.backgroundColor = .white
        containerView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor.cyan.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: -10)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        guard let data = viewModel?.getCoinData(index ?? 1) else {
            return
        }
        coinNameLabel.text = data.name
        coinShortNameLabel.text = data.symbol
        logoImage.image = viewModel?.getImageAtId(data.id)
        marketCapLabel.text = data.marketCap?.convertToShortString() ?? "N/A"
        rankLabel.text = "#TOP " + (viewModel?.getPriceRank(data.id))!
        priceLabel.text = "$ \(data.currentPrice.convertToShortString())"

        setScrollView(nil)
    }
    
    func setScrollView(_ textData: String?) {
       
        // Create a UIScrollView
        descScrollView.translatesAutoresizingMaskIntoConstraints = false

        // Add a height constraint to limit the height of the UIScrollView
        let scrollViewHeightConstraint = descScrollView.heightAnchor.constraint(equalToConstant: 150)
        scrollViewHeightConstraint.isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0 // Allow for multiple lines of text
        descriptionLabel.lineBreakMode = .byWordWrapping // Allow the text to wrap to multiple lines if needed
        var descText = ""
        if let textData = textData, textData != "" {
            descText = textData
        } else {
            descText = "Description Data Not Available Yet!!"
        }
        descriptionLabel.text = descText

        descriptionLabel.centerXAnchor.constraint(equalTo: descScrollView.centerXAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: descScrollView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: descScrollView.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descScrollView.topAnchor, constant: 10).isActive = true
        // Set the width of the UILabel to be equal to the width of the UIScrollView minus the horizontal margins of 40 points
        descriptionLabel.sizeToFit()

        // Call layoutIfNeeded to update the layout before setting the content size of the UIScrollView
        view.layoutIfNeeded()

        // Set the content size of the UIScrollView to be equal to the height of the UILabel plus the vertical margins of 40 points
        descScrollView.contentSize = CGSize(width: descScrollView.frame.width, height: descriptionLabel.frame.height + 40)

        descScrollView.isScrollEnabled = true
    }
    
    func setData(_ vm: PrimaryViewModel?, _ index: Int, _ navVC: UINavigationController) {
        self.viewModel = vm
        self.index = index
        self.navController = navVC
    }
}
extension DetailsViewController: ViewModelDelegate {
    
    func updateUI() {
        guard let data = viewModel?.getCoinData(index ?? 1) else {
            return
        }
        if descriptionLabel != nil {
            setScrollView(viewModel?.infoDictionary[data.id]?.description.en)
        }
    }
}
