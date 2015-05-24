//
//  RecordViewController.swift
//  ParseStarterProject
//
//  Created by Jiajia Luo on 5/23/15.
//  Copyright (c) 2015 Jiajia Luo. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class RecordViewController: UIViewController, AVAudioPlayerDelegate {
    
    required init(coder aDecoder: NSCoder) {

        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        var pathComponents = [baseString, "sound.m4a"]
        self.audioURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSetting : [NSObject : AnyObject] = Dictionary()
        recordSetting[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSetting[AVSampleRateKey] = 44100.0
        recordSetting[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: self.audioURL, settings: recordSetting, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        
        // Roll Tide...
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var audioRecorder : AVAudioRecorder
    var audioPlayer = AVAudioPlayer()
    var audioURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Roll Tide...


        self.playButton.enabled = false
        self.saveButton.enabled = false
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        // Make PFFile
        var audioData = NSFileManager.defaultManager().contentsAtPath(self.audioURL.path!)
        var audioFile = PFFile(data: audioData!)
        
        // Make Sound PFObject
        var sound = PFObject(className: "Sound")
        sound.setObject(PFUser.currentUser()!, forKey: "User")
        sound.setObject(audioFile, forKey: "Audio")
        
        // Upload the sound to Parse
        sound.saveInBackgroundWithBlock { (Bool saved, NSError error) -> Void in
            if saved {
                println("Worked!")
            } else {
                println("Not Saved..Broken")
            }
        }
    
    }
    
    @IBAction func recordTapped(sender: AnyObject) {
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("Record", forState: UIControlState.Normal)
            self.playButton.enabled = true
            self.saveButton.enabled = true
        } else {
            AVAudioSession.sharedInstance().setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordButton.setTitle("Stop Recording", forState: UIControlState.Normal)
            self.playButton.enabled = false
            self.saveButton.enabled = false
        }
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        self.audioPlayer = AVAudioPlayer(contentsOfURL: self.audioURL, error: nil)
        
        // Set up AVAudioPlayerDelegate to use the method
        // - audioPlayerDidFinishPlaying:successfully:
        // In order to disable the recordButton (saveButton) while playButton Tapped
        self.audioPlayer.delegate = self
        self.audioPlayer.prepareToPlay()
        self.recordButton.enabled = false
        self.saveButton.enabled = false
        
        // Play the recorded audio
        self.audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // In order to use this method, must add AVAudioPlayerDelegate
        // Enable recordButton (and saveButton) while audioPlayerDidFinishPlaying is true
        self.recordButton.enabled = true
        self.saveButton.enabled = true
        self.audioPlayer.delegate = nil
    }
}







































