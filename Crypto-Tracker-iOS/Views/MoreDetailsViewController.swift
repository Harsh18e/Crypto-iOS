//
//  MoreDetailsViewController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 18/05/23.
//

import UIKit
import SwiftUI

class MoreDetailsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var additionalCollectionView: UICollectionView!
    @IBOutlet weak var graphView: UIView!
    private var data: Coin?
    private var hostingController: UIHostingController<ChartView>?
    private weak var viewModel: PrimaryViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showChartView()
        collectionView.register(UINib(nibName: DetailsCollectionViewCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: "DetailsCollectionViewCell")
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        additionalCollectionView.register(UINib(nibName: DetailsCollectionViewCell.getNibName(), bundle: nil), forCellWithReuseIdentifier: "DetailsCollectionViewCell")
        additionalCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        view.backgroundColor = .black
        navigationItem.title = data?.name.localizedUppercase ?? ""
        
        guard let data = data else {return}
        // Assuming you have a reference to your image
        if let image = viewModel?.getImageAtId(data.id) {
            let imageSize: CGFloat = 30
            
            let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
            buttonView.contentMode = .center
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            
            buttonView.addSubview(imageView)
            
            let barButtonItem = UIBarButtonItem(customView: buttonView)
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    private func showChartView() {
        let chartView = ChartView(data!)
        hostingController = UIHostingController(rootView: chartView)
        hostingController?.view.backgroundColor = .black
        
        if let hostingController = hostingController {
            addChild(hostingController)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            graphView.addSubview(hostingController.view)
            
            NSLayoutConstraint.activate([
                hostingController.view.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
                hostingController.view.topAnchor.constraint(equalTo: graphView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: graphView.bottomAnchor)
            ])
            
            hostingController.didMove(toParent: self)
        }
    }
    
    func setData(_ _data: Coin, _ vm: PrimaryViewModel?) {
        self.data = _data
        self.viewModel = vm
    }
}

//MARK: CollectionView DataSource & Delegate Methods
extension MoreDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == additionalCollectionView {
            return 6
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as! DetailsCollectionViewCell
        
        switch collectionView {
        case additionalCollectionView:
            cell.setupCell(data, type: DetailBlockType(rawValue: indexPath.row + 4),viewModel)
        default:
            cell.setupCell(data, type: DetailBlockType(rawValue: indexPath.row),viewModel)
        }
        
        return cell
    }
}

extension MoreDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth / 2.2
        var cellHeight = collectionView.bounds.height / 2.2
        if collectionView == additionalCollectionView {
            cellHeight = collectionView.bounds.height / 3.6
        }

        return CGSize(width: cellWidth, height: cellHeight)
    }

}
