try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/admin/announcements?page=0&size=10' -Method GET
    Write-Host 'Status Code:' $response.StatusCode
    Write-Host 'Content:' $response.Content
}
catch {
    Write-Host 'Error:' $_.Exception.Message
}