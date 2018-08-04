//
//  SecondViewController.swift
//  Silicon Valley Water
//
//  Created by Ujjwal Krishnamurthi on 7/24/18.
//  Copyright © 2018 Ujjwal Krishnamurthi. All rights reserved.
//

import UIKit
import MessageUI

class SecondViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var summary: UIButton!
    @IBOutlet weak var details: UIButton!
    @IBOutlet weak var HowToUse: UIButton!
    
    var details_str: String = "";
    var summary_str: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summary.layer.cornerRadius = 12;
        details.layer.cornerRadius = 12;
        
        HowToUse.titleLabel?.textAlignment = .center;
        HowToUse.layer.cornerRadius = 12;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func summary_action(_ sender: UIButton) {
        let alert = UIAlertController(title: "Summary", message: self.summary_str, preferredStyle: .alert);
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in });
        alert.addAction(cancel);
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func details_action(_ sender: UIButton) {
        let alert = UIAlertController(title: "Details", message: self.details_str, preferredStyle: .alert);
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in });
        alert.addAction(cancel);
        self.present(alert, animated: true, completion: nil);
    }
    
    @IBAction func councilmember_action(_ sender: UIButton) {
        self.sendEmailTo(to: ["rkumar@saratoga.ca.us"], subject: "Saratoga Water App FAQ", text: "Question: ");
    }
    
    @IBAction func howtouse_act(_ sender: UIButton) {
        let app_str: String = "This app allows you to send protest letters from the main tab, and has information about our protest in the second tab. The third tab has downloads, where you can view the steps of our protest process thus far. The fourth tab has graphics from studies of water consumption and water rate increases. The fifth tab has additional information about community involvement and what you can do to contribute–district meetings, filings, hearings, and how we will continue our protesting process.";
        let alert = UIAlertController(title: "App Information", message: app_str, preferredStyle: .alert);
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in });
        alert.addAction(cancel);
        self.present(alert, animated: true, completion: nil);
    }
    
    func sendEmailTo(to: [String], subject: String, text: String) -> Void {
        let composeVC = MFMailComposeViewController();
        composeVC.mailComposeDelegate = self;
        composeVC.setToRecipients(to);
        composeVC.setSubject(subject);
        composeVC.setMessageBody(text, isHTML: false);
        
        self.present(composeVC, animated: true, completion: nil);
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil);
    }
    
    func openUrl(url:String!) {
        let url = URL(string: url);
        if(UIApplication.shared.canOpenURL(url!)) {
            UIApplication.shared.open(url!);
        }
    }
}

