//
//  StartView.swift
//  BubblePop
//
//  Created by Nikhil Krshna U on 30/4/2025.
//
import SwiftUI

struct StartView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to BubblePop!")
                    .font(.largeTitle)

                TextField("Enter your name", text: $viewModel.playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // NavigationLink with label inside
                NavigationLink(
                    destination: GameView(viewModel: viewModel),
                    label: {
                        Text("Start Game")
                            .padding()
                            .background(viewModel.playerName.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    .disabled(viewModel.playerName.isEmpty) // Disable if name is empty
            }
            .padding()
        }
    }
}
