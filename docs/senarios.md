
```yaml

gateway:
  enabled: true
  name: http-gateway
  tls:
    name: example
    cert: |
      -----BEGIN CERTIFICATE-----
      -----END CERTIFICATE-----

    key: |
      -----BEGIN RSA PRIVATE KEY-----
      -----END RSA PRIVATE KEY-----

```

```yaml
{{- if .Values.gateway.enabled }}
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: {{ .Values.gateway.name }}
spec:
  gatewayClassName: istio
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: Same
  - name: https
    port: 443
    protocol: HTTPS
    hostname: "*.pouchen.com"
    tls:
      certificateRefs:
      - kind: Secret
        name: {{ .Values.gateway.name }}-{{ .Values.gateway.tls.name }}-tls
    allowedRoutes:
      namespaces:
        from: Same
{{- end }}
{{- if .Values.gateway.enabled }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.gateway.name }}-{{ .Values.gateway.tls.name }}-tls
data:
  tls.crt: {{ .Values.gateway.tls.cert | b64enc }}
  tls.key: {{ .Values.gateway.tls.key | b64enc }}
type: kubernetes.io/tls
{{- end }}
```



```mermaid
graph TD
    %% Cluster nodes
    A[Test Cluster]
    B[Production Cluster]

    %% Environment nodes
    A1[Lab Environment]
    A2[Test Environment]
    B1[Production Environment]

    %% Environment httproute
    HA1[Lab Httproute]
    HA2[Test Httproute]
    HB1[Production Httproute]

    %% Gateway nodes
    G1[Shared Gateway]
    G2[Non-Shared Gateway]

    A --> G1
    %% Test cluster relationships
    subgraph test-ns [test-ns]
    G1 --> HA1
    G1 --> HA2
    HA1 --> A1
    HA2 --> A2
    end

    B --> G2
    %% Production cluster relationships
    subgraph prod-ns [prod-ns]
    G2 --> HB1
    HB1 --> B1
    end
```
