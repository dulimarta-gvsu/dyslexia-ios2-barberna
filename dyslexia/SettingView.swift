//
//  SettingView.swift
//  dyslexia
//
//  Created by Nathan Barber on 3/14/26.
//

import SwiftUI

struct SettingView: View {
    
    @ObservedObject var navCtrl: MyNavigator
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            // Header with Back Button
            HStack {
                Button(action: {
                    navCtrl.navigateBackToRoot()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding()
                Spacer()
            }
            
            Form {
                Section(header: Text("Word Settings")) {
                    Slider(value: $viewModel.minLength, in: 3...5, step: 1) {
                        Text("Min Length")
                    }
                    Text("Min Length: \(Int(viewModel.minLength))")
                    Slider(value: $viewModel.maxLength, in: 5...10, step: 1) {
                        Text("Max Length")
                    }
                    Text("Max Length: \(Int(viewModel.maxLength))")
                }
                viewModel.letterBackgroundColor.opacity(0.4)
                                .ignoresSafeArea()
                
                
                Section(header: Text("Background Color")) {
                    Slider(value: $viewModel.red, in: 0...1) { Text("Red") }
                    Text("Red: \(Int(viewModel.red * 255))")
                            .font(.caption)
                    Slider(value: $viewModel.green, in: 0...1) { Text("Green") }
                    Text("Green: \(Int(viewModel.green * 255))")
                            .font(.caption)
                    Slider(value: $viewModel.blue, in: 0...1) { Text("Blue") }
                    Text("Blue: \(Int(viewModel.blue * 255))")
                            .font(.caption)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    
}
