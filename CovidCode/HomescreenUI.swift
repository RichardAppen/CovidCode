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
        ScrollView {
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY <= 0 {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .offset(y: geometry.frame(in: .global).minY/9)
                    .frame(width: geometry.size.width, height: geometry.size.height*4)
                } else {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                    .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            TopWelcomeView(username: username).padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            VStack {
                
                StatisticsButton(increaseNumber: 700, title: "CONFIRMED", mainValue: 898765, subTitle: "Cases", isPlusGreen: false).padding()
                StatisticsButton(increaseNumber: 500, title: "CONFIRMED", mainValue: 747634, subTitle: "Deaths", isPlusGreen: false).padding()
                StatisticsButton(increaseNumber: 600, title: "CONFIRMED", mainValue: 645373, subTitle: "Recoveries", isPlusGreen: true).padding()
                Divider().frame(height: 2).background(Color(UIColor.darkGray)).padding()
                Spacer()
                HStack {
                    gotToQRCodeButton(parentTabController: parentTabController, showDetail: showDetail).padding()
                    
                VStack {
                if (getIfUserCompletedSurveyToday()) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                    Text("Today's Survey Complete!").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
                } else {
                    Image(systemName: "xmark.circle.fill").font(.system(size: 30, weight:      .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                    GeometryReader { geometry in
                    VStack {
                        Text("Today's Survery Not Complete!").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
                        Button(action: {
                            parentTabController.selectedTab = 2
                        }) {
                            Text("Go To Calender")
                                .foregroundColor(.white)
                                .padding(6)
                        }
                        .frame(width: geometry.size.width / 1.1)
                        .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        .buttonStyle(PlainButtonStyle())
                    }
                    }
                }
                }
                .padding()
                /*.cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 4))*/
                }
            }
            .padding()
        }//.background(Color(red: 119/255, green: 158/255, blue: 203/255))
        .edgesIgnoringSafeArea(.top)
        
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

struct StatisticsButton: View {
    var increaseNumber: Int
    var title: String
    var mainValue: Int
    var subTitle: String
    var isPlusGreen : Bool
    var body: some View {
        Button(action: {
            
        }) {
            VStack{
                HStack {
                Text(title).font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                Text(String(mainValue)).frame(alignment: .trailing)
                }
                HStack {
                Text(subTitle).font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                getIncDecText()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.black)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 228/255, green: 228/255, blue: 228/255)))
                
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    
    private func getIncDecText() -> some View {
        var stringToReturn : String
        var colorToUse: Color
        if (increaseNumber >= 0) {
            stringToReturn = " +" + String(increaseNumber) + " "
            if (isPlusGreen) {
                colorToUse = Color(red: 119/255, green: 221/255, blue: 119/255)
            } else {
                colorToUse = Color(red: 250/255, green: 128/255, blue: 114/255)
            }
        } else {
            stringToReturn = " -" + String(increaseNumber) + " "
            if (isPlusGreen) {
                colorToUse = Color(red: 119/255, green: 221/255, blue: 119/255)
            } else {
                colorToUse = Color(red: 250/255, green: 128/255, blue: 114/255)
            }
        }
        
        return Text(stringToReturn).background(RoundedRectangle(cornerRadius: 8).fill(colorToUse)).frame(alignment: .trailing)
    }

}


struct TopWelcomeView: View {
    var username: String
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text("Weclome " + username.capitalizingFirstLetter())
                .font(.largeTitle)
                //.background(Color(red: 119/255, green: 158/255, blue: 203/255))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            Text(getCurrDate())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
    
    private func getCurrDate() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        var currentMonthWritten: String

        switch (currentMonth) {
        case 1:
            currentMonthWritten = "January"
        case 2:
            currentMonthWritten = "Feburary"
        case 3:
            currentMonthWritten = "March"
        case 4:
            currentMonthWritten = "April"
        case 5:
            currentMonthWritten = "May"
        case 6:
            currentMonthWritten = "June"
        case 7:
            currentMonthWritten = "July"
        case 8:
            currentMonthWritten = "August"
        case 9:
            currentMonthWritten = "September"
        case 10:
            currentMonthWritten = "October"
        case 11:
            currentMonthWritten = "Novemeber"
        default:
            currentMonthWritten = "Decemeber"
        }
        
        return currentMonthWritten + " " + String(currentDay) + ", " + String(currentYear)
    }
}

struct TopBlueParralax: View {
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .frame(width: UIScreen.main.bounds.width)
        }
    }
}

struct gotToQRCodeButton: View {
    var parentTabController: TabControllerUI
    var showDetail: Bool
    var body: some View {
        VStack {
        Button(action: {
            let contentView = QRCodeUI(showDetail: showDetail, parentTabController: parentTabController)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: contentView)
                window.makeKeyAndVisible()
            }
        }) {
            Image(systemName: "qrcode.viewfinder").font(.system(size: 100, weight: .regular)).foregroundColor(Color(UIColor.black))
                
        }
    
            Text("Scan/Generate Your QR Code").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
        }
    }
}
