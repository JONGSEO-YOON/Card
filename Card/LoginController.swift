//
//  LoginController.swift
//  Card
//
//  Created by 윤종서 on 2016. 7. 29..
//  Copyright © 2016년 윤종서. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let inputsContainerVeiw: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:  255, g: 108, b: 108)
        button.setTitle("회원가입", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        
        return button
    }()
    
        
    let nametextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name / 닉네임"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let nameSeparatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r:  220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let EmailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let EmailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r:  220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let PasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password / 6자리 이상"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Firstimage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPrifileImage)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
       
        let sc = UISegmentedControl(items: ["로그인", "회원가입"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.layer.cornerRadius = 10
        
        
        sc.addTarget(self, action: #selector(handleloginRegisterSegmentedControl), for: .valueChanged)
        
        return sc
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r:  255, g: 72, b: 72)
        
        view.addSubview(inputsContainerVeiw)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
       
        setupInputsContainerVeiw()
        setupLoginRegisterButton()
        setupProfileImage()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLoginRegisterSegmentedControl() {
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerVeiw.topAnchor, constant: -10).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerVeiw(){
        //need x, y, width, heigh constraints
        
        inputsContainerVeiw.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerVeiw.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerVeiw.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerVeiw.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        
        inputsContainerVeiw.addSubview(nametextField)
        inputsContainerVeiw.addSubview(nameSeparatorView)
        inputsContainerVeiw.addSubview(EmailTextField)
        inputsContainerVeiw.addSubview(EmailSeparatorView)
        inputsContainerVeiw.addSubview(PasswordTextField)
        
        //x, y nameTextField
        nametextField.leftAnchor.constraint(equalTo: inputsContainerVeiw.leftAnchor, constant: 12).isActive = true
        nametextField.topAnchor.constraint(equalTo: inputsContainerVeiw.topAnchor).isActive = true
        nametextField.widthAnchor.constraint(equalTo: inputsContainerVeiw.widthAnchor).isActive = true
        nameHeightAnchor = nametextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/3)
        nameHeightAnchor?.isActive = true
        
        //x, y nameSeparatorView
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerVeiw.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nametextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerVeiw.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //x, y nameTextField
        EmailTextField.leftAnchor.constraint(equalTo: inputsContainerVeiw.leftAnchor, constant: 12).isActive = true
        EmailTextField.topAnchor.constraint(equalTo: nametextField.bottomAnchor).isActive = true
        EmailTextField.widthAnchor.constraint(equalTo: inputsContainerVeiw.widthAnchor).isActive = true
        emailHeightAnchor = EmailTextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/3)
        emailHeightAnchor?.isActive = true
        
        //x, y nameSeparatorView
        EmailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerVeiw.leftAnchor).isActive = true
        EmailSeparatorView.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor).isActive = true
        EmailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerVeiw.widthAnchor).isActive = true
        EmailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //x, y nameTextField
        PasswordTextField.leftAnchor.constraint(equalTo: inputsContainerVeiw.leftAnchor, constant: 12).isActive = true
        PasswordTextField.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor).isActive = true
        PasswordTextField.widthAnchor.constraint(equalTo: inputsContainerVeiw.widthAnchor).isActive = true
        passwordHeightAnchor = PasswordTextField.heightAnchor.constraint(equalTo: inputsContainerVeiw.heightAnchor, multiplier: 1/3)
        passwordHeightAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, heigh constraints
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerVeiw.bottomAnchor, constant: 10).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImage() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green:  g/255, blue:  b/255, alpha:  1)
    }
}
