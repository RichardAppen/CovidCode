//
//  QuestionnaireUI.swift
//  CovidCode
//
//  Created by Ryan muinos on 11/21/20.
//

import SwiftUI

struct QuestionnaireUI: View {
     
       /// List of questions
       @State var questions: [Question] = [
        Question(id: 1, question: "Do you have a cough?"),
        Question(id: 2, question: "Do you have a headache?"),
        Question(id: 3, question: "Does your stomach?"),
        Question(id: 4, question: "Do you have a fever?"),
        Question(id: 5, question: "Do you feel good and feel well?")
       ]
       
        
       private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
           let offset: CGFloat = CGFloat(questions.count - 1 - id) * 10
           return geometry.size.width - offset
       }
       
       
       private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
           return  CGFloat(questions.count - 1 - id) * 10
       }
       
       var body: some View {
           VStack {
               GeometryReader { geometry in
                   VStack {
                       ZStack {
                           ForEach(self.questions, id: \.self) { q in
                            QuestionCardView(question: q)
                                   .frame(width: self.getCardWidth(geometry, id: q.id), height: 400)
                                   .offset(x: 0, y: self.getCardOffset(geometry, id: q.id))
                           }
                       }
                       Spacer()
                   }
               }
           }.padding()
       }
   }


struct QuestionnaireUI_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireUI()
    }
}


