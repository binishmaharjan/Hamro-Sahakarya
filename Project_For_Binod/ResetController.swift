//
//  ResetController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/02.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class ResetController: UIViewController {

    //MARK: IBOutlet and Variables
    @IBOutlet var bannerLogoView: UIImageView!
    @IBOutlet var emailTextView: UITextField_Designable!
    
    //Flag for is screen is up or not
    var isScreenUp : Bool = false
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //Customzise banner Image
        bannerLogoView.layer.cornerRadius = 90
        bannerLogoView.clipsToBounds = true
        
        //Setting Delegate for the textView
        emailTextView.delegate = self
        
        //Move screen up when keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Actions
    @IBAction func sendEmailButtonClicked(_ sender: Any) {
        //If texr is not entered in the text field
        if emailTextView.text!.isEmpty {
            emailTextView.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }else{//Email address was entered
            //Sending request to the php file
            
            //creating the url component
            var urlComponent = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/resetpassword.php?")!
            //adding query to the url component
            urlComponent.query = "email=\(emailTextView.text!)"
            
            //getting the url out of the url component
            guard let url = urlComponent.url else {
                return
            }
            
            print(url)
            //legendbinish124@gmail.com
            
            //Creating URLSession and URLSessionDataTask
            let defaultSession : URLSession = URLSession(configuration: .default)
            var dataTask :URLSessionDataTask?
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        print(json)
                        
                        
                        if let status = json["status"] as? String{
                            if status == "200"{
                                DispatchQueue.main.async {
                                    appDelegate.errorView(message: json["message"] as! String,color: UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                                }
                            }else{
                                DispatchQueue.main.async {
                                    appDelegate.errorView(message: json["message"] as! String,color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                                }
                            }
                        }
                        
                        
                    }catch{
                        print("Error while Catching : \(error)")
                        DispatchQueue.main.async {
                            let message = error.localizedDescription
                            appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                }else{
                    print("Error while creating the data task : \(String(describing: error))")
                    DispatchQueue.main.async {
                        let message = error?.localizedDescription
                        appDelegate.errorView(message: message!, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            })
            
            dataTask?.resume()

            
        }
    }
    
    //MARK: Keyboard
    //Functions to move screen up and down when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == false{
                self.view.frame.origin.y -= 200
                isScreenUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == true{
                self.view.frame.origin.y += 200
                isScreenUp = false
            }
        }
    }

}

extension ResetController : UITextFieldDelegate {
    //Function to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextView.resignFirstResponder()
        return true
    }
}
