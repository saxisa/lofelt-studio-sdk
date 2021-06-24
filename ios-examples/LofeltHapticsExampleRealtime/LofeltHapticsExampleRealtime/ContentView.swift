//
//  ContentView.swift
//  LofeltHapticsExampleRealtime
//
//  Created by Tomash Ghz on 10.07.20.
//  Copyright © 2020 Lofelt GmbH. All rights reserved.
//

import SwiftUI
import LofeltHaptics
import AVFoundation

struct ContentView: View {
    
    var haptics: LofeltHaptics?
    var hapticsSupported = false;
    var audioEngine: AVAudioEngine?
    var audioPlayer: AVAudioPlayerNode?
    var mainMixer: AVAudioMixerNode?
    
    init(){
        // Instantiate haptics player
        haptics = try? LofeltHaptics.init()
        
        // check if device supports Lofelt Haptics
        hapticsSupported = LofeltHaptics.deviceMeetsMinimumRequirement()
        
        // Create audio engine and player.
        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayerNode()
        
        // Connect player to main mixer.
        audioEngine?.attach(audioPlayer!)
        mainMixer = audioEngine?.mainMixerNode
        
        // Connect player to Lofelt haptics.
        try! haptics?.attachAudioSource(audioPlayer!)
    }
    
    var body: some View {
        if hapticsSupported {
            VStack {
                HStack {
                    Button(action: {
                        // Load audio clip.
                        let fileUrl = Bundle.main.url(forResource: "OP-Z", withExtension: "wav")!
                        let audioFile = try! AVAudioFile.init(forReading: fileUrl)
                        
                        self.audioEngine?.connect(self.audioPlayer!, to: self.mainMixer!, format: audioFile.processingFormat)
                        
                        // Start audio engine and play audio.
                        try! self.audioEngine?.start()
                        self.audioPlayer!.scheduleFile(audioFile, at: nil, completionHandler: nil)
                        self.audioPlayer!.play()
                    }) {
                        HStack {
                            Text("Drums")
                        }
                    }
                    .shadow(radius: 20.0)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10.0)
                    
                }.padding()
                
            }
            .foregroundColor(Color.white)
            .font(.subheadline)
        } else {
            Text("Lofelt Haptics is not supported on this device. \r\nMinimum requirements: at least iOS 13 and iPhone 8 or newer.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
