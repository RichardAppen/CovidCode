//
//  CurrentDateInfoBoxUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//

import Foundation
import SwiftUI

struct CurrentDateInfoBoxUI: View {
    
    var currentDay: Int
    var currentMonth: Int
    var currentYear: Int
    var parentTabController: TabControllerUI
    //var completedSurvery = false
    
    var body: some View {
        VStack {
            getTitleString().font(.subheadline)
            if (getIfTheUserCompletedSurvey()) {
                HStack {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(UIColor.systemGreen))
                    Text("Survey Completed!")
                        .foregroundColor(Color(UIColor.systemGreen))
                }
                Button(action: {
                    deleteQuestionnaire( currentDay: currentDay, currentMonth: currentMonth, currentYear: currentYear)
                    let dateString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
                    let defaults = UserDefaults.standard
                    defaults.set("0", forKey: dateString)
                    let contentView = QuestionnaireUI(currentDay: currentDay, currentMonth: currentMonth, currentYear: currentYear, parentTabController: parentTabController)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Redo Survery")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.red))
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                HStack {
                    Image(systemName: "xmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(UIColor.systemPink))
                    Text("Survey Not Complete!")
                        .foregroundColor(Color(UIColor.systemRed))
                }
                Button(action: {
                    let contentView = QuestionnaireUI(currentDay: currentDay, currentMonth: currentMonth, currentYear: currentYear, parentTabController: parentTabController)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Complete Survery")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                }
                .buttonStyle(PlainButtonStyle())
            
            }
        }
        .padding()
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
        .stroke(Color.black, lineWidth: 4))
        .shadow(radius: 10)
    }
    
    private func getIfTheUserCompletedSurvey() -> Bool {
        let finalString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
        let defaults = UserDefaults.standard
        if let surveyFilledStatus = defaults.string(forKey: finalString) {
            return true
        } else {
            return false
        }
    }
    
    private func getTitleString() -> some View {
        let finalString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
        
        return Text(finalString).fontWeight(.bold)
    }
}
