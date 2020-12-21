//
//  NewsTableViewController.swift
//  finalProject
//
//  Created by Davran Arifzhanov on 16.12.2020.
//

import UIKit
import SafariServices


class NewsTableViewController: UITableViewController {
    
    var articles = [Article]()
    let cellIdentifier = "PackageTableViewCell"
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    //MARK: Assigning values from API
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PackageTableViewCell
        let article = articles[indexPath.row]
        cell.authorLabel.text = article.author
        cell.titleLabel.text = article.title
        let imagelink = article.urlToImage!
        cell.posterImageView.downloaded(from: imagelink)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PackageTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsMultipleSelectionDuringEditing = false
        loadNews()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = articles[indexPath.row]
        let articleURL = selected.url!
        let vc = SFSafariViewController(url: URL(string: articleURL)!)
        present(vc, animated: true)
    }
    //MARK: Making API request
    func loadNews(){
        let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2020-12-10&to=2020-12-10&sortBy=popularity&apiKey=f1219a417f774d66939817dee2a25fd9")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    guard let data = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else{
                        print("Error trying to convert")
                        return
                    }
                    JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
                    let arrData = data["articles"] as? [[String: Any]] ?? [[String: Any]]()
                    let array = try JSONSerialization.data(withJSONObject: arrData)
                    
                    self.articles = try JSONDecoder().decode([Article].self, from: array)
                    for article in self.articles{
                        print(article.author!)
                    }
                    
                } catch {
                    print("Parse Error\(error)")
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
        
    }

    
}
