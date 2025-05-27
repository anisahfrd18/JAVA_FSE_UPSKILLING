-- 1. User Upcoming Events
-- Show a list of all upcoming events a user is registered for in their city, sorted by date.

SELECT 
    u.user_id,
    u.full_name,
    e.event_id,
    e.title AS event_title,
    e.city AS event_city,
    e.start_date,
    e.end_date
FROM 
    Users u
JOIN 
    Registrations r ON u.user_id = r.user_id
JOIN 
    Events e ON r.event_id = e.event_id
WHERE 
    e.status = 'upcoming'
    AND u.city = e.city
ORDER BY 
    u.user_id, e.start_date;

-- 2. Top Rated Events
-- Identify events with the highest average rating, considering only those that have received at least 10 feedback submissions.
SELECT 
    e.event_id,
    e.title,
    ROUND(AVG(f.rating), 2) AS average_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM 
    Events e
JOIN 
    Feedback f ON e.event_id = f.event_id
GROUP BY 
    e.event_id, e.title
HAVING 
    COUNT(f.feedback_id) >= 10
ORDER BY 
    average_rating DESC;

-- 3. Inactive Users
-- Retrieve users who have not registered for any events in the last 90 days.
SELECT 
    u.user_id,
    u.full_name,
    u.email,
    u.city,
    u.registration_date
FROM 
    Users u
LEFT JOIN 
    Registrations r ON u.user_id = r.user_id AND r.registration_date >= CURDATE() - INTERVAL 90 DAY
WHERE 
    r.registration_id IS NULL;


-- 4. Peak Session Hours
-- Count how many sessions are scheduled between 10 AM to 12 PM for each event.
SELECT 
    event_id,
    COUNT(*) AS session_count_between_10_and_12
FROM 
    Sessions
WHERE 
    TIME(start_time) >= '10:00:00' 
    AND TIME(end_time) <= '12:00:00'
GROUP BY 
    event_id;


-- 5. Most Active Cities
-- List the top 5 cities with the highest number of distinct user registrations.
SELECT 
    u.city,
    COUNT(DISTINCT r.user_id) AS distinct_user_registrations
FROM 
    Users u
JOIN 
    Registrations r ON u.user_id = r.user_id
GROUP BY 
    u.city
ORDER BY 
    distinct_user_registrations DESC
LIMIT 5;

-- 6. Event Resource Summary
-- Generate a report showing the number of resources (PDFs, images, links) uploaded for each event.
SELECT 
    e.event_id,
    e.title,
    r.resource_type,
    COUNT(r.resource_id) AS resource_count
FROM 
    Events e
LEFT JOIN 
    Resources r ON e.event_id = r.event_id
GROUP BY 
    e.event_id, e.title, r.resource_type
ORDER BY 
    e.event_id, r.resource_type;


-- 7. Low Feedback Alerts
-- List all users who gave feedback with a rating less than 3, along with their comments and associated event names.
SELECT 
    u.user_id,
    u.full_name,
    e.event_id,
    e.title AS event_title,
    f.rating,
    f.comments
FROM 
    Feedback f
JOIN 
    Users u ON f.user_id = u.user_id
JOIN 
    Events e ON f.event_id = e.event_id
WHERE 
    f.rating < 3;


-- 8. Sessions per Upcoming Event
-- Display all upcoming events with the count of sessions scheduled for them.
SELECT 
    e.event_id,
    e.title,
    COUNT(s.session_id) AS session_count
FROM 
    Events e
LEFT JOIN 
    Sessions s ON e.event_id = s.event_id
WHERE 
    e.status = 'upcoming'
GROUP BY 
    e.event_id, e.title
ORDER BY 
    e.start_date;


-- 9. Organizer Event Summary
-- For each event organizer, show the number of events created and their current status (upcoming, completed, cancelled).
SELECT 
    u.user_id AS organizer_id,
    u.full_name AS organizer_name,
    e.status,
    COUNT(e.event_id) AS event_count
FROM 
    Users u
LEFT JOIN 
    Events e ON u.user_id = e.organizer_id
GROUP BY 
    u.user_id, u.full_name, e.status
ORDER BY 
    u.user_id, e.status;


-- 10. Feedback Gap
-- Identify events that had registrations but received no feedback at all.
SELECT 
    e.event_id,
    e.title
FROM 
    Events e
JOIN 
    Registrations r ON e.event_id = r.event_id
LEFT JOIN 
    Feedback f ON e.event_id = f.event_id
GROUP BY 
    e.event_id, e.title
HAVING 
    COUNT(r.registration_id) > 0 
    AND COUNT(f.feedback_id) = 0;


-- 11. Daily New User Count
-- Find the number of users who registered each day in the last 7 days.

-- 12. Event with Maximum Sessions
-- List the event(s) with the highest number of sessions.

-- 13. Average Rating per City
-- Calculate the average feedback rating of events conducted in each city.

-- 14. Most Registered Events
-- List top 3 events based on the total number of user registrations.

-- 15. Event Session Time Conflict
-- Identify overlapping sessions within the same event (i.e., session start and end times that conflict).

-- 16. Unregistered Active Users
-- Find users who created an account in the last 30 days but haven’t registered for any events.

-- 17. Multi-Session Speakers
-- Identify speakers who are handling more than one session across all events.

-- 18. Resource Availability Check
-- List all events that do not have any resources uploaded.

-- 19. Completed Events with Feedback Summary
-- For completed events, show total registrations and average feedback rating.

-- 20. User Engagement Index
-- For each user, calculate how many events they attended and how many feedbacks they submitted.

-- 21. Top Feedback Providers
-- List top 5 users who have submitted the most feedback entries.

-- 22. Duplicate Registrations Check
-- Detect if a user has been registered more than once for the same event.

-- 23. Registration Trends
-- Show a month-wise registration count trend over the past 12 months.

-- 24. Average Session Duration per Event
-- Compute the average duration (in minutes) of sessions in each event.

-- 25. Events Without Sessions
-- List all events that currently have no sessions scheduled under them.
