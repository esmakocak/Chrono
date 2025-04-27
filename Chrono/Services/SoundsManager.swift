//
//  SoundsManager.swift
//  Chrono
//
//  Created by Esma Koçak on 27.04.2025.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            // 🔥 BU KISIM ÖNEMLİ
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
