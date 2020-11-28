//
//  QuestionnaireUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/21/20.
//

import SwiftUI


/*
 
 Are you experiencing any of the following symptoms? Cough, Headache, Fatigue, Breathing Issues, Soreness
 Do you have a fever? No, Yes a low fever between 37.2°C and 38.5°C, Yes a high fever over 38.5°C
 Have you participated in any of the following recently? Attended a mass gathering such as a party or wedding, travelled by plane, train, bus, or other public transport, None of these
 Have you come in close contact with anyone diagnosed with Covid-19 today?
 Do you continue to practice protective measures such as using a mask to cover your nose and mouth, follow social distancing, and washing your hands with soap and water? Yes or No
 
 
 
 
 */

var question0: String = "Are you experiencing any of the following symptoms?"
var question1: String = "Do you have a fever?"
var question2: String = "Have you participated in any of the following recently?"
var question3: String = "Have you come in close contact with anyone diagnosed with Covid-19 recently?"
var question4: String = "Do you continue to practice protective measures such as using a mask to cover your nose and mouth, follow social distancing, and washing your hands frequently?"

var q0_answer0: String = "Cough"
var q0_answer1: String = "Headache"
var q0_answer2: String = "Fatigue"
var q0_answer3: String = "Breathing Issues"
var q0_answer4: String = "Soreness"

var q1_answer0: String = "No, I don't have a fever"
var q1_answer1: String = "Yes, a low fever between 37.2°C and 38.5°C"
var q1_answer2: String = "Yes, a high fever over 38.5°C"

var q2_answer0: String = "Attended a mass gathering such as a party or wedding"
var q2_answer1: String = "Been on a plane, train, bus, or other public transport"
var q2_answer2: String = "None of the above"

var qSingle: String = "single"
var qMultiple: String = "multiple"

class Questions: ObservableObject {
    
    @Published var questions: [Question] = [
        
        Question(id: 0, question: question0, type: qMultiple, answers: [q0_answer0: false, q0_answer1: false, q0_answer2: false, q0_answer3: false, q0_answer4: false] ),
        Question(id: 1, question: question1, type: qMultiple, answers: [q1_answer0: false, q1_answer1: false, q1_answer2: false]),
        Question(id: 2, question: question2, type: qMultiple, answers: [q2_answer0: false, q2_answer1: false, q2_answer2: false]),
        Question(id: 3, question: question3, type: qSingle, answers: [:]),
        Question(id: 4, question: question4, type: qSingle, answers: [:])
    ]
}

struct QuestionnaireUI: View {
    var currentDay: Int
    var currentMonth: Int
    var currentYear: Int
    var parentTabController: TabControllerUI
    @ObservedObject var questions: Questions = Questions()
    
    
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
                            ForEach(self.questions.questions, id: \.self) { q in
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
                SubmitQuestionnaireButton(currentDay: currentDay, currentMonth: currentMonth, currentYear: currentYear, questions: questions, parentTabController: parentTabController)
                Spacer()
            }
        }
    }
}

struct SubmitQuestionnaireButton: View {
    var currentDay: Int
    var currentMonth: Int
    var currentYear: Int
    @ObservedObject var questions: Questions
    @State var errorMsg: String = ""
    var parentTabController: TabControllerUI
    @State private var showingAlert = false
    var body: some View {
        Button(action: {
            if ((!questions.questions[1].answers[q1_answer0]! && !questions.questions[1].answers[q1_answer1]!  && !questions.questions[1].answers[q1_answer2]! )) {
                errorMsg = "Please answer question 2"
                showingAlert = true
            } else if (!questions.questions[2].answers[q2_answer0]! && !questions.questions[2].answers[q2_answer1]! && !questions.questions[2].answers[q2_answer2]! ){
                errorMsg = "Please answer question 3"
                showingAlert = true
            } else if (questions.questions[3].answer == nil) {
                errorMsg = "Please answer question 4"
                showingAlert = true
                
            } else if (questions.questions[4].answer == nil) {
                errorMsg = "Please answer question 5"
                showingAlert = true
            } else {
                print("y")
                NetworkNewRisk.newRisk(username: UserDefaults.standard.string(forKey: "currUsername") ?? "usernameError", password: UserDefaults.standard.string(forKey: "currPassword") ?? "passwordError", risk: String(5), state: "new", handler: newRiskHandler)
            }
        }) {
            Text("Submit")
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.green))
            
        }
        .buttonStyle(PlainButtonStyle())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMsg.capitalizingFirstLetter()), dismissButton: .default(Text("Confirm")))
        }
        
    }
    
    func newRiskHandler(res: Bool, error: String) -> () {
        // TODO Change this name and make this the return handler of login
        if (res) {
            DispatchQueue.main.async {
                let dateString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
                let defaults = UserDefaults.standard
                defaults.set("1", forKey: dateString)
                let contentView = parentTabController
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: contentView)
                    window.makeKeyAndVisible()
                }
            }
        } else {
            print("unsuccessful")
            showingAlert = true
            errorMsg = error
        }
        
    }
    
}






