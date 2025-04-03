//
//  NetworkErrorDemoViewController.swift
//  embrace-outdoors-ios
//
//  Created by Sergio Rodriguez on 3/4/25.
//

import EmbraceIO
import UIKit

class NetworkErrorDemoViewController: UIViewController {
    
    private var retryCount = 0
    private let maxRetries = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Set up network error button
        let networkButton = UIButton(type: .system)
        networkButton.setTitle("Trigger Network Error", for: .normal)
        networkButton.addTarget(self, action: #selector(triggerNetworkError), for: .touchUpInside)
        networkButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        view.addSubview(networkButton)
    }
    
    @objc func triggerNetworkError() {
        // Log breadcrumb
        Embrace.client?
                .add(event: .breadcrumb("User initiated network error test"))
        
        // Reset retry count
        retryCount = 0
        
        // Make a network request to a non-existent endpoint
        makeNetworkRequest()
    }
    
    private func makeNetworkRequest() {
        // Create a URL that will fail
        guard let url = URL(string: "https://nonexistent-domain-that-will-fail.example") else {
            return
        }
        
        // Log breadcrumb for the request attempt
        Embrace.client?
                .add(event: .breadcrumb("Attempting network request (attempt \(retryCount + 1))"))
        
        // Create a span to track the network request
        let span = Embrace.client?
            .buildSpan(name: "failing_network_request", type: .networkRequest)
            .setAttribute(key: "retry_count", value: "\(retryCount)")
            .setAttribute(key: "url", value: url.absoluteString)
            .startSpan()
        
        // Create and execute the request
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            // Handle the error
            if let error = error {
                // Log the error
                Embrace.client?
                        .add(event: .breadcrumb("Network error: \(error.localizedDescription)"))
                
                // End the span with error information
                span?.setAttribute(key: "error_description", value: error.localizedDescription)
                span?.end(errorCode: .failure)
                
                // Retry the request if we haven't reached the maximum retries
                if self.retryCount < self.maxRetries {
                    self.retryCount += 1
                    
                    // Log retry attempt
                    Embrace.client?
                            .add(event: .breadcrumb("Retrying network request (attempt \(self.retryCount + 1))"))
                    
                    // Retry after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.makeNetworkRequest()
                    }
                } else {
                    // Log that we've reached maximum retries
                    Embrace.client?
                            .add(event: .breadcrumb("Maximum retries reached, giving up"))
                }
            } else {
                // This won't execute since the request will fail, but included for completeness
                span?.end()
            }
        }
        
        // Start the network request
        task.resume()
    }
} 