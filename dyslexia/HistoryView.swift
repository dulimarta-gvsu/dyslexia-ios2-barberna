//
//  HistoryView.swift
//  dyslexia
//
//  Created by Nathan Barber on 3/14/26.
//
import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    @ObservedObject var navCtrl: MyNavigator
    
    var body: some View {
        ZStack {
            
            viewModel.letterBackgroundColor.opacity(0.4)
                            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Title Section
                Text("Word History")
                    .font(.largeTitle)
                    .bold()
                
                Text("Sort By:")
                    .font(.headline)
                
                // Sort Buttons Row
                HStack(spacing: 8) {
                    Group {
                        Button("Word") { viewModel.sortByWord() }
                        Button("Score") { viewModel.sortByScore() }
                        Button("Moves") { viewModel.sortByMoves() }
                        Button("Time") { viewModel.sortByTime() }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .tint(viewModel.letterBackgroundColor)
                }
                .padding(.horizontal)
                
                // List (Equivalent to LazyColumn)
                List(viewModel.gameHistory) { record in
                    Button(action: {
                        navCtrl.navigate(to: .selected)
                            navCtrl.payload[navCtrl.payload.count - 1]["word"] = record.secretWord
                            navCtrl.payload[navCtrl.payload.count - 1]["score"] = record.score
                            navCtrl.payload[navCtrl.payload.count - 1]["moves"] = record.moves
                            navCtrl.payload[navCtrl.payload.count - 1]["time"] = record.time
                    }) {
                        HStack {
                            Spacer()
                            if record.score == 0 {
                                Text("\(record.secretWord) Status: Incomplete")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(record.secretWord) Status: Complete")
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                
                Spacer()
                

                Button(action: {
                    navCtrl.navigateBackToRoot()
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
    }
}

#Preview {
    
}
