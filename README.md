#Experiments in OTEL & ADOT Intrumentation for Java & dotNet

References:
* https://github.com/build-on-aws/instrumenting-java-apps-using-opentelemetry
* https://github.com/aws-observability/aws-otel-java-instrumentation/
* https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation
* https://github.com/aws-observability/aws-otel-dotnet
* https://www.mytechramblings.com/posts/getting-started-with-opentelemetry-metrics-and-dotnet-part-2/
* https://aws-otel.github.io/docs/introduction

Using region: ap-southeast-2

# Collector

Either run
  * the **local** OTEL collector using tempo - see local (browse results at http://localhost:3000/explore -> Search)
  * the **local2** OTEL collector - see local (browse results at http://localhost:3000/explore -> Search)
  * the **aws** ADOT collector - see aws (browse to X-Ray Traces or Metrics in Cloudwatch)
    * Create a "Zero Spend Budget" to keep within the "Free Plan" using  https://us-east-1.console.aws.amazon.com/billing/home#/budgets/
    * Create an access key using https://us-east-1.console.aws.amazon.com/iamv2/home?region=ap-southeast-2#/users/details/<user>?section=security_credentials
    * Create a default local profile with region/access key using *aws cli*

## AWS Metrics

https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~()
* All metrics -> OTeLib -> ... -> Source

# Client app

java (port 1111)
- auto and manual instrumentation

## metrics

Source
```
{
    "metrics": [
        [ "otel-j-app", "custom.metric.number.of.exec", "OTelLib", "io.opentelemetry.metrics.hello", { "id": "m1" } ]
    ],
    "sparkline": true,
    "view": "gauge",
    "stacked": false,
    "region": "ap-southeast-2",
    "liveData": true,
    "yAxis": {
        "left": {
            "min": 0,
            "max": 10
        }
    },
    "stat": "Sum",
    "period": 360,
    "setPeriodToTimeRange": false,
    "trend": true
}
```

dotnet (port 1112)
- auto instrumentation

## metrics

Source
```
{
    "metrics": [
        [ "otel-n-app", "http.server.duration", "OTelLib", "OpenTelemetry.Instrumentation.AspNetCore", { "id": "m1" } ]
    ],
    "sparkline": true,
    "view": "gauge",
    "stacked": false,
    "region": "ap-southeast-2",
    "liveData": true,
    "yAxis": {
        "left": {
            "min": 0,
            "max": 10
        }
    },
    "stat": "Sum",
    "period": 360,
    "setPeriodToTimeRange": false,
    "trend": true
}
```

dotnetm (post 8080)
- manual instrumentation

#Test

with: ./hello.sh

# Issues

  1. dotnet (auto) gathers metrics but no traces???

```
  See docker cp otel-n-app:/log .
  [2023-06-19T05:30:20.6148099Z] [Error] EventSource=OpenTelemetry-Exporter-OpenTelemetryProtocol, Message=Exporter failed send data to collector to http://collector:5555/ endpoint. Data will not be sent. Exception: Grpc.Core.RpcException: Status(StatusCode="Unimplemented", Detail="unknown service opentelemetry.proto.collector.logs.v1.LogsService")
     at Grpc.Net.Client.Internal.HttpClientCallInvoker.BlockingUnaryCall[TRequest,TResponse](Method`2 method, String host, CallOptions options, TRequest request)
     at Grpc.Core.Interceptors.InterceptingCallInvoker.<BlockingUnaryCall>b__3_0[TRequest,TResponse](TRequest req, ClientInterceptorContext`2 ctx)
     at Grpc.Core.ClientBase.ClientBaseConfiguration.ClientBaseConfigurationInterceptor.BlockingUnaryCall[TRequest,TResponse](TRequest request, ClientInterceptorContext`2 context, BlockingUnaryCallContinuation`2 continuation)
     at Grpc.Core.Interceptors.InterceptingCallInvoker.BlockingUnaryCall[TRequest,TResponse](Method`2 method, String host, CallOptions options, TRequest request)
     at OpenTelemetry.Proto.Collector.Logs.V1.LogsService.LogsServiceClient.Export(ExportLogsServiceRequest request, CallOptions options)
     at OpenTelemetry.Proto.Collector.Logs.V1.LogsService.LogsServiceClient.Export(ExportLogsServiceRequest request, Metadata headers, Nullable`1 deadline, CancellationToken cancellationToken)
     at OpenTelemetry.Exporter.OpenTelemetryProtocol.Implementation.ExportClient.OtlpGrpcLogExportClient.SendExportRequest(ExportLogsServiceRequest request, CancellationToken cancellationToken) 
```
