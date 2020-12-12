//
//  Homescreen.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//
//  The homescreen displays different information to the user on login. It display how many of their friends
//  are high risk for covid, national covid statistics, their own QR code, and sruvey status.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins
import CodeScanner
import CoreLocation

struct HomescreenUI: View {
    
    // Must be initialized
    var parentTabController: TabControllerUI
    var username: String
    
    @State private var showDetail = false
    @State private var isShowingScanner = false
    @State var completedSurveyToday = false
    
    // For use in getting Covid Info from Covid Data API
    @State var results = [CovidTrackingInfo]()
    @State var cases = 0
    @State var casesIncrease = 0
    @State var deaths = 0
    @State var deathsIncrease = 0
    @State var negative = 0
    @State var negativeIncrease = 0
    
    // Fill these values in from data retrieved from server
    @State var firstName = ""
    @State var lastName = ""
    @State var covidRisk = 0
    @State var friendCount = 0
    @State var highRiskFriendCount = 0
    @State var highRiskFriendCountInc = 0
    @State var fullname = ""
    
    // For menu button
    @State var dark:Bool = false
    @State var showDetailMenu = false
    
    // For determining if loading icon should show, and how it operates
    @State var getRiskHistoryLoading: Bool = false
    @State var getRiskLoading: Bool = false
    @State var getFriendsLoading: Bool = false
    @State private var isAnimating = false
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
    }
    
    // Location manager
    var locationManager = CLLocationManager()

    var body: some View {
        ZStack {
            GeometryReader {_ in
                ScrollView {
                    
                    // Extension View
                    Header()
                    
                    // Extension View
                    TopWelcomeView(name: firstName, showDetailMenu: $showDetailMenu).padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    
                    
                    VStack {
                        // Extension View : Display how many of your friends are high risk for Covid
                        StatisticsButton(increaseNumber: highRiskFriendCountInc, title: "HIGH RISK FRIENDS", mainValue: highRiskFriendCount, subTitle: "In Your Friends List", isPlusGreen: false).padding()
                        
                        // Extension View : Display the current user's QR code
                        QRCodeWindow(showDetail: showDetail, covidRisk: $covidRisk, sizeSmall: UIScreen.main.bounds.width / 1.7, sizeLarge: UIScreen.main.bounds.width / 1.1, extra: true, username: username)
                        
                        // Darker divider
                        Divider().frame(height: 2).background(Color(UIColor.darkGray)).padding()
                        
                        Spacer()
                        
                        HStack {
                            // Extension View
                            gotToQRCodeButton(showDetail: showDetail).padding()
                            VStack {
                                
                                // If the user completed their survey for today
                                if (completedSurveyToday) {
                                    
                                    // Tell them they completed it
                                    Image(systemName: "checkmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                                    Text("Today's Survey Complete!").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
                                    
                                // else they did not complete their survey for today
                                } else {
                                    
                                    // Tell them they need to complete it
                                    Image(systemName: "xmark.circle.fill").font(.system(size: 30, weight:      .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                                    
                                    VStack {
                                        Text("Today's Survery Not Complete!").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
                                        
                                        // And give them a button that takes them to the calendar where the survey is
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
                        }
                        
                        // Extension Views : Display statistics gathered from Covid Data Project API
                        StatisticsButton(increaseNumber: casesIncrease, title: "CASES", mainValue: cases, subTitle: "In The US", isPlusGreen: false).padding()
                        StatisticsButton(increaseNumber: deathsIncrease, title: "DEATHS", mainValue: deaths, subTitle: "In The US", isPlusGreen: false).padding()
                        StatisticsButton(increaseNumber: negativeIncrease, title: "NEGATIVE TESTS", mainValue: negative, subTitle: "In The US", isPlusGreen: true).padding()
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    
                    // Ask for the user's location
                    locationManager.requestWhenInUseAuthorization()
                    
                    loadData()
                    
                    // Get ready to deal with local data
                    let defaults = UserDefaults.standard
                    
                    // Load up the user's first and last name
                    if let first_name = defaults.string(forKey: "firstName") {
                        
                        firstName = first_name
                    }
                    if let last_name = defaults.string(forKey: "lastName") {
                        
                        lastName = last_name
                    }
                    
                    // Now call all network functions to load every part of the homescreen
                    if let currUsername = defaults.string(forKey: "currUsername") {
                        if let currPassword = defaults.string(forKey: "currPassword") {
                            // Set loading values to true so homescreen display's loading icon while these network functions do their thing
                            getRiskLoading = true
                            getFriendsLoading = true
                            getRiskHistoryLoading = true
                            
                            
                            NetworkGetRisk.getRisk(username: currUsername, password: currPassword, handler: getRiskHandler)
                            NetworkGetRiskHistory.getRiskHistory(username: currUsername, password: currPassword, handler: getRiskHistoryHandler)
                            NetworkGetFriends.getFriends(username: currUsername, password: currPassword, handler: getFriendsHandler)
                        }
                    }
                    
                    // Create the fullname from loaded values
                    fullname = firstName + " " + lastName
                }
                HStack{
                    // Menu displayed when button in header is pressed
                    Menu(dark: self.$dark, show: self.$showDetailMenu, name: self.$fullname, friend_count: friendCount, username: username)
                        // Displayed using ternary operator on a showDetailMenu which is toggled when the button in the header is pressed
                        .offset(x: self.showDetailMenu ? UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 1.5) : UIScreen.main.bounds.width)
            
                    Spacer(minLength: 0)
                }
                .background(Color.primary.opacity(self.showDetailMenu ? (self.dark ? 0.05 : 0.2) : 0).edgesIgnoringSafeArea(.all))
            }
            // If we are still loading network functions set the entire views's height to zero, else let it be normal
            .frame(height: (getRiskLoading || getRiskHistoryLoading || getFriendsLoading) ? 0 : nil)
            
            // If we are still loading network functions display the loading icon, else don't
            if (getRiskLoading || getRiskHistoryLoading || getFriendsLoading) {
                VStack {
                Image(systemName: "burn")
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                    .animation(self.isAnimating ? foreverAnimation : .default)      // animated loading icon
                    .onAppear { self.isAnimating = true }
                    .onDisappear { self.isAnimating = false }
                    .font(.system(size: 23, weight: .regular))
                    Text("Loading...").padding(.top)
                }
            }
        }
    }
    
    // HANDLER : For network function to get the risk of the current user
    func getRiskHandler(risk: Int) {
        
        // Set the risk
        covidRisk = risk
        
        // Communicate that it is no longer getting the risk
        getRiskLoading = false
    }
    
    // HANDLER : For network function to get the COVID history of the current user
    func getRiskHistoryHandler(risks: [String: String]) {
        
        // Save the history to user defaults to load the calendar whenever
        let defaults = UserDefaults.standard
        for(key, value) in risks {
            defaults.set("1", forKey: key)
            print(key)
            print(value)
            getIfUserCompletedSurveyToday()
            
        }
        
        // Communicate that it is no longer getting the risk history
        getRiskHistoryLoading = false
        
    }
    
    // HANDLER : For network function to get the friends and covid risk of the friends of the current user
    func getFriendsHandler(friendsDict: [String: String]) {
        
        // Set high risk friend count based on how many friends have the high risk value (3)
        let HRFC = friendsDict.filter { key, value in return Int(value) ?? -1 == 3}.count
        highRiskFriendCount = HRFC
        
        // Now count all friends that aren't high risk
        let LRFC = friendsDict.filter { key, value in return Int(value) ?? -1 == 1}.count
        let MRFC = friendsDict.filter { key, value in return Int(value) ?? -1 == 2}.count
        let NRFC = friendsDict.filter { key, value in return Int(value) ?? -1 == 0}.count
        
        // Add everything up for friend count
        friendCount = HRFC + LRFC + MRFC + NRFC
        
        // Communicate that it is no longer getting the user's friend info
        getFriendsLoading = false
        
    }
            
    // Function to check whether or not the user has done today's survey
    private func getIfUserCompletedSurveyToday() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        let actualDate = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
        
        // Check local data for if the user completed the survey on today's date
        let defaults = UserDefaults.standard
        if defaults.string(forKey: actualDate) != nil {
            completedSurveyToday = true
        } else {
            completedSurveyToday = false
        }
    }
        
    // Load data from CovidTracking API
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


// EXTENSION VIEW : Given a main value and how much it has incremented or decrement display the values and a given title
struct StatisticsButton: View {
    var increaseNumber: Int
    var title: String
    var mainValue: Int
    var subTitle: String
    var isPlusGreen : Bool          // Are we incrementing or decrementing ?
    
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
    
    // Add commas into huge numbers
    private func formatMainNumber() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let mainValueFormatted = numberFormatter.string(from: NSNumber(value:mainValue))
        
        return mainValueFormatted!
        
    }
    
    // Determine whether or not we are incrementing or decrementing the main value
    private func getIncDecText() -> some View {
        var stringToReturn : String
        var colorToUse: Color
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let increaseNumberFormatted = numberFormatter.string(from: NSNumber(value:increaseNumber))
        
        // Incrementing
        if (increaseNumber > 0) {
            stringToReturn = " +" + increaseNumberFormatted! + " "
            
            // Green if going up is a good thing
            if (isPlusGreen) {
                colorToUse = Color(red: 119/255, green: 221/255, blue: 119/255)
                
            // Red if it is a bad thing
            } else {
                colorToUse = Color(red: 250/255, green: 128/255, blue: 114/255)
            }
            
        // Decrementing
        } else if (increaseNumber < 0) {
            stringToReturn = " -" + increaseNumberFormatted! + " "
            
            // Green if going down is a good thing
            if (isPlusGreen) {
                colorToUse = Color(red: 119/255, green: 221/255, blue: 119/255)
                
            // Red if it is a bad thing
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

// EXTENSION VIEW : Addition to the header to include a welcome message
struct TopWelcomeView: View {
    var name: String
    @Binding var showDetailMenu: Bool
    
    var body: some View {
        VStack {
            // Many spacers to deal with parallax header setup
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            HStack {
                Text("Welcome " + name.capitalizingFirstLetter())
                .font(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
                // Button to toggle the special menu that pops out
                Button(action: {
                  withAnimation(.default){
                      self.showDetailMenu.toggle()
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
    
    // Function to get todays date and write it out
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
        
        // Write out todays date as a string
        return currentMonthWritten + " " + String(currentDay) + ", " + String(currentYear)
    }
}

// EXTENSION VIEW : Display a blue header on the top of the phone screen that has a parallax effect when it is used within a scroll view.
struct Header: View {
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .global).minY <= 0 {
                
                // Extension View
                TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                .offset(y: geometry.frame(in: .global).minY)
                .frame(width: geometry.size.width, height: geometry.size.height*4)
            } else {
                
                // Extension View
                TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                .offset(y: -geometry.frame(in: .global).minY)
            }
        }
    }
}

// EXTENSION VIEW : Blue square that ignores safe area
struct TopBlueParralax: View {
    
    var body: some View {
        VStack {
            // Extra spacers to deal with parallax setup
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

// Call pop up view that opens QR code scanner
struct gotToQRCodeButton: View {
    var showDetail: Bool
    @State private var isShowingScanner = false

    var body: some View {
        VStack {
            Button(action: {
                 self.isShowingScanner = true       // Toggle the scanner
             }) {
                Image(systemName: "qrcode.viewfinder").font(.system(size: 100, weight: .regular)).foregroundColor(Color(UIColor.black))
             }
            // .sheet is for pop ups
             .sheet(isPresented: $isShowingScanner) {
                
                // Call the actual scanner that opens the camera
                 CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
             }
    
            Text("Scan a QR Code").multilineTextAlignment(.center).padding().fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // HANDLER : what to do with the data scanned
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

// EXTENSION VIEW : Display the user's QR code
struct QRCodeWindow: View {
    @State var showDetail : Bool
    @Binding var covidRisk: Int
    var sizeSmall: CGFloat
    var sizeLarge: CGFloat
    var extra: Bool
    @State var username: String
    
    var body: some View {
        VStack {
            Button(action: {
                showDetail.toggle()     // Toggle size increase on QR code display
            }) {
                // Large QR code
                if (showDetail){
                    // Display a QR code for the current user given his/her username
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
                     
                // Small QR code
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
        
            // If we are displaying the big QR code then display some extra info
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
    
    // generate the QR Code given the link we want to display
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
        
    }
    
}

// EXTENSION VIEW : Have this text bring the user to their covid risk link
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
        }
    }
}

// Struct to hold all possible information the CovidTracking API will return
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

// EXTENSION VIEW : special pop out menu 
struct Menu : View {
  
    @Binding var dark : Bool
    @Binding var show : Bool
    @Binding var name : String
    var friend_count: Int
    var username: String
  
  
      var body: some View {
          
        GeometryReader { geometry in
            VStack() {
                  HStack{
                    Spacer()
                      Button(action: {
                          withAnimation(.default) {
                              self.show.toggle()        // Take away pop out menu
                          }
                      }) {
                          Image(systemName: "chevron.right")
                              .font(.system(size: 22))
                              .foregroundColor(.black)
                      }
                  }
                  .padding(.top)
                  .padding(.bottom,25)
                  
                // Display the name and username
                VStack(spacing: 12) {
                    Text(self.name)
                    Text(username).font(.subheadline)
                      
                    Text(String(friend_count) + " friends")
                        .font(.caption)
                }
                .padding(.top,25)
                  
                Spacer()
                
                // At the bottom have a log out button
                Button(action: {
                    
                    // Clear all local data (user defaults)
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    
                    // Go back to the login page
                    let contentView = ContentView()
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .padding(6)
                        .frame(width: geometry.size.width / 2)
                        .background(RoundedRectangle(cornerRadius: .infinity).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom)
                  
            }.foregroundColor(.primary)
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width / 1.5)
            .background((self.dark ? Color.black : Color.white).edgesIgnoringSafeArea(.all))
            .overlay(Rectangle().stroke(Color.primary.opacity(0.2),lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
        }
    }

}

