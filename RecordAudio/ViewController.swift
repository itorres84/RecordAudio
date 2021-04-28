//
//  ViewController.swift
//  RecordAudio
//
//  Created by Israel Torres Alvarado on 27/04/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var btnRecord: UIBarButtonItem!
    @IBOutlet weak var btnPlay: UIBarButtonItem!

    let fileName = "recording.m4a"
    
    var soundPlayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        setupRecorder()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    
    func setupRecorder() {
        
        let recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                                AVEncoderBitRateKey: 320000,
                                AVNumberOfChannelsKey: 2,
                                AVSampleRateKey: 44100.0] as [String : Any]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: getDocumentsDirectory().appendingPathComponent(fileName), settings: recordSettings)
            
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            
        } catch {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func record(_ sender: UIBarButtonItem) {
        
        if sender.tag == 0 {
                
            audioRecorder.record()
            sender.tag = 1
            sender.tintColor = .red
            btnPlay.isEnabled = false
            
        } else {
            
            audioRecorder.stop()
            sender.tag = 0
            sender.tintColor = .systemBlue
            
        }
    
    }
    
    
    @IBAction func playSound(_ sender: UIBarButtonItem) {
    
        
        if sender.tag == 0 {
                
            prepareForPlay()
            soundPlayer.play()
            btnPlay.tintColor = .red
            btnPlay.tag = 1
            
        } else {
            
            soundPlayer.stop()
            btnPlay.tintColor = .systemBlue
            btnPlay.tag = 0
            
        }
    
    }
    
    func prepareForPlay() {
    
        do {
            
            soundPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName))
            soundPlayer.prepareToPlay()
            soundPlayer.delegate = self
            soundPlayer.volume = 1.0
            
            
        } catch {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        btnPlay.isEnabled = true
        
        //TODO: Firebase Node Save
        
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        soundPlayer.stop()
        btnPlay.tintColor = .systemBlue
        btnPlay.tag = 0
        
    }
    
}

