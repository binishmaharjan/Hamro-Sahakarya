//
//  RegisterController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/02.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class RegisterController: UIViewController{

    //MARK: IBOutlets and Variable
    @IBOutlet var bannerLogoView: UIImageView!
    @IBOutlet var usernameTextView: UITextField_Designable!
    @IBOutlet var passwordTextView: UITextField_Designable!
    @IBOutlet var firstnameTextView: UITextField_Designable!
    @IBOutlet var lastnameTextView: UITextField_Designable!
    @IBOutlet var emailTextView: UITextField_Designable!
    
    //Flag for is screen is up or not
    var isScreenUp : Bool = false
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        //Customizing banner Logo
        bannerLogoView.layer.cornerRadius = 90
        bannerLogoView.clipsToBounds = true
        bannerLogoView.contentMode = .scaleAspectFill
        
        //Setting Delegate to textviews
        usernameTextView.delegate = self
        passwordTextView.delegate = self
        firstnameTextView.delegate = self
        lastnameTextView.delegate  = self
        emailTextView.delegate = self
        
        //Password Field
        passwordTextView.isSecureTextEntry = true
    
        
        
        //Move screen up when keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    @IBAction func registerButtonClicked(_ sender: Any) {
        //If all the text are not entered in the text field
        if usernameTextView.text!.isEmpty || passwordTextView.text!.isEmpty || emailTextView.text!.isEmpty || firstnameTextView.text!.isEmpty || lastnameTextView.text!.isEmpty {
            usernameTextView.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : UIColor.red])
            passwordTextView.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor.red])
            emailTextView.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor.red])
            firstnameTextView.attributedPlaceholder = NSAttributedString(string: "firstname", attributes: [NSForegroundColorAttributeName : UIColor.red])
            lastnameTextView.attributedPlaceholder = NSAttributedString(string: "lastname", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }else{//All text are entered procced to registration
            //Creating the url Component
            var urlComponent :  URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/register.php")!
            //Addidng the url component to query
            urlComponent.query = "username=\(usernameTextView.text!.lowercased())&password=\(passwordTextView.text!)&email=\(emailTextView.text!)&fullname=\(firstnameTextView.text!)+\(lastnameTextView.text!)"
            
            //Getting the url from urlCompnent
            guard let url = urlComponent.url else {
                return
            }
            //url to send to the php file
            print(url)
           
            //Starting the data Session
            let defautSession : URLSession = URLSession(configuration: .default)
            var dataTask : URLSessionDataTask
            
            dataTask = defautSession.dataTask(with: url, completionHandler: { (data, response, error) in
                //If there is no Error in dataTask
                if error == nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        let id = json["id"]
                       
                        if id != nil {
                            print(json)
                            DispatchQueue.main.async {
                                appDelegate.errorView(message: json["message"] as! String,color: UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                            }
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            DispatchQueue.main.async {
                                appDelegate.errorView(message: json["message"] as! String,color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                            }
                        }
                        
                        
                    }catch{
                        print("Caught Error : \(error)")
                        DispatchQueue.main.async {
                            let message = "Error!!!"
                            appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                }else{
                    print("Error : \(String(describing: error?.localizedDescription))")
                    DispatchQueue.main.async {
                        let message = "Error!!!"
                        appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            })
            
            //Executing the dataTask
            dataTask.resume()
        }
    }
    
    //MARK: Keyboard
    //Functions to move screen up and down when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == false{
                self.view.frame.origin.y -= 175
                isScreenUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == true{
                self.view.frame.origin.y += 175
                isScreenUp = false
            }
        }
    }
}

extension RegisterController :  UITextFieldDelegate {
    
    //Function to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextView.resignFirstResponder()
        passwordTextView.resignFirstResponder()
        firstnameTextView.resignFirstResponder()
        lastnameTextView.resignFirstResponder()
        emailTextView.resignFirstResponder()
        return true
    }
}
