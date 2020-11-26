//
//  ProfileUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/26/20.
//

import Foundation
import SwiftUI

struct ProfileUI : View {
    
  @State var index:Int = 0
  @State var show:Bool = false
  @State var dark:Bool = false
  @State var name:String = "John Doe"
  @State var bio:String = "This is my Bio"
  @State var username:String = "JohnDoe1995"
  @State var friend_count:Int = 0
    @State var showDetail: Bool = false
    var parentTabController: TabControllerUI
  
    
    
    var body: some View{
        
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
            }.padding(.bottom)
            
          
          VStack(spacing: 0) {
              Text(self.name)
                  .font(.title)
                  .foregroundColor(Color.black.opacity(0.8))
              
              Text(self.username)
                  .foregroundColor(Color.black.opacity(0.8))
                  .padding(.top,10)
              
              
              Text(String(self.friend_count) + " Friends")
                  .foregroundColor(Color.black.opacity(0.6))
                  .padding(.top, 8)
                  .padding(.bottom,8)
                  
              
              Text(self.bio)
                  .foregroundColor(Color.black.opacity(0.7))
                  .padding(.top, 8)
                  .frame(width: 350)
                  .padding(.bottom, 10)
              
          }.padding(-35)
          .padding(.bottom, 35)
          .padding(.top)
          
          
            Button(action: {
                let contentView = EditProfileUI(parentTabController: parentTabController)
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }) {
                Text("Edit Profile")
            }
          
          Spacer(minLength: 30)
        }
        .background(Color("Color1").edgesIgnoringSafeArea(.all))
          }
          
          HStack{
              Menu(dark: self.$dark, show: self.$show, name: self.$name, friend_count: self.$friend_count)
                .offset(x: self.show ? UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 1.5) : UIScreen.main.bounds.width)
          
              Spacer(minLength: 0)
          }
          .background(Color.primary.opacity(self.show ? (self.dark ? 0.05 : 0.2) : 0).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
      }
      }
      //}.padding(.top, -50)
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
  @Binding var friend_count: Int
  
  
  var body: some View {
      
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
        }) {
            Text("Log Out")
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
          
      }.foregroundColor(.primary)
      .padding(.horizontal, 20)
      .frame(width: UIScreen.main.bounds.width / 1.5)
      .background((self.dark ? Color.black : Color.white).edgesIgnoringSafeArea(.all))
      .overlay(Rectangle().stroke(Color.primary.opacity(0.2),lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
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
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
            }
        
        }
    }
}
