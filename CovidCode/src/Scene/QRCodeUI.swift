//
//  QRCodeUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/25/20.
//

import Foundation
import SwiftUI

struct QRCodeUI: View {
    @State var showDetail : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
        VStack {
        Text("Your QR Code")
            .font(.title)
            .padding()
        Button(action: {
            showDetail.toggle()
        }) {
            if (showDetail){
                Image(uiImage: generateQRCode(from: "www.google.com")).interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } else {
                Image(uiImage: generateQRCode(from: "www.google.com")).interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
        }
        if (!showDetail) {
            Text("Click image to enlarge").font(.caption)
        }
        Button(action: {
        }) {
            Text("What is this?")
        }
        .padding()
            Spacer()
        }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("QR Code").font(.headline)
        
                }
            }
        }
        
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let image = filter.outputImage {
            if let img = context.createCGImage(image, from: image.extent) {
                return UIImage(cgImage: img)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}
