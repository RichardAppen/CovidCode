//
//  NetworkGetFriend.swift
//  CovidCode
//
//  Created by Richard Appen on 11/26/20.
//

import Foundation


class NetworkGetIncomingFriends {
    typealias getFriendsIncomingHandler = ([String: String]) -> ()
    
    static func getIncomingFriends(username: String, password: String, handler: @escaping getFriendsIncomingHandler) {
        let parameters = ["username": username,
                          "password": password]
        let url = URL(string: "https://52.32.17.11:8000/api/get_friends")!
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
            
            if let responseJSON = responseJSON as? [String: [String: String]] {
                // API - One of these two results based on input from user
                //  {"error": username/password/friend} -- Malformed json input
                //  {"error": Username or password do not exist}
                //  {"status": Friend already added}
                //  {"error": Friend does not exist in system}
                //  {"status": deleted}
                //  {"status": no change} -- If this person is not a shared friend
                print("---------============#########============------------")
                print (responseJSON)
                //handler(responseJSON)
                if (responseJSON["inc_friends"] != nil) {
                    handler(responseJSON["inc_friends"]!)
                } else {
                    //handler(false, responseJSON["error"] as! String)
                }
                
                return
            }
        }
        task.resume()
    }

    
}


