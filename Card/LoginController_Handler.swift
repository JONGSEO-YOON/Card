
//
//  LoginController_Handler\.swift
//  CardxTED
//
//  Created by 윤종서 on 2016. 8. 12..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    
    func handleSelectPrifileImage() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("Canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleloginRegisterSegmentedControl() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        //Change inputsContainerView
        if(loginRegisterSegmentedControl.selectedSegmentIndex == 0){
            inputsContainerViewHeightAnchor?.constant = 100
            
            nameHeightAnchor?.isActive = false
            emailHeightAnchor?.isActive = false
            passwordHeightAnchor?.isActive = false
            
            nameHeightAnchor = nametextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 0)
            emailHeightAnchor = EmailTextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/2)
            passwordHeightAnchor = PasswordTextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/2)
            
            nameHeightAnchor?.isActive = true
            emailHeightAnchor?.isActive = true
            passwordHeightAnchor?.isActive = true
            
        }
        else{
            inputsContainerViewHeightAnchor?.constant = 150
            
            nameHeightAnchor?.isActive = false
            emailHeightAnchor?.isActive = false
            passwordHeightAnchor?.isActive = false
            
            nameHeightAnchor = nametextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/3)
            emailHeightAnchor = EmailTextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/3)
            passwordHeightAnchor = PasswordTextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/3)
            
            nameHeightAnchor?.isActive = true
            emailHeightAnchor?.isActive = true
            passwordHeightAnchor?.isActive = true
            
        }
        
        
        
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else{
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = EmailTextField.text, let password = PasswordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleRegister() {
        guard let email = EmailTextField.text, let password = PasswordTextField.text, let name = nametextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            //successfully
            let imageName = UUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("ProfileImages").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
            
            //if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
                self.dismiss(animated: true, completion: nil)
                
            }
        })
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]){
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil{
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    


}
