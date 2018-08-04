//
//  Downloader.swift
//  Silicon Valley Water
//
//  Created by Ujjwal Krishnamurthi on 8/2/18.
//  Copyright © 2018 Ujjwal Krishnamurthi. All rights reserved.
//

import Foundation
class Downloader {
    class func load(URL: NSURL) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL as URL)
        request.httpMethod = "GET"
        
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            if (error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                
            }
            else {
                print("Failure: %@", error.localizedDescription);
            }
        })
        task.resume()
    }
}
