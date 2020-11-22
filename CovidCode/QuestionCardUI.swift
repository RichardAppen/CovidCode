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
    
}

struct QuestionCardView: View {
    @State private var translation: CGSize = .zero
    
    var question: Question

    
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
                }.padding(.bottom, 300)
                .padding(.top, 100)
                HStack {
                    Spacer()
                    Image(systemName: "x.circle")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        
                    Spacer()
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                .padding(.horizontal)
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
