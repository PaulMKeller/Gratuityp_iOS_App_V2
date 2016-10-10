//
//  ConnectViewController.swift
//  Gratuityp
//
//  Created by Paul Keller on 8/9/16.
//  Copyright © 2016 Paul Keller. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var confirm: UILabel!
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    @IBAction func submit(sender: AnyObject) {
        submitDetails()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        email.returnKeyType = .Done
        fname.returnKeyType = .Done
        lname.returnKeyType = .Done
        country.returnKeyType = .Done
        
        email.delegate = self
        fname.delegate = self
        lname.delegate = self
        country.delegate = self
        
        activityView.center = self.view.center
        self.view.addSubview(activityView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     Submit details for Gratuityp registration
     */
    func submitDetails() {
        
        self.view.endEditing(true)
        self.activityView.startAnimating()

        
        let url:NSURL = NSURL(string: "http://www.gratuityp.com/php/register.php")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        var paramString = "email=" + email.text!
        paramString += "&firstname=" + fname.text!
        paramString += "&lastname=" + lname.text!
        paramString += "&country=" + country.text!
        paramString += "&websiteSubmission=FALSE"
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(dataString)
            if dataString!.lowercaseString.rangeOfString("error") != nil {
                self.confirm.text = "ERROR: Check entries and try again."
            } else {
                self.confirm.text = "Thank you for connecting!"
            }
            self.activityView.stopAnimating()
        }
        
        task.resume()
        
    }


}

