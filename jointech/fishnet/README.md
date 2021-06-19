# fishnet

This is a helmchart for fishnet, a stateless service for distributed stockfish analysis.

provide your fishnet key in a secret like this:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: fishnet
data:
  key: YOUR_KEY_BASE64
```
