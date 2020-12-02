//
//  ProfileUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/26/20.
//

import Foundation
import SwiftUI

struct ProfileUI : View {
    
    @State private var covidRisk = 0
  @State var index:Int = 0
  @State var show:Bool = false
  @State var dark:Bool = false
  @State var name:String = "John Doe"
  @State var username:String = "JohnDoe1995"
  @State var friend_count:Int = 0
    @State var showDetail: Bool = false
    @State var friendDictionary: [String : String] = [:]
  
    
    
    var body: some View{
        NavigationView{
      ZStack {
          
          GeometryReader {_ in
             
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
                TopProfileView(show: self.$show).padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                GeometryReader { geometry in
        VStack{
        
            
            /*HStack(spacing: 0){
                
                Button(action: {
                  withAnimation(.default){
                      self.show.toggle()
                  }
                  
                }) {
                    
                    Image(systemName: "slider.horizontal.3")
                      .resizable()
                      .frame(width: 15, height: 15)
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
              Spacer(minLength: 133)
                
                Text("Profile")
                    .font(.title)
                  .multilineTextAlignment(.center)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                }) {
                    
                    Text("Add")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background(Color("Color"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .foregroundColor(.primary)
            .overlay(Rectangle().stroke(Color.primary.opacity(-2),lineWidth: 1).shadow(radius: 3).edgesIgnoringSafeArea((.top)))
            */
            
            // FILLER
            HStack{
                Image(systemName: "person")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/6)
                      .clipShape(Circle())
                      .frame(alignment: .center)
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            QRCodeWindow(showDetail: showDetail, covidRisk: covidRisk, sizeSmall: UIScreen.main.bounds.width / 3.4, sizeLarge: UIScreen.main.bounds.width / 1.8, extra: false).padding()
            
          
          VStack(spacing: 0) {
              Text(self.name)
                  .font(.title)
                  .foregroundColor(Color.black.opacity(0.8))
              
              getUsername()
                  .foregroundColor(Color.black.opacity(0.8))
                  .padding(.top,10)
              
              
              Text(String(getFriendCount()) + " Friends")
                  .foregroundColor(Color.black.opacity(0.6))
                  .padding(.top, 8)
                  .padding(.bottom,8)
                  
              
              
          }.padding(-35)
          .padding(.bottom, 35)
          .padding(.top)
          
          
            /*Button(action: {
                let contentView = EditProfileUI(parentTabController: parentTabController)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }) {
                Text("Edit Profile")
                    .foregroundColor(.white)
                    .padding(6)
            }*/
            
          
          Spacer(minLength: 30)
        }
        .edgesIgnoringSafeArea(.all)
            }
          }
            .navigationBarHidden(true)
          
          HStack{
              Menu(dark: self.$dark, show: self.$show, name: self.$name, friend_count: getFriendCount())
                .offset(x: self.show ? UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 1.5) : UIScreen.main.bounds.width)
          
              Spacer(minLength: 0)
          }
          .background(Color.primary.opacity(self.show ? (self.dark ? 0.05 : 0.2) : 0).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
      }
      }
        }
        .navigationBarHidden(true)
      //}.padding(.top, -50)
    }
    
    private func getUsername() -> Text {
        let defaults = UserDefaults.standard
        if let currUsername = defaults.string(forKey: "currUsername") {
            return Text(currUsername)
        }
        
        return Text("")
    }
    
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
        friendDictionary = friendsDict
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

struct Menu : View {
  
  @Binding var dark : Bool
  @Binding var show : Bool
  @Binding var name : String
  var friend_count: Int
  
  
  var body: some View {
      
    GeometryReader { geometry in
    VStack() {
          HStack{
            Spacer()
              Button(action: {
                  withAnimation(.default) {
                      
                      self.show.toggle()
                  }
              }) {
                  
                  Image(systemName: "chevron.right")
                      .font(.system(size: 22))
                      .foregroundColor(.black)
              }
              
              
          }.padding(.top)
          .padding(.bottom,25)
          // End HStack
          

          
          VStack(spacing: 12) {
              Text(self.name)
              
              Text(String(self.friend_count) + " friends")
                  .font(.caption)
          }
          .padding(.top,25)
          

          Group {
              Button(action: {
                  
              }) {
                HStack{
                  Image("sprocket")
                      .resizable()
                      .frame(width: 30, height: 30)
                      .foregroundColor(.yellow)
                    Text("Settings and Privacy")
                  Spacer()
                  }
              }.padding(.top, 25)
              
          }
          
          Button(action: {
              
          }) {
              HStack{
              Image("NotificationSymbol")
                  .resizable()
                  .frame(width: 35, height: 35)
                  .foregroundColor(.yellow)
              Text("Push Notifications")
                  Spacer()
              }
          }
          .padding(.top, 25)
          
          Spacer()
        
        Button(action: {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
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
      .overlay(Rectangle().stroke(Color.primary.opacity(0.2),lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
  }
}


struct TopProfileView: View {
    @Binding var show : Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Spacer()
                Button(action: {
                  withAnimation(.default){
                      self.show.toggle()
                  }
                  
                }) {
                    
                    Image(systemName: "slider.horizontal.3")
                      .resizable()
                      .frame(width: 15, height: 15)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
        
        }
    }
}

