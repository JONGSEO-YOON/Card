//
//  ViewController.swift
//  Card
//
//  Created by 윤종서 on 2016. 7. 29..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit
import Firebase
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let TableCellId = "TableCellId"
    var MenuFlag = 0

    
    lazy var MenuButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        let image = UIImage(named: "menu")
        button.setImage(image, for: UIControlState())
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        
        return button
    }()
    
    //메세지 버튼
    lazy var NewMessegeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "speech-bubble")
        button.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        button.setImage(image, for: UIControlState())
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handleNewMesseageButton), for: .touchUpInside)
            
        return button
    }()
    
    func handleNewMesseageButton() {
        let newMesseageController = NewMesseageController()
        newMesseageController.mainViewController = self
        //오른쪽에서 왼쪽으로 애니메이션
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
 
        present(newMesseageController, animated: false, completion: nil)
        
    }
    
    fileprivate var MainTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        
        
        tv.translatesAutoresizingMaskIntoConstraints = false

        return tv
    }()
  
    
    let TopNameTextField: UILabel = {
        var tf = UILabel()
        tf.text = "Card x TED"
        tf.textAlignment = NSTextAlignment.center
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = UIColor.white
        tf.isUserInteractionEnabled = true
        
        tf.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    lazy var CloseMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: UIControlState())
        button.backgroundColor = UIColor(r:  255, g: 108, b: 108)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleColseMenuButton), for: .touchUpInside)
        return button
    }()
    
    lazy var LogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: UIControlState())
        button.backgroundColor = UIColor(r:  255, g: 108, b: 108)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let MenuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:  255, g: 108, b: 108)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:  255, g: 78, b: 78)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
      
        messages.removeAll()
        messageDictionary.removeAll()
        MainTableView.reloadData()
        
        observeUserMessages()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r:  220, g: 220, b: 220)
        view.addSubview(topView)
        
        MainTableView.delegate = self
        MainTableView.dataSource = self
        
        view.addSubview(MainTableView)
        MainTableView.register(UserCell.self, forCellReuseIdentifier: TableCellId)
        
        SettopView()
        SetMainTableView()
        checkLogin()
        
        //observeMessages()
        messages.removeAll()
        messageDictionary.removeAll()
        MainTableView.reloadData()
        
        observeUserMessages()
        
        //TopNameTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChantroller)))
    }
    
    func showChatControllerForUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        present(chatLogController, animated: false, completion: nil)
    }
    
    var messages = [MesseageObject]()
    var messageDictionary = [String: MesseageObject]()
    
    func observeUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messeages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = FIRDatabase.database().reference().child("Messeages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = MesseageObject()
                    message.setValuesForKeys(dictionary)
                    //self.messages.append(message)
                    
                    if let toID = message.toID {
                        self.messageDictionary[toID] = message
                        
                        self.messages = Array(self.messageDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            
                            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
                        })
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.MainTableView.reloadData()
                    })
                }

                
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    func observeMessages() {
        
        let ref = FIRDatabase.database().reference().child("Messeages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = MesseageObject()
                message.setValuesForKeys(dictionary)
                //self.messages.append(message)
                
                if let toID = message.toID {
                    self.messageDictionary[toID] = message
                    
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        
                        return message1.timestamp?.int32Value > message2.timestamp?.int32Value
                    })
                }
                
                DispatchQueue.main.async(execute: { 
                    self.MainTableView.reloadData()
                })
            }
            
           
            
            }, withCancel: nil)
    }
    
    
    
    var MenuConstraint: NSLayoutConstraint?
    var CloseButtonConstraint: NSLayoutConstraint?
    var topviewLeftConstraint: NSLayoutConstraint?
    var MainTableViewLeftConstraint: NSLayoutConstraint?
    
    func SettopView() {
        
        
        topviewLeftConstraint = topView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        topView.addSubview(MenuButton)
        topView.addSubview(TopNameTextField)
        //메세지 버튼
        topView.addSubview(NewMessegeButton)

        topviewLeftConstraint?.isActive = true
        
        SetMenuButton()
        SetTopNameTextField()
        //메세지 버튼
        SetNewMessegeButton()
        
    }
    
    //메세지 버튼
    
    func SetNewMessegeButton(){
        NewMessegeButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: 0).isActive = true
        NewMessegeButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        NewMessegeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        NewMessegeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func SetTopNameTextField(){
        TopNameTextField.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        TopNameTextField.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        TopNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        TopNameTextField.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 1/3).isActive = true
        
    }
    
    func handleMenuButton() {
        SetMenu()
        if(MenuFlag == 0){
        MenuFlag = 1
        
        MenuConstraint?.isActive = true
  
        MainTableViewLeftConstraint?.isActive = false
        topviewLeftConstraint?.isActive = false
        
        topviewLeftConstraint = topView.leftAnchor.constraint(equalTo: MenuView.rightAnchor)
        MainTableViewLeftConstraint = MainTableView.leftAnchor.constraint(equalTo: MenuView.rightAnchor)
        
        MainTableViewLeftConstraint?.isActive = true
        topviewLeftConstraint?.isActive = true
        }
        else if(MenuFlag == 1){
            MenuView.removeFromSuperview()
            CloseMenuButton.removeFromSuperview()
            LogoutButton.removeFromSuperview()
            
            MenuFlag = 0
        }
        
    }
    
    func handleColseMenuButton() {
        
        
        
        MenuView.removeFromSuperview()
        CloseMenuButton.removeFromSuperview()
        LogoutButton.removeFromSuperview()
        
        MenuFlag = 0
        
        
        MainTableViewLeftConstraint?.isActive = false
        topviewLeftConstraint?.isActive = false
        
        topviewLeftConstraint = topView.leftAnchor.constraint(equalTo: view.leftAnchor)
        MainTableViewLeftConstraint = MainTableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        
        MainTableViewLeftConstraint?.isActive = true
        topviewLeftConstraint?.isActive = true
        
    }
    
    func SetMenu() {
        view.addSubview(MenuView)
        
        
        MenuView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        MenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        MenuConstraint = MenuView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        MenuView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5).isActive = true
        
        MenuView.addSubview(CloseMenuButton)
        MenuView.addSubview(LogoutButton)
        SetCloseMenuButton()
        SetLogoutButton()
        CloseButtonConstraint?.isActive = true
        
        
        
        

    }
    
    
    
    func SetMenuButton() {
        MenuButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 0).isActive = true
        MenuButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20).isActive = true
        MenuButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        MenuButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func SetCloseMenuButton() {
        CloseMenuButton.leftAnchor.constraint(equalTo: MenuView.leftAnchor, constant: 0).isActive = true
        CloseMenuButton.topAnchor.constraint(equalTo: MenuView.topAnchor, constant: 20).isActive = true
        CloseButtonConstraint = CloseMenuButton.heightAnchor.constraint(equalToConstant: 60)
        CloseButtonConstraint?.isActive = true
        CloseMenuButton.widthAnchor.constraint(equalTo: MenuView.widthAnchor, multiplier: 1).isActive = true
    }
    
    func SetLogoutButton() {
        LogoutButton.leftAnchor.constraint(equalTo: MenuView.leftAnchor, constant: 0).isActive = true
        LogoutButton.topAnchor.constraint(equalTo: CloseMenuButton.bottomAnchor, constant: 10).isActive = true
        LogoutButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        LogoutButton.widthAnchor.constraint(equalTo: MenuView.widthAnchor).isActive = true
    }
    
    func checkLogin() {
        //not login
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
           fetchUserAndSetUpNavBarTitle()
            
            
            
        }
    }
    
    func fetchUserAndSetUpNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //user ID 사용하기 위해서.
                self.navigationItem.title = dictionary["name"] as? String
            }
            
            }, withCancel: nil)
    
    }
    
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func SetMainTableView() {
        MainTableViewLeftConstraint = MainTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
        MainTableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        //MainTableView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, multiplier: 1).active = true
        MainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        MainTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        MainTableViewLeftConstraint?.isActive = true
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[(indexPath as NSIndexPath).row]
        
        guard let chatPartnerId = message.chayPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: { (snapshot) in
            print(snapshot)
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user)
            
            }, withCancel: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: TableCellId)
        
        let cell = MainTableView.dequeueReusableCell(withIdentifier: TableCellId, for: indexPath) as! UserCell
        
        let message = messages[(indexPath as NSIndexPath).row]
        
        cell.message = message
        
        return cell
    }
    
    
}

