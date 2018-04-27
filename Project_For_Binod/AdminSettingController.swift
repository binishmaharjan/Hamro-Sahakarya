//
//  AdminSettingController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/06.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class AdminSettingController: UIViewController{
    
    //MARK: IBOutlet and Variables
    //Reference to Tableveiw
    @IBOutlet var tableView: UITableView!
    
    //Titles
    let tableTitle : [String] = ["Overview",
                                 "Delete User",
                                 "Make Admin",
                                 "Add Amount",
                                 "Add Amount to all Members",
                                 "Loan a Member",
                                 "Loan Returned",
                                 "Add Expenses",
                                 "Add Extra",
                                 "Sign Up",
                                 "Noticeboard Message"]
    let descriptionTitle : [String] = ["Overview of the balance sheet",
                                       "Delete a member",
                                       "Upgrade a user to admin",
                                       "Add some amount",
                                       "Add some amount to all members",
                                       "Give loan to the member","Loan was returned by the member",
                                       "All the expenses of the group",
                                       "Extra income of the group",
                                       "Add a new member",
                                       "Write new message to notice board"]

    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting Delegate and Datasource for tableView
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AdminSettingController : UITableViewDelegate, UITableViewDataSource{
    //Table View Function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row + 1)) \(tableTitle[indexPath.row])"
        cell?.detailTextLabel?.text = descriptionTitle[indexPath.row]
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If Sign Up Was Clciked
        if indexPath.row == 9 {
            let rvc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! RegisterController
            _ = UINavigationController(rootViewController: rvc)
            rvc.title = "SIGN UP "
            self.navigationController?.pushViewController(rvc, animated: true)
            
        }
            //If Notice Board Message was Clicked
        else if indexPath.row == 10{
            let nbc = self.storyboard?.instantiateViewController(withIdentifier: "NoticeMessage") as! NoticeMessageController
            _ = UINavigationController(rootViewController: nbc)
            nbc.title = "WRITE MESSAGE"
            self.navigationController?.pushViewController(nbc, animated: true)
        }
            
            //If Other option was clicked
        else if indexPath.row != 0  {
            let mlfac = self.storyboard?.instantiateViewController(withIdentifier: "memberlistforadmin") as! MemberListForAdmin
            _ = UINavigationController(rootViewController: mlfac)
            mlfac.actionToBePerformed = indexPath.row
            mlfac.title = tableTitle[indexPath.row]
            self.navigationController?.pushViewController(mlfac, animated: true)
        }
            //If overview was clicked
        else if indexPath.row == 0 {
            let ovc = self.storyboard?.instantiateViewController(withIdentifier: "OverviewContoller") as! OverviewController
            _ = UINavigationController(rootViewController: ovc)
            ovc.title = "Overview"
            self.navigationController?.pushViewController(ovc, animated: true)
            
        }
    }
}
