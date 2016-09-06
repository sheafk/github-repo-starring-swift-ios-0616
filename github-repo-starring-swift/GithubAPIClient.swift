//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {

    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "https://api.github.com/repositories?client_id=\(clientId)&client_secret=\(clientSecret)&access_token=\(token)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
       
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    //check if it is starred
    class func checkIfRepositoryIsStarred(fullName: String, completion:(Bool) ->()) {
        
        let session = NSURLSession.sharedSession()
        let urlString = "https://api.github.com/user/starred/\(fullName)?client_id=\(clientId)&client_secret=\(clientSecret)&access_token=\(token)"
        let url = NSURL(string: urlString)
        
        if let unwrappedURL = url {
            
            let request = NSMutableURLRequest(URL: unwrappedURL)
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request) {
                
                (data, response, error) in
                
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 204 {
                        completion(true)
                        print("this repo is starred already")
                    }
                    else if response.statusCode == 404 {
                        completion(false)
                        print("this repo is not starred yet")
                    } else {
                        print("Error get: \(error?.localizedDescription)")
                    }
                }
            }
            task.resume()
    } 
}
    
    //This adds a star
    class func starRepository(fullName: String, completion: () -> ()) {
        
        let session = NSURLSession.sharedSession()
        let urlString = "https://api.github.com/user/starred/\(fullName)?client_id=\(clientId)&client_secret=\(clientSecret)&access_token=\(token)"
        let url = NSURL(string: urlString)
        
        if let unwrappedURL = url {
            
            let request = NSMutableURLRequest(URL: unwrappedURL)
            request.HTTPMethod = "PUT"
            
            let task = session.dataTaskWithRequest(request) {
                
                (data, response, error) in
                
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 204 {
                        completion()
                        print("this repo is starred already")
                    } else {
                        print("ErrorPut: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    //This removes the star
    class func unstarRepository(fullName: String, completion: () -> ()) {
        
        let session = NSURLSession.sharedSession()
        let urlString = "https://api.github.com/user/starred/\(fullName)?client_id=\(clientId)&client_secret=\(clientSecret)&access_token=\(token)"
        let url = NSURL(string: urlString)
        
        if let unwrappedURL = url {
            
            let request = NSMutableURLRequest(URL: unwrappedURL)
            request.HTTPMethod = "DELETE"
            
            let task = session.dataTaskWithRequest(request) {
                
                (data, response, error) in
                
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 204 {
                        completion()
                        print("Unstarred")
                    } else {
                        print("ErrorDelete: \(error)")
                    }
                }
            }
            task.resume()
        }
    }

    
}



