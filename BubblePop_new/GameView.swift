//
//  GameView.swift
//  BubblePop
//
//  Created by Nikhil Krshna U on 30/4/2025.
//
import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var screenSize: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()

                VStack {
                    HStack {
                        Text("Player: \(viewModel.playerName)")
                        Spacer()
                        Text("Time: \(viewModel.timeLeft)s")
                        Spacer()
                        Text("Score: \(viewModel.score)")
                    }
                    .padding()

                    Spacer()

                    ZStack {
                        ForEach(viewModel.bubbles) { bubble in
                            Circle()
                                .fill(bubble.color.color)
                                .frame(width: 60, height: 60)
                                .position(randomPosition(for: bubble, in: geometry.size))
                                .onTapGesture {
                                    viewModel.popBubble(bubble)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

                    Spacer()

                    if viewModel.gameOver {
                        NavigationLink(destination: ScoreboardView(viewModel: viewModel)) {
                            Text("View Scoreboard")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding()
                    }
                }
                .onAppear {
                    screenSize = geometry.size
                    viewModel.startGame()
                }
            }
        }
    }

    private func randomPosition(for bubble: Bubble, in size: CGSize) -> CGPoint {
        let radius: CGFloat = 30
        let x = CGFloat.random(in: radius...(size.width - radius))
        let y = CGFloat.random(in: radius...(size.height - radius))
        return CGPoint(x: x, y: y)
    }
}
