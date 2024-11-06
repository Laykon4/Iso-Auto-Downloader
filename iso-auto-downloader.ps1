Clear-Host
$debianUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"

$response = Invoke-WebRequest -Uri $debianUrl
$pageContent = $response.Content

$isoPattern = "debian-[\d.]+-amd64-netinst\.iso" 
$isoFile = [regex]::Match($pageContent, $isoPattern).Value

if ($isoFile) {
    $latestIsoUrl = "$debianUrl$isoFile"
    $localPath = "yourpath\$isoFile"

    if (Test-Path -Path $localPath) {
        $localLastModified = (Get-Item -Path $localPath).LastWriteTime
        $remoteLastModified = $response.Headers["Last-Modified"]
        $remoteLastModifiedDate = [DateTime]::ParseExact($remoteLastModified, "R", $null)

        if ($remoteLastModifiedDate -gt $localLastModified) {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
        
            Write-Output "Le fichier ISO a été mis à jour et téléchargé : $isoFile"
        } else {
            Write-Output "Le fichier ISO est déjà à jour."
        }
    }else {
        Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
        Write-Output "Le fichier ISO n'existait pas localement et a été téléchargé : $isoFile"
    }


} else {
    Write-Output "Aucun fichier ISO trouvé dans le répertoire Debian."
}