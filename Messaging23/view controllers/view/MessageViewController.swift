//
//  PostViewController.swift
//  Messaging23
//
//  Created by Karissa McDaris on 12/10/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messageController = MessageController()
    
    var refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageController.message.count
        
    }
    
    
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        
        messageController.fetchMessages {
            
        }
        
        messageTableView.estimatedRowHeight = 45
        messageTableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        messageTableView.refreshControl = refreshControl
        
        self.reloadTableView()
        
        super.viewDidLoad()
        
    }
    
    @IBAction func addMessageButtonTapped(_ sender: Any) {
        
        presentNewMessageAlert()
        reloadTableView()
        
    }
    
    func presentNewMessageAlert(){
        
        let alertController = UIAlertController(title: "Add your own post!", message: "", preferredStyle: .alert)
        alertController.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Enter your username here..."
        }
        
        alertController.addTextField { (messageTextField) in
            messageTextField.placeholder = "Enter your message here..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let username = alertController.textFields?[0].text, !username.isEmpty,
                let message = alertController.textFields?[1].text, !message.isEmpty else {return}
            self.messageController.addNewMessageWith(username: username, text: message, completion: {
                self.reloadTableView()
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        self.present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = messageController.message[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) posted at \(Date(timeIntervalSince1970: post.timestamp))"
        
        return cell
    }
    
    @objc func refreshControlPulled(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        messageController.fetchMessages {
            
            self.reloadTableView()
            DispatchQueue.main.async {
                
                self.refreshControl.endRefreshing()
                
            }
        }
    }
    
    func reloadTableView(){
        
        DispatchQueue.main.async {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.messageTableView.reloadData()
            
        }
    }
}
