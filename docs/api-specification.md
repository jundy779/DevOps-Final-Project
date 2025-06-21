# Voting Application API Specification

## Base URL
```
http://voting-backend/api/v1
```

## Authentication
All endpoints require JWT authentication except for public voting endpoints.
Include the token in the Authorization header:
```
Authorization: Bearer <token>
```

## Endpoints

### Authentication
```
POST /auth/login
POST /auth/register
POST /auth/refresh-token
```

### Polls
```
GET    /polls              # List all active polls
POST   /polls              # Create new poll
GET    /polls/{id}         # Get poll details
PUT    /polls/{id}         # Update poll
DELETE /polls/{id}         # Delete poll
POST   /polls/{id}/vote    # Submit vote
GET    /polls/{id}/results # Get poll results
```

### Users
```
GET    /users              # List users (admin only)
GET    /users/{id}         # Get user profile
PUT    /users/{id}         # Update user profile
DELETE /users/{id}         # Delete user (admin only)
```

## Request/Response Examples

### Create Poll
```json
POST /polls
{
  "title": "Favorite Programming Language",
  "description": "Vote for your favorite programming language",
  "options": [
    "Python",
    "JavaScript",
    "Java",
    "Go"
  ],
  "endDate": "2024-04-01T00:00:00Z",
  "isPublic": true
}
```

### Submit Vote
```json
POST /polls/{id}/vote
{
  "optionId": "option_123",
  "userId": "user_456"
}
```

### Get Poll Results
```json
GET /polls/{id}/results
Response:
{
  "pollId": "poll_789",
  "title": "Favorite Programming Language",
  "totalVotes": 150,
  "results": [
    {
      "option": "Python",
      "votes": 75,
      "percentage": 50
    },
    {
      "option": "JavaScript",
      "votes": 45,
      "percentage": 30
    },
    {
      "option": "Java",
      "votes": 20,
      "percentage": 13.33
    },
    {
      "option": "Go",
      "votes": 10,
      "percentage": 6.67
    }
  ]
}
```

## Error Responses
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": {
      "field": "Additional error details"
    }
  }
}
```

## Rate Limiting
- 100 requests per minute per IP
- 1000 requests per hour per user

## Monitoring Endpoints
```
GET /health    # Health check
GET /ready     # Readiness check
GET /metrics   # Prometheus metrics
``` 