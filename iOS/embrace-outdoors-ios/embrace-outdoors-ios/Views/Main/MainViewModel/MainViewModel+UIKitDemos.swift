//
//  MainViewModel+UIKitDemos.swift
//  embrace-outdoors-ios
//
//  Created by Sergio Rodriguez on 4/3/25.
//

import UIKit
import SwiftUI

extension MainViewModel {
    
    // MARK: - UIKit Demo Functions
    
    func presentCrashDemo(from viewController: UIViewController) {
        let crashDemoVC = CrashDemoViewController()
        viewController.present(crashDemoVC, animated: true)
    }
    
    func presentBackgroundCrashDemo(from viewController: UIViewController) {
        let backgroundCrashDemoVC = BackgroundCrashDemoViewController()
        viewController.present(backgroundCrashDemoVC, animated: true)
    }
    
    func presentMemoryLeakDemo(from viewController: UIViewController) {
        let memoryLeakDemoVC = MemoryLeakDemoViewController()
        viewController.present(memoryLeakDemoVC, animated: true)
    }
    
    func presentNetworkErrorDemo(from viewController: UIViewController) {
        let networkErrorDemoVC = NetworkErrorDemoViewController()
        viewController.present(networkErrorDemoVC, animated: true)
    }
} 