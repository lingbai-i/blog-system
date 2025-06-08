@echo off
curl -X GET "http://localhost:8080/api/admin/announcements?page=0&size=10" -H "Content-Type: application/json"
echo.
echo Testing public API:
curl -X GET "http://localhost:8080/api/announcements" -H "Content-Type: application/json"
pause