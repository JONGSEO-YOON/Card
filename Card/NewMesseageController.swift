//
//  NewMesseageController.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 11..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit
import Firebase

class NewMesseageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "cellId"
    
    var users = [User]()
    
    lazy var BackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        let image = UIImage(named: "back")
        button.setImage(image, for: UIControlState())
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        return button
    }()
    
   
    
    let MainTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let TopNameTextField: UILabel = {
        var tf = UILabel()
        tf.text = "   Card x TED"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = UIColor.white
        
        tf.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    /////////////// override func
    ///////////////
    ///////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainTableView.delegate = self
        MainTableView.dataSource = self
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(topView)
        view.addSubview(MainTableView)
        
        MainTableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        SetupTableView()
        SettopView()
        
        fetchUser()
        
        
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                //
                DispatchQueue.main.async(execute: { 
                    self.MainTableView.reloadData()
                })
                //user.name = dictionary["name"]
                //user.email = dictionary["email"]
                
            }
            }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        
        let cell = MainTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UserCell
        
        let user = users[(indexPath as NSIndexPath).row]
        cell!.textLabel?.text = user.name
        cell!.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell?.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell!
    }
    var mainViewController: MainViewController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            print("Dismiss")
            let user = self.users[(indexPath as NSIndexPath).row]
            self.mainViewController?.showChatControllerForUser(user)
        }
    }
    ///////////////
    ///////////////
    ///////////////  func
    
    func handleBackButton() {
        let mainviewcontroller = MainViewController()
        
        //왼쪽에서 오른쪽으로 애니메이션
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(mainviewcontroller, animated: false, completion: nil)
    }
    
    func SetTopNameTextField(){
        TopNameTextField.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        TopNameTextField.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        TopNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        TopNameTextField.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 1/3).isActive = true
        
    }
    
    func SettopView() {
        topView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        topView.addSubview(BackButton)
        topView.addSubview(TopNameTextField)
        
        SetBackButton()
        SetupTopNameTextField()
    }
    
    func SetBackButton(){
        BackButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 0).isActive = true
        BackButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        BackButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        BackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func SetupTopNameTextField(){
        TopNameTextField.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        TopNameTextField.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        TopNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        TopNameTextField.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 1/3).isActive = true
    }
    
    func SetupTableView() {
        MainTableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        MainTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        MainTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        MainTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
}
