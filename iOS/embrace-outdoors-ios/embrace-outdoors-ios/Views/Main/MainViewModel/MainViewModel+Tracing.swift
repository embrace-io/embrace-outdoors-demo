//
//  MainViewModel+Tracing.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import Foundation
import EmbraceIO

extension MainViewModel {
    //MARK: Tracing Actions
    
    func buildNestedSpans() {
        //this trace has a series of nested spans that form a tree-like structure
        
        guard let client = Embrace.client else {return}
        
        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning nested flow", properties: ["startTime" : parentStartTime.description]))
        
        let traceRootSpan = client
            .buildSpan(
                name: "Live Updates Trace",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        let loadingStartTime = parentStartTime.advanced(by: .variableTimeInterval)
        let loadingScreenSpan = client
            .buildSpan(
                name: "Show Loading screen",
                type: .performance
            )
            .setStartTime(time: loadingStartTime)
            .setParent(traceRootSpan)
            .startSpan()
        
        let loadingEndTime = loadingStartTime.advanced(by: .mockMediumTimeInterval)
        loadingScreenSpan.end(time: loadingEndTime)
        
        let openWebSocketStartTime = loadingStartTime.advanced(by: .mockShortTimeInterval)
        let websocketSpan = client
            .buildSpan(
                name: "Open Websocket",
                attributes: ["service-type" : "websocket"]
            )
            .setStartTime(time: openWebSocketStartTime)
            .setParent(traceRootSpan)
            .startSpan()
        
        let receiveStreamingInfoStartTime = openWebSocketStartTime.advanced(by: .mockShortTimeInterval)
        let receivingWebsocketInfoSpan = client
            .buildSpan(name: "Receive Streaming Information")
            .setStartTime(time: receiveStreamingInfoStartTime)
            .setParent(websocketSpan)
            .startSpan()
        
        let updateUIStartTime = receiveStreamingInfoStartTime.advanced(by: .mockShortTimeInterval)
        let updatingUISpan = client
            .buildSpan(
                name: "Update UI",
                type: .ux
            )
            .setStartTime(time: updateUIStartTime)
            .setParent(traceRootSpan)
            .startSpan()
        
        receivingWebsocketInfoSpan.addEvent(
            name: "Received streamed data",
            attributes: ["data-batch" : .int(1)],
            timestamp: receiveStreamingInfoStartTime.advanced(by: .mockShortTimeInterval)
        )
        
        receivingWebsocketInfoSpan.addEvent(
            name: "Received streamed data",
            attributes: ["data-batch" : .int(2)],
            timestamp: receiveStreamingInfoStartTime.advanced(by: .mockShortTimeInterval)
        )
        
        let streamingDataCloseNoticeTime = receiveStreamingInfoStartTime.advanced(by: .mockMediumTimeInterval)
        websocketSpan.addEvent(
            name: "Received close notice",
            timestamp: streamingDataCloseNoticeTime
        )
        
        receivingWebsocketInfoSpan.end(time: streamingDataCloseNoticeTime)
        websocketSpan.end(time: streamingDataCloseNoticeTime)
        
        let updateUIEndTime = streamingDataCloseNoticeTime.advanced(by: .mockShortTimeInterval)
        updatingUISpan.end(time: updateUIEndTime)
        traceRootSpan.end(time: updateUIEndTime)
    }
    
    func buildSpanWithConcurrentNetworkRequest() {
        // this trace has a network request that occurs during its duration
        // it adds a spanevent when a network call is made
        
        guard let client = Embrace.client else {return}
        
        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning concurrent request flow", properties: ["startTime" : parentStartTime.description]))

        let traceRootSpan = client
            .buildSpan(
                name: "Concurrent Network Request Trace",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        for _ in 1...3 {
            traceRootSpan.addEvent(name: "making async network call")
            self.makeWorkingNetworkCall()
            
            sleep(1)
        }
        
        traceRootSpan.end()
        
    }
    
    func buildMockMiddlewareNetworkingSpans() {
        guard let client = Embrace.client else {return}
                        
        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning middleware flow", properties: ["startTime" : parentStartTime.description]))
        
        let traceRootSpan = client
            .buildSpan(
                name: "Network Request",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        let middlewareParentTime = parentStartTime.advanced(by: .mockMediumTimeInterval)
        let middlewareParentSpan = client
            .buildSpan(name: "Middleware/Intercept Network Request")
            .setStartTime(time: middlewareParentTime)
            .setParent(traceRootSpan)
            .startSpan()
        
        let middlewareValidateRequestBodyTime = middlewareParentTime.advanced(by: .variableTimeInterval)
        let middlewareValidateRequestBodySpan = client
            .buildSpan(name: "Middleware/Validate Request Body")
            .setStartTime(time: middlewareValidateRequestBodyTime)
            .setParent(middlewareParentSpan)
            .startSpan()
        
        let middlewareRemovePIISpan = client
            .buildSpan(name: "Middleware/Remove Sensitive Request Body Info")
            .setStartTime(time: middlewareValidateRequestBodyTime)
            .setParent(middlewareValidateRequestBodySpan)
            .startSpan()
        
        let middlewareValidateRequestBodyEndTime = middlewareValidateRequestBodyTime.advanced(by: .mockShortTimeInterval)
        middlewareRemovePIISpan.end(time: middlewareValidateRequestBodyEndTime)

        
        let middlewareCompressSpan = client
            .buildSpan(name: "Middleware/Compress Request Body")
            .setStartTime(time: middlewareValidateRequestBodyEndTime)
            .setParent(middlewareValidateRequestBodySpan)
            .startSpan()
        
        let middlewareCompressEndSpan = middlewareValidateRequestBodyEndTime.advanced(by: .mockShortTimeInterval)
        middlewareCompressSpan.end(time: middlewareCompressEndSpan)
        middlewareValidateRequestBodySpan.end(time: middlewareCompressEndSpan)
        
        let addRequestHeadersSpan = client
            .buildSpan(name: "Middleware/Add Request Headers")
            .setStartTime(time: middlewareCompressEndSpan.advanced(by: -.mockShortTimeInterval))
            .setParent(middlewareParentSpan)
            .startSpan()
        
        addRequestHeadersSpan.end(time: middlewareCompressEndSpan.advanced(by: .mockShortTimeInterval))

        let validateRequestURLSpan = client
            .buildSpan(name: "Middleware/Validate Request URL")
            .setStartTime(time: middlewareCompressEndSpan.advanced(by: -.mockShortTimeInterval))
            .setParent(middlewareParentSpan)
            .startSpan()
        
        validateRequestURLSpan.end(time: middlewareCompressEndSpan.advanced(by: .mockShortTimeInterval))
        
        let endTime = middlewareCompressEndSpan.advanced(by: .mockMediumTimeInterval)
        middlewareParentSpan.end(time: endTime)
        traceRootSpan.end(time: endTime)
    }
    
    func buildMockCheckoutSpans() {
        guard let client = Embrace.client else {return}
        
        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning checkout flow", properties: ["startTime" : parentStartTime.description]))
        
        let traceRootSpan = client
            .buildSpan(
                name: "Enter Checkout Flow",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        let navigateCheckoutInitialTime = parentStartTime.advanced(by: .mockShortTimeInterval)
        let navigateCheckoutInitialSpan = client
            .buildSpan(name: "UI/Navigate to Checkout Initial Screen")
            .setParent(traceRootSpan)
            .setStartTime(time: navigateCheckoutInitialTime)
            .startSpan()
        
        let confirmInventoryRequestTime = navigateCheckoutInitialTime.advanced(by: .variableTimeInterval)
        let confirmInventoryRequestSpan = client
            .buildSpan(name: "Network/Confirm Inventory Request")
            .setParent(navigateCheckoutInitialSpan)
            .setStartTime(time: confirmInventoryRequestTime)
            .startSpan()
        
        let confirmCustomerAddresssTime = navigateCheckoutInitialTime.advanced(by: .mockShortTimeInterval)
        let confirmCustomerAddresssSpan = client
            .buildSpan(name: "UI/Confirm Customer Address")
            .setParent(navigateCheckoutInitialSpan)
            .setStartTime(time: confirmCustomerAddresssTime)
            .startSpan()
        
        let inventoryRequestEndTime = confirmInventoryRequestTime.advanced(by: .variableTimeInterval)
        
        confirmInventoryRequestSpan.end(time: inventoryRequestEndTime.advanced(by: .mockShortTimeInterval))
        confirmCustomerAddresssSpan.end(time: inventoryRequestEndTime.advanced(by: .mockMediumTimeInterval))
        
        confirmCustomerAddresssSpan.end(time: inventoryRequestEndTime.advanced(by: .mockLongTimeInterval))
        navigateCheckoutInitialSpan.end(time: inventoryRequestEndTime.advanced(by: .mockLongTimeInterval))
        
        let navigateCheckoutPaymentTime = inventoryRequestEndTime.advanced(by: .mockShortTimeInterval)
        let navigateCheckoutPaymentSpan = client
            .buildSpan(name: "UI/Navigate to Checkout Payment Screen")
            .setParent(traceRootSpan)
            .setStartTime(time: navigateCheckoutPaymentTime)
            .startSpan()
        
        let makeFirstPaymentRequestTime = navigateCheckoutPaymentTime.advanced(by: .mockShortTimeInterval)
        let makeFirstPaymentRequestSpan = client
            .buildSpan(name: "Network/Make Payment Request")
            .setParent(navigateCheckoutPaymentSpan)
            .setStartTime(time: navigateCheckoutPaymentTime)
            .startSpan()
        
        let firstPaymentRequestEndTime = makeFirstPaymentRequestTime.advanced(by: .mockMediumTimeInterval)
        makeFirstPaymentRequestSpan.end(errorCode: .failure, time: firstPaymentRequestEndTime)
        
        let updateCCTime = firstPaymentRequestEndTime.advanced(by: .mockShortTimeInterval)
        let updateCCSpan = client
            .buildSpan(name: "UI/Update Credit Card")
            .setParent(navigateCheckoutPaymentSpan)
            .setStartTime(time: updateCCTime)
            .startSpan()
        
        let updateCCEndTime = updateCCTime.advanced(by: .mockMediumTimeInterval)
        updateCCSpan.end(time: updateCCEndTime)
        
        let makeSecondPaymentRequestTime = updateCCEndTime.advanced(by: .mockShortTimeInterval)
        let makeSecondPaymentRequestSpan = client
            .buildSpan(name: "Network/Make Payment Request")
            .setParent(navigateCheckoutPaymentSpan)
            .setStartTime(time: makeSecondPaymentRequestTime)
            .startSpan()
        
        let endTime = makeSecondPaymentRequestTime.advanced(by: .mockMediumTimeInterval)
        makeSecondPaymentRequestSpan.end(time: endTime)
        navigateCheckoutPaymentSpan.end(time: endTime)
                
        traceRootSpan.end(time: endTime.advanced(by: .mockShortTimeInterval))
    }
    
    func buildMockPermissionsSpans() {
        guard let client = Embrace.client else {return}
        
        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning permissions flow", properties: ["startTime" : parentStartTime.description]))

        let traceRootSpan = client
            .buildSpan(
                name: "Browse Local Restaurants",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        let fetchLocationPermissionTime = parentStartTime.advanced(by: .mockShortTimeInterval)
        let fetchLocationPermissionSpan = client
            .buildSpan(name: "Permissions/Fetch Location Permissions")
            .setParent(traceRootSpan)
            .setStartTime(time: fetchLocationPermissionTime)
            .startSpan()
        
        let fetchLocationPermissionEndTime = fetchLocationPermissionTime.advanced(by: .mockShortTimeInterval)
        fetchLocationPermissionSpan.end(time: fetchLocationPermissionEndTime)
        
        let askForLocationPermissionSpan = client
            .buildSpan(name: "Permission/Ask for Location Permission")
            .setParent(traceRootSpan)
            .setStartTime(time: fetchLocationPermissionEndTime)
            .startSpan()

        let showLocationModalTime = fetchLocationPermissionEndTime.advanced(by: .mockShortTimeInterval)
        let showLocationModalSpan = client
            .buildSpan(name: "UI/Show Ask for Location Modal")
            .setParent(askForLocationPermissionSpan)
            .setStartTime(time: showLocationModalTime)
            .startSpan()
        
        let showLocationModalEndTime = showLocationModalTime.advanced(by: .variableTimeInterval)
        showLocationModalSpan.end(time: showLocationModalEndTime)
        askForLocationPermissionSpan.end(time: showLocationModalEndTime)
        
        let getUserLocationTime = showLocationModalEndTime.advanced(by: .mockShortTimeInterval)
        let getUserLocationSpan = client
            .buildSpan(name: "Location/Get User Location")
            .setParent(traceRootSpan)
            .setStartTime(time: showLocationModalTime)
            .startSpan()
        
        let getUserLocationEndTime = getUserLocationTime.advanced(by: .mockMediumTimeInterval)
        getUserLocationSpan.end(time: getUserLocationEndTime)
        
        let networkRequestSpan = client
            .buildSpan(name: "Network/Request Restaurants by Location")
            .setParent(traceRootSpan)
            .setStartTime(time: getUserLocationEndTime)
            .startSpan()
        
        networkRequestSpan.end(time: getUserLocationEndTime.advanced(by: .mockMediumTimeInterval))
        
        let uxFakeTime = getUserLocationEndTime.advanced(by: .mockLongTimeInterval)
        let uxFakeSpan = client
            .buildSpan(name: "UX/...")
            .setParent(traceRootSpan)
            .setStartTime(time: uxFakeTime)
            .startSpan()
        
        uxFakeSpan.end(time: uxFakeTime.advanced(by: .mockShortTimeInterval))
        traceRootSpan.end(time: uxFakeTime.advanced(by: .mockMediumTimeInterval))
    }
    
    func buildMockAuthSpans() {
        guard let client = Embrace.client else {return}

        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning auth flow", properties: ["startTime" : parentStartTime.description]))
        
        let traceRootSpan = client
            .buildSpan(
                name: "Attempt Login",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        let checkCredentialCacheTime = parentStartTime.advanced(by: .mockShortTimeInterval)
        let checkCredentialCacheSpan = client
            .buildSpan(name: "LocalMem/Retrieve Credential Cache")
            .setParent(traceRootSpan)
            .setStartTime(time: checkCredentialCacheTime)
            .startSpan()
        
        let checkCredentialExpiryTime = checkCredentialCacheTime.advanced(by: .mockShortTimeInterval)
        let checkCredentialExpirySpan = client
            .buildSpan(name: "LocalMem/Check Credential Expiry")
            .setParent(checkCredentialCacheSpan)
            .setStartTime(time: checkCredentialExpiryTime)
            .startSpan()
        
        let useBioMetricsTime = checkCredentialExpiryTime.advanced(by: .mockShortTimeInterval)
        checkCredentialExpirySpan.end(time: useBioMetricsTime)
        checkCredentialCacheSpan.end(time: useBioMetricsTime)
        
        let useBioMetricsSpan = client
            .buildSpan(name: "System/Use Biometrics")
            .setParent(traceRootSpan)
            .setStartTime(time: useBioMetricsTime)
            .startSpan()

        let navigateToLoginTime = useBioMetricsTime.advanced(by: .mockMediumTimeInterval)
        useBioMetricsSpan.end(time: navigateToLoginTime)
        
        let navigateToLoginSpan = client
            .buildSpan(name: "UI/Navigate to Login Screen")
            .setParent(traceRootSpan)
            .setStartTime(time: navigateToLoginTime)
            .startSpan()
        
        let enterUserNameTime = navigateToLoginTime.advanced(by: .mockMediumTimeInterval)
        let enterUserNameSpan = client
            .buildSpan(name: "UI/Enter Username")
            .setParent(navigateToLoginSpan)
            .setStartTime(time: enterUserNameTime)
            .startSpan()

        let enterPasswordTime = enterUserNameTime.advanced(by: .mockMediumTimeInterval)
        enterUserNameSpan.end(time: enterPasswordTime)
        
        let enterPasswordSpan = client
            .buildSpan(name: "UI/Enter Password")
            .setParent(navigateToLoginSpan)
            .setStartTime(time: enterPasswordTime)
            .startSpan()
        
        let tapLoginTime = enterPasswordTime.advanced(by: .mockShortTimeInterval)
        enterPasswordSpan.end(time: tapLoginTime)
        
        let tapLoginSpan = client
            .buildSpan(name: "UI/Tap Login")
            .setParent(navigateToLoginSpan)
            .setStartTime(time: tapLoginTime)
            .startSpan()
        tapLoginSpan.end(time: tapLoginTime.advanced(by: .mockShortTimeInterval))
        navigateToLoginSpan.end(time: tapLoginTime.advanced(by: .mockShortTimeInterval))
        
        let sendLoginRequestSpan = client
            .buildSpan(name: "Network/Send Login Request")
            .setParent(traceRootSpan)
            .setStartTime(time: tapLoginTime)
            .startSpan()
        
        let loginRequestEndTime = tapLoginTime.advanced(by: .variableTimeInterval)
        sendLoginRequestSpan.end(time: loginRequestEndTime)
        
        let navigateToTwoFactorSpan = client
            .buildSpan(name: "UI/Navigate to Two-Factor")
            .setParent(traceRootSpan)
            .setStartTime(time: loginRequestEndTime)
            .startSpan()
        let sendTwoFactorTime = loginRequestEndTime.advanced(by: .mockShortTimeInterval)
        navigateToTwoFactorSpan.end(time: sendTwoFactorTime)
        
        let sendTwoFactorSpan = client
            .buildSpan(name: "Network/Send Two-Factor")
            .setParent(navigateToTwoFactorSpan)
            .setStartTime(time: sendTwoFactorTime)
            .startSpan()
        
        let endTime = sendTwoFactorTime.advanced(by: .variableTimeInterval)
        sendTwoFactorSpan.end(time: endTime)
        traceRootSpan.end(time: endTime)
    }
    
    func buildMockSearchSpans() {
        guard let client = Embrace.client else {return}
        
        let parentStartTime = Date.now
        client.add(event: .breadcrumb("beginning search flow", properties: ["startTime" : parentStartTime.description]))
        
        let traceRootSpan = client
            .buildSpan(
                name: "Enter Search",
                type: .ux
            )
            .setStartTime(time: parentStartTime)
            .startSpan()
        
        let boxAppearsTime = parentStartTime.advanced(by: .mockShortTimeInterval)
        let boxAppearsSpan = client
            .buildSpan(name: "UI/Search Box Appears")
            .setParent(traceRootSpan)
            .setStartTime(time: boxAppearsTime)
            .startSpan()
        
        let firstTextTime = boxAppearsTime.advanced(by: .mockShortTimeInterval)
        let firstTextSpan = client
            .buildSpan(name: "UI/Search Text Entered")
            .setParent(traceRootSpan)
            .setStartTime(time: firstTextTime)
            .startSpan()
        
        let firstRequestMadeTime = firstTextTime.advanced(by: .mockShortTimeInterval)
        let firstRequestMadeSpan = client
            .buildSpan(name: "Network/Search Text Request")
            .setParent(firstTextSpan)
            .setStartTime(time: firstRequestMadeTime)
            .startSpan()
        
        let firstRequestMadeEndTime = firstRequestMadeTime.advanced(by: .variableTimeInterval)

        let cachedTime = firstRequestMadeEndTime
        let cachedSpan = client
            .buildSpan(name: "LocalMem/Search Response Cached")
            .setParent(firstTextSpan)
            .setStartTime(time: cachedTime)
            .startSpan()
        
        let secondTextTime = firstTextTime.advanced(by: .mockShortTimeInterval)
        let secondTextSpan = client
            .buildSpan(name: "UI/Search Text Changed")
            .setParent(traceRootSpan)
            .setStartTime(time: secondTextTime)
            .startSpan()
        
        let secondRequestMadeSpan = client
            .buildSpan(name: "Network/Search Text Request Made")
            .setParent(secondTextSpan)
            .setStartTime(time: secondTextTime.advanced(by: .mockShortTimeInterval))
            .startSpan()
        let endTime = secondTextTime.advanced(by: .variableTimeInterval)
        
        secondRequestMadeSpan.end(
            errorCode: .failure,
            time: endTime
        )
        secondTextSpan.end(time: secondTextTime.advanced(by: .mockShortTimeInterval))
        cachedSpan.end(time: cachedTime + .mockShortTimeInterval)
        firstRequestMadeSpan.end(time: firstRequestMadeEndTime)
        firstTextSpan.end(time: firstTextTime.advanced(by: .mockShortTimeInterval))
        boxAppearsSpan.end(time: boxAppearsTime.advanced(by: .mockShortTimeInterval))
        traceRootSpan.end(time: endTime)
        
    }
}
