//
//  NetworkSubmitQuestionnaire.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/22/20.
//

import Foundation

//currently a placeholder

class NetworkSubmitQuestionnaire {
    /*typealias addFriendHandler = (Bool) -> ()
    
    static func addFriend(username: String, password: String, friend: String, handler: @escaping addFriendHandler) {
        let parameters = ["username": username,
                          "password": password,
                          "friend": friend]
        let url = URL(string: "https://52.32.17.11:8000/api/add_friend")!
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
                // API - One of these two results based on input from user
                //  {"error": username/password/friend} -- Malformed json input
                //  {"error": Username or password do not exist}
                //  {"status": Friend already added}
                //  {"error": Friend does not exist in system}
                //  {"status": added, "shared": True/False}
                print (responseJSON)

                return
            }
        }
        task.resume()
    }*/

    
}
