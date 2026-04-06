#!/usr/bin/env bash
set -u

ALERTS_FILE="alerts.log"
FAILED=0

log_alert() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') ALERT: $1" >> "$ALERTS_FILE"
}

check_service() {
  local service_name="$1"
  if ! systemctl is-active --quiet "$service_name"; then
    log_alert "Service $service_name is not running"
    FAILED=1
  fi
}

check_disk() {
  local usage
  usage=$(df / | awk 'NR==2 {gsub("%", "", $5); print $5}')
  if [ "$usage" -gt 85 ]; then
    log_alert "Disk usage is high: ${usage}%"
    FAILED=1
  fi
}

check_memory() {
  local used_percent
  used_percent=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')
  if [ "$used_percent" -gt 90 ]; then
    log_alert "Memory usage is high: ${used_percent}%"
    FAILED=1
  fi
}

check_http() {
  local url="http://localhost:8080/health"
  if ! curl -fsS --max-time 3 "$url" > /dev/null; then
    log_alert "Health endpoint failed: $url"
    FAILED=1
  fi
}

check_service nginx
check_service docker
check_disk
check_memory
check_http

if [ "$FAILED" -eq 0 ]; then
  echo "All checks passed"
  exit 0
else
  echo "One or more checks failed"
  exit 1
fi
