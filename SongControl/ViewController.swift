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
  
  var currentSongIndex:Int!
  
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
    if currentSongIndex > 0 {
      self.audioQueuePlayer.pause()
      self.audioQueuePlayer.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
      let temporaryNowPlayIndex = currentSongIndex
      let temporaryPlayList = self.createSongs()
      self.audioQueuePlayer.removeAllItems()
      for var index = temporaryNowPlayIndex - 1; index < temporaryPlayList.count; index++ {
        self.audioQueuePlayer.insertItem(temporaryPlayList[index] as! AVPlayerItem, afterItem: nil)
      }
      self.currentSongIndex = temporaryNowPlayIndex - 1
      self.audioQueuePlayer.seekToTime(kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
      self.audioQueuePlayer.play()
    }
  }
  
  @IBAction func nextButtonPressed(sender: UIButton) {
    audioQueuePlayer.advanceToNextItem()
    // increment the song index so we know which song we are on
    currentSongIndex = currentSongIndex + 1
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
//    audioQueuePlayer.play()
//    // this means we play first song
    if audioQueuePlayer.rate > 0 && audioQueuePlayer.error == nil {
      self.audioQueuePlayer.pause()
    } else if currentSongIndex == nil {
      self.audioQueuePlayer.play()
      self.currentSongIndex = 0
    } else {
      self.audioQueuePlayer.play()
    }
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
  
  // MARK: - Audio Notification
  
  func songEnded(notification: NSNotification) {
    // increment song to make sure we are keeping track of where we are in the music queue
    currentSongIndex = currentSongIndex + 1
  }
  
  // MARK: - UIUpdate Helpers
  
  func currentSongName() -> String {
    var currentSong: String
    if currentSongIndex == 0 {
      currentSong = "Classical Solitude"
    }else if currentSongIndex == 1 {
      currentSong = "The Knolls of Doldesh"
    }
    else if currentSongIndex == 2 {
      currentSong = "Sending my Signal"
    }
    else {
      currentSong = "No Song Playing"
      println("Something went wrong!")
    }
    return currentSong
  }
  
}

