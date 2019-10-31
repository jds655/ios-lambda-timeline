//
//  AudioPostViewController.swift
//  LambdaTimeline
//
//  Created by Joshua Sharp on 10/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AudioPostViewController: UIViewController {
    
    private enum Status: String {
        case waiting = "Press Record Above"
        case recording = "Recording, press again to stop"
        case saving = "Please wait while saving"
        case playing = "Playing back now"
        case done = "Save recording?"
    }
    
    var post: Post?
    var postController: PostController?
    var recorder: Recorder?
    var player: Player?
    private var status: AudioPostViewController.Status = .waiting
    private lazy var timeFormatter: DateComponentsFormatter = {
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter not good for milliseconds, use DateFormatter instead)
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()

    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        recorder = Recorder()
        player = Player()
        super.init(coder: aDecoder)
        recorder?.delegate = self
        player?.delegate = self
        status = .waiting
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    private func updateViews() {
        statusLabel.text = status.rawValue
        
        switch status {
        case .recording:
            guard let recorder = recorder else { return }
            recordTimeLabel.text = timeFormatter.string(from: recorder.duration)
            break
        case .saving:
            break
        case .waiting:
            break
        case .playing:
            guard let player = player else { return }
            recordTimeLabel.text = timeFormatter.string(from: player.timeRemaining)
        case .done:
            break
        }
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        guard let recorder = recorder else { return }
        recorder.toggleRecording()
        switch recorder.isRecording {
        case true:
            status = .recording
        case false:
            status = .saving
        }
        updateViews()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if status == .playing || status == .done {
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        status = .waiting
        self.dismiss(animated: true, completion: nil)
    }
}

extension AudioPostViewController: PlayerDelegate {
    func playDidChangeState(player: Player) {
        updateViews()
    }
}

extension AudioPostViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
    }
    
    func recorderDidSaveFile(recorder: Recorder) {
        status = .playing
        updateViews()
        if let url = recorder.fileURL, recorder.isRecording == false {
            //Play the recording
            let player = Player(url: url)
            player.delegate = self
            player.play()
            status = .waiting
        }
    }
}
