//
//  Homescreen.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//

import Foundation
import SwiftUI

struct HomescreenUI: View {
    
    @State private var showDetail = false
    var username: String

    var body: some View {
        VStack {
            Text(username)
                .padding()
                .font(.largeTitle)
            Image(systemName: "person").font(.system(size: 100, weight: .regular))
            Spacer()
            Spacer()
            HStack {
                Image(systemName: "xmark.square").font(.system(size: 16, weight: .regular)).foregroundColor(Color(UIColor.systemRed))

                Text("Covid Postitive")
                    .font(.headline)

                Spacer()

                    Button(action: {
                        self.showDetail.toggle()
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .imageScale(.large)
                            .rotationEffect(.degrees(showDetail ? 90 : 0))
                            .scaleEffect(showDetail ? 1.5 : 1)
                            .padding()
                            .animation(.spring())
                    }
                }
            Spacer()

            if showDetail {
                CovidDiagnosisUI()
            }
        }
        .padding()
    }
    
    
    
}
