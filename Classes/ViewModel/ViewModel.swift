//
//  ViewModel.swift
//  BitBucketRepos
//
//  Created by achhatre on 27/06/21.
//

import Foundation
import UIKit

typealias JSONDictionary = [String: AnyObject]

class ViewModel {
    
    var webService = Webservice()
    
    func createRepositoryResource(urlStr: String) -> Resource<[Repository]>? {
        
        guard let url = URL(string: urlStr) else {return nil}
        
        let repositoryResource = Resource<[Repository]>(url: url , parse: { data in
            //Convert data to json
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
                  let valuesArray = json["values"] as? [JSONDictionary],
                  let nextURL = json["next"] as? String else {return nil}
            
            // parse the json data
            var repositories = [Repository]()
            for value in valuesArray {
                guard let date = value["updated_on"] as? String,
                      let owner = value["owner"] as? JSONDictionary,
                      let displayName = owner["display_name"] as? String,
                      let type = owner["type"] as? String,
                      let links = owner["links"] as? JSONDictionary,
                      let avatar = links["avatar"] as? JSONDictionary,
                      let avatarURL = avatar["href"] as? String else {
                    return nil
                }
                
                let repository = Repository(displayName: displayName, type: type, date: date, avatarURL: avatarURL, nextURL: nextURL)
                repositories.append(repository)
            }
            return repositories
        })
        return repositoryResource
    }
    
    
    func loadRepositories(urlStr: String, completion: @escaping ([Repository]?) -> ()) {
        
        guard let repositoryResource = createRepositoryResource(urlStr: urlStr) else {
            completion(nil)
            return
        }
        
        webService.load(resource: repositoryResource) { (repositories) in
            completion(repositories)
        }
    }
    
    func loadImageResource(urlStr: String, completion: @escaping (UIImage?) -> ()) {
        // Create Image resource
        guard let url = URL(string: urlStr) else {return}
        let imageResource = Resource<UIImage>(url: url) { (data) -> UIImage? in
            return UIImage(data: data)
        }
        
        // Load Image resource
        Webservice().load(resource: imageResource) { (image) in
            completion(image)
        }
    }
}
