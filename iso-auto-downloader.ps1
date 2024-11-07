Clear-Host
#Demander à l'utilisateur de faire un choix
$choice = Read-Host "Choose an OS type : `n 1 - Debian `n 2 - Kali Linux)"

# Utiliser le switch pour déterminer le choix
$osType = switch ($choice) {
    "1" { "Debian" }
    "2" { "Kali Linux" }
    Default { "Unknown" }
}

# Utiliser le résultat du switch dans une condition
if ($osType -eq "Debian") {

    $debianUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
    $debianIsoPattern = "debian-[\d.]+-amd64-netinst\.iso"
    $debianLocalPath = "F:\ScriptISO\debian\"

    Write-Host "You selected Debian. Proceeding with Debian setup..."
    $response = Invoke-WebRequest -Uri $debianUrl
    $pageContent = $response.Content

    # Extrait + match du pattern compare au contenu du site
    $isoFile = [regex]::Match($pageContent, $debianIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$debianUrl$isoFile"
        $localPath = "$debianLocalPath$isoFile"

        # Vérifie si le fichier existe
        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            # Compare les dates
            $remoteLastModified = $response.Headers["Last-Modified"]
            $remoteLastModifiedDate = [DateTime]::ParseExact($remoteLastModified, "R", $null)

            if ($remoteLastModifiedDate -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "Le fichier ISO a été mis à jour et téléchargé : $isoFile"
            } else {
                $logmessage= "Le fichier ISO est déjà à jour."
            }
        }else {
            # dl si le fichier local n'existe pas
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "Le fichier ISO n'existait pas localement et a été téléchargé : $isoFile"
        }


    } else {
        $logmessage= "Aucun fichier ISO trouvé dans le répertoire."
}



} 

elseif ($osType -eq "Kali Linux") {

    [Int] $version = Read-Host "Choose a version for Kali Linux (1 for Netinst | 2 for Complete)"
    switch ($version) {
        1 {$kaliIsoPattern = "kali-linux-[\d.]+-installer-netinst-amd64\.iso"}
        2 {$kaliIsoPattern = "kali-linux-[\d.]+-installer-amd64\.iso"}
    }

    $kaliUrl = "https://cdimage.kali.org/current/"
    $kaliLocalPath = "F:\ScriptISO\kali\"

    Write-Host "You selected Kali Linux. Proceeding with Kali Linux setup..."
    $response = Invoke-WebRequest -Uri $kaliUrl
    $pageContent = $response.Content

    # Extrait + match du pattern compare au contenu du site
    $isoFile = [regex]::Match($pageContent, $kaliIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$kaliUrl$isoFile"
        $localPath = "$kaliLocalPath$isoFile"

        # Vérifie si le fichier existe
        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            # Compare les dates
            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModifiedDate -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "Le fichier ISO a été mis à jour et téléchargé : $isoFile"
            } else {
                $logmessage= "Le fichier ISO est déjà à jour."
            }
        }else {
            # dl si le fichier local n'existe pas
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "Le fichier ISO n'existait pas localement et a été téléchargé : $isoFile"
        }


    } else {
        $logmessage= "Aucun fichier ISO trouvé dans le répertoire."
}

} 

else {
    Write-Host "Invalid choice. Please select a valid option."
}


$stamp + " : " + $logmessage >> $logfilepath
