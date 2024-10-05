//
//  AboutView.swift
//  GadzoinksAssist
//
//  Created by Neal Katz on 4/5/24.
//

import SwiftUI
import os.log

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack(alignment: .center) {
           
            Image("about")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 550, height: 300)
            Spacer()
            Text("LoraExplorer is a free app that lets you view a LORA metadata.")
                .lineLimit(2)
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            Text("Courtesy of")
            Text("www.gadzoinks.com")
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .onTapGesture {
                    // Handle hyperlink tap action
                    if let url = URL(string: "https://www.gadzoinks.com") {
                        NSWorkspace.shared.open(url)
                    }
                }
            // These are used when the app is submited to Apple App Store
            // You should remove them if forking the code for other use

            HStack {
                Text("Terms of Use")
                    .foregroundColor(.black)
                    .onTapGesture {
                        // Handle hyperlink tap action
                        if let url = URL(string: GadzoinksTermsUrl) {
                            NSWorkspace.shared.open(url)
                        }
                    }
                Text("  ")
                Text("Privacy Policy")
                    .foregroundColor(.black)
                    .onTapGesture {
                        // Handle hyperlink tap action
                        if let url = URL(string: GadzoinksPrivacyUrl) {
                            NSWorkspace.shared.open(url)
                        }
                    }
                
            }
            
            
            Spacer()
            HStack {
                Button("Close") {
                    dismiss()
                }.buttonStyle(BorderlessButtonStyle())
            }
            
        }
        .frame(minWidth: 300, minHeight: 300)
        .padding(20)
    }
}

