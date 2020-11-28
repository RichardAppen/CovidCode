//
//  NetworkNewRisk.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/26/20.
//

import SwiftUI

//STILL NEED HELP WITH THIS

class NetworkNewRisk {
    typealias newRiskHandler = (Bool, String) -> ()
    
    static func newRisk( username: String, password: String, risk: String, state: String, handler: @escaping newRiskHandler) {
        let parameters = ["username": username,
                          "password": password,
                          "risk": risk,
                          "state": state]
        let url = URL(string: "https://52.32.17.11:8000/api/new_risk")!
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: NSURLSessionPinningDelegate(),
                                 delegateQueue: nil)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // This blck is async
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            print(response)
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // API - One of these two results based on input from user
                //  {"error": username/password/first_name/last_name/email} -- Malformed json input
                //  {"error": user exists}
                //  {"status": Added}
                print (responseJSON)
                print("test1")
                if (responseJSON["status"] != nil && responseJSON["status"] as! String == "added") {
                    handler(true, "none")
                } else {
                    handler(false, responseJSON["error"] as! String)
                }

                return
            }
        }
        task.resume()
    }

    
}
