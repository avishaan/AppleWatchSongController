//
//  ViewController.swift
//  SongControl
//
//  Created by Brown Magic on 5/25/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var currentSongLabel: UILabel!
  
  var audioSession: AVAudioSession! //singleton, only one will exist
  var audioPlayer: AVAudioPlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    configureAudioSession()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - IBActions
  @IBAction func playButtonPressed(sender: UIButton) {
    
  }
  
  @IBAction func previousButtonPressed(sender: UIButton) {
    
  }
  
  @IBAction func nextButtonPressed(sender: UIButton) {
    
  }
  
  // Mark: - Audio
  
  func configureAudioSession() {
    audioSession = AVAudioSession.sharedInstance()
    
    var categoryError: NSError?
    var activeError: NSError?
    
    audioSession.setCategory(AVAudioSessionCategoryPlayback, error: &categoryError)
    println("error \(categoryError)")
    
    var success = self.audioSession.setActive(true, error: &activeError)
    if !success {
      println("error making audio session active: \(activeError)")
    }
    
    
  }
}

