//
//  ChatMessageCell.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 19..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 162, b: 162)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(bubbleView)
        addSubview(textView)
        
        //ios 9 constraint
        //xywh
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant:  8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //textView.widthAnchor.constraintEqualToConstant(200).active = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
