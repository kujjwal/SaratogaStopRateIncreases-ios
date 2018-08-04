//
//  FourthViewController.swift
//  Silicon Valley Water
//
//  Created by Ujjwal Krishnamurthi on 8/2/18.
//  Copyright © 2018 Ujjwal Krishnamurthi. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import WebKit

class FourthViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    let list = ["http://www.rishikumar.com/uploads/3/3/0/6/3306532/cpuc_public_hearing_may_30th_2018__3_.docx", "http://www.rishikumar.com/uploads/3/3/0/6/3306532/cpuc_sjwc_insurance.docx", "http://www.rishikumar.com/uploads/3/3/0/6/3306532/cpuc_public_hearing_november_6th_2017.docx", "http://www.rishikumar.com/uploads/3/3/0/6/3306532/rishikumar_sjwc_adv518_sl.pdf", "http://www.rishikumar.com/uploads/3/3/0/6/3306532/scvwd_remove_mandatory.docx"];
    let listNames = ["CPUC Hearing–May 2018", "CPUC SJWC Insurance Waivers", "CPUC Hearing-November 2017", "CPUC and SJWC Audit Letters", "SCVWD Drought and Water Appeals"];
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self;
        indicator.hidesWhenStopped = true;
    }
    
    override func loadView() {
        super.loadView();
        let url: URL! = URL(string: list[0]);
        webView.scalesPageToFit = true;
        webView.loadRequest(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20.0));
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        cell.textLabel?.text = listNames[indexPath.row];
        
        return (cell);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        let url: URL! = URL(string: list[indexPath.row]);
        webView.loadRequest(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15.0));
    }
    
    @IBAction func councilmember_act(_ sender: UIButton) {
        self.sendEmailTo(to: ["rkumar@saratoga.ca.us"], subject: "Saratoga Water App FAQ", text: "Question: ");
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
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return IndexPath(row: 0, section: 0);
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicator.startAnimating();
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating();
    }
}
