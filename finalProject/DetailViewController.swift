//
//  DetailViewController.swift
//  finalProject
//
//  Created by Davran Arifzhanov on 15.12.2020.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    var latestURL: String!
    var homeURL: String!
    var name: String!
    var version: String!
    
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBAction func getLatestTapped(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: latestURL)!)
        present(vc, animated: true)
    }
    
    @IBAction func goToHomepageTapped(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: homeURL)!)
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packageNameLabel.text = name
        versionLabel.text = version
    }
    

}
