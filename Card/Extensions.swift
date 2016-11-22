//
//  Extensions.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 12..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit

let imageCache = NSCache()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //다운로드 에러일때
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}
