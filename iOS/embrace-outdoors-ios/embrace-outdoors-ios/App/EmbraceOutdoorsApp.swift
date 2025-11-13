//
//  embrace_outdoors_iosApp.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import SwiftUI
import EmbraceIO

@main
struct EmbraceOutdoorsApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    init() {
        do {
            try Embrace.setup(
                options: Embrace.Options(
                    appId: "00000",
                    platform: .default,
                    export: nil
                )
            )
            .start()
            
            try? Embrace.client?.metadata.addProperty(
                key: "AB: Checkout Flow",
                value: Int.random(in: 0...10) < 8 ? "Control" : "Experiment",
                lifespan: .session
            )
           
            try? Embrace.client?.metadata.addProperty(
                key: "AB: Login Flow",
                value: Int.random(in: 0...10) < 9 ? "Control" : "Experiment",
                lifespan: .session
            )
           
            try? Embrace.client?.metadata.addProperty(
                key: "Migration: Checkout API",
                value: Int.random(in: 0...10) < 8 ? "v1" : "v2",
                lifespan: .permanent
            )
           
            try? Embrace.client?
                .metadata.add(
                    persona: Int.random(in: 0...10) < 8 ? "Trial" : "Paid"
                )
            
        } catch let e {
            print("Couldn't initialize Embrace SDK: \(e.localizedDescription)")
        }
    }
}
