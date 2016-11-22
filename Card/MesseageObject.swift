//
//  MesseageObject.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 18..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit
import Firebase

class MesseageObject: NSObject {

    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toID: String?
    
    func chayPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toID : fromId
        
    }
}
