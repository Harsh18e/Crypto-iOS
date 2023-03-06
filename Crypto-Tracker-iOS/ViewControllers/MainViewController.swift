//
//  ViewController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 28/02/23.
//

import UIKit

class MainViewController: UIViewController, ViewModelDelegate {
    func updateUI() {
        tableView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: PrimaryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PrimaryViewModel()
        viewModel?.makeNetworkCall()
        viewModel?.delegate = self
        
        tableView.register(UINib(nibName: CoinsTableViewCell.getNibName(), bundle: nil), forCellReuseIdentifier: "coinCell")
        tableView.register(UINib(nibName: "TrendingTableViewCell", bundle: nil), forCellReuseIdentifier: "trendingcell")
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
        cell.setupCell(viewModel?.getCoinData(indexPath.row), indexPath.row)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
