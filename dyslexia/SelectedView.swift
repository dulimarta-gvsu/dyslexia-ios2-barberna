//
//  SelectedView.swift
//  dyslexia
//
//  Created by Nathan Barber on 3/14/26.
//

import SwiftUI

struct SelectedView: View {
    @ObservedObject var navCtrl: MyNavigator
    @ObservedObject var viewModel: AppViewModel
    
    private var word: String { navCtrl.payload.last?["word"] as? String ?? "" }
    private var score: Int { navCtrl.payload.last?["score"] as? Int ?? 0 }
    private var moves: Int { navCtrl.payload.last?["moves"] as? Int ?? 0 }
    private var time: TimeInterval { navCtrl.payload.last?["time"] as? TimeInterval ?? 0 }
    
    var body: some View {
        
        ZStack {
            viewModel.letterBackgroundColor.opacity(0.4)
                            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Game Details")
                    .font(.largeTitle)
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Word: \(word)")
                    
                    Text(score == 0 ? "Status: INCOMPLETE" : "Final Score: \(score)")
                        .foregroundColor(score == 0 ? .red : .primary)
                    
                    Text("Total Moves: \(moves)")
                    
                    Text("Time Spent: \(Int(time)) seconds")
                }
                .font(.title2)
                
                Spacer()
                
                Button(action: {
                    navCtrl.navigateBack()
                }) {
                    Text("Back to Game")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.letterBackgroundColor)
                .controlSize(.large)
                .padding(.horizontal, 40)
                .padding(.bottom, 16)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

#Preview {

}
