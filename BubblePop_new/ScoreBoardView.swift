//
//  ScoreBoardView.swift
//  BubblePop
//
//  Created by Nikhil Krshna U on 30/4/2025.
//

import SwiftUI

struct ScoreboardView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("🏆 High Scores")
                .font(.largeTitle)
                .bold()
                .padding(.top, 30)

            let highScores = viewModel.getHighScores()

            if highScores.isEmpty {
                Text("No high scores yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(highScores, id: \.0) { (name, score) in
                        HStack {
                            Text(name)
                                .font(.headline)
                            Spacer()
                            Text("\(score)")
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                }
                .frame(maxHeight: 300)
            }

            Spacer()

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Play Again")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing, .bottom], 20)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
