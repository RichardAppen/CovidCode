/*
 * Covid Code
 * NetworkRemoveFriend.swift
 *
 * Remove friend
 *
 * Created by Colin Drewes
 */

import Foundation

class NetworkRemoveFriend {
    typealias removeFriendHandler = (Bool, String) -> ()
    
    static func removeFriend(username: String, password: String, friend: String, handler: @escaping removeFriendHandler) {
        let parameters = ["username": username,
                          "password": password,
                          "friend": friend]
        let url = URL(string: "https://52.32.17.11:8000/api/remove_friend")!
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
                //  {"status": deleted}
                //  {"status": no change} -- If this person is not a shared friend
                print (responseJSON)
                if (responseJSON["status"] != nil && responseJSON["status"] as! String == "deleted") {
                    handler(true, "Friend removed")
                } else if (responseJSON["status"] != nil && responseJSON["status"] as! String == "no change") {
                    handler(false, "There was an error removing this friend")
                } else {
                    handler(false, responseJSON["error"] as! String)
                }
                return
            }
        }
        task.resume()
    }

    
}
