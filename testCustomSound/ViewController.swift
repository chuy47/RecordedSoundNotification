//
//  ViewController.swift
//  testCustomSound
//
//  Created by Gerardo on 16/02/16.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    private var recorder: AVAudioRecorder?
    
    @IBAction func notify() {
        let n = UILocalNotification()
        n.soundName = "recorded.caf"
        n.alertBody = "test"
        n.timeZone = NSTimeZone.defaultTimeZone()
        n.fireDate = NSDate(timeIntervalSinceNow: 4)
        n.alertAction = "Open"
        UIApplication.sharedApplication().scheduleLocalNotification(n)
    }
    
    @IBAction func recordAudio() {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath = soundsPath + "/recorded.caf"
        
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    
                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    
                    //create AnyObject of settings
                    if (self.recorder == nil) {
                        let settings: [String : AnyObject] = [
                            AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
                            AVSampleRateKey:44100.0,
                            AVNumberOfChannelsKey:2,
                            AVEncoderBitRateKey:12800,
                            AVLinearPCMBitDepthKey:16,
                            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
                        ]
                        
                        //record
                        try! self.recorder = AVAudioRecorder(URL: NSURL.fileURLWithPath(filePath), settings: settings)
                    }
                    
                    self.recorder?.record()
                    
                } else{
                    print("not granted")
                }
            })
        }
    }
    
    @IBAction func stopRecordingAndSave() {
        self.recorder?.stop()
    }
}

