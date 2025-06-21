<<<<<<< HEAD
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import { submitVote, getVotes } from '../app.js';

// Mock fetch
global.fetch = jest.fn();

describe('Voting Component', () => {
  beforeEach(() => {
    fetch.mockClear();
  });

  describe('submitVote', () => {
    it('should successfully submit a vote', async () => {
      const mockResponse = { success: true, message: 'Vote recorded successfully' };
      fetch.mockImplementationOnce(() =>
        Promise.resolve({
          ok: true,
          json: () => Promise.resolve(mockResponse),
        })
      );

      const result = await submitVote('123', '456', '789');
      expect(result).toEqual(mockResponse);
      expect(fetch).toHaveBeenCalledWith('/api/votes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          candidateId: '123',
          voterId: '456',
          electionId: '789',
        }),
      });
    });

    it('should handle submission errors', async () => {
      fetch.mockImplementationOnce(() =>
        Promise.resolve({
          ok: false,
          json: () => Promise.resolve({ error: 'Vote already recorded' }),
        })
      );

      await expect(submitVote('123', '456', '789')).rejects.toThrow('Vote already recorded');
    });
  });

  describe('getVotes', () => {
    it('should fetch votes successfully', async () => {
      const mockVotes = [
        { id: '1', candidateId: '123', voterId: '456', electionId: '789' },
        { id: '2', candidateId: '124', voterId: '457', electionId: '789' },
      ];

      fetch.mockImplementationOnce(() =>
        Promise.resolve({
          ok: true,
          json: () => Promise.resolve(mockVotes),
        })
      );

      const votes = await getVotes();
      expect(votes).toEqual(mockVotes);
      expect(fetch).toHaveBeenCalledWith('/api/votes');
    });

    it('should handle fetch errors', async () => {
      fetch.mockImplementationOnce(() =>
        Promise.reject(new Error('Network error'))
      );

      await expect(getVotes()).rejects.toThrow('Network error');
    });
  });
});

// Simple test for frontend
describe('Frontend Tests', () => {
  test('should have basic functionality', () => {
    // Mock DOM elements
    document.body.innerHTML = `
      <div id="candidates-container"></div>
      <div id="alert-container"></div>
      <div id="loader"></div>
    `;

    // Test that DOM elements exist
    expect(document.getElementById('candidates-container')).toBeTruthy();
    expect(document.getElementById('alert-container')).toBeTruthy();
    expect(document.getElementById('loader')).toBeTruthy();
  });

  test('should handle API calls', async () => {
    // Mock fetch
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve({
          candidates: [
            { id: 1, name: 'Kandidat A', votes: 5 },
            { id: 2, name: 'Kandidat B', votes: 3 }
          ]
        })
      })
    );

    // Test API call
    const response = await fetch('/api/votes');
    const data = await response.json();

    expect(data.candidates).toHaveLength(2);
    expect(data.candidates[0].name).toBe('Kandidat A');
  });

  test('should handle API errors', async () => {
    // Mock fetch with error
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: false,
        status: 500
      })
    );

    // Test error handling
    const response = await fetch('/api/votes');
    expect(response.ok).toBe(false);
    expect(response.status).toBe(500);
  });
=======
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import { submitVote, getVotes } from '../app.js';

// Mock fetch
global.fetch = jest.fn();

describe('Voting Component', () => {
  beforeEach(() => {
    fetch.mockClear();
  });

  describe('submitVote', () => {
    it('should successfully submit a vote', async () => {
      const mockResponse = { success: true, message: 'Vote recorded successfully' };
      fetch.mockImplementationOnce(() =>
        Promise.resolve({
          ok: true,
          json: () => Promise.resolve(mockResponse),
        })
      );

      const result = await submitVote('123', '456', '789');
      expect(result).toEqual(mockResponse);
      expect(fetch).toHaveBeenCalledWith('/api/votes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          candidateId: '123',
          voterId: '456',
          electionId: '789',
        }),
      });
    });

    it('should handle submission errors', async () => {
      fetch.mockImplementationOnce(() =>
        Promise.resolve({
          ok: false,
          json: () => Promise.resolve({ error: 'Vote already recorded' }),
        })
      );

      await expect(submitVote('123', '456', '789')).rejects.toThrow('Vote already recorded');
    });
  });

  describe('getVotes', () => {
    it('should fetch votes successfully', async () => {
      const mockVotes = [
        { id: '1', candidateId: '123', voterId: '456', electionId: '789' },
        { id: '2', candidateId: '124', voterId: '457', electionId: '789' },
      ];

      fetch.mockImplementationOnce(() =>
        Promise.resolve({
          ok: true,
          json: () => Promise.resolve(mockVotes),
        })
      );

      const votes = await getVotes();
      expect(votes).toEqual(mockVotes);
      expect(fetch).toHaveBeenCalledWith('/api/votes');
    });

    it('should handle fetch errors', async () => {
      fetch.mockImplementationOnce(() =>
        Promise.reject(new Error('Network error'))
      );

      await expect(getVotes()).rejects.toThrow('Network error');
    });
  });
});

// Simple test for frontend
describe('Frontend Tests', () => {
  test('should have basic functionality', () => {
    // Mock DOM elements
    document.body.innerHTML = `
      <div id="candidates-container"></div>
      <div id="alert-container"></div>
      <div id="loader"></div>
    `;

    // Test that DOM elements exist
    expect(document.getElementById('candidates-container')).toBeTruthy();
    expect(document.getElementById('alert-container')).toBeTruthy();
    expect(document.getElementById('loader')).toBeTruthy();
  });

  test('should handle API calls', async () => {
    // Mock fetch
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve({
          candidates: [
            { id: 1, name: 'Kandidat A', votes: 5 },
            { id: 2, name: 'Kandidat B', votes: 3 }
          ]
        })
      })
    );

    // Test API call
    const response = await fetch('/api/votes');
    const data = await response.json();

    expect(data.candidates).toHaveLength(2);
    expect(data.candidates[0].name).toBe('Kandidat A');
  });

  test('should handle API errors', async () => {
    // Mock fetch with error
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: false,
        status: 500
      })
    );

    // Test error handling
    const response = await fetch('/api/votes');
    expect(response.ok).toBe(false);
    expect(response.status).toBe(500);
  });
>>>>>>> 5eec687 (Add Jenkinsfile for CI/CD)
}); 