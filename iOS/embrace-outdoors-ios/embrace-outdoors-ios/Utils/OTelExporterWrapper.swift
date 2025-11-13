//
//  OTelExporterWrapper.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import Foundation

// NOTE: This file has been disabled after upgrading Embrace SDK from 6.12.1 to 6.14.1
//
// The Embrace SDK now uses opentelemetry-swift-core instead of the standalone
// opentelemetry-swift package, which conflicts with direct OpenTelemetry imports.
//
// Since this ExporterWrapper is not currently used in the codebase, it has been
// commented out to allow the SDK upgrade.
//
// If custom OpenTelemetry exporters are needed in the future, consider:
// 1. Using Embrace SDK's built-in export capabilities
// 2. Configuring export to an OTel Collector in Embrace.Options
// 3. Or reimplementing using opentelemetry-swift-core modules if needed
//
// For more info: https://github.com/embrace-io/embrace-apple-sdk

/*
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
*/
