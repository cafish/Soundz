//
//  SoundCell.swift
//  ParseStarterProject
//
//  Created by Jiajia Luo on 5/23/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class SoundCell: UITableViewCell, AVAudioPlayerDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    var audioFile = PFFile()
    var firstTime = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func playPauseTapped(sender: AnyObject) {
        if self.firstTime {
            self.playSound()
            self.firstTime = false
        } else {
            if self.audioPlayer.playing {
                self.audioPlayer.pause()
                self.playPauseButton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
            } else {
                self.playSound()
            }
        }
    }
    
    func playSound() {
        self.playPauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        
        if !audioFile.isDataAvailable{
            audioFile.getDataInBackgroundWithBlock({ (data : NSData?, error : NSError?) -> Void in
                var audioData = self.audioFile.getData()
                AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:
                    AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
                
                self.audioPlayer = AVAudioPlayer(data: audioData, error: nil)
                self.audioPlayer.delegate = self
                self.audioPlayer.play()
            })
        } else {
            
            var audioData = self.audioFile.getData()
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:
                AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
            
            self.audioPlayer = AVAudioPlayer(data: audioData, error: nil)
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.playPauseButton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        self.audioPlayer.delegate = nil
    }
}

































