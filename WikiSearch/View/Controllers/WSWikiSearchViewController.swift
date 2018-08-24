//
//  WSWikiSearchViewController.swift.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 22/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit
import SafariServices

class WSWikiSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = WikiSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = WSAppConstant.kTitleText
        viewModel.delegate = self
        self.isLoading = true
        viewModel.fetchAllPageIds()
    }
    
    var isLoading: Bool = false {
        didSet {
            self.tableView.backgroundView = self.emptyBackgroundView
        }
    }
    
    var emptyBackgroundView:UIView {
        get {
            let emptyBackgroundView = UIView.init(frame: self.view.bounds)
            let message = UILabel.init(frame: CGRect.init(x: 0, y: (emptyBackgroundView.frame.height/2) - 150, width: emptyBackgroundView.frame.width, height: 50))
            message.text = self.viewModel.searchText.count > 0 ? "Oops... couldn't find anything." : "Please type something to search."
            message.numberOfLines = 0
            message.textAlignment = .center
            emptyBackgroundView.addSubview(message)
            return emptyBackgroundView;
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.tableView.reloadData()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension WSWikiSearchViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension WSWikiSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.viewModel.articleCount
        tableView.backgroundView?.isHidden = count > 0 && !isLoading
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: WSWikiSearchTableViewCell.self), for: indexPath) as! WSWikiSearchTableViewCell
        cell.setup(article: viewModel.searchResultList![indexPath.row])
        cell.downloadButton.isHidden = viewModel.isAlreadySaved(viewModel.searchResultList![indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WSAppConstant.kTableViewCellHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

extension WSWikiSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.searchResultList![indexPath.row]
        self.openInSafari(url: viewModel.getURL(article: article))
    }
}

extension WSWikiSearchViewController: WSWikiSearchTableViewCellDelegate {
    func didTapOnDownloadButton(forCell cell: WSWikiSearchTableViewCell) {
        let idxPath = self.tableView.indexPath(for: cell)
        if !viewModel.isAlreadySaved(viewModel.searchResultList![(idxPath?.row)!]) {
            viewModel.cacheArticle(viewModel.searchResultList![(idxPath?.row)!])
            cell.downloadButton.isHidden = true
        }
    }
}

extension WSWikiSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: WSAppConstant.kSearchAnimationDuration) {
            self.view.endEditing(true)
            self.searchBar.text = ""
            self.viewModel.searchText = self.searchBar.text!
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension WSWikiSearchViewController: WikiSearchViewModelDelegate {
    func searchResultListUpdated() {
        self.reloadData()
    }
    
    func failedToGetData() {
        self.reloadData()//Can handle failure in a different way.
    }
}
