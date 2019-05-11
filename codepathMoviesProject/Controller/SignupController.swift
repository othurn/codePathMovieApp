//
//  SignupController.swift
//  codepathMoviesProject
//
//  Created by Dong Yoon Han on 5/10/19.
//  Copyright © 2019 Oliver Thurn. All rights reserved.
//

import UIKit

class SignupController: UIViewController, UITextFieldDelegate{
    
    // UI components
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icons8-ios-application-placeholder-80"))
        return imageView
    }()
    
    let signUpDescriptionLabel: UILabel = {
        let label = UILabel()
        let descriptionStr:String = "New account"
        let attributedTitle = NSMutableAttributedString(string: descriptionStr, attributes: [ NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        label.attributedText = attributedTitle
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = 0
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let userTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = 1
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        //        textField.placeholder = "Password"
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.tag = 2
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordConfirmTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        //        textField.placeholder = "Password"
        textField.attributedPlaceholder = NSAttributedString(string: "Re-enter your password", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.tag = 3
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    var hidePasswordButton: UIButton = {
        
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "hide").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "visible").withRenderingMode(.alwaysTemplate), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        let buttonWidth:CGFloat = 26.5
        let buttonHeight:CGFloat = 37
        let buttonVerticalMargin:CGFloat = 9
        let buttonHorizontalMargin:CGFloat = 8
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        button.imageEdgeInsets = UIEdgeInsets(top: buttonVerticalMargin, left: 0, bottom: buttonVerticalMargin, right: buttonHorizontalMargin)
        
        button.tintColor = .black//colorTheme
        button.addTarget(self, action: #selector(hidePasswordButtonHandler), for: .touchUpInside)
        
        return button
    }()
    
    let signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.mainColor
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.4
        button.addTarget(self, action: #selector(signUpActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let backToLoginButton:UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Have an account? ", attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        attributedTitle.append(NSAttributedString(string: "Log in.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : Constants.mainColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(backToLoginButtonActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let lineView:UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor.rgbColor(220, 220, 220).cgColor
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
        setUpSubViewsLayout()
        observeKeyboardNotifications()
        
        textFieldDelegateSetup()
    }
    
    @objc func backToLoginButtonActionHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = (userTextField.text?.count ?? 0) > 0 && (emailTextField.text?.count ?? 0) > 0 && (passwordTextField.text?.count ?? 0) > 0 && (passwordConfirmTextField.text?.count ?? 0) > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.alpha = 1
        } else {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.4
        }
    }
    
    
    @objc func signUpActionHandler() {
        //TODO: after signup button touched
        
        guard let username = userTextField.text, let password = passwordTextField.text, let email = emailTextField.text,
            let confirmPassword = passwordConfirmTextField.text
            else { return }
        
        if password != confirmPassword {
            let alertVC = UIAlertController(title: "Password error", message: "password and confirm password must be equal", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
            
        }
        
//        let user = PFUser()
//        user.email = email
//        user.username = username
//        user.password = password
//
//        user.signUpInBackground { (success, error) in
//            if success {
//
//                PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
//                    if user != nil {
//                        let homeNaviVC = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
//                        self.present(homeNaviVC, animated: false, completion: nil)
//                    } else {
//                        print("Error: ", error!)
//                    }
//                }
//
//
//            } else {
//                print("Error: ", error!)
//            }
//        }
        
    }
    fileprivate func textFieldDelegateSetup() {
        emailTextField.delegate = self
        userTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
    }
    
    fileprivate func setUpSubViewsLayout() {
        
        verticalStackView.addArrangedSubViews([signUpDescriptionLabel, emailTextField, userTextField, passwordTextField, passwordConfirmTextField, signUpButton ])
        view.addSubviews([iconImageView, verticalStackView, lineView, backToLoginButton])
        
//        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150))
        iconImageView.anchor(top: nil, leading: nil, bottom: self.verticalStackView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150))
        iconImageView.centerXInSuperview()
//        verticalStackView.anchor(top: iconImageView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 50, right: 10))
        verticalStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: lineView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 100, right: 10))

        verticalStackView.constrainHeight(constant: 350)
        print("view.height: ", view.frame.height)
        
        
        backToLoginButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, size: .init(width: view.frame.width, height: 45))

        lineView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: backToLoginButton.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, size: .init(width: view.frame.width, height: 1))
        
        passwordTextField.rightView = hidePasswordButton
//        passwordTextField.rightViewMode = .whileEditing
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
//        print(userInfo)
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        print(keyboardFrame.height)
//        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

//            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -150 : -80
            self.view.frame = CGRect(x: 0, y: -keyboardFrame.height, width: self.view.frame.width, height: self.view.frame.height)
            
            
        }, completion: nil)
    }
    
    @objc func hidePasswordButtonHandler() {
        hidePasswordButton.isSelected = !hidePasswordButton.isSelected
        if hidePasswordButton.isSelected {
            passwordTextField.isSecureTextEntry = false
            
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        switch(textField.tag) {
        case 0:
            userTextField.becomeFirstResponder()
        case 1:
            passwordTextField.becomeFirstResponder()
        case 2:
            passwordConfirmTextField.becomeFirstResponder()
        case 3:
            passwordConfirmTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    deinit {
        print("SignupController has been deinitialzed!")
    }
}
