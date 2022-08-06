//
//  ContentView.swift
//  RoPaSci
//
//  Created by RJ Tedoco on 8/5/22.
//

import SwiftUI

struct ContentView: View {
    enum Moves: Int, CaseIterable {
        case Rock, Paper, Scissors
    }
    
    @State private var appMove = Moves.allCases.randomElement();
    @State private var shouldWin = Bool.random()
    @State private var showingAlert = false;
    @State private var alertTitle = ""
    @State private var showingEndAlert = false;
    @State private var endAlertTitle = ""
    @State private var score = 0
    @State private var questionCounter = 0
    
    func getEmoji(_ move: Moves) -> String {
        switch move {
            case Moves.Scissors:
                return "✂️"
            case Moves.Paper:
                return "📃"
            default:
                return "🪨"
        }
    }
    
    func engage(playerMove: Moves, appMove: Moves, shouldWin: Bool) -> Bool {
        var hasPlayerWon: Bool
        
        switch appMove {
        case .Rock:
            switch playerMove {
            case .Rock:
                hasPlayerWon = false;
            case .Paper:
                hasPlayerWon = true;
            case .Scissors:
                hasPlayerWon = false;
            }
        case .Paper:
            switch playerMove {
            case .Rock:
                hasPlayerWon = false
            case .Paper:
                hasPlayerWon = false
            case .Scissors:
                hasPlayerWon = true
            }
        case .Scissors:
            switch playerMove {
            case .Rock:
                hasPlayerWon = true
            case .Paper:
                hasPlayerWon = false
            case .Scissors:
                hasPlayerWon = false
            }
        }
        
        if(shouldWin) {
            return hasPlayerWon
        } else {
            return !hasPlayerWon
        }
    }
    
    func reset() {
        appMove = Moves.allCases.randomElement();
        shouldWin = Bool.random()
        alertTitle = "";
        endAlertTitle = "";
        
        if(!hasGameEnded) {
            questionCounter += 1
        } else {
            showingEndAlert = true;
            endAlertTitle = "Game has ended."
            questionCounter = 0;
        }
    }
    
    var hasGameEnded: Bool {
        if(questionCounter < 10) {
            return true
        } else {
            return false
        }
    }
    
    func incrementScore() {
        score += 1;
    }
    
    func decrementScore() {
        if(score > 0) {
            score -= 1;
        }
    }
    
    func handleButton(playerMove: Moves) {
        if(engage(playerMove: playerMove, appMove: appMove!, shouldWin: shouldWin)) {
            alertTitle = "You got it!"
            incrementScore()
        } else {
            alertTitle = "You didn't get it..."
            decrementScore()
        }
        
        showingAlert = true
    }
    
    var EmojiButtons: some View {
        HStack {
            Button("🪨") {
                handleButton(playerMove: Moves.Rock)
            }
                .padding()
            Button("📃") {
                handleButton(playerMove: Moves.Paper)
            }
                .padding()
            Button("✂️") {
                handleButton(playerMove: Moves.Scissors)
            }
                .padding()
        }
        .font(.system(size: 64))
        .shadow(radius: 4)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Continue?") {
                reset()
            }
        }
        
        .alert(endAlertTitle, isPresented: $showingEndAlert) {
            Button("Play again?") {
                reset()
                score = 0
            }
        } message: {
            Text("Your total score is: \(score)")
        }
    }
    
    var TextCard: some View {
        VStack {
            Text("This is my move:")
                .font(.title2)
            Text(getEmoji(appMove!))
                .font(.system(size: 128))
                .padding()
                .shadow(radius: 4)
            Text(shouldWin ? "What's your move to WIN this round?" : "What's your move to LOSE this round?")
                .italic()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 8)
        .padding()
    }
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.red, .orange], center: .center, startRadius: 0, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Rock, Paper, and Scissors")
                    .font(.largeTitle)
                    .padding()
                TextCard
                
                Spacer()

                Text("Tap on one of the three moves")
                    .font(.subheadline)
                EmojiButtons

                Text("Score: \(score)")
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
