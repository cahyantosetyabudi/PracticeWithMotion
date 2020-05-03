//
//  ViewController.swift
//  PracticeWithCoreMotion
//
//  Created by Cahyanto Setya Budi on 03/05/20.
//  Copyright © 2020 Cahyanto Setya Budi. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let motion = MotionDetector()
        motion.start()
    }
}

final class MotionDetector {
    private let motionManager = CMMotionManager()
    private let opQueue: OperationQueue = {
        let o = OperationQueue()
        o.name = "core-motion-updates"
        return o
    }()

    private var shouldRestartMotionUpdates = false

    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }

    func start() {
        self.shouldRestartMotionUpdates = true
        self.restartMotionUpdates()
    }

    func stop() {
        self.shouldRestartMotionUpdates = false
        self.motionManager.stopDeviceMotionUpdates()
    }

    @objc private func appDidEnterBackground() {
        self.restartMotionUpdates()
    }

    @objc private func appDidBecomeActive() {
        self.restartMotionUpdates()
    }

    private func restartMotionUpdates() {
        guard self.shouldRestartMotionUpdates else { return }
        
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.startgyr
        self.motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: self.opQueue) { (data, error) in
            guard let data = data else { return }
            print(data)
        }
    }
}
