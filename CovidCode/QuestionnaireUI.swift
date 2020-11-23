//
//  QuestionnaireUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/21/20.
//

import SwiftUI

struct QuestionnaireUI: View {
    var currentDay: Int
    var currentMonth: Int
    var currentYear: Int
    var parentTabController: TabControllerUI
    
    let tests: [String: String] = ["PCR": "no", "Covid-19": "yes"]
    let symptoms: [String: String] = ["Headache": "no", "Cough": "no", "Fever": "no"]
    @State var questions: [Question] = [
        
        Question(id: 1, question: "Have you tested positive for Covid-19?", type: "multiple", answers: ["PCR": "no", "Covid-19": "yes"] ),
        Question(id: 3, question: "What are your symptoms", type: "multiple", answers: ["Headache": "no", "Cough": "no", "Fever": "no"]),
        Question(id: 4, question: "Do you feel good and feel well?", type: "single")
    ]
    
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        let contentView = parentTabController
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: contentView)
                            window.makeKeyAndVisible()
                        }
                    }) {
                        Text("Back").padding()
                    }
                    Spacer()
                }
                
            }
            Divider()
            VStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHStack {
                        TabView {
                            ForEach(self.questions, id: \.self) { q in
                                ZStack {
                                    QuestionCardView(question: q)
                                }
                            }
                            .padding(.all, 10)
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
                        .tabViewStyle(PageTabViewStyle())
                    }
                }
                Button(action: {
                    let dateString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
                    let defaults = UserDefaults.standard
                    defaults.set("1", forKey: dateString)
                    let contentView = parentTabController
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                    submitQuestionnaire(questions: questions)
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
                    
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
        }
    }
}



func submitQuestionnaire (questions: [Question]) {
    
}