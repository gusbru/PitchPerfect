//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Gustavo Brunetto on 2020-04-16.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStopRecord: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnStopRecord.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording"
        btnRecord.isEnabled = false
        btnStopRecord.isEnabled = true
        
        // setup to start record
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        // initialize the audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        // start recorder
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        // delegate
        // doing this, the AVAudioRecorderDelegate knows that the audioRecorderDidFinishRecording
        // needs to be called when the audio record finishes
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tap to Record"
        btnRecord.isEnabled = true
        btnStopRecord.isEnabled = false
        
        // stop record
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // audio record finished
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Error recording audio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

