import EmbraceIO
import UIKit

// Mock implementation of EmbracePayloadManager since it doesn't exist in the project
class EmbracePayloadManager {
    static let shared = EmbracePayloadManager()
    
    func shareMostRecentCrashPayload(from viewController: UIViewController, sourceView: UIView) {
        let alert = UIAlertController(
            title: "Mock Payload Manager",
            message: "This would share the most recent crash payload in a real implementation.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    func clearAllPayloads() -> Bool {
        // Return true to simulate success
        return true
    }
}

class CrashDemoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var crashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Trigger Crash", for: .normal)
        button.addTarget(self, action: #selector(triggerCrash), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var sharePayloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share Last Crash Payload", for: .normal)
        button.addTarget(self, action: #selector(shareLastCrashPayload), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var clearPayloadsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear All Payloads", for: .normal)
        button.addTarget(self, action: #selector(clearAllPayloads), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        Embrace.client?
                .add(event: .breadcrumb("Sergio Was here"))
        
        // Add custom information to the crash report
        try? Embrace.client?.appendCrashInfo(key: "current_screen", value: "CrashDemoViewController")
        try? Embrace.client?.appendCrashInfo(key: "user_action", value: "Viewing crash demo screen")
        
        // Add a breadcrumb to track user journey
        Embrace.client?
                .add(event: .breadcrumb("User navigated to crash demo screen"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Log breadcrumb for user journey tracking
        Embrace.client?
                .add(event: .breadcrumb("Crash demo screen appeared"))
        
        // Create a custom span to track user activity
        let span = Embrace.client?
            .buildSpan(name: "viewing_crash_demo", type: .ux)
            .startSpan()
        
        // End the span after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            span?.end()
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(crashButton)
        view.addSubview(sharePayloadButton)
        view.addSubview(clearPayloadsButton)
        
        NSLayoutConstraint.activate([
            crashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crashButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            crashButton.widthAnchor.constraint(equalToConstant: 200),
            crashButton.heightAnchor.constraint(equalToConstant: 50),
            
            sharePayloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharePayloadButton.topAnchor.constraint(equalTo: crashButton.bottomAnchor, constant: 20),
            sharePayloadButton.widthAnchor.constraint(equalToConstant: 250),
            sharePayloadButton.heightAnchor.constraint(equalToConstant: 50),
            
            clearPayloadsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearPayloadsButton.topAnchor.constraint(equalTo: sharePayloadButton.bottomAnchor, constant: 20),
            clearPayloadsButton.widthAnchor.constraint(equalToConstant: 200),
            clearPayloadsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc func triggerCrash() {
        // Log breadcrumb right before crash
        Embrace.client?
                .add(event: .breadcrumb("User tapped crash button"))
        
        // Force unwrap a nil value to cause a crash
        let array: [String]? = nil
        let _ = array![0] // This will cause a crash
    }
    
    @objc func shareLastCrashPayload() {
        Embrace.client?.add(event: .breadcrumb("User tapped share crash payload button"))
        EmbracePayloadManager.shared.shareMostRecentCrashPayload(from: self, sourceView: sharePayloadButton)
    }
    
    @objc func clearAllPayloads() {
        Embrace.client?.add(event: .breadcrumb("User tapped clear payloads button"))
        if EmbracePayloadManager.shared.clearAllPayloads() {
            let alert = UIAlertController(
                title: "Success",
                message: "All payloads have been cleared.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Error",
                message: "Failed to clear payloads.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
} 