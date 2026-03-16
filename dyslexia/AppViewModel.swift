//
//  AppViewModel.swift
//  dyslexia

import Foundation
import Combine
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var letters: [Letter] = []
    
    struct WorldRecord: Equatable, Identifiable {
        let id = UUID()
        let secretWord: String
        let score: Int
        let moves: Int
        let time: TimeInterval
    }
    
    private let vocabulary: Set<String> = [
        "hydrogen", "helium", "lithium", "beryllium", "boron",
        "carbon", "nitrogen", "oxygen", "fluorine", "neon",
        "sodium", "magnesium", "aluminum", "silicon", "phosphorus",
        "sulfur", "chlorine", "argon", "potassium", "calcium",
        "scandium", "titanium", "vanadium", "chromium", "manganese",
        "iron", "cobalt", "nickel", "copper", "zinc"
    ]
    
    private let letterScores: [Character: Int] = [
        "A": 1, "B": 3, "C": 3, "D": 2, "E": 1, "F": 4, "G": 2, "H": 4, "I": 1,
        "J": 8, "K": 5, "L": 1, "M": 3, "N": 1, "O": 1, "P": 3, "Q": 10, "R": 1,
        "S": 1, "T": 1, "U": 1, "V": 4, "W": 4, "X": 8, "Y": 4, "Z": 10
    ]
    
    private var timer: AnyCancellable?
    private var startTime: Date = Date()
    private var secretWord: String = ""
    
    
    
    var removedLetter: Letter? = nil
    var removedIndex: Int? = nil
    
    
    @Published var moveCount: Int = 0
    @Published var elapsedTime: TimeInterval = 0
    @Published var isSolved: Bool = false
    @Published var wordScore: Int? = nil
    @Published var gameHistory: [WorldRecord] = []
    
    // Settings
    @Published var minLength: Double = 3
    @Published var maxLength: Double = 10
    @Published var red: Double = 0.5
    @Published var green: Double = 0.5
    @Published var blue: Double = 0.5
    
    var letterBackgroundColor: Color {
        Color(red: red, green: green, blue: blue)
    }
    
    init () {
        self.startNewGame()
    }
    
    func startNewGame() {
        let filtered = vocabulary.filter {
            $0.count >= Int(minLength) && $0.count <= Int(maxLength)
        }
        
        if !secretWord.isEmpty && !isSolved {
            gameHistory.append(WorldRecord(secretWord: secretWord, score: 0, moves: moveCount, time: elapsedTime))
        }
        
        let wordToUse = (filtered.randomElement() ?? "Gold").uppercased()
        self.secretWord = wordToUse
        
        self.isSolved = false
        self.moveCount = 0
        self.elapsedTime = 0
        self.startTime = Date()
        
        self.letters = wordToUse.map { char in
            Letter(text: String(char), point: letterScores[char] ?? 1)
        }.shuffled()
        
        startTimer()
    }
    
    private func startTimer() {
            timer?.cancel() // Reset any existing timer
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self, !self.isSolved else { return }
                    self.elapsedTime = Date().timeIntervalSince(self.startTime)
                }
        }
    
    
    func rearrange(to: [Letter]) {
            self.letters = to
            self.moveCount += 1
            checkIfSolved()
        }
    
    private func checkIfSolved() {
            let currentWord = String(letters.compactMap { $0.text.first }).uppercased()
            
            if currentWord == secretWord && !isSolved {
                isSolved = true
                
                // Calculate score based on actual letter point values
                let finalScore = letters.reduce(0) { $0 + $1.point }
                self.wordScore = finalScore
                
                gameHistory.append(WorldRecord(
                    secretWord: currentWord,
                    score: finalScore,
                    moves: moveCount,
                    time: elapsedTime
                ))
                
                self.secretWord = "" // Clear to prevent double saving
                timer?.cancel()
            }
        }
    
    // Sorting functions for Game History
    func sortByWord() { gameHistory.sort { $0.secretWord < $1.secretWord } }
    func sortByScore() { gameHistory.sort { $0.score > $1.score } }
    func sortByMoves() { gameHistory.sort { $0.moves < $1.moves } }
    func sortByTime() { gameHistory.sort { $0.time < $1.time } }
    
}
