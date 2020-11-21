/*
 * ShareSafe
 * NetworkManager.swift
 *
 *
 */

import Foundation
import Security
import UIKit

class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("*** challenge accepted: \(challenge)")
        let trust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        let myCertName = "cert"
        var remoteCertMatchesPinnedCert = false
        if let myCertPath = Bundle.main.path(forResource: myCertName, ofType: "der") {
            if let pinnedCertData = NSData(contentsOfFile: myCertPath) {
                // Compare certificate data
                let remoteCertData: NSData = SecCertificateCopyData(SecTrustGetCertificateAtIndex(trust, 0)!)
                if remoteCertData.isEqual(to: pinnedCertData as Data) {
                    print("=== matching certificate ===")
                    remoteCertMatchesPinnedCert = true
                }
                else {
                    print("=== certification data mismatch ===")
                }

            } else {
                print("=== certificate pinning broken ===")
            }
        } else {
            print("*** === certificate pinning not loading ===")
        }
        if remoteCertMatchesPinnedCert {
            print("=== certificate accepted ===")
            completionHandler(.useCredential, credential)
        } else {
            print("=== certificate denied ===")
            completionHandler(.rejectProtectionSpace, nil)
        }
    }
}
