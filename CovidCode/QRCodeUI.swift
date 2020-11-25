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
    var parentTabController: TabControllerUI
    
    var body: some View {
        VStack {
            ZStack {
                HStack() {
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
                HStack {
                    Text("QR Code")
                }
            }
            Divider()
            Spacer()
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
