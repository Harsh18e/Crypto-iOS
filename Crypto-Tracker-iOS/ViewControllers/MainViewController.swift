//
//  ViewController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 28/02/23.
//

import UIKit
import GoogleSignIn

class MainViewController: UIViewController, ViewModelDelegate {
    func updateUI() {
        tableView.reloadData()
    }

    @IBAction func didTapLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constants.LOGINSTATUS)
        
        GIDSignIn.sharedInstance.signOut()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
  
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: PrimaryViewModel?
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PrimaryViewModel()
        viewModel?.makeNetworkCall()
        viewModel?.delegate = self
        
        tableView.register(UINib(nibName: CoinsTableViewCell.getNibName(), bundle: nil), forCellReuseIdentifier: "coinCell")
        tableView.register(UINib(nibName: "TrendingTableViewCell", bundle: nil), forCellReuseIdentifier: "trendingcell")
        tableView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
 
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 { return viewModel?.getCoinsCount() ?? 0 }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingcell", for: indexPath) as! TrendingTableViewCell
            cell.viewModel = viewModel
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell" , for: indexPath) as! CoinsTableViewCell
        guard let coinData = viewModel?.getCoinData(indexPath.row) else {
            return cell
        }
        cell.setupCell(coinData, indexPath.row, viewModel?.getImageAtId(coinData.id))
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title: String
        
        if section == 0 {
            title = "Trending Coins"
        } else {
            title = "Live Prices of Coins"
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as! SectionHeaderView
        headerView.titleLabel.text = title
//
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 10)
//        cell.layer.shadowOpacity = 0.3
//        cell.layer.shadowRadius = 10
//        cell.layer.masksToBounds = false
        headerView.titleLabel.layer.shadowColor = UIColor.black.cgColor
        headerView.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.titleLabel.layer.shadowOpacity = 0.4
        headerView.titleLabel.layer.shadowRadius = 4
        
        return headerView
    }
   
}
