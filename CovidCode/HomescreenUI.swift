//
//  Homescreen.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner

struct HomescreenUI: View {
    
    @State private var showDetail = false
    @State private var isShowingScanner = false
    @State private var covidRisk = UserDefaults.standard.integer(forKey: "risk")
    var parentTabController: TabControllerUI
    var username: String
    @State var results = [CovidTrackingInfo]()
    @State var cases = 0
    @State var casesIncrease = 0
    @State var deaths = 0
    @State var deathsIncrease = 0
    @State var negative = 0
    @State var negativeIncrease = 0
    @State var firstName = ""
    @State var lastName = ""
    @State var friendCount = UserDefaults.standard.integer(forKey: "friendsCount")
    @State var highRiskFriendCount = UserDefaults.standard.integer(forKey: "highRiskFriendsCount")
    @State var dark:Bool = false
    @State var showDetailMenu = false
    @State var fullname = ""

    var body: some View {
        ZStack {
        GeometryReader {_ in
        ScrollView {
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY <= 0 {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .offset(y: geometry.frame(in: .global).minY)
                    .frame(width: geometry.size.width, height: geometry.size.height*4)
                

                } else {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                    .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            TopWelcomeView(name: firstName, showDetailMenu: $showDetailMenu).padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            VStack {
                StatisticsButton(increaseNumber: highRiskFriendCount, title: "HIGH RISK FRIENDS", mainValue: highRiskFriendCount, subTitle: "In Your Friends List", isPlusGreen: false).padding()
                
                //StatisticsButton(increaseNumber: 2, title: "PERCENT OF USER", mainValue: 70, subTitle: "That May Have Covid", isPlusGreen: false).padding()
                QRCodeWindow(showDetail: showDetail, covidRisk: covidRisk ?? 0, sizeSmall: UIScreen.main.bounds.width / 1.7, sizeLarge: UIScreen.main.bounds.width / 1.1, extra: true, username: username)
                Divider().frame(height: 2).background(Color(UIColor.darkGray)).padding()
                Spacer()
                HStack {
                    gotToQRCodeButton(showDetail: showDetail).padding()
                VStack {
                if (getIfUserCompletedSurveyToday()) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                    Text("Today's Survey Complete!").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
                } else {
                    Image(systemName: "xmark.circle.fill").font(.system(size: 30, weight:      .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                    VStack {
                        Text("Today's Survery Not Complete!").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
                        Button(action: {
                            parentTabController.selectedTab = 2
                        }) {
                            Text("Go To Calender")
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.leading)
                                .padding(.trailing)
                                .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                }
                .padding()
                    
                /*.cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 4))*/
                }
                StatisticsButton(increaseNumber: casesIncrease, title: "CASES", mainValue: cases, subTitle: "In The US", isPlusGreen: false).padding()
                StatisticsButton(increaseNumber: deathsIncrease, title: "DEATHS", mainValue: deaths, subTitle: "In The US", isPlusGreen: false).padding()
                StatisticsButton(increaseNumber: negativeIncrease, title: "NEGATIVE TESTS", mainValue: negative, subTitle: "In The US", isPlusGreen: true).padding()
            }
            .padding()
            
        }//.background(Color(red: 119/255, green: 158/255, blue: 203/255))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            loadData()
            let defaults = UserDefaults.standard
            if let first_name = defaults.string(forKey: "firstName") {
                firstName = first_name
            }
            if let last_name = defaults.string(forKey: "lastName") {
                lastName = last_name
            }
            
            fullname = firstName + " " + lastName
        }
        HStack{
            Menu(dark: self.$dark, show: self.$showDetailMenu, name: self.$fullname, friend_count: friendCount, username: username)
              .offset(x: self.showDetailMenu ? UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 1.5) : UIScreen.main.bounds.width)
        
            Spacer(minLength: 0)
        }
        .background(Color.primary.opacity(self.showDetailMenu ? (self.dark ? 0.05 : 0.2) : 0).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        }
        }

        
    }
    /*
    private func getFriendCount() -> Int {
        let defaults = UserDefaults.standard
        if let currUsername = defaults.string(forKey: "currUsername") {
            if let currPassword = defaults.string(forKey: "currPassword") {
                NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
                
            }
        }
        
        return friendDictionary.count
    }
    
    func getFriendsHandler(friendsDict: [String: String]) {
        friendDictionary = friendsDict.filter { key, value in return Int(value) ?? -1 == 3}
    }
    */
    
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
    
    func loadData() {
            guard let url = URL(string: "https://api.covidtracking.com/v1/us/current.json") else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode([CovidTrackingInfo].self, from: data) {
                        DispatchQueue.main.async {
                            self.results = response
                            results.forEach { result in
                                if let positive = result.positive {
                                    self.cases = positive
                                }
                                
                                if let positiveIncrease = result.positiveIncrease {
                                    self.casesIncrease = positiveIncrease
                                }
                                
                                if let deaths = result.death {
                                    self.deaths = deaths
                                }
                                
                                if let deathsIncrease = result.deathIncrease {
                                    self.deathsIncrease = deathsIncrease
                                }
                                
                                if let negative = result.negative {
                                    self.negative = negative
                                }
                                
                                if let negativeIncrease = result.negativeIncrease {
                                    self.negativeIncrease = negativeIncrease
                                }
                            
                                
                            }
                        }
                        
                        return
                    }
                }
            }.resume()
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
                Text(String(formatMainNumber())).frame(alignment: .trailing)
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
    
    private func formatMainNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let mainValueFormatted = numberFormatter.string(from: NSNumber(value:mainValue))
        
        return mainValueFormatted!
        
    }
    
    
    private func getIncDecText() -> some View {
        var stringToReturn : String
        var colorToUse: Color
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let increaseNumberFormatted = numberFormatter.string(from: NSNumber(value:increaseNumber))
        
        if (increaseNumber > 0) {
            stringToReturn = " +" + increaseNumberFormatted! + " "
            if (isPlusGreen) {
                colorToUse = Color(red: 119/255, green: 221/255, blue: 119/255)
            } else {
                colorToUse = Color(red: 250/255, green: 128/255, blue: 114/255)
            }
        } else if (increaseNumber < 0) {
            stringToReturn = " -" + increaseNumberFormatted! + " "
            if (isPlusGreen) {
                colorToUse = Color(red: 119/255, green: 221/255, blue: 119/255)
            } else {
                colorToUse = Color(red: 250/255, green: 128/255, blue: 114/255)
            }
        } else {
            stringToReturn = " +" + increaseNumberFormatted! + " "
            colorToUse = Color(UIColor.lightGray)
        }
        
        return Text(stringToReturn).background(RoundedRectangle(cornerRadius: 8).fill(colorToUse)).frame(alignment: .trailing)
    }

}


struct TopWelcomeView: View {
    var name: String
    @Binding var showDetailMenu: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            HStack {
                Text("Welcome " + name.capitalizingFirstLetter())
                .font(.largeTitle)
                //.background(Color(red: 119/255, green: 158/255, blue: 203/255))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                  withAnimation(.default){
                      self.showDetailMenu.toggle()
                    print(showDetailMenu)
                  }
                  
                }) {
                    
                    Image(systemName: "slider.horizontal.3")
                      .resizable()
                      .frame(width: 15, height: 15)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
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
            currentMonthWritten = "December"
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
    var showDetail: Bool
    @State private var isShowingScanner = false

    var body: some View {
        VStack {
            Button(action: {
                 self.isShowingScanner = true
             }) {
                Image(systemName: "qrcode.viewfinder").font(.system(size: 100, weight: .regular)).foregroundColor(Color(UIColor.black))
             }
             .sheet(isPresented: $isShowingScanner) {
                 CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
             }
    
            Text("Scan a QR Code").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>) {
           self.isShowingScanner = false
           switch result {
           case .success(let data):
               print("Success with \(data)")
                
           case .failure(let error):
               print("Scanning failed \(error)")
           }
    }
}


struct QRCodeWindow: View {
    @State var showDetail : Bool
    @State var covidRisk: Int
    var sizeSmall: CGFloat
    var sizeLarge: CGFloat
    var extra: Bool
    @State var username: String
    
    var body: some View {
        VStack {
        Button(action: {
            showDetail.toggle()
        }) {
            if (showDetail){
                Image(uiImage: generateQRCode(from: "http://52.32.17.11:8080/user_risk/" + username)).interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: sizeLarge, height: sizeLarge)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .colorMultiply(determineColor())
                    .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(determineColor(), lineWidth: 4)
                        )
                    
            } else {
                Image(uiImage: generateQRCode(from: "http://52.32.17.11:8080/user_risk/" + username)).interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: sizeSmall, height: sizeSmall)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .colorMultiply(determineColor())
                    .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(determineColor(), lineWidth: 4)
                        )
            }
        }
            if (extra) {
                if (!showDetail) {
                    if (covidRisk == 3) {
                        Text("Red indicates high covid risk")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    } else if (covidRisk == 1) {
                        Text("Green indicates low covid risk")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    } else if (covidRisk == 2) {
                        Text("Yellow indicates medium covid risk")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("Please fill out the questionnaire to determine your risk!")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else {
                    if (covidRisk == 3) {
                        Text("We have determined that you have high Covid Risk")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("")
                        LinkedText(username: username)
                    } else if (covidRisk == 1) {
                        Text("We have determined that you have low Covid Risk")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("")
                        LinkedText(username: username)
                    } else if (covidRisk == 2) {
                        Text("We have determined that you have medium Covid Risk")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("")
                        LinkedText(username: username)
                    } else if (covidRisk == 0) {
                        Text("Please fill out the questionnaire to determine your risk!")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            Spacer()
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
    
    private func determineColor() -> Color {
        if (covidRisk == 3) {
            return Color(red: 250/255, green: 128/255, blue: 114/255)
        } else if (covidRisk == 1) {
            return Color(red: 119/255, green: 221/255, blue: 119/255)
        } else if (covidRisk == 2) {
            return Color(.yellow)
        } else {
            return Color(.white)
        }
        
        return Color.gray
    }
    
}

struct LinkedText: View {
    var username: String
    var body: some View {
        Text("Scan the QR Code or visit the link below for more info")
            .font(.subheadline)
            .fixedSize(horizontal: false, vertical: true)
        
        Button (action: {
            UIApplication.shared.open(URL(string: "http://52.32.17.11:8080/user_risk/" + username)!)
        }) {
           Text("Link")
        }//.onTapGesture {
         //   UIApplication.shared.open(URL(string: "http://52.32.17.11:8080/user_risk/" + username)!)
        //}
        
            
        
    }
}


struct CovidTrackingInfo: Codable  {
    let date: Int
    let death: Int?
    let deathIncrease: Int?
    let hash: String
    let hospitalizedCumulative: Int?
    let hospitalizedCurrently: Int?
    let hospitalizedIncrease: Int?
    let inIcuCumulative: Int?
    let inIcuCurrently: Int?
    let negative: Int?
    let negativeIncrease: Int?
    let onVentilatorCumulative: Int?
    let onVentilatorCurrently: Int?
    let pending: Int?
    let positive: Int?
    let positiveIncrease: Int?
    let recovered: Int?
    let states: Int?
    let totalTestResults: Int?
    let totalTestResultsIncrease: Int?
    
    
}
