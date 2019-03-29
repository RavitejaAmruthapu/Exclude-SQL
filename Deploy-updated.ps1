param([string]$serverName, [string]$userName, [string]$Password, [string]$Dacpac, [string]$targetDatabaseName)

$ConnectionString="server=$serverName;User ID=$userName;Password=$Password;Encrypt=True;TrustServerCertificate=True;Authentication=Sql Password"

$dacfxPath = 'C:\Program Files (x86)\Microsoft SQL Server\120\DAC\bin\Microsoft.SqlServer.Dac.dll'

$logs = "C:\DacpacReport"

#create log path
New-Item $logs -ItemType directory -force | out-null;

# Load the DAC assembly
Write-Verbose 'Testing if DACfx was installed...'
$validate = Test-Path $dacfxPath
if (!$dacfxPath) {
    throw 'No usable version of Dac Fx found.'
}
Write-Verbose -Verbose 'DacFX found, attempting to load DAC assembly...'
Add-Type -Path $dacfxPath
Write-Verbose -Verbose 'Loaded DAC assembly.'

# Load DacPackage
$dacPackage = [Microsoft.SqlServer.Dac.DacPackage]::Load($Dacpac)


# Setup DacServices
#$server = "server=$targetConnectionString"
$server = "$ConnectionString"
$dacServices = New-Object Microsoft.SqlServer.Dac.DacServices $server

# Deploy package
try {
    Write-Host 'Starting Dacpac deployment...'
    $dacServices.GenerateDeployScript($dacPackage, $targetDatabaseName, $dacProfile.DeployOptions) | Out-File "$logs\$targetDatabaseName.sql"
    $dacServices.Deploy($dacPackage, $targetDatabaseName, $true, $null)
    Write-Host 'Deployment succeeded!'
}
catch [Microsoft.SqlServer.Dac.DacServicesException] {
    throw ('Deployment failed: ''{0}'' Reason: ''{1}''' -f $_.Exception.Message, $_.Exception.InnerException.Message)
}


#C:\Users\Teja\Desktop\deploy.ps1 -targetConnectionString "server=(local);Data Source=RAVITEJA;Persist Security Info=True;User ID=sa;Pooling=False;MultipleActiveResultSets=False;Connect Timeout=60;Encrypt=False;TrustServerCertificate=True" -Dacpac "C:\Users\Teja\Documents\Visual Studio 2015\Projects\DACPAC-POC2\DACPAC-POC2\bin\Debug\DACPAC-POC2.dacpac" -targetDatabaseName "ART1" -Profile "ART"

#C:\Users\Teja\Desktop\deploy.ps1 -targetConnectionString "server=(local)" -Dacpac "C:\Users\Teja\Documents\Visual Studio 2015\Projects\DACPAC-POC2\DACPAC-POC2\bin\Debug\DACPAC-POC2.dacpac" -targetDatabaseName "ART1" -Profile "ART"

#C:\Users\Teja\Desktop\Deploy-updated.ps1 -serverName "local" -userName "sa" -Password "teja_101" -Dacpac "C:\Users\Teja\Documents\Visual Studio 2015\Projects\DACPAC-POC2\DACPAC-POC2\bin\Debug\DACPAC-POC2.dacpac" -targetDatabaseName "ART1"

#C:\Users\Teja\Desktop\Deploy-updated.ps1 -serverName "RAVITEJA" -userName "sa" -Password "teja_101" -Dacpac "C:\Users\Teja\Documents\Visual Studio 2015\Projects\DACPAC-POC2\DACPAC-POC2\bin\Debug\DACPAC-POC2.dacpac" -targetDatabaseName "ARTART"