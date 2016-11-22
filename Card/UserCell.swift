//
//  UserCell.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 18..
//  Copyright © 2016년 윤종서. All rights reserved.
//
import Firebase
import UIKit

class UserCell: UITableViewCell {
    
    var message: MesseageObject? {
        didSet {
            
            setupNameAndProfileImage()
            
            self.detailTextLabel?.text = message!.text
            
            if let seconds = message?.timestamp?.doubleValue{
                let timestampDate = Date(timeIntervalSince1970:  seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
      
        if let ID = message?.chayPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(ID)
            ref.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
                }, withCancel: nil)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        // ios 9 constraint anchors
        //need x, y, width, height anchors
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:  10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}

