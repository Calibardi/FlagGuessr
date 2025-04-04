//
//  HomeView.swift
//  FlagGuessr
//
//  Created by Lorenzo Ilardi on 03/04/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
//            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.7),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
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
                                ForEach(0..<3) { number in
                                    Button {
                                        didTapFlagButton(number)
                                    } label: {
                                        Image(countries[number])
                                            .clipShape(.rect(cornerRadius: 10))
                                            .shadow(radius: 20)
                                    }
                                }
                            }
                        } else if verticalSizeClass == .regular {
                            ForEach(0..<3) { number in
                                Button {
                                    didTapFlagButton(number)
                                } label: {
                                    Image(countries[number])
                                        .clipShape(.rect(cornerRadius: 10))
                                        .shadow(radius: 20)
                                }
                            }
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
                
                ZStack {
                    Text("Score: ???")
                        .font(.title.bold())
                        .padding()
                }
                .frame(width: 300, height: 60)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
            }
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is ???")
        }
    }
    
    private func didTapFlagButton(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
        } else {
            scoreTitle = "Wrong!"
        }
        
        showingScore = true
    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    HomeView()
}
