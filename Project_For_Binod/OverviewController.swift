//
//  OverviewController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/21.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class OverviewController: UIViewController {
    
    //MARK: IBOutlet and Variables
    @IBOutlet var totalCollectionLbl: UILabel!
    @IBOutlet var loanGivenLbl: UILabel!
    @IBOutlet var expensenLbl: UILabel!
    @IBOutlet var extraLbl: UILabel!
    @IBOutlet var currentBalanceLbl: UILabel!
    @IBOutlet var balancesheetView: UIView_Designable!
    
    //width of the column
    var columnWidth : CGFloat = CGFloat()
    var heightRow : CGFloat = 36
    
    //Getting all data of member for overview
    var allUsers = [AnyObject]()
    
    //Varialbes
    var totalCollection : Int = 0
    var expenses : Int = 0
    var extra : Int = 0
    var loanGiven : Int = 0
    var currentBalance : Int = 0
    
    //NumberFormatter
    var numberFormatter : NumberFormatter = NumberFormatter()

    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the value for colun height
        columnWidth = (UIScreen.main.bounds.size.width - 56) / 4
        
        //Loading all users
        searchUsers(searchedText: "")
        
        //Initializing the number formatter
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
    }
 

    //MARK: Actions
    //Display All Users
    func searchUsers(searchedText :String){
        let word = searchedText
        
        //url componenet
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/users.php")!
        urlComponent.query = "word=\(word)&username=\((user?["username"])!)"
        
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
                    
                    guard let allUsers = json["users"] as?  [AnyObject] else{
                        return
                    }
                    
                    DispatchQueue.main.async {
                        //saving all users in the gobal users
                        self.allUsers = allUsers
                        print(self.allUsers)
                        
                        
                        //Filling the TableView if data is loaded
                          self.fillTheBalanceSheet()
                        
                        //Filling the total collection veiw
                        self.calulateTotalCollection()
                        
                        //Filling the expenses
                        self.calculateExpenses()
                        
                        //Fillin the extra
                        self.calculateExtra()
                        
                        //Filling loan Given
                        self.calulateLoanGiven()
                        
                        //Filling current balance
                        self.calculateCurrentBalance()
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
    
    //MARK: Balance Sheet Table
    //Function to fill the balance sheet
    func fillTheBalanceSheet(){
        //Title of the table
        let titleView = UIView()
        balancesheetView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.leadingAnchor.constraint(equalTo: balancesheetView.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: balancesheetView.trailingAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: balancesheetView.topAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: heightRow).isActive = true
        titleView.backgroundColor = UIColor(hex: "8F6593")
        
        //Add titles
        addTitleLabelToBalanceSheet(parentView: titleView)
        
        //main table VIew
        let scrollView = UIScrollView()
        balancesheetView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.trailingAnchor .constraint(equalTo: balancesheetView.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: balancesheetView.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: balancesheetView.topAnchor, constant: heightRow).isActive   = true
        scrollView.bottomAnchor.constraint(equalTo: balancesheetView.bottomAnchor, constant: 0).isActive = true

        
        scrollView.contentSize = CGSize(width: columnWidth * 4, height: CGFloat(allUsers.count) * heightRow)
        
        for i in 0..<allUsers.count{
            let singleUserRow = UIView()
            scrollView.addSubview(singleUserRow)
            singleUserRow.translatesAutoresizingMaskIntoConstraints = false
            singleUserRow.leadingAnchor.constraint(equalTo: balancesheetView.leadingAnchor, constant: 0).isActive = true
            singleUserRow.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: heightRow *  CGFloat(i)).isActive = true
            singleUserRow.trailingAnchor.constraint(equalTo: balancesheetView.trailingAnchor, constant: 0).isActive = true
            singleUserRow.heightAnchor.constraint(equalToConstant: heightRow).isActive = true
            
            //Filling single user row
            addUserColumn(parentView: singleUserRow, index: i)
        }
        
    }
    
    //Function to add title label to balance sheet
    func addTitleLabelToBalanceSheet(parentView : UIView){
        let titles : [String] = ["Username","Balance","Loan","Date"]
        
        for i in 0...3{
            let titleLabel = UILabel()
            parentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: columnWidth * CGFloat(i)).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: columnWidth).isActive = true
            titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
            titleLabel.text = titles[i]
            titleLabel.textAlignment = .center
            titleLabel.layer.borderWidth = 0.5
            titleLabel.layer.borderColor = UIColor.black.cgColor
            titleLabel.textColor = UIColor(hex: "3B252C")
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.font = UIFont(name: "Marker Felt", size: 17)
          
        }
    }
    
    //Function to add user column
    func addUserColumn(parentView : UIView , index : Int){
        for i in 0...3{
            let userColumn = UILabel()
            parentView.addSubview(userColumn)
            userColumn.translatesAutoresizingMaskIntoConstraints = false
            userColumn.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: columnWidth * CGFloat(i)).isActive = true
            userColumn.widthAnchor.constraint(equalToConstant: columnWidth).isActive = true
            userColumn.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
            userColumn.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
            userColumn.textAlignment = .center
            userColumn.layer.borderWidth = 0.5
            userColumn.layer.borderColor = UIColor.black.cgColor
            userColumn.textColor = UIColor(hex: "3B252C")
            userColumn.adjustsFontSizeToFitWidth = true
            userColumn.font = UIFont(name: "Marker Felt", size: 17)
            if i == 0 {//Setting the username
                guard let username = allUsers[index]["username"] as? String else{
                    print("No Username")
                    return
                }
                 userColumn.text = username
            }else if i == 1{//Settin the balance
                guard let balance = allUsers[index]["balance"] as? String else{
                    print("No Balance")
                    return
                }
                //Formatting the amount
                let formattedNumber  = numberFormatter.string(from: NSNumber(value:Int(balance)!))!
                userColumn.text = formattedNumber
                
            }else if i == 2{//Setting the loan
                guard let loan = allUsers[index]["loan"] as? String else{
                    print("No Loan")
                    return
                }
                //Formatting the amount
                let formattedNumber  = numberFormatter.string(from: NSNumber(value:Int(loan)!))!
                userColumn.text = formattedNumber
            }else if i == 3{// Setting the date
                guard let loan = allUsers[index]["loan"] as? String else{
                    print("No Loan")
                    return
                }
                
                guard let date = allUsers[index]["date"] as? String else{
                    print("No Date")
                    return
                }
                
                //Getting the date onlu from the date stamp
                let ind  = date.index(date.startIndex, offsetBy: 10)
                let dateOnly = date.substring(to: ind)
                
                if loan == "0" {
                    userColumn.text = "-"
                }else{
                     userColumn.text = dateOnly
                }
            }
            
        }

    }
    
    
    //Function to calculate the total collection of all member
    func calulateTotalCollection(){
        allUsers.forEach { (singleUser) in
            guard let balance = singleUser["balance"] as? String else{
                print("No Balance")
                return
            }
            
            let balanceInt : Int = Int(balance)!
            
            totalCollection = totalCollection + balanceInt
            
        }
        
        //Setting the text label

        let formattedNumber  = numberFormatter.string(from: NSNumber(value:totalCollection))!
        totalCollectionLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calclulate expenses
    func calculateExpenses(){
      
        guard let expensesString = allUsers[0]["expenses"] as? String else {
            print("No Expsenses")
            return
        }
        
        expenses = Int(expensesString)!
        
        //Setting the label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:expenses))!
        expensenLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calclulate extra
    func calculateExtra(){
        
        guard let extraString = allUsers[0]["extra"] as? String else {
            print("No Extra")
            return
        }
        
        extra = Int(extraString)!
        
        //Setting the label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:extra))!
        extraLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calculate the loan given to  all member
    func calulateLoanGiven(){
        allUsers.forEach { (singleUser) in
            guard let balance = singleUser["loan"] as? String else{
                print("No Loan")
                return
            }
            
            let LoanInt : Int = Int(balance)!
            
            loanGiven = loanGiven + LoanInt
            
        }
        
        //Setting the text label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:loanGiven))!
        loanGivenLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calculate Current Balance
    func calculateCurrentBalance(){
        currentBalance = totalCollection + extra - expenses - loanGiven
        
        //Setting the lable to the current balance label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:currentBalance))!
        currentBalanceLbl.text = "¥\(formattedNumber)"
    }
    



}
