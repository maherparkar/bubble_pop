import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // Published variables to update the UI
    @Published var playerName: String = ""
    @Published var score: Int = 0
    @Published var timeLeft: Int = 60
    @Published var bubbles: [Bubble] = []
    @Published var gameOver = false

    private var timer: AnyCancellable?
    private var maxBubbles = 15
    private var lastPoppedColor: BubbleColor?

    // Start the game with default or user-adjusted values
    func startGame(duration: Int = 60, maxBubbles: Int = 15) {
        self.timeLeft = duration
        self.score = 0
        self.bubbles = []
        self.gameOver = false
        self.maxBubbles = maxBubbles
        self.lastPoppedColor = nil

        // Start a 1-second timer loop
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateBubbles()
                self.timeLeft -= 1
                if self.timeLeft <= 0 {
                    self.timer?.cancel()
                    self.gameOver = true
                    self.saveScore()
                }
            }
    }

    // Refresh the bubbles on screen each second
    func updateBubbles() {
        // Randomly remove some unpopped bubbles
        bubbles.removeAll(where: { _ in Bool.random() })

        // Add new random bubbles until max is reached
        while bubbles.count < maxBubbles {
            let newBubble = Bubble(
                color: BubbleColor.random(),
                position: .zero // UI will assign actual position
            )
            bubbles.append(newBubble)
        }
    }

    // Handle popping a bubble and apply combo bonus
    func popBubble(_ bubble: Bubble) {
        guard let index = bubbles.firstIndex(where: { $0.id == bubble.id }) else { return }
        bubbles.remove(at: index)

        var points = bubble.color.points
        if bubble.color == lastPoppedColor {
            points = Int(Double(points) * 1.5) // combo bonus
        }
        score += points
        lastPoppedColor = bubble.color
    }

    // Save player's high score
    func saveScore() {
        let key = "player_\(playerName)"
        let currentHigh = UserDefaults.standard.integer(forKey: key)
        if score > currentHigh {
            UserDefaults.standard.set(score, forKey: key)
        }
    }


    // Load all saved high scores
    func getHighScores() -> [(String, Int)] {
        let all = UserDefaults.standard.dictionaryRepresentation()

        return all.compactMap {
            let key = $0.key
            guard key.hasPrefix("player_"),
                  let value = $0.value as? Int else {
                return nil
            }
            let playerName = key.replacingOccurrences(of: "player_", with: "")
            return (playerName, value)
        }
        .sorted { $0.1 > $1.1 }
    }


}

