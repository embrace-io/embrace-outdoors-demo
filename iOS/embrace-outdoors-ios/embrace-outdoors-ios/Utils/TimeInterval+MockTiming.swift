//
//  TimeInterval+MockTiming.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import Foundation

// random numbers for variable trace timing. returns millisecond intervals
extension TimeInterval {
        
    static var mockShortTimeInterval: Double {
        Double.random(in: 0.001...0.1)
    }
    
    static var mockMediumTimeInterval: Double {
        Double.random(in: 0.1...0.25)
    }
    
    static var mockLongTimeInterval: Double {
        Double.random(in: 0.26...1.00)
    }
    
    static var variableTimeInterval: Double {
        Double.random(in: 1.0...8.0) * Self.mockLongTimeInterval
    }
}
