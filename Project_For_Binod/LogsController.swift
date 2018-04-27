//
//  LogsController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/06.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class LogsController: UIViewController{

    //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    var logs : [AnyObject] = [AnyObject]()
    
    //Refresh Control for the Table view
    private let refreshControl = UIRefreshControl()
    
    
    //MARK:  Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate for table view
        tableView.delegate = self
        tableView.dataSource = self
        
        //GEt all logs
        getAllLogs()
        
        //Set Title for Navigation Bar
        navigationItem.title = "LOGS"
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        //Add Target to the  resfresh control
        refreshControl.addTarget(self, action: #selector(refreshButtonPressed(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    //When refresh Button Is Pressed
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getAllLogs()
//        DispatchQueue.main.async {
//            appDelegate.errorView(message: "Refresing",color: UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
//        }
    }
    
    //Get logs from the database
    func getAllLogs(){
        DispatchQueue.main.async {
            //get url
            let urlComponent = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/showalllogs.php")
            guard let url = urlComponent?.url else {
                return
            }
            
            //Creating the deafult sessions
            let defaultSession : URLSession = URLSession(configuration: .default)
            var dataTask :URLSessionDataTask = URLSessionDataTask()
            
            
            //Starting the task
            dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        //parsing the data
                        guard let logs = json["logs"] else{
                            print("Error While Parsing Log")
                            return
                        }
                        
                        //Checking if there are log or not..if no logs i.e. logs is subclass of NSNUll
                        if logs is NSNull{
                             print(type(of: logs))
                        }else{
                            DispatchQueue.main.async {
                                self.logs = logs as! [AnyObject]
                                self.tableView.reloadData()
                                //print(self.logs)
                                
                                //Stoping the animation of the refresh control
                                self.refreshControl.endRefreshing()
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
}

extension LogsController : UITableViewDelegate,UITableViewDataSource{
    
    //Table Delegate and Datasource Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LogCell
        let temp = logs[indexPath.row]
        
        //Replacing the values in the log
        cell.usernameLabel.text = temp["username"] as? String
        cell.fullnameLabel.text = temp["fullname"] as? String
        cell.dateLabel.text = temp["date"] as? String
        cell.logLabel.text = temp["log"] as? String
        
        //Downloading all replacing the image
        if let imageUrl = temp["ava"] as? String{
            if imageUrl.isEmpty{
                cell.avaImageView.image = UIImage(named: "hamro_sahakarya")
            }else{
                let url = URL(string: imageUrl)
                if let imageData  = NSData(contentsOf: url!){
                    cell.avaImageView.image = UIImage(data: imageData as Data)
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
