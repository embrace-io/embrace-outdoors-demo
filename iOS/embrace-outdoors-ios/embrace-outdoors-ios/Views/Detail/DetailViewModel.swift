//
//  DetailViewModel.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import Foundation
import EmbraceIO

@Observable
class DetailViewModel {
    private let park: ParkRequestResult.Park
    
    var parkDescription: String {
        park.parkDescription
    }
    
    var parkName: String {
        park.parkName
    }
    
    init(park: ParkRequestResult.Park) {
        self.park = park
    }
    
    func logViewAppeared() {
        Embrace.client?.log(
            "Detail View Model Appeared for \(park.parkName)",
            severity: .info
        )
    }
}
