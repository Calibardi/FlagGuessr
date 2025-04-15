//
//  HomeView.swift
//  FlagGuessr
//
//  Created by Lorenzo Ilardi on 03/04/25.
//

import SwiftUI

/*
 
 1. Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert and in the score label. - Done
 2. When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example. - Done
 3. Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game. - Done
 {
 Did not use an alert, but a button, that is shown if certain conditions are met. Tapping it will restart score and questions
 }
 4. Replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
 
 5. When you tap a flag, make it spin around 360 degrees on the Y axis. - Done
 6. Make the other two buttons fade out to 25% opacity. - Done
 7. Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment! - Done
 
 */

struct HomeView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @State private var score = 0
    @State private var questionNumber = 1
    @State private var answeredQuestions: Int = 0
    @State private var nextQuestionIsLoading: Bool = false
    
    // Animation state params
    @State private var flagsRotationAmount: [Double] = [0.0, 0.0, 0.0]
    @State private var flagsOpacity: [Double] = [1.0, 1.0, 1.0]
    @State private var flagsScalingAmount: [Double] = [1.0, 1.0, 1.0]
    
    private let maxNumberOfQuestions: Int = 8
    private var gameIsCompleted: Bool {
        answeredQuestions == maxNumberOfQuestions
    }
    
    // MARK: DATA
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.7),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            HStack(alignment: .top) {
                VStack {
                    Spacer()
                    Text("Guess the flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Group {
                        VStack(spacing: 15) {
                            VStack {
                                Text("Tap the flag of")
                                    .font(.subheadline.weight(.heavy))
                                    .foregroundStyle(.secondary)
                                Text(countries[correctAnswer])
                                    .font(.largeTitle.weight(.semibold))
                            }
                            
                            if verticalSizeClass == .compact {
                                HStack(spacing: 10) {
                                    flagButtonsElement
                                }
                            } else if verticalSizeClass == .regular {
                                flagButtonsElement
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    .padding(.horizontal, 10)
                    .shadow(radius: 10)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        ZStack {
                            Text("\(questionNumber)/\(maxNumberOfQuestions)")
                                .font(.headline.weight(.semibold))
                                .padding()
                        }
                        .frame(width: 100, height: 30)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                        
                        ZStack {
                            Text("Score: \(score)")
                                .font(.title.bold())
                                .padding()
                        }
                        .frame(width: 300, height: 60)
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    
                    Spacer()
                    
                    if gameIsCompleted {
                        restartButtonElement
                    } else {
                        restartButtonElement
                            .hidden()
                    }
                }
            }
        }
//        .alert(scoreTitle, isPresented: $showingScore) {
//            Button("Continue", action: askQuestion)
//        } message: {
//            Text(alertMessage)
//        }
    }
    
    // MARK: UI bound methods
    private func didTapFlagButton(_ number: Int) {
        if number == correctAnswer {
            score += 1
        }
        
        loadNextQuestion()
    }
}

// MARK: - Methods extension
private extension HomeView {
    private func loadNextQuestion() {
        nextQuestionIsLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            incrementQuestionsNumber()
            askQuestion()
            nextQuestionIsLoading = false
        }
    }
    
    private func askQuestion() {
        guard !gameIsCompleted else { return }
        resetAnimationsState()
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    private func incrementQuestionsNumber() {
        answeredQuestions += 1
        if !gameIsCompleted {
            questionNumber += 1
        }
    }
    
    private func restartGame() {
        restartQuestionsState()
        restartScore()
        askQuestion()
    }
    
    private func restartScore() {
        score = 0
    }
    
    private func restartQuestionsState() {
        answeredQuestions = 0
        questionNumber = 1
    }
    
    private func triggerAnimation(for number: Int) {
        withAnimation {
            
            flagsOpacity = flagsOpacity.enumerated().map { offset, element in
                if offset == number {
                    return 1.0
                } else {
                    return 0.25
                }
            }
            
            flagsScalingAmount = flagsScalingAmount.enumerated().map { offset, element in
                if offset == number {
                    return 1.0
                } else {
                    return 0.6
                }
            }
            
            flagsRotationAmount[number] += 360
        }
    }
    
    private func resetAnimationsState() {
        withAnimation {
            flagsOpacity = [1.0, 1.0, 1.0]
            flagsScalingAmount = [1.0, 1.0, 1.0]
        }
    }
}

// MARK: -  UI extension
private extension HomeView {
    var restartButtonElement: some View {
        Button {
            restartGame()
        } label: {
            Text("Restart")
            Image(systemName: "restart")
        }
        .tint(.white)
    }
    
    var flagButtonsElement: some View {
        return ForEach(0..<3) { number in
            Button {
                triggerAnimation(for: number)
                didTapFlagButton(number)
            } label: {
                FlagImage(resourceName: countries[number])
            }
            .disabled(gameIsCompleted || nextQuestionIsLoading)
            .rotation3DEffect(
                .degrees(flagsRotationAmount[number]),
                axis: (x: 0, y: 1, z: 0))
            .opacity(flagsOpacity[number])
            .scaleEffect(flagsScalingAmount[number])
        }
    }
}

#Preview {
    HomeView()
}
