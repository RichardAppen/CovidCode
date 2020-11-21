/*
 * ShareSafe
 * NetworkUser.swift
 *
 * User related network functions
 *
 * Created by Colin Drewes and Richard Appen
 * Copyright © 2020 Colin Drewes/Richard Appen. All rights reserved.
 */

import Foundation

class NetworkUser {
    typealias userLoginHandler = (Bool) -> ()
    typealias newUserHandler   = () -> ()
 
    // Check to see if the user has made it into the network
    static func networkStatus(username: String, password: String) {
        let parameters = ["username": username,
                             "password": password]
        let url = URL(string: "https://52.32.17.11:8000/user")!
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
            if let responseJSON = responseJSON as? [String: Any] {
                print (responseJSON)
                if let inNetwork = responseJSON.values.first as? String {
                    print(inNetwork)
                   /* if (inNetwork == "False") {
                        AmIinNetwork = false
                    } else {
                        AmIinNetwork = true
                    }*/
                }
                return
            }
        }
        task.resume()
    }
}
