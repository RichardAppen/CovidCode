//
//  NetworkGetRiskHistory.swift
//  CovidCode
//
//  Created by Ryan muinos on 12/9/20.
//
//
//  NetworkGetFriend.swift
//  CovidCode
//
//  Created by Richard Appen on 11/26/20.
//

import Foundation


class NetworkGetRiskHistory {
    typealias getRiskHistoryHandler = ([String: String]) -> ()
    
    static func getRiskHistory(username: String, password: String, handler: @escaping getRiskHistoryHandler) {
        let parameters = ["username": username,
                          "password": password]
        let url = URL(string: "https://52.32.17.11:8000/api/get_risk_hist")!
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

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            //print (responseJSON)
            if let responseJSON = responseJSON as? [String: String] {
                // API - One of these two results based on input from user
                print("---------============#########============------------")
                
                //handler(responseJSON)
                if (responseJSON["error"] != nil) {
                    handler([:])
                } else if (responseJSON != nil) {
                    handler(responseJSON as [String: String] )
                    
                } else {
                    handler([:])
                }
                
                return
            }
        }
        task.resume()
    }

    
}


