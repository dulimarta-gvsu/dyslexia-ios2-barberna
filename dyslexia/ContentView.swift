//  ContentView.swift
//  dyslexia

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    @StateObject private var navCtrl = MyNavigator()
    
    var body: some View {
        NavigationStack(path: $navCtrl.navPath) {
            VStack(spacing: 20) {
                HStack {
                    Button("History") { navCtrl.navPath.append(Route.history) }
                    Button("Settings") { navCtrl.navPath.append(Route.setting) }
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.letterBackgroundColor)
                
                HStack(spacing: 40) {
                    Text("Moves: \(viewModel.moveCount)")
                    Text("Time: \(Int(viewModel.elapsedTime))s")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                
                Spacer()
                
                
                LetterGroup(letters: $viewModel.letters, backgroundColor: viewModel.letterBackgroundColor, isSolved: viewModel.isSolved) { rearrangedArray in
                    viewModel.rearrange(to: rearrangedArray)
                }
                
                Spacer()
            
                if viewModel.isSolved {
                    VStack {
                        Text("Congratulations!")
                        Text("Total Moves: \(viewModel.moveCount)")
                        Text("Time: \(Int(viewModel.elapsedTime)) seconds")
                    }
                    .foregroundColor(.red)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                }
                
                Button("New Game") {
                    viewModel.startNewGame()
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.letterBackgroundColor)
            }
            .padding()
            .background(viewModel.letterBackgroundColor.opacity(0.4))
            .navigationTitle("Dyslexia")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .setting:
                    SettingView(navCtrl: navCtrl, viewModel: viewModel)
                case .history:
                    HistoryView(viewModel: viewModel, navCtrl: navCtrl)
                case .selected:
                    SelectedView(navCtrl: navCtrl, viewModel: viewModel)
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: AppViewModel())
    }
}
#endif

