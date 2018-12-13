//
//  PostController.swift
//  Messaging23
//
//  Created by Karissa McDaris on 12/10/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import Foundation

class MessageController {
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    var message: [Messages] = []
    
    func addNewMessageWith(username: String, text: String, completion: @escaping() -> Void) {
        
        let post = Messages(username: username, text: text)
        var postData: Data
        
        do {
            
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(post)
            
        } catch {
            
            print("\(error.localizedDescription)")
            completion()
            return
        }
        
        guard let unwrappedURL = baseURL else {completion() ; return}
        
        var postEndpoint = unwrappedURL.appendingPathExtension("json")
        
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                
                print("\(error)there was an error recieving data from \(#function)")
                completion()
                return
                
            }
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8) else {NSLog("Data is nil bro"); completion() ; return}
            NSLog(responseDataString)
            self.fetchMessages {
                
                completion()
            }
        }
        
        dataTask.resume()
        
    }
    
    func fetchMessages(completion: @escaping () -> Void) {
        
        guard let url = baseURL else {completion() ; return}
        let getterEndpoint = url.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                
                print("\(error) there was an error recieving data from \(#function)")
                completion()
                return
            }
            
            guard let data = data else {completion() ; return}
            
            let decoder = JSONDecoder()
            
            do {
                
                let postsDictionary = try decoder.decode([String: Messages].self, from: data)
                var posts : [Messages] = postsDictionary.compactMap({$0.value})
                posts.sort(by: {$0.timestamp > $1.timestamp})
                self.message = posts
                completion()
                
            } catch {
                
                print("error decoding data")
                completion()
                return
                
            }
        }
        
        dataTask.resume()
        
    }
}
