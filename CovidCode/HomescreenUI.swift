//
//  Homescreen.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct HomescreenUI: View {
    
    @State private var showDetail = false
    var parentTabController: TabControllerUI
    var username: String

    var body: some View {
            VStack {
                Text("Weclome " + username)
                    .padding()
                    .font(.largeTitle)
                Spacer()
                Text("Your QR Code")
                    .font(.title)
                    .padding()
                Button(action: {
                    showDetail.toggle()
                }) {
                    if (showDetail){
                        Image(uiImage: generateQRCode(from: "www.google.com")).interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    } else {
                        Image(uiImage: generateQRCode(from: "www.google.com")).interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }
                if (!showDetail) {
                    Text("Click image to enlarge").font(.caption)
                }
                Button(action: {
                }) {
                    Text("What is this?")
                }
                .padding()
                Spacer()
                VStack {
                if (getIfUserCompletedSurveyToday()) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(UIColor.systemGreen))
                    Text("You have completed your survey for today. Keep it up!").fontWeight(.bold).padding()
                } else {
                    Image(systemName: "xmark.circle.fill").font(.system(size: 30, weight:      .regular)).foregroundColor(Color(UIColor.systemPink))
                    VStack {
                        Text("You have not completed your survey for today. Check the calendar!").fontWeight(.bold).padding()
                        Button(action: {
                            parentTabController.selectedTab = 2
                        }) {
                            Text("Go To Calender")
                                .foregroundColor(.white)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                                .shadow(radius: 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                }
                .padding()
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 4))
                Spacer()
            }
            .padding()
        
    }
    
    private func getIfUserCompletedSurveyToday() -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        let actualDate = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
        let defaults = UserDefaults.standard
        if let surveyFilledStatus = defaults.string(forKey: actualDate) {
            return true
        } else {
            return false
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let image = filter.outputImage {
            if let img = context.createCGImage(image, from: image.extent) {
                return UIImage(cgImage: img)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    
}
