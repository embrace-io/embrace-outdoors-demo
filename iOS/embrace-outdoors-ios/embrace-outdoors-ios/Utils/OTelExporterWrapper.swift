//
//  OTelExporterWrapper.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import Foundation
import GRPC
import NIO

import OpenTelemetryProtocolExporterHttp
import OpenTelemetryProtocolExporterGrpc
import OpenTelemetrySdk
import StdoutExporter

struct ExporterWrapper {
    
    private init() {}
    
    static var localOtelCollectorSpanExporter: OtlpTraceExporter {
        let config = ClientConnection.Configuration.default(
            target: ConnectionTarget.hostAndPort("localhost", 4317),
            eventLoopGroup: MultiThreadedEventLoopGroup(numberOfThreads: 1)
        )
        
        let client = ClientConnection(configuration: config)
        
        return OtlpTraceExporter(channel: client)
    }
    
    static let consoleSpanExporter = StdoutSpanExporter()
    
    static func grafanaHTTPEndpointSpanExporter(authorizationKey: String) -> OtlpHttpTraceExporter {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Basic \(authorizationKey)"]
        let session = URLSession(configuration: configuration)

    
        return OtlpHttpTraceExporter(
            endpoint: URL(string: "https://otlp-gateway-prod-us-east-0.grafana.net/otlp/v1/traces")!,
            useSession: session
        )
    }
    
    static func grafanaHTTPEndpointLogExporter(authorizationKey: String) -> OtlpHttpLogExporter {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Basic \(authorizationKey)"]
        let session = URLSession(configuration: configuration)

    
        return OtlpHttpLogExporter(
            endpoint: URL(string: "https://otlp-gateway-prod-us-east-0.grafana.net/otlp/v1/logs")!,
            useSession: session
        )
    }
    
    static func honeycombHTTPEndpointSpanExporter(authorizationKey: String, datasetName: String) -> OtlpHttpTraceExporter {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "x-honeycomb-team": authorizationKey,
            "x-honeycomb-dataset": datasetName
        ]
        let session = URLSession(configuration: configuration)
        
        return OtlpHttpTraceExporter(
            endpoint: URL(string: "https://api.honeycomb.io/v1/traces")!,
            useSession: session
        )
    }
    
    static func spanExporterWithXcodeSpanLogging(exporter: SpanExporter) -> MultiSpanExporter {
        MultiSpanExporter(spanExporters: [Self.consoleSpanExporter, exporter])
    }
    
}
