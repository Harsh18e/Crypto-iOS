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
        LaunchView.isHidden = true
    }

    @objc func didTapLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constants.LOGINSTATUS)
        
        GIDSignIn.sharedInstance.signOut()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        
        self.navigationController?.setViewControllers([vc], animated: true)
    }
  
    @IBOutlet weak var LaunchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PrimaryViewModel?
    
    // MARK: Lifecycle methods
    
    override func loadView() {
        super.loadView()
        viewModel = PrimaryViewModel()
        viewModel?.makeNetworkCall()
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        
        tableView.register(UINib(nibName: CoinsTableViewCell.getNibName(), bundle: nil), forCellReuseIdentifier: "coinCell")
        tableView.register(UINib(nibName: "TrendingTableViewCell", bundle: nil), forCellReuseIdentifier: "trendingcell")
        tableView.register(UINib(nibName: "SectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        title = "Crypto HUB"
        let signOutImage = UIImage(systemName: "power")

        let signOutBarButtonItem = UIBarButtonItem(image: signOutImage, style: .plain, target: self, action: #selector(didTapLogOut(_:)))
        signOutBarButtonItem.title = "Sign Out"
        navigationItem.rightBarButtonItem = signOutBarButtonItem
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 { return viewModel?.getCoinsCount() ?? 10 }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trendingcell", for: indexPath) as! TrendingTableViewCell
            cell.viewModel = viewModel
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell" , for: indexPath) as! CoinsTableViewCell
        
        cell.setupCell(viewModel, indexPath.row)
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
            title = "Name                    All Coins                     Price"
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeaderView") as! SectionHeaderView
        headerView.titleLabel.text = title
        headerView.titleLabel.layer.shadowColor = UIColor.systemGray5.cgColor
        headerView.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        headerView.titleLabel.layer.shadowOpacity = 0.4
        headerView.titleLabel.layer.shadowRadius = 4
        headerView.titleLabel.textColor = UIColor(hex: "#00DBC6")
        
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let coinName = (viewModel?.getCoinData(indexPath.row)?.id) else {return}
        didSelectCellAtID(coinName, indexPath.row)
    }
}

extension MainViewController: TrendingTableViewCellDelegate {
    func didSelectCellAtID(_ id: String, _ index: Int) {
        var url = Constants.coinURL
        url += id
        url += Constants.coinEndpoint
        viewModel?.makeNetworkCall(url)
        
        let presentedVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        
        presentedVC.modalPresentationStyle = .pageSheet
        presentedVC.modalTransitionStyle = .coverVertical
        presentedVC.setData(viewModel, index, navigationController!)
        navigationController?.present(presentedVC, animated: true)
    }
}
