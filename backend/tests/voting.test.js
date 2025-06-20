const request = require('supertest');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const app = require('../src/app');
const Vote = require('../src/models/vote');
const express = require('express');
const { Pool } = require('pg');

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  await mongoose.connect(mongoUri);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

beforeEach(async () => {
  await Vote.deleteMany({});
});

// Mock pg module
jest.mock('pg', () => ({
  Pool: jest.fn()
}));

// Mock prom-client
jest.mock('prom-client', () => ({
  collectDefaultMetrics: jest.fn(),
  Histogram: jest.fn(() => ({
    labels: jest.fn(() => ({
      observe: jest.fn()
    }))
  })),
  Counter: jest.fn(() => ({
    labels: jest.fn(() => ({
      inc: jest.fn()
    }))
  })),
  register: {
    contentType: 'text/plain',
    metrics: jest.fn().mockResolvedValue('test metrics')
  }
}));

// Mock express-rate-limit
jest.mock('express-rate-limit', () => jest.fn(() => (req, res, next) => next()));

// Mock express-validator
jest.mock('express-validator', () => ({
  body: jest.fn(() => ({
    isInt: jest.fn(() => ({
      withMessage: jest.fn(() => [])
    }))
  })),
  validationResult: jest.fn(() => ({
    isEmpty: jest.fn(() => true),
    array: jest.fn(() => [])
  }))
}));

// Mock helmet
jest.mock('helmet', () => jest.fn(() => (req, res, next) => next()));

describe('Voting API', () => {
  let mockPool;

  beforeEach(() => {
    // Reset mocks
    jest.clearAllMocks();
    
    // Setup mock pool
    mockPool = {
      query: jest.fn()
    };
    Pool.mockImplementation(() => mockPool);
  });

  describe('GET /api/votes', () => {
    it('should return candidates with vote counts', async () => {
      const mockCandidates = [
        { id: 1, name: 'Kandidat A', votes: '5' },
        { id: 2, name: 'Kandidat B', votes: '3' }
      ];

      mockPool.query.mockResolvedValueOnce({ rows: mockCandidates });

      const response = await request(app)
        .get('/api/votes')
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.candidates).toEqual(mockCandidates);
      expect(mockPool.query).toHaveBeenCalledTimes(1);
    });

    it('should handle database errors', async () => {
      mockPool.query.mockRejectedValueOnce(new Error('Database error'));

      const response = await request(app)
        .get('/api/votes')
        .expect(500);

      expect(response.body.success).toBe(false);
      expect(response.body.message).toBe('Internal server error');
    });
  });

  describe('POST /api/votes', () => {
    it('should create a new vote', async () => {
      const candidateId = 1;
      
      // Mock candidate exists check
      mockPool.query.mockResolvedValueOnce({ rows: [{ id: candidateId }] });
      // Mock vote insertion
      mockPool.query.mockResolvedValueOnce({ rowCount: 1 });

      const response = await request(app)
        .post('/api/votes')
        .send({ candidate_id: candidateId })
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.message).toBe('Vote berhasil disimpan');
      expect(mockPool.query).toHaveBeenCalledTimes(2);
    });

    it('should handle invalid candidate_id', async () => {
      const candidateId = 999;
      
      // Mock candidate not found
      mockPool.query.mockResolvedValueOnce({ rows: [] });

      const response = await request(app)
        .post('/api/votes')
        .send({ candidate_id: candidateId })
        .expect(404);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toBe('Kandidat tidak ditemukan');
    });

    it('should handle database errors during vote creation', async () => {
      mockPool.query.mockRejectedValueOnce(new Error('Database error'));

      const response = await request(app)
        .post('/api/votes')
        .send({ candidate_id: 1 })
        .expect(500);

      expect(response.body.success).toBe(false);
      expect(response.body.error).toBe('Internal server error');
    });
  });

  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body.status).toBe('ok');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('uptime');
    });
  });

  describe('GET /metrics', () => {
    it('should return prometheus metrics', async () => {
      const response = await request(app)
        .get('/metrics')
        .expect(200);

      expect(response.headers['content-type']).toBe('text/plain');
      expect(response.text).toBe('test metrics');
    });
  });
}); 