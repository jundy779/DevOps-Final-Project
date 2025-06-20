# 📊 Setup Metrics Grafana untuk Voting App

## 🎯 Overview

Setup monitoring yang lengkap untuk aplikasi voting dengan:
- ✅ **System Metrics**: CPU, Memory, Network
- ✅ **Application Metrics**: Request rate, Response time, Error rate
- ✅ **Business Metrics**: Total votes, Voting rate, Success rate
- ✅ **Database Metrics**: Connections, Query performance
- ✅ **Alerting**: Automated alerts untuk critical issues

## 📁 Struktur Dashboard

### 1. **Voting Metrics Dashboard** (`voting-metrics.json`)
**Technical Metrics:**
- Request Rate (req/sec)
- Response Time (95th percentile)
- Error Rate (%)
- Memory Usage
- CPU Usage (%)
- HTTP Status Codes
- Requests by Endpoint

### 2. **Business Metrics Dashboard** (`voting-business-metrics.json`)
**Business KPIs:**
- Total Votes Cast
- Votes per Candidate
- Voting Rate (votes/minute)
- Active Users
- Voting Session Duration
- Voting Success Rate
- Database Performance

## 🚀 Setup Instructions

### 1. **Deploy Monitoring Stack**
```bash
cd monitoring
docker-compose up -d
```

### 2. **Access Grafana**
- URL: `http://localhost:3001`
- Username: `admin`
- Password: `admin`

### 3. **Import Dashboards**
Dashboard akan otomatis ter-import, atau manual:
1. Buka Grafana
2. Klik **+** → **Import**
3. Upload file JSON dari folder `grafana/dashboards/`

## 📈 Metrics yang Dimonitor

### **System Metrics**
```promql
# CPU Usage
rate(process_cpu_seconds_total{job="voting-backend"}[5m]) * 100

# Memory Usage
process_resident_memory_bytes{job="voting-backend"}

# Request Rate
rate(http_requests_total{job="voting-backend"}[5m])
```

### **Application Metrics**
```promql
# Response Time (95th percentile)
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{job="voting-backend"}[5m])) * 1000

# Error Rate
rate(http_requests_total{job="voting-backend", status=~"5.."}[5m]) / rate(http_requests_total{job="voting-backend"}[5m]) * 100

# HTTP Status Codes
sum by (status) (rate(http_requests_total{job="voting-backend"}[5m]))
```

### **Business Metrics**
```promql
# Total Votes
sum(votes_total)

# Voting Rate
rate(votes_total[5m]) * 60

# Success Rate
(sum(votes_successful) / sum(votes_total)) * 100
```

## 🔔 Alerting Rules

### **Critical Alerts**
- **Service Down**: Service tidak respond
- **High Error Rate**: Error rate > 5%
- **High Response Time**: Response time > 2s

### **Warning Alerts**
- **High Memory Usage**: Memory > 1GB
- **High CPU Usage**: CPU > 80%
- **High Database Connections**: Connections > 50

### **Info Alerts**
- **High Voting Rate**: > 100 votes/minute

## 🛠️ Customization

### **Add Custom Metrics**
1. Tambahkan metrics di aplikasi:
```javascript
// Backend - Express.js
const prometheus = require('prom-client');
const votesTotal = new prometheus.Counter({
  name: 'votes_total',
  help: 'Total number of votes cast'
});

// Increment metric
votesTotal.inc();
```

2. Expose metrics endpoint:
```javascript
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', prometheus.register.contentType);
  res.end(await prometheus.register.metrics());
});
```

### **Custom Dashboard Panels**
1. Buka dashboard di Grafana
2. Klik **Add Panel**
3. Gunakan PromQL query:
```promql
# Custom metric example
rate(custom_metric_total[5m])
```

## 📊 Dashboard Features

### **Variables**
- **Job**: Filter by backend/frontend
- **Status**: Filter by HTTP status
- **Candidate**: Filter by voting candidate

### **Time Ranges**
- **Default**: Last 1 hour
- **Business Metrics**: Last 6 hours
- **Refresh**: 10s (Technical), 30s (Business)

### **Visualizations**
- **Time Series**: Request rate, response time
- **Stat Panels**: Total votes, active users
- **Gauge**: Success rate
- **Bar Chart**: Votes per candidate

## 🔧 Troubleshooting

### **No Data Showing**
1. **Check Prometheus Targets**:
   - Buka Prometheus: `http://localhost:9090`
   - Status → Targets
   - Pastikan semua targets UP

2. **Check Metrics Endpoint**:
   ```bash
   curl http://localhost:8000/metrics
   curl http://localhost:3000/metrics
   ```

3. **Check Prometheus Config**:
   - File: `prometheus/prometheus-final.yml`
   - Pastikan targets benar

### **Dashboard Not Loading**
1. **Check Grafana Logs**:
   ```bash
   docker logs monitoring-grafana-1
   ```

2. **Check Datasource**:
   - Grafana → Configuration → Data Sources
   - Pastikan Prometheus connected

### **Alerts Not Working**
1. **Check Alertmanager** (jika menggunakan):
   ```bash
   docker logs alertmanager
   ```

2. **Check Prometheus Rules**:
   - Prometheus → Alerts
   - Pastikan rules loaded

## 📚 Best Practices

### **Metrics Naming**
- Gunakan prefix yang konsisten: `voting_*`
- Gunakan units yang jelas: `_seconds`, `_bytes`, `_total`
- Gunakan labels untuk filtering: `{job="voting-backend"}`

### **Dashboard Design**
- Group related metrics together
- Use appropriate visualizations
- Set meaningful thresholds
- Include legends dan descriptions

### **Performance**
- Limit query time ranges
- Use rate() untuk counters
- Aggregate data appropriately
- Set reasonable refresh intervals

## 🔄 Maintenance

### **Regular Tasks**
1. **Review Alerts**: Monthly review alert thresholds
2. **Update Dashboards**: Add new metrics as needed
3. **Clean Old Data**: Monitor Prometheus storage
4. **Backup Configs**: Backup dashboard JSON files

### **Scaling**
- **High Volume**: Increase scrape intervals
- **More Services**: Add new targets to Prometheus
- **Multiple Environments**: Use different namespaces

## 📞 Support

Jika ada masalah dengan metrics setup:
1. Check logs: `docker logs monitoring-*`
2. Verify connectivity: `curl` ke endpoints
3. Check Prometheus targets status
4. Review Grafana datasource configuration 