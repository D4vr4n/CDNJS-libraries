//
//  ViewController.swift
//  finalProject
//
//  Created by Davran Arifzhanov on 13.12.2020.
//

import UIKit
import Firebase
import APIRequest

//MARK: Downloading Images from Url
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class PackagesTableViewController: UITableViewController,UISearchDisplayDelegate, UISearchBarDelegate {
    
    
    var root = LibraryResponse(results: [])
    var search = LibraryResponse(results: [])
    var searchActive = false
    let searchController = UISearchController(searchResultsController: nil)
    let viewDetailSegueIdentifier = "viewDetailSegueIdentifier"
   
    //MARK: Loading JS packages from API
    func loadPackages(){
        APIRequest("GET", path: "/libraries").with(name: "fields", value: "version,description,homepage").execute(LibraryResponse.self) { data, status in
            if let root = data {
                self.root = root
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView)->Int{
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return search.results?.count ?? 0
            
        }else{
            return root.results?.count ?? 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if searchActive{
            let searchResult = search.results?[indexPath.row]
            
                cell.textLabel?.text = searchResult?.name
                cell.detailTextLabel?.text = searchResult?.version
                return cell
            
        } else {
            let result = root.results?[indexPath.row]
            
                cell.textLabel?.text = result?.name
                cell.detailTextLabel?.text = result?.version
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let librarySelected = root.results?[indexPath.row]
        print(librarySelected?.name ?? "")
        performSegue(withIdentifier: viewDetailSegueIdentifier, sender: librarySelected)
        
    }
    
    //MARK: Sharing data to DetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let librarySelected = sender as! Library
    
            
            if segue.identifier == viewDetailSegueIdentifier{
                if let dVC = segue.destination as? DetailViewController {
                    dVC.name = librarySelected.name
                    dVC.version = librarySelected.version
                    dVC.latestURL = librarySelected.latest
                    dVC.homeURL = librarySelected.homepage
                }

            }
            
        }
    
    //MARK: Filtering searched data
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
        
        search.results = root.results?.filter({ (item) -> Bool in
            if let name = item.name, name.range(of: searchText, options: .caseInsensitive) != nil{
                return true
            }

            return false
        })
        
        searchActive = true
        self.tableView.reloadData()
        
        if searchText == "" {
            searchActive = false
            self.tableView.reloadData()
            
        }
    }
    
  
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        loadPackages()
    }
    
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    
    
    private func handleNotAuthenticated(){
        //MARK: Checking if user authenticated before
        if Auth.auth().currentUser == nil{
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    


}

