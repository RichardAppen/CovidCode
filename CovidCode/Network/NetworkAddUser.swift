/*
 * Covid Code
 * NetworkAddUser.swift
 *
 * Add new user
 *
 * Created by Colin Drewes
 */

import Foundation

class NetworkAddUser {
    typealias addUserHandler = (Bool) -> ()
    
    static func addUser(first_name: String, last_name: String, username: String, password: String, email: String, handler: @escaping addUserHandler) {
        let parameters = ["first_name": first_name,
                          "last_name": last_name,
                          "username": username,
                          "password": password,
                          "email": email]
        let url = URL(string: "https://52.32.17.11:8000/api/new_user")!
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
                //  {"error": username/password/first_name/last_name/email} -- Malformed json input
                //  {"error": user exists}
                //  {"status": Added}
                print (responseJSON)

                return
            }
        }
        task.resume()
    }

    
}
