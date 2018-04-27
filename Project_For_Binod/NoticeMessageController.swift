//
//  NoticeMessageController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/03/08.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class NoticeMessageController: UIViewController{

    //MARK: IBOutlet and Variables
    @IBOutlet var NoticeMessageTextView: UITextView!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        //Customising the text Area
        NoticeMessageTextView.layer.borderWidth = 1
        NoticeMessageTextView.layer.borderColor = UIColor(hex: "8F6593")?.cgColor
        NoticeMessageTextView.layer.cornerRadius = 5
        
        //Add delegate
        NoticeMessageTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    //Write Button was clicked
    @IBAction func writeButtonClicked(_ sender: Any) {
        if NoticeMessageTextView.text.isEmpty {
            NoticeMessageTextView.attributedText = NSAttributedString(string: "Write Messsage", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }else{
            //Writing to the database
            writeToTheNoticeBoard()
        }
    }
    
    
    //Function to write message to the noticeboard
    func writeToTheNoticeBoard(){
        let message = NoticeMessageTextView.text!
        
        //url componenet
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/notice.php")!
        
        urlComponent.query = "username=\(user!["username"]!)&message=\(message)"
        
        //gettning url from the componenet
        let url = urlComponent.url
        
        //Creating the deafult sessions
        let defaultSession : URLSession = URLSession(configuration: .default)
        var dataTask :URLSessionDataTask = URLSessionDataTask()
        
        
        //Starting the task
        dataTask = defaultSession.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error == nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    
                    guard let status = json["status"] as?  String else{
                        print("No Status")
                        return
                    }
                  

                    //Status 200 : Successful
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: json["message"] as! String,color: UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                        
                        //Logging out when reset is succesful with delay 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    }else{//Status 400 : Failed
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: json["message"] as! String, color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                }catch{
                    print(" Caught Error : \(error)")
                }
            }else{
                print("Error : \(String(describing: error))")
            }
        })
        
        dataTask.resume()
    }
}

extension NoticeMessageController : UITextViewDelegate{
    
    //TextView Delegate Functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
