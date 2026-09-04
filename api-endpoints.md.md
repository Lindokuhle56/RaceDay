# RaceDay API Endpoint Plan

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| **Authentication** | | | | | |
| POST | `/api/auth/register` | Register a new user account | None (Public) | `{email, password, fullName, role}` | 201 Created - User profile; 400 Bad Request; 409 Conflict - Email exists |
| POST | `/api/auth/login` | Authenticate user & return JWT token | None (Public) | `{email, password}` | 200 OK - Token + user info; 401 Unauthorized |
| **User Profile** | | | | | |
| GET | `/api/users/{id}` | Get user profile by ID | Any Authenticated | — | 200 OK - User data; 404 Not Found |
| PUT | `/api/users/{id}` | Update own profile | Any Authenticated | `{fullName, phone}` | 200 OK - Updated profile; 403 Forbidden |
| **Events** | | | | | |
| GET | `/api/events` | List all upcoming events | None (Public) | — | 200 OK - Array of events |
| GET | `/api/events/{id}` | Get single full event details | None (Public) | — | 200 OK - Event + route info; 404 Not Found |
| POST | `/api/events` | Create new event | Organiser | `{name, description, location, startDate, endDate}` | 201 Created - New event; 400 Invalid data |
| PUT | `/api/events/{id}` | Update event details | Organiser | `{all event fields}` | 200 OK - Updated event; 403 Forbidden; 404 Not Found |
| DELETE | `/api/events/{id}` | Delete/remove event | Organiser | — | 204 No Content; 404 Not Found |
| **Categories** | | | | | |
| GET | `/api/events/{eventId}/categories` | Get all categories for an event | None (Public) | — | 200 OK - Category list |
| POST | `/api/events/{eventId}/categories` | Add race category to event | Organiser | `{name, distance, price, maxParticipants}` | 201 Created; 400 Invalid |
| PUT | `/api/categories/{id}` | Update category details | Organiser | Updated fields | 200 OK; 404 Not Found |
| **Enrolments** | | | | | |
| GET | `/api/enrolments/my` | View my race entries | Participant | — | 200 OK - User enrolment history |
| POST | `/api/enrolments` | Enter an event category | Participant | `{categoryId}` | 201 Created; 409 Category full; 400 Invalid |
| PUT | `/api/enrolments/{id}` | Update enrolment status / Cancel | Participant / Organiser | `{status}` | 200 OK; 404 Not Found |
| **Results** | | | | | |
| GET | `/api/events/{eventId}/results` | View published race results | None (Public) | — | 200 OK - Ranked results list |
| POST | `/api/results` | Record participant result | Organiser | `{enrolmentId, finishTime, position}` | 201 Created; 400 Invalid |
| GET | `/api/results/my` | View my personal race results | Participant | — | 200 OK - Personal performance stats |