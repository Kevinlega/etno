//
//  DownloadAudioViewController.swift
//  ETNO
//
//  Created by Kevin Legarreta on 12/5/18.
//  Copyright © 2018 Los 5. All rights reserved.
//

import UIKit
import AVFoundation


class DownloadAudioViewController: UIViewController,AVAudioPlayerDelegate {
    
    // MARK: - Variables
    var user_id = Int()
    var project_id = Int()
    var location = String()
    var Player : AVAudioPlayer!
    @IBOutlet weak var PlayRef: UIButton!
    var IsPlaying = false
    var Audio = Data()

    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayRef.isEnabled = false
        self.Label.text = "Recording: " +  location.components(separatedBy: "/").last!
        
        
        let url = URL(string: location)!
        
//        let url = URL(string: "http://54.81.239.120/projects/1/5190075e-a8ec-4a3d-9a29-7940e5bc5f4d/voice/VOICE_1_20181204_223102_.3gp")!
        // Start transfer
        let task = URLSession.shared.downloadTask(with: url){ localURL, urlResponse, error in
            // Save file from server to tmp file.
            
            if let localURL = localURL{
              
                if let audio = try? Data(contentsOf: localURL){
                    self.Audio = audio
                    DispatchQueue.main.async{
                        self.PlayRef.isEnabled = true
                    }
                    self.present(Alert(title: "Downloaded", message: "You may play the audio file.", Dismiss: "Dismiss"),animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    
    
    // When "Play" button is pressed, play recording and change button labels.
    // If currently playing, stops playing session.
    @IBAction func PlayButton(_ sender: Any){
        if(IsPlaying){
            Player.stop()
            PlayRef.setTitle("Play", for: .normal)
            IsPlaying = false
        }
        else{
                PlayRef.setTitle("Stop", for: .normal)
                preparePlay()
                Player.play()
                IsPlaying = true
        }
    }
    
    
    func preparePlay(){
        do{
            Player = try AVAudioPlayer(data: Audio)
            Player.delegate = self
            Player.prepareToPlay()
        }
        catch{}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BackToProject"){
            let vc = segue.destination as! ProjectViewController
            vc.user_id = user_id
            vc.project_id = project_id
        }
    }
}