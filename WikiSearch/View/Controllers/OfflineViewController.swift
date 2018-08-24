//
//  OfflineViewController.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 24/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit
import SafariServices

class OfflineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = OfflineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = self.emptyBackgroundView
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCachedArticles()
    }
    
    var emptyBackgroundView:UIView {
        get {
            let emptyBackgroundView = UIView.init(frame: self.view.bounds)
            let message = UILabel.init(frame: CGRect.init(x: 0, y: (emptyBackgroundView.frame.height/2) - 150, width: emptyBackgroundView.frame.width, height: 50))
            message.text = "Please download something first."
            message.numberOfLines = 0
            message.textAlignment = .center
            emptyBackgroundView.addSubview(message)
            return emptyBackgroundView;
        }
    }

    func openInSafari(url: String) {
        if let url = URL(string: url) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        } else {
            print("URL could not be formed.")
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OfflineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.offlineArticleList?.count ?? 0
        tableView.backgroundView?.isHidden = count > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: OfflineTableViewCell.self), for: indexPath) as! OfflineTableViewCell
        cell.setup(article: viewModel.offlineArticleList![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WSAppConstant.kTableViewCellHeight
    }
}

extension OfflineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.offlineArticleList![indexPath.row]
        self.openInSafari(url: viewModel.getURL(article: article))
    }
}

extension OfflineViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension OfflineViewController: OfflineViewModelDelegate {
    func offlineArticleListUpdated() {
        self.reloadData()
    }
}
