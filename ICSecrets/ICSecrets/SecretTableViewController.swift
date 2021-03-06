//
//  SecretTableViewController.swift
//  ICSecrets
//
//  Created by Ali Attar on 26/02/2016.
//  Copyright © 2016 Ali Attar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SecretTableViewController: UITableViewController {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var headerView: UIView!
  
  override func viewDidLoad() {
    let oldTitleFrame = titleLabel.frame
    let oldFrame = headerView.frame
    
    print(oldTitleFrame)
    headerView.frame = CGRectMake(0, 0, super.view!.frame.width, super.view!.frame.height)
        
    titleLabel.updateConstraints()
    print(titleLabel.frame)
    
    UIView.animateWithDuration(1.5, animations: {
      self.headerView.frame = oldFrame
      self.titleLabel.frame = oldTitleFrame
    })
    
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 25
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("secretCell", forIndexPath: indexPath) as! SecretTableCell
    
    cell.title.text = "Secret #2103"
    cell.detail.text = "Mathematics Year 2"
    cell.date.text = "02.01.2016"
    cell.secret.text = "This is a dummy test secret, let's see if it works."
    
    cell.secret.font = UIFont(name: "Courier", size: 16)
    cell.secret.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
    
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
    return cell
    
  }
  
  func getSecret(number: Int) -> String {

    var secret = ""
    var Request : FBSDKGraphRequest
    
    let parameters1 = ["access_token":FBSDKAccessToken.currentAccessToken().tokenString]
    
    Request  = FBSDKGraphRequest(graphPath:"ImperialCollegeSecrets/posts", parameters:parameters1, HTTPMethod:"GET")
    
    Request.startWithCompletionHandler({ (connection, result, error) -> Void in
      
      if ((error) != nil)
      {
        print("Error: \(error)")
      }
      else
      {
        let dataDict: AnyObject = result!.objectForKey("data")!
        let paging: AnyObject = result!.objectForKey("paging")!
        
        let num = number%25
        
        print(paging["next"])
        
        if let post = dataDict[num] as? [String: AnyObject] {
          if let message = post["message"] as? String {
            secret = message
          }
        }

      }
    })
    
    print(secret)
    return secret
  }
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    print("User Logged In")
    if ((error) != nil)
    {
      // Process error
    }
    else if result.isCancelled {
      // Handle cancellations
    }
    else {
      // If you ask for multiple permissions at once, you
      // should check if specific permissions missing
      if result.grantedPermissions.contains("email")
      {
        // Do work
      }
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }


  
}

class SecretTableCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var detail: UILabel!
  @IBOutlet weak var secret: UITextView!
  @IBOutlet weak var date: UILabel!
  
}