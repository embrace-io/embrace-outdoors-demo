//
//  ContentView.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationSplitView {
            List {
                
                // Sample traces
                Section {
                    Button {
                        viewModel.buildNestedSpans()
                    } label: {
                        Text(viewModel.nestedTraceLabelText)
                    }
                    .accessibilityIdentifier("nested-traces-button")
                    
                    Button {
                        viewModel.buildSpanWithConcurrentNetworkRequest()
                    } label: {
                        Text(viewModel.traceWithRequestLabelText)
                    }
                    .accessibilityIdentifier("request-within-traces-button")
                    
                    Button {
                        viewModel.buildMockAuthSpans()
                    } label: {
                        Text(viewModel.mockAuthLabelText)
                    }
                    .accessibilityIdentifier("mock-auth-traces-button")
                    
                    Button {
                        viewModel.buildMockSearchSpans()
                    } label: {
                        Text(viewModel.mockSearchLabelText)
                    }
                    .accessibilityIdentifier("mock-search-traces-button")
                    
                    Button {
                        viewModel.buildMockCheckoutSpans()
                    } label: {
                        Text(viewModel.mockCheckoutLabelText)
                    }
                    .accessibilityIdentifier("mock-checkout-traces-button")
                    
                    Button {
                        viewModel.buildMockPermissionsSpans()
                    } label: {
                        Text(viewModel.mockPermissionsLabelText)
                    }
                    .accessibilityIdentifier("mock-permissions-traces-button")
                    
                    Button {
                        viewModel.buildMockMiddlewareNetworkingSpans()
                    } label: {
                        Text(viewModel.mockNetworkingMiddlewareLabelText)
                    }
                    .accessibilityIdentifier("mock-middleware-traces-button")
                    
                } header: {
                    Text(viewModel.tracesSectionHeaderText)
                }
                
                // Sampling of Embrace actions
                Section {
                    Picker(viewModel.pickerText, selection: $viewModel.selectedState) {
                        ForEach(
                            viewModel.pickerValues,
                            id:\.self
                        ) {
                            Text($0)
                        }
                    }
                    .accessibilityIdentifier("states-picker")
                    
                    Button {
                        viewModel.makeWorkingNetworkCall()
                    } label: {
                        Text(viewModel.parkRequestLabelText)
                    }
                    .accessibilityIdentifier("working-network-request-button")
                    
                    Button {
                        viewModel.makeMockEndpointCall()
                    } label: {
                        Text(viewModel.nsfRequestLabelText)
                    }
                    .accessibilityIdentifier("nsf-request-button")
                    
                    Button {
                        viewModel.makeForbiddenCall()
                    } label: {
                        Text(viewModel.unauthorizedRequestLabelText)
                    }
                    .accessibilityIdentifier("unauthorized-request-button")
                    
                    Button {
                        viewModel.makeTimeoutCall()
                    } label: {
                        Text(viewModel.timeoutRequestLabelText)
                    }
                    .accessibilityIdentifier("timeout-request-button")
                    
                    Button {
                        viewModel.forceEmbraceCrash()
                    } label: {
                        Text(viewModel.crashLabelText)
                    }
                    .accessibilityIdentifier("force-crash-button")
                    
                    Text(viewModel.versionAndBuildInfo)
                    
                } header: {
                    Text(viewModel.networkingSectionHeaderText)
                }
                
                // List of park items after request
                if viewModel.requestResultsExist {
                    Section {
                        ForEach(viewModel.parksFromResult, id: \.fullName ) { park in
                            NavigationLink {
                                DetailView(park: park)
                            } label: {
                                Text(park.parkName)
                            }
                            .accessibilityIdentifier("listitem-\(park.parkName)-button")
                        }
                    } header: {
                        Text(viewModel.resultSectionHeaderText)
                    }
                    .accessibilityIdentifier("networking-results-list-section")
                }
            }
            .navigationTitle(Text(viewModel.titleText))
            .accessibilityIdentifier("main-list-view")
        } detail: {}
            .onAppear {
                self.viewModel.logViewAppeared()
                self.viewModel.logRandomAction()
            }
    }
}

#Preview {
    MainView()
}
