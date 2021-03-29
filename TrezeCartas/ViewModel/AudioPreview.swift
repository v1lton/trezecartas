//
//  AudioPreview.swift
//  TrezeCartas
//
//  Created by Samuel Brasileiro on 25/03/21.
//

import AVKit

class AudioPreview{
    static var shared = AudioPreview()
    
    var backgroundPlayer: AVAudioPlayer?
    
    var actionPlayer: AVAudioPlayer?
    
    init(){
        guard let url = Bundle.main.url(forResource: "background_sound", withExtension: "wav") else {
            print("No file with specified name exists")
            return }
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer!.numberOfLoops = -1
            backgroundPlayer!.prepareToPlay()
            backgroundPlayer!.volume = 0.1
            
        }
        catch{
            print(error)
        }
    }
    
    func play(name: String, volume: Float, delay: Double){
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("No file with specified name exists")
            return }
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            
            actionPlayer = try AVAudioPlayer(contentsOf: url)
            actionPlayer!.prepareToPlay()
            actionPlayer!.volume = volume
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.actionPlayer!.play()
            }
        }
        catch{
            print(error)
        }
    }

}
