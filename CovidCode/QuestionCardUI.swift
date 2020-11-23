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
    var answer: Bool?
}

struct QuestionCardView: View {
    @State private var translation: CGSize = .zero
    
    @State var question: Question

    var yesButtonColor: Color {
        
        if (self.question.answer == nil) {
            return Color.gray
        } else if (self.question.answer == false) {
            return Color.black
        } else {
            return Color.green
        }
    }
    
    var noButtonColor: Color {
        
        if (self.question.answer == nil) {
            return Color.gray
        } else if (self.question.answer == true) {
            return Color.black
        } else {
            return Color.red
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("\(self.question.question) ")
                        .font(.title)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }.padding(.bottom, 200)
                .padding(.top, 100)
                HStack {
                    
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

                }
                
                Spacer()
                
                
            }
            .padding(10)
            .multilineTextAlignment(.center)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            
        }
    }
}


struct QuestionCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCardView(question: Question(id: 1, question: "Do you have a cough?"))
            
    }
}
