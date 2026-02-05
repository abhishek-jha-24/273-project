# CMPE 273 – Week 1 Lab 1: Your First Distributed System

for complete working screenshot outputs of this project: https://docs.google.com/document/d/1jbdrbmOSMctdEUUo8LsNZAp8tg3T7v-qK0MEJmtiodc/edit?usp=sharing


This project implements a distributed system with two independent services that communicate over HTTP.

## Architecture

**Service A** (Port 8080)
- `/health` - Returns service status
- `/echo?msg=...` - Echoes back the provided message

**Service B** (Port 8081)
- `/health` - Returns service status
- `/call-echo?msg=...` - Calls Service A's `/echo` endpoint and returns the result

Service B includes:
- Timeout handling (1 second timeout on requests to Service A)
- Error logging with HTTP status codes
- Graceful degradation when Service A is unavailable (returns 503)

## How to Run Locally

### Prerequisites
- Python 3.8+
- pip (Python package manager)

### Setup & Run

**Terminal 1 - Start Service A:**
```bash
cd python-http/service-a
pip install -r requirements.txt
python app.py
```

**Terminal 2 - Start Service B (in a new terminal):**
```bash
cd python-http/service-b
pip install -r requirements.txt
python app.py
```

You should see output indicating both services are running:
- Service A: `Running on http://127.0.0.1:8080`
- Service B: `Running on http://127.0.0.1:8081`

### Testing

**Test successful communication:**
```bash
curl "http://127.0.0.1:8081/call-echo?msg=hello"
```

Expected response:
```json
{
  "service_b": "ok",
  "service_a": {
    "echo": "hello"
  }
}
```

**Test health check:**
```bash
curl "http://127.0.0.1:8080/health"
```

**Test failure scenario:**
1. Stop Service A (press Ctrl+C in Terminal 1)
2. Try to call Service B:
```bash
curl "http://127.0.0.1:8081/call-echo?msg=hello"
```

Expected response (HTTP 503):
```json
{
  "service_b": "ok",
  "service_a": "unavailable",
  "error": "timeout",
  "http_status": 504
}
```

Check the terminal logs to see Service B's error logging:
```
for complete working screenshot outputs of this project: https://docs.google.com/document/d/1jbdrbmOSMctdEUUo8LsNZAp8tg3T7v-qK0MEJmtiodc/edit?usp=sharing

```

## What Makes This Distributed?

This system demonstrates core distributed systems principles. **Independent Processes** - Service A and Service B run as separate Python processes that can be started, stopped, and restarted independently, allowing them to have different lifetimes and failure modes. **Network Communication** - Services communicate exclusively over HTTP/TCP, not through shared memory or direct function calls, simulating real-world distributed communication across network boundaries. **Fault Isolation** - Failure of Service A does not crash Service B; instead, Service B gracefully handles the error with a 1-second timeout and returns a 503 status code, allowing clients to understand the degraded state and react accordingly. **Timeout & Resilience** - Service B implements timeout logic (1 second) to prevent indefinite blocking when Service A is unavailable, a critical resilience pattern in distributed systems that prevents cascading failures.
