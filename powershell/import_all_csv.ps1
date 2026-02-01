$server = "LAP-S2M059"
$db     = "masterlist_S2M"
$folder = "C:\csv_import"

Write-Host "=== Starting STAGING Bulk Insert ==="

# Clear staging table before load
Write-Host "Truncating dbo.staging_emails..."
sqlcmd -S $server -d $db -Q "TRUNCATE TABLE dbo.staging_emails"

# Bulk insert all CSV files into staging
Get-ChildItem "$folder\*.csv" | ForEach-Object {

    $file = $_.FullName
    Write-Host "Importing $file"

    $sql = @"
BULK INSERT dbo.staging_emails
FROM '$file'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK
);
"@

    sqlcmd -S $server -d $db -Q $sql
}

Write-Host "=== STAGING Bulk Insert Completed Successfully ==="