/*
class customCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    let Image1: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let Image2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    let SeperateBar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    let Label1: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(15)
        label.text = "1123123123123"
        return label
    }()
    
    let Label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(15)
        label.text = "2123123123123123123"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(Image1)
        addSubview(Image2)
        addSubview(SeperateBar)
        addSubview(Label2)
        addSubview(Label1)
        
        // ios 9 constraint anchors
        //need x, y, width, height anchors
        
        Image1.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 0).active = true
        Image1.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        Image1.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/2).active = true
        Image1.heightAnchor.constraintEqualToConstant(200).active = true
        
        Image2.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: 0).active = true
        Image2.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        Image2.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/2).active = true
        Image2.heightAnchor.constraintEqualToConstant(200).active = true
        
        SeperateBar.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        SeperateBar.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        SeperateBar.widthAnchor.constraintEqualToConstant(1).active = true
        SeperateBar.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        
        Label1.centerXAnchor.constraintEqualToAnchor(Image1.centerXAnchor, constant: 0).active = true
        Label1.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        Label1.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/2).active = true
        Label1.heightAnchor.constraintEqualToConstant(200).active = true
        
        Label2.centerXAnchor.constraintEqualToAnchor(Image2.centerXAnchor, constant: 0).active = true
        Label2.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        Label2.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/2).active = true
        Label2.heightAnchor.constraintEqualToConstant(200).active = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}*/
