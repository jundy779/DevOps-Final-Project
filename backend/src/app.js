import express from 'express';
import cors from 'cors';
import { Pool } from 'pg';
import * as promClient from 'prom-client';
import rateLimit from 'express-rate-limit';
import { body, validationResult } from 'express-validator';
import helmet from 'helmet';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const port = process.env.PORT || 8000;

// Security middleware
app.use(helmet());
app.use(cors({
  origin: ['http://178.128.55.244:3000', 'http://localhost:3000', 'http://127.0.0.1:3000'],
  methods: ['GET', 'POST'],
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 menit
  max: 100, // limit setiap IP ke 100 request per windowMs
  message: 'Terlalu banyak request dari IP ini, silakan coba lagi setelah 15 menit'
});

// Prometheus metrics
const collectDefaultMetrics = promClient.collectDefaultMetrics;
collectDefaultMetrics();

// Custom metrics
const httpRequestDurationMicroseconds = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Middleware
app.use(express.json());

// Metrics middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    httpRequestDurationMicroseconds
      .labels(req.method, req.route?.path || req.path, res.statusCode.toString())
      .observe(duration / 1000);
    httpRequestsTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode.toString())
      .inc();
  });
  next();
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});

// Database connection
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

// Database health check
const checkDatabaseConnection = async () => {
  try {
    await pool.query('SELECT 1');
    return true;
  } catch (error) {
    console.error('Database connection error:', error);
    return false;
  }
};

// Routes
app.get('/api/votes', async (req, res) => {
  try {
    const query = `
      SELECT 
        c.id, 
        c.name, 
        COUNT(v.id) AS votes
      FROM 
        candidates c
      LEFT JOIN 
        votes v ON c.id = v.candidate_id
      GROUP BY 
        c.id, c.name
      ORDER BY 
        c.id;
    `;
    const result = await pool.query(query);
    res.json({ success: true, candidates: result.rows });
  } catch (err) {
    console.error('Error getting votes:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
});

// Vote validation middleware
const voteValidation = [
  body('candidate_id')
    .isInt({ min: 1 })
    .withMessage('Candidate ID harus berupa angka positif'),
  limiter
];

app.post('/api/votes', voteValidation, async (req, res) => {
  // Check validation errors
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ 
      success: false,
      errors: errors.array() 
    });
  }

  const { candidate_id } = req.body;

  try {
    // Check if candidate exists
    const candidateCheck = await pool.query(
      'SELECT id FROM candidates WHERE id = $1',
      [candidate_id]
    );

    if (candidateCheck.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Kandidat tidak ditemukan'
      });
    }

    await pool.query(
      'INSERT INTO votes (candidate_id) VALUES ($1)',
      [candidate_id]
    );
    
    res.json({
      success: true,
      message: 'Vote berhasil disimpan'
    });
  } catch (error) {
    console.error('Error saving vote:', error);
    res.status(500).json({ 
      success: false,
      error: 'Internal server error',
      message: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'Terjadi kesalahan pada server',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Start server
app.listen(port, () => {
  console.log(`Server berjalan di port ${port}`);
  // Check database connection on startup
  checkDatabaseConnection().then(isConnected => {
    if (isConnected) {
      console.log('Database connection successful');
    } else {
      console.error('Database connection failed');
    }
  });
}); 