//
//  CurrentDateInfoBoxUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//
//  A small box displayed in the CalendarUI anytime a specific date is clicked
//

import Foundation
import SwiftUI

struct CurrentDateInfoBoxUI: View {
    
    var currentDay: Int
    var currentMonth: Int
    var currentYear: Int
    var parentTabController: TabControllerUI
    
    var body: some View {
        VStack {
            // EXTENSION VIEW FUNCTION
            getTitleString().font(.subheadline)
            
            // If the user has completed todays survey
            if (getIfTheUserCompletedSurvey()) {
                // Tell them that they did
                HStack {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                    Text("Survey Completed!")
                        .foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                }
                // Then give them the option to redo it
                Button(action: {
                    let dateString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
                    let defaults = UserDefaults.standard
                    defaults.set("0", forKey: dateString)
                    
                    // If they click this button send tehm back to the Questionnaire
                    let contentView = QuestionnaireUI(currentDay: currentDay, currentMonth: currentMonth, currentYear: currentYear, parentTabController: parentTabController)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }) {
                    Text("Redo Survery")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 250/255, green: 128/255, blue: 114/255)))
                }
                .buttonStyle(PlainButtonStyle())
                
            // else the user did not fill out today's survey
            } else {
                
                // Tell them that they didn't
                HStack {
                    Image(systemName: "xmark.circle.fill").font(.system(size: 30, weight:   .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                    Text("Survey Not Complete!")
                        .foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                }
                
                // Then give them the option to go take it
                Button(action: {
                    
                    // when this button is clicked take them to the questionnaire
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
    }
    
    // Determine if the user completed today's survey or not
    private func getIfTheUserCompletedSurvey() -> Bool {
        let finalString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
        
        // Check user defaults (local data) to see this
        let defaults = UserDefaults.standard
        if let surveyFilledStatus = defaults.string(forKey: finalString) {
            return true
        } else {
            return false
        }
    }
    
    // EXTENSION VIEW FUNCTION : return the current date clicked as a text view
    private func getTitleString() -> some View {
        let finalString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
        
        return Text(finalString).fontWeight(.bold)
    }
}
