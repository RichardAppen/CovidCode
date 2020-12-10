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
var question0: String = "Have you tested positive for Covid-19?"
var question1: String = "Are you experiencing any of the following symptoms?"
var question2: String = "Do you have a fever?"
var question3: String = "Have you participated in any of the following recently?"
var question4: String = "Have you come in close contact with anyone diagnosed with Covid-19 recently?"
var question5: String = "Do you continue to practice protective measures such as using a mask to cover your nose and mouth, follow social distancing, and washing your hands frequently?"

var q1_answer0: String = "Cough"
var q1_answer1: String = "Headache"
var q1_answer2: String = "Fatigue"
var q1_answer3: String = "Breathing Issues"
var q1_answer4: String = "Soreness"
/*
var q2_answer0: String = "No, I don't have a fever"
var q2_answer1: String = "Yes, a low fever between 37.2°C and 38.5°C"
var q2_answer2: String = "Yes, a high fever over 38.5°C"
*/
var q3_answer0: String = "Attended a mass gathering such as a party or wedding"
var q3_answer1: String = "Been on a plane, train, bus, or other public transport"
var q3_answer2: String = "None of the above"

var qSingle: String = "single"
var qMultiple: String = "multiple"

class Questions: ObservableObject {
    
    @Published var questions: [Question] = [
        
        Question(id: 0, question: question0, type: qSingle, answers: [:]),
        Question(id: 1, question: question1, type: qMultiple, answers: [q1_answer0: false, q1_answer1: false, q1_answer2: false, q1_answer3: false, q1_answer4: false] ),
        Question(id: 2, question: question2, type: qSingle, answers: [:]),
        Question(id: 3, question: question3, type: qMultiple, answers: [q3_answer0: false, q3_answer1: false, q3_answer2: false]),
        Question(id: 4, question: question4, type: qSingle, answers: [:]),
        Question(id: 5, question: question5, type: qSingle, answers: [:])
        
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
                        let defaults = UserDefaults.standard
                        if let currUsername = defaults.string(forKey: "currUsername") {
                            
                            let contentView = TabControllerUI(selectedTab: 2, username: currUsername)
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: contentView)
                                window.makeKeyAndVisible()
                            }
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
            var state: String
            let dateString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
            let defaults = UserDefaults.standard
            if (defaults.string(forKey: dateString) == "1") {
                state = "current"
           } else {
                state = "new"
           }
           
            if (questions.questions[0].answer == nil) {
                errorMsg = "Please answer question 1"
                showingAlert = true
            } else if (questions.questions[2].answer == nil) {
                errorMsg = "Please answer question 3"
                showingAlert = true
            } else if (!questions.questions[3].answers[q3_answer0]! && !questions.questions[3].answers[q3_answer1]! && !questions.questions[3].answers[q3_answer2]! ){
                errorMsg = "Please answer question 4"
                showingAlert = true
            } else if (questions.questions[4].answer == nil) {
                errorMsg = "Please answer question 5"
                showingAlert = true
                
            } else if (questions.questions[5].answer == nil) {
                errorMsg = "Please answer question 6"
                showingAlert = true
                
            } else {
                var risk: Double = 0
                if (questions.questions[0].answer == true) {
                    risk += 1
                }
                if (questions.questions[1].answers[q1_answer0] == true) {
                    risk += 0.3
                }
                if (questions.questions[1].answers[q1_answer1] == true) {
                    risk += 0.3
                }
                if (questions.questions[1].answers[q1_answer2] == true) {
                    risk += 0.3
                }
                if (questions.questions[1].answers[q1_answer3] == true) {
                    risk += 0.3
                }
                if (questions.questions[1].answers[q1_answer4] == true) {
                    risk += 0.3
                }
                if (questions.questions[2].answer == true) {
                    risk += 0.3
                }
                if (questions.questions[3].answers[q3_answer0] == true) {
                    risk += 0.2
                }
                if (questions.questions[3].answers[q3_answer1] == true) {
                    risk += 0.2
                }
                if (questions.questions[4].answer == true) {
                    risk += 0.5
                }
                if (questions.questions[5].answer == false) {
                    risk += 0.2
                }
                var nRisk: Int = 0
                if (risk < 0.5) {
                    nRisk = 1
                } else if (risk < 1.0) {
                    nRisk = 2
                } else {
                    nRisk = 3
                }
                NetworkNewRisk.newRisk(username: UserDefaults.standard.string(forKey: "currUsername") ?? "usernameError", password: UserDefaults.standard.string(forKey: "currPassword") ?? "passwordError", risk: String(nRisk), state: state, handler: newRiskHandler)
                
                defaults.setValue(nRisk, forKey: "risk")
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
            print("test")
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                var dateString = String(currentMonth) + "/" + String(currentDay) + "/" + String(currentYear)
                defaults.set("1", forKey: dateString)
                if let currUsername = defaults.string(forKey: "currUsername") {
                let contentView = TabControllerUI(selectedTab: 2, username: currUsername)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = UIHostingController(rootView: contentView)
                        window.makeKeyAndVisible()
                    }
                }
            }
        } else {
            print("unsuccessful")
            showingAlert = true
            errorMsg = error
        }
        
    }
    
}






