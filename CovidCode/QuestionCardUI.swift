//
//  QuestionCardUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/21/20.
//

import SwiftUI

struct Question: Hashable {
    var id: Int
    let question: String
    var type: String
    var answer: Bool?
    var answers: [String: String] = [:]
}

struct QuestionCardView: View {
    @State private var translation: CGSize = .zero
    
    @State var question: Question
    
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
            self.question.answers[id] = "yes"
        } else {
            self.question.answers[id] = "no"
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
                                    .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            })
                            
                            
                            Spacer()
                            Spacer()
                            Button(action: {
                                self.question.answer = true
                            }, label: {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .foregroundColor(yesButtonColor)
                                    .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            })
                            Spacer()
                        } else if (self.question.type == "multiple"){
                            Spacer()
                            VStack {
                                ForEach(self.question.answers.sorted(by: >), id: \.key) { key, value in
                                    CheckboxField(id: key, label: key, callback: checkboxSelected)
                                }
                            }
                            
                            Spacer()
                        }
                        
                    }.frame(width: 325, height: 0, alignment: .bottomLeading)
                }
                }
 
                
            }.background(LinearGradient(
                gradient: Gradient(colors: [.blue, .gray]),
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
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 30,
        color: Color = Color.black,
        textSize: Int = 14,
        callback: @escaping (String, Bool)->()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}


struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        let answers = ["sick": "yes", "fever": "no", "cough": "no", "cdough": "no", "codugh": "no"]
        QuestionCardView(question: Question(id: 1, question: "Do ads ads asd adsadsads adsdsa zcxcxzcxz you have a cough?", type: "multiple", answers: answers))
        
    }
}



