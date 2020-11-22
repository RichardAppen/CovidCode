/*
 * Covid Code
 * NetworkUser.swift
 *
 * User related network functions
 *
 * Created by Colin Drewes
 */

import Foundation

class NetworkLogin {
    // Function takes a bool and has no return value
    typealias userLoginHandler = (Bool) -> ()
 
    static func loginUser(username: String, password: String, handler: @escaping userLoginHandler) {
        let parameters = ["username": username,
                          "password": password]
        let url = URL(string: "https://52.32.17.11:8000/api/user_login")!
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
                //  {"error": username/password} -- Malformed json input
                //  {"error": Username or password do not exist}
                //  {"status": Login successful}
                print (responseJSON)

                return
            }
        }
        task.resume()
    }
}
