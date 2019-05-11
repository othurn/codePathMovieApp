//
//  LoginController.swift
//  codepathMoviesProject
//
//  Created by Dong Yoon Han on 5/10/19.
//  Copyright © 2019 Oliver Thurn. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    // UI components
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icons8-ios-application-placeholder-80"))
        //        imageView.tintColor = colorTheme
        return imageView
    }()
    
    let userTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = 0
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.tag = 1
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
//        textField.rightView = self.hidePasswordButton
        textField.rightViewMode = .whileEditing
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
    
    let loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.mainColor
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.4
        button.addTarget(self, action: #selector(loginActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray ])
        attributedTitle.append(NSAttributedString(string: "Sign up.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : Constants.mainColor]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(signUpActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let lineView: UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor.rgbColor(220, 220, 220).cgColor
        return lineView
    }()
    
    // End of UI components
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.isNavigationBarHidden = true
        
        setUpSubViewsLayout()
        textFieldDelegateSetup()
        observeKeyboardNotifications()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func textFieldDelegateSetup() {
        userTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // Setup UI components
    fileprivate func setUpSubViewsLayout() {

        verticalStackView.addArrangedSubViews([userTextField, passwordTextField, loginButton])
        view.addSubviews([logoImageView, verticalStackView, lineView, signUpButton])
        
        signUpButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, size: .init(width: view.frame.width, height: 45))
        
        lineView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: self.signUpButton.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .zero, size: .init(width: view.frame.width, height: 1))
        
        verticalStackView.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: lineView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 200, right: 10))
        verticalStackView.constrainHeight(constant: 200)
        
        logoImageView.anchor(top: nil, leading: nil, bottom: self.verticalStackView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width:200, height: 200))
        logoImageView.centerXInSuperview()
        
        passwordTextField.rightView = hidePasswordButton
//        passwordTextField.rightViewMode = .whileEditing
    }
    
    
    // Logic
    // Login function
    @objc func loginActionHandler() {
        guard let username = userTextField.text, let password = passwordTextField.text else { return }
//        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
//            if user != nil {
//                let homeNaviVC = UINavigationController(rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
//                self.present(homeNaviVC, animated: false, completion: nil)
//            } else {
//                print("Error: ", error)
//            }
//        }
        self.dismiss(animated: false, completion: nil)
    }
    
    // Sign up function
    @objc func signUpActionHandler() {
        let signupVC = SignupController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    @objc func handleTextInputChange() {
        let isFormValid = (userTextField.text?.count ?? 0) > 0 && (passwordTextField.text?.count ?? 0) > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false
            loginButton.alpha = 0.4
        }
    }
    
    @objc func hidePasswordButtonHandler() {
        hidePasswordButton.isSelected = !hidePasswordButton.isSelected
        if hidePasswordButton.isSelected {
            passwordTextField.isSecureTextEntry = false
            
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -150 : -80
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField.tag) {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            passwordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    deinit {
        print("LoginController has been deinitialzed!")
    }
}
