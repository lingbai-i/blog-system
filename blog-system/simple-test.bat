curl -X GET "http://localhost:8080/api/admin/announcements?page=0&size=10" -v
echo.
echo ===== Testing public API =====
curl -X GET "http://localhost:8080/api/announcements/published" -v