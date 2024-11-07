Clear-Host
Write-Host "Welcome to the ISO automatic downloader "
Write-Host " 1 - Debian"
Write-Host " 2 - Kali Linux"
[Int] $osChoice = Read-Host "From which OS do you want to download the iso ?"

switch ($osChoice) {
    1 {
        $localOsPath = "F:\ScriptISO\debian\"
        $isoPattern = "debian-[\d.]+-amd64-netinst\.iso"
        $downloadUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
    }

    2 {
        Clear-Host
        [Int] $installType = Read-Host "Netinst or Complete install ? (1 for netinst | 2 for complete) ?"
        switch ($installType) {
            1 {$isoPattern = "kali-linux-[\d.]+-installer-netinst-amd64\.iso"}
            2 {$isoPattern = "kali-linux-[\d.]+-installer-amd64\.iso"}
        }
        $localOsPath = "F:\ScriptISO\kali\"
        $downloadUrl = "https://cdimage.kali.org/current/"
    }

    Default {
        Write-Host "Invalid choice."
        exit
    }
}



# contenu du repertoire
$response = Invoke-WebRequest -Uri $downloadUrl
$pageContent = $response.Content

# Extrait + match du pattern compare au contenu du site
$isoFile = [regex]::Match($pageContent, $isoPattern).Value

if ($isoFile) {
    $latestIsoUrl = "$downloadUrl$isoFile"
    $localPath = "$localOsPath$isoFile"

    # Vérifie si le fichier existe
    if (Test-Path -Path $localPath) {
        $localLastModified = (Get-Item -Path $localPath).LastWriteTime

        # Compare les dates
        $remoteLastModified = $response.Headers["Last-Modified"]
        $remoteLastModifiedDate = [DateTime]::ParseExact($remoteLastModified, "R", $null)

        if ($remoteLastModifiedDate -gt $localLastModified) {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
        
            Write-Output "The ISO file has been updated and downloaded : $isoFile"
        } else {
            Write-Output "The ISO file is already up to date."
        }
    }else {
        # dl si le fichier local n'existe pas
        Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
        Write-Output "The ISO file did not exist locally and was downloaded : $isoFile"
    }


} else {
    Write-Output "no file found in this directory"
}