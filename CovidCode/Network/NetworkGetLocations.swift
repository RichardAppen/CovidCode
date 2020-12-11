//
//  NetworkGetLocations.swift
//  CovidCode
//
//  Created by Daniel Walder on 12/10/20.
//

import Foundation


class NetworkGetLocations {
    typealias getLocationsHandler = ([String: String]) -> ()
    
    static func getLocations(username: String, password: String, handler: @escaping getLocationsHandler) {
        let parameters = ["username": username,
                          "password": password]
        let url = URL(string: "https://52.32.17.11:8000/api/get_all_risks")!
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
            print("LOCATIONS")
            print (responseJSON)
            if let responseJSON = responseJSON as? [String: String] {
                print("---------============#########============------------")
                print (responseJSON)
                //handler(responseJSON)
                handler(responseJSON)
                
                return
            }
        }
        task.resume()
    }

    
}



