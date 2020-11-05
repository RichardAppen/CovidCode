//
//  CovidDiagnosisUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/4/20.
//

import Foundation
import SwiftUI

struct CovidDiagnosisUI: View {
    
    @State var currentImage = AnyView(Image(systemName: "bell").font(.system(size: 16, weight: .regular)))
    @State var currentText = ""
    
    var buttons = [
        ("Diagnosis", AnyView(Image(systemName: "xmark.seal").font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.systemRed)))),
        ("What to do", AnyView(Image(systemName: "bed.double.fill").font(.system(size: 40, weight: .regular)))),
        ("Result Calculations", AnyView(Image(systemName: "square.and.pencil").font(.system(size: 40, weight: .regular)))),
    ]
    
    var body: some View {
        return VStack {
            Spacer()
            HStack {
                currentImage
                Text(currentText)
            }
            Spacer()
            
            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button(action: {
                        self.currentImage = value.1
                        if (value.0 == "Diagnosis") {
                            currentText = "This is text explaining the negative diagnosis and what it means"
                        } else if (value.0 == "What to do") {
                            currentText = "This is text explaining what to do becuase of the diagnosis"
                        } else {
                            currentText = "This is text explaining how we calculated the results"
                        }
                    }) {
                        Text(value.0)
                            .font(.system(size: 15))
                            .animation(nil)
                    }
                }
            }
            
        }
    }
    
}

