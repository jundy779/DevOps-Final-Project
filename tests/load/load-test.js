import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');
const votingDuration = new Trend('voting_duration');

// Test configuration
export const options = {
  stages: [
    { duration: '1m', target: 50 },  // Ramp up to 50 users
    { duration: '3m', target: 50 },  // Stay at 50 users
    { duration: '1m', target: 100 }, // Ramp up to 100 users
    { duration: '3m', target: 100 }, // Stay at 100 users
    { duration: '1m', target: 0 },   // Ramp down to 0 users
  ],
  thresholds: {
    'errors': ['rate<0.1'],          // Error rate should be less than 10%
    'voting_duration': ['p(95)<2000'], // 95% of requests should be below 2s
  },
};

// Test data
const BASE_URL = 'http://localhost:3000';
const CANDIDATES = ['1', '2', '3', '4'];
const VOTERS = Array.from({ length: 1000 }, (_, i) => `voter${i}`);

export default function () {
  // Simulate user login
  const loginRes = http.post(`${BASE_URL}/api/auth/login`, {
    username: VOTERS[Math.floor(Math.random() * VOTERS.length)],
    password: 'password123',
  });

  check(loginRes, {
    'login successful': (r) => r.status === 200,
  });

  if (loginRes.status === 200) {
    const token = loginRes.json('token');

    // Simulate voting
    const startTime = new Date();
    const voteRes = http.post(
      `${BASE_URL}/api/votes`,
      {
        candidateId: CANDIDATES[Math.floor(Math.random() * CANDIDATES.length)],
        electionId: '1',
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      }
    );

    votingDuration.add(new Date() - startTime);

    check(voteRes, {
      'vote successful': (r) => r.status === 201,
    });

    errorRate.add(voteRes.status !== 201);
  }

  // Simulate viewing results
  const resultsRes = http.get(`${BASE_URL}/api/results/1`);

  check(resultsRes, {
    'results retrieved': (r) => r.status === 200,
  });

  errorRate.add(resultsRes.status !== 200);

  sleep(1);
} 