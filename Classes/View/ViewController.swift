//
//  ViewController.swift
//  BitBucketRepos
//
//  Created by achhatre on 27/06/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let viewModel = ViewModel()
    var repositories = [Repository]()
    @IBOutlet var repositoryTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRepositories(urlStr: Constants.bitBucketRepoURL)
    }
    
    @IBAction func loadNextBtnClicked(_ sender: Any) {
        if self.repositories.count > 0 {
            self.loadRepositories(urlStr: self.repositories[0].nextURL)
        }
    }
    
    func loadRepositories(urlStr: String) {
        self.viewModel.loadRepositories(urlStr: urlStr) { (repositories) in
            guard let repos = repositories else { return }
            self.repositories.append(contentsOf: repos)
            DispatchQueue.main.async {
                self.repositoryTable?.reloadData()
            }
        }
    }
    
    // MARK Tableview Datasource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as! RepositoryTableViewCell
        cell.viewModel = self.viewModel
        
        if indexPath.row < self.repositories.count {
            let repository = self.repositories[indexPath.row]
            cell.nameLabel?.text = repository.displayName
            cell.typeLabel?.text = repository.type
            cell.dateLabel?.text = repository.date
            cell.avatarImageURL = repository.avatarURL
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
}

