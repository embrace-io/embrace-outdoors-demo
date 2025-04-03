//
//  BackgroundCrashDemoViewController.swift
//  embrace-outdoors-ios
//
//  Created by Sergio Rodriguez on 3/4/25.
//

import EmbraceIO
import UIKit

class BackgroundCrashDemoViewController: UIViewController {
    
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Set up crash button
        let crashButton = UIButton(type: .system)
        crashButton.setTitle("Trigger Background Crash", for: .normal)
        crashButton.addTarget(self, action: #selector(triggerBackgroundCrash), for: .touchUpInside)
        crashButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        view.addSubview(crashButton)
    }
    
    @objc func triggerBackgroundCrash() {
        // Log breadcrumb
        Embrace.client?
                .add(event: .breadcrumb("User initiated background crash"))
        
        // Start background task
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            // If the background task expires, end it properly
            if let task = self?.backgroundTask, task != .invalid {
                UIApplication.shared.endBackgroundTask(task)
                self?.backgroundTask = .invalid
            }
        }
        
        // Add custom info to crash report
        try? Embrace.client?.appendCrashInfo(key: "crash_type", value: "background_crash")
        try? Embrace.client?.appendCrashInfo(key: "background_task_id", value: "\(backgroundTask.rawValue)")
        
        // Simulate app going to background
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Log that we're about to go to background
            Embrace.client?
                    .add(event: .breadcrumb("App moving to background"))
            
            // Simulate background processing
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
                // Log right before crash
                Embrace.client?
                        .add(event: .breadcrumb("About to crash in background"))
                
                // Cause a crash in the background
                let array: [String]? = nil
                let _ = array![0] // This will cause a crash
            }
        }
    }
    
    deinit {
        // End background task if it's still valid
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
} 