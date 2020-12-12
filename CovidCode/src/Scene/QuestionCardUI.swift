//
//  QuestionCardUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/21/20.
//

import SwiftUI

class Question: Hashable, ObservableObject {
    static func == (lhs: Question, rhs: Question) -> Bool {
        if lhs.id != rhs.id {
            return false
        } else {
            return true
        }
    }
    
    var id: Int = 0
    var question: String = ""
    var type: String = ""
    @Published var answer: Bool?
    @Published var answers: [String: Bool] = [:]
    
    init(id: Int, question: String, type: String, answers: [String: Bool]  ) {
        self.id = id;
        self.question = question
        self.type = type
        self.answers = answers
    }
    
    init(id: Int, question: String, type: String ) {
        self.id = id;
        self.question = question
        self.type = type
        self.answers = [:]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct QuestionCardView: View {
    @State private var translation: CGSize = .zero
    
    @ObservedObject var question: Question
    
    var yesButtonColor: Color {
        
        if (self.question.answer == nil) {
            return Color.black
        } else if (self.question.answer == false) {
            return Color.black
        } else {
            return Color.green
        }
    }
    
    var noButtonColor: Color {
        
        if (self.question.answer == nil) {
            return Color.black
        } else if (self.question.answer == true) {
            return Color.black
        } else {
            return Color.red
        }
    }
    
    func checkboxSelected(id: String, res: Bool) {
        if (res) {
            //self.question.answers[id] = true
        } else {
            //self.question.answers[id] = false
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial, vibrancyStyle: .none) {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(self.question.question) ")
                                .font(.title)
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                        }
                        .frame(width: 375, height: 400, alignment: .topTrailing)
                        
                        HStack {
                            if(self.question.type == "single") {
                                Spacer()
                                Button(action: {
                                    self.question.answer = false
                                }, label: {
                                    Image(systemName: "x.circle")
                                        .resizable()
                                        .foregroundColor(noButtonColor)
                                        .frame(width: 48, height: 48, alignment: .center)
                                })
                                
                                
                                Spacer()
                                Spacer()
                                Button(action: {
                                    self.question.answer = true
                                }, label: {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .foregroundColor(yesButtonColor)
                                        .frame(width: 48, height: 48, alignment: .center)
                                })
                                Spacer()
                            } else if (self.question.type == "multiple"){
                                Spacer()
                                VStack {
                                    ForEach(self.question.answers.sorted(by: ==), id: \.key) { key, value in
                                        CheckboxField(id: key, label: key, callback: self.checkboxSelected, q: self.question)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                        }.frame(width: 325, height: 0, alignment: .bottomLeading)
                    }
                }
 
                
            }.background(LinearGradient(
                gradient: Gradient(colors: [.blue, .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .multilineTextAlignment(.center)
            .cornerRadius(10)
            .animation(.interactiveSpring())
        }
    }
}



//CheckBoxField code used from Muahmud Ahsan
//https://thinkdiff.net/ios/how-to-create-checkbox-in-swiftui/
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    @ObservedObject var q: Question
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 30,
        color: Color = Color.black,
        textSize: Int = 14,
        callback: @escaping (String, Bool)->(),
        q: Question
        
    ) {
    
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
        self.q = q
       
        
    }
    
    
    
    
    var body: some View {
        HStack {
            Button(action:{
                self.q.answers[id] = !(self.q.answers[id] ?? false)
                self.callback(self.id, self.q.answers[id] ?? false)
            }) {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: (self.q.answers[id]!) ? "checkmark.square" : "square")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.size, height: self.size)
                    
                    /*Text(label)
                        .font(.system(size: 20))
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: false, vertical: true)*/
                    
                }.foregroundColor(self.color)
            }
            .foregroundColor(Color.white)
            Text(label)
                .font(.system(size: 20))
                .minimumScaleFactor(0.5)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
    }
}



/*
 
 The Questionnaire:
 
 Are you experiencing any of the following symptoms? Cough, Headache, Fatigue, Breathing Issues, Soreness
 Do you have a fever? No, Yes a low fever between 37.2°C and 38.5°C, Yes a high fever over 38.5°C
 Have you participated in any of the following recently? Attended a mass gathering such as a party or wedding, travelled by plane, train, bus, or other public transport, None of these
 Have you come in close contact with anyone diagnosed with Covid-19 today?
 Do you continue to practice protective measures such as using a mask to cover your nose and mouth, follow social distancing, and washing your hands with soap and water? Yes or No
 
 */


struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        let answers = ["Attended a mass gathering such as a party or wedding": false, "test": false, "cough": false, "cdough": false, "codugh": false]
        QuestionCardView(question: Question(id: 1, question: "Do you have a fever", type: "multiple", answers: answers))
        
    }
}




