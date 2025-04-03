//
//  UIKitDemosWrappers.swift
//  embrace-outdoors-ios
//
//  Created by Sergio Rodriguez on 4/3/25.
//

import SwiftUI
import UIKit
import EmbraceIO

// Wrapper for CrashDemoViewController
struct CrashDemoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CrashDemoViewController {
        return CrashDemoViewController()
    }
    
    func updateUIViewController(_ uiViewController: CrashDemoViewController, context: Context) {
        // Nothing to update
    }
}

// Wrapper for BackgroundCrashDemoViewController
struct BackgroundCrashDemoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BackgroundCrashDemoViewController {
        return BackgroundCrashDemoViewController()
    }
    
    func updateUIViewController(_ uiViewController: BackgroundCrashDemoViewController, context: Context) {
        // Nothing to update
    }
}

// Wrapper for MemoryLeakDemoViewController
struct MemoryLeakDemoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MemoryLeakDemoViewController {
        return MemoryLeakDemoViewController()
    }
    
    func updateUIViewController(_ uiViewController: MemoryLeakDemoViewController, context: Context) {
        // Nothing to update
    }
}

// Wrapper for NetworkErrorDemoViewController
struct NetworkErrorDemoView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> NetworkErrorDemoViewController {
        return NetworkErrorDemoViewController()
    }
    
    func updateUIViewController(_ uiViewController: NetworkErrorDemoViewController, context: Context) {
        // Nothing to update
    }
} 