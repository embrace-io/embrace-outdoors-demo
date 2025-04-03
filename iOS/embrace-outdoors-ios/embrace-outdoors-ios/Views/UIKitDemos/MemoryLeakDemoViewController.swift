//
//  MemoryLeakDemoViewController.swift
//  embrace-outdoors-ios
//
//  Created by Sergio Rodriguez on 3/4/25.
//

import EmbraceIO
import UIKit

class MemoryLeakDemoViewController: UIViewController {
    
    // This array will hold strong references and cause memory growth
    private var leakyArray: [Data] = []
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Set up leak button
        let leakButton = UIButton(type: .system)
        leakButton.setTitle("Start Memory Leak", for: .normal)
        leakButton.addTarget(self, action: #selector(startMemoryLeak), for: .touchUpInside)
        leakButton.frame = CGRect(x: 100, y: 150, width: 200, height: 50)
        view.addSubview(leakButton)
        
        // Set up aggressive leak button
        let aggressiveLeakButton = UIButton(type: .system)
        aggressiveLeakButton.setTitle("Start Aggressive Leak", for: .normal)
        aggressiveLeakButton.addTarget(self, action: #selector(startAggressiveMemoryLeak), for: .touchUpInside)
        aggressiveLeakButton.frame = CGRect(x: 100, y: 225, width: 200, height: 50)
        view.addSubview(aggressiveLeakButton)
        
        // Set up stop button
        let stopButton = UIButton(type: .system)
        stopButton.setTitle("Stop Memory Leak", for: .normal)
        stopButton.addTarget(self, action: #selector(stopMemoryLeak), for: .touchUpInside)
        stopButton.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        view.addSubview(stopButton)
        
        // Set up simulate warning button
        let simulateButton = UIButton(type: .system)
        simulateButton.setTitle("Simulate Memory Warning", for: .normal)
        simulateButton.addTarget(self, action: #selector(simulateMemoryWarning), for: .touchUpInside)
        simulateButton.frame = CGRect(x: 100, y: 375, width: 200, height: 50)
        view.addSubview(simulateButton)
    }
    
    @objc func startMemoryLeak() {
        // Log breadcrumb
        Embrace.client?
                .add(event: .breadcrumb("User started memory leak simulation"))
        
        // Create a span to track the memory leak operation
        let span = Embrace.client?
            .buildSpan(name: "memory_leak_simulation", type: .performance)
            .startSpan()
        
        // Start a timer that allocates memory repeatedly
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Allocate 10MB of memory each time
            let dataSize = 10 * 1024 * 1024
            let data = Data(repeating: 0, count: dataSize)
            self.leakyArray.append(data)
            
            // Log the current memory usage
            Embrace.client?
                    .add(event: .breadcrumb("Memory allocated: \(self.leakyArray.count * dataSize) bytes"))
            
            // After allocating a significant amount of memory, the system will send a memory warning
            // which will be automatically captured by Embrace's LowMemoryWarningCaptureService
        }
        
        // End the span after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            span?.end()
        }
    }
    
    @objc func startAggressiveMemoryLeak() {
        // Log breadcrumb
        Embrace.client?
                .add(event: .breadcrumb("User started aggressive memory leak simulation"))
        
        // Create a span to track the memory leak operation
        let span = Embrace.client?
            .buildSpan(name: "aggressive_memory_leak_simulation", type: .performance)
            .startSpan()
        
        // Start a timer that allocates memory rapidly
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Allocate 50MB of memory each time - much more aggressive
            let dataSize = 50 * 1024 * 1024
            let data = Data(repeating: 0, count: dataSize)
            self.leakyArray.append(data)
            
            // Log the current memory usage
            Embrace.client?
                    .add(event: .breadcrumb("Memory allocated: \(self.leakyArray.count * dataSize) bytes"))
            
            // Force a memory warning after allocating 500MB
            if self.leakyArray.count % 10 == 0 {
                self.simulateMemoryWarning()
            }
        }
        
        // End the span after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            span?.end()
        }
    }
    
    @objc func stopMemoryLeak() {
        // Stop the timer
        timer?.invalidate()
        timer = nil
        
        // Clear the array to release memory
        leakyArray.removeAll()
        
        // Log breadcrumb
        Embrace.client?
                .add(event: .breadcrumb("User stopped memory leak simulation"))
    }
    
    @objc func simulateMemoryWarning() {
        // Log breadcrumb
        Embrace.client?
                .add(event: .breadcrumb("Simulating memory warning"))
        
        // Simulate a memory warning
        #if targetEnvironment(simulator)
        // This is a private API that works in the simulator to trigger a memory warning
        // Note: This should only be used for testing purposes
        let selector = NSSelectorFromString("_performMemoryWarning")
        UIApplication.shared.perform(selector)
        #else
        // For real devices, we can't directly trigger a memory warning
        // but we can notify Embrace that one occurred
        NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        #endif
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        leakyArray.removeAll()
    }
} 