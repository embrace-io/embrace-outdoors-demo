//
//  DetailView.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import SwiftUI

struct DetailView: View {
    @State var viewModel: DetailViewModel
    
    init (park: ParkRequestResult.Park) {
        self.viewModel = DetailViewModel(park: park)
    }
    
    var body: some View {
        VStack {
            Text(viewModel.parkDescription)
        }
        .navigationTitle(viewModel.parkName)
        .onAppear {
            self.viewModel.logViewAppeared()
        }
    }
    
}
