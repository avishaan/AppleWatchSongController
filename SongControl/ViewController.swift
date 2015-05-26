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
    configureAudioPlayer()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - IBActions
  @IBAction func playButtonPressed(sender: UIButton) {
    playMusic()
  }
  
  @IBAction func previousButtonPressed(sender: UIButton) {
    
  }
  
  @IBAction func nextButtonPressed(sender: UIButton) {
    
  }
  
  // MARK: - Audio
  
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
  
  func configureAudioPlayer() {
    
    var songPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")
    var songURL = NSURL.fileURLWithPath(songPath!)
    
    var songError: NSError?
    self.audioPlayer = AVAudioPlayer(contentsOfURL: songURL, error: &songError)
    println("song error: \(songError)")
    self.audioPlayer.numberOfLoops = 0
    
  }
  
  func playMusic() {
    self.audioPlayer.prepareToPlay()
    self.audioPlayer.play()
  }
  
}

