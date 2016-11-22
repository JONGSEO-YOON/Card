//
//  ChatLog.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 16..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let cellId = "cellId"
    var user: User? {
        didSet {
            TopNameTextField.text = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [MesseageObject]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messeages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("Messeages").child(messageId)
            
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = MesseageObject()
                message.setValuesForKeys(dictionary)
                
                if message.chayPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async(execute: {
                        self.collectionView?.reloadData()
                    })
                }
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Messeage.."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
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
    
    
    let TopNameTextField: UILabel = {
        var tf = UILabel()
        //tf.text = "   Chat Log"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.textColor = UIColor.white
        tf.textAlignment = NSTextAlignment.center
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[(indexPath as NSIndexPath).item]
        cell.textView.text = message.text
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[(indexPath as NSIndexPath).item].text{
            height = estimateFrameForText(text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(topView)
        
        SettopView()
        
        setupInputComponents()
        
    }
    
    ////////////
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(containerView)
        
        //ios9 constraing anchors
        //x,y,w,h
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let SendButton = UIButton(type: .system)
        SendButton.setTitle("Send", for: UIControlState())
        SendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(SendButton)
        //x,y,w,h
        SendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        SendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        SendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        SendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        SendButton.addTarget(self, action: #selector(handlesend), for: .touchUpInside)
        
        containerView.addSubview(inputTextField)
        //x, y, w, h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: SendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    func handlesend() {
        
        let ref = FIRDatabase.database().reference().child("Messeages")
        let childRef = ref.childByAutoId()
        let toId:String = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp:NSNumber = NSNumber(Int(Date().timeIntervalSince1970))
        let values = ["text": inputTextField.text!, "toID": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        //childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            let userMessagesRef = FIRDatabase.database().reference().child("user-messeages").child(fromId)
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID: 1])
        
            let recipientUserMessagessRef = FIRDatabase.database().reference().child("user-messeages").child(toId)
            recipientUserMessagessRef.updateChildValues([messageID: 1])
            
        }
        
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handlesend()
        return true
    }
    
  
}
