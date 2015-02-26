//
//  SupportViewController.swift
//  grouplunch
//
//  Created by Randy Melder on 2/24/15.
//  Copyright (c) 2015 RCM Software, LLC. All rights reserved.
//

import UIKit
import MessageUI

class SupportViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let EMAIL_SUPPORT       = "grouplunch@spininternetmedia.com" as String
    var EMAIL_SUPPORT_SUBJ  = "GroupLunch™ App Suggestion" as String
    let app                 = UIApplication.sharedApplication().delegate as AppDelegate

    
    // MARK: ------------- Interaction --------------
    @IBOutlet weak var versionLabel: UILabel!
    @IBAction func doSuggestionButton(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func doCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: ------------- Email -----------------
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC  = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        mailComposerVC.setToRecipients([self.EMAIL_SUPPORT])
        mailComposerVC.setSubject("\(self.EMAIL_SUPPORT_SUBJ)")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        self.app.printLogMessage("Device cannot send email")
        let sendMailErrorAlert = UIAlertView(title: "No Email??", message: "Your device appears to not have an email account configured. Please add an account.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        if (nil != error) {
            self.app.printLogMessage(error.description)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: ------------- Built-Ins --------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.versionLabel.text      = "version: \(app.getAppMinorVersion())"
        self.EMAIL_SUPPORT_SUBJ     = "GroupLunch v\(self.app.getAppMinorVersion()) Suggestion"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
