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
//  var audioPlayer: AVAudioPlayer!
  var audioQueuePlayer: AVQueuePlayer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    configureAudioSession()
//    configureAudioPlayer()
    configureAudioQueuePlayer()
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
  
//  func configureAudioPlayer() {
//    
//    var songPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")
//    var songURL = NSURL.fileURLWithPath(songPath!)
//    
//    var songError: NSError?
//    self.audioPlayer = AVAudioPlayer(contentsOfURL: songURL, error: &songError)
//    println("song error: \(songError)")
//    self.audioPlayer.numberOfLoops = 0
//    
//  }
  
  // setup audio queue player
  func configureAudioQueuePlayer() {
    let songs = createSongs()
    audioQueuePlayer = AVQueuePlayer(items: songs)
    
    for var songIndex = 0; songIndex < songs.count; songIndex++ {
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "songEnded:", name: AVPlayerItemDidPlayToEndTimeNotification, object: songs[songIndex])
    }
    
  }
  
  func playMusic() {
//    self.audioPlayer.prepareToPlay()
//    self.audioPlayer.play()
    audioQueuePlayer.play()
  }
  
  func createSongs() -> [AnyObject] {
    let firstSongPath = NSBundle.mainBundle().pathForResource("CLASSICAL SOLITUDE", ofType: "wav")
    let secondSongPath = NSBundle.mainBundle().pathForResource("Timothy Pinkham - The Knolls of Doldesh", ofType: "mp3")
    let thirdSongPath = NSBundle.mainBundle().pathForResource("Open Source - Sending My Signal", ofType: "mp3")
    
    let firstSongURL = NSURL.fileURLWithPath(firstSongPath!)
    let secondSongURL = NSURL.fileURLWithPath(secondSongPath!)
    let thirdSongURL = NSURL.fileURLWithPath(thirdSongPath!)
    
    let firstPlayItem = AVPlayerItem(URL: firstSongURL)
    let secondPlayItem = AVPlayerItem(URL: secondSongURL)
    let thirdPlayItem = AVPlayerItem(URL: thirdSongURL)
    
    let songs: [AnyObject] = [firstPlayItem, secondPlayItem, thirdPlayItem]
    return songs
  }
  
}

