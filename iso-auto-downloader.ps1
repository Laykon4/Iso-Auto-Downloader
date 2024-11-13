Clear-Host
$stamp = (Get-Date).toString("yyyy-MM-dd -- HH.mm.ss")
$logfilepath="F:\ScriptISO\report_$stamp.log"
$logmessage= "###### DEBUT DU SCRIPT ######" 

function debian {
    $debianUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
    $debianIsoPattern = "debian-[\d.]+-amd64-netinst\.iso"
    $debianLocalPath = "F:\ScriptISO\debian\"

    Write-Host "You selected Debian. Proceeding with Debian setup..."
    $response = Invoke-WebRequest -Uri $debianUrl
    $pageContent = $response.Content

    $isoFile = [regex]::Match($pageContent, $debianIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$debianUrl$isoFile"
        $localPath = "$debianLocalPath$isoFile"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]
            $remoteLastModifiedDate = [DateTime]::ParseExact($remoteLastModified, "R", $null)

            if ($remoteLastModifiedDate -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "Debian : The new iso file was downloaded : $isoFile"
            } else {
                $logmessage= "Debian : The iso file is already up to date."
            }
        }else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "Debian : The ISO file did not exist locally and was downloaded : $isoFile"
        }


    } else {
        $logmessage= "Debian : No ISO files found in the directory."
    }
    $stamp + " : " + $logmessage >> $logfilepath
}

function kaliLinux {
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

    $isoFile = [regex]::Match($pageContent, $kaliIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$kaliUrl$isoFile"
        $localPath = "$kaliLocalPath$isoFile"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModified -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "Kali Linux : The new iso file was downloaded : $isoFile"
            } else {
                $logmessage= "Kali Linux : The iso file is already up to date."
            }
        }else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "Kali Linux : The ISO file did not exist locally and was downloaded : $isoFile"
        }


    } else {
        $logmessage= "Kali Linux : No ISO files found in the directory."
    } 
$stamp + " : " + $logmessage >> $logfilepath
}

function ubuntu {
    $ubuntuUrl = "https://releases.ubuntu.com/"

    Write-Host "You selected Ubuntu. Proceeding with Ubuntu setup..."
    $response = Invoke-WebRequest -Uri $ubuntuUrl
    $pageContent = $response.Content

    $ubuntuPattern = "(?<=href=[""'])(\d{2}\.\d{2})(?=[""'/])"
    $isoFile = [regex]::Matches($pageContent, $ubuntuPattern) | ForEach-Object { $_.Value }

    $latestVersion = ($isoFile | Sort-Object -Descending)[0]

    $latestIsoUrl = "$ubuntuUrl$latestVersion/ubuntu-$latestVersion-desktop-amd64.iso"
    $ubuntuLocalPath = "F:\ScriptISO\ubuntu"


    if ($latestVersion) {
        $localPath = "$ubuntuLocalPath\ubuntu-$latestVersion-desktop-amd64.iso"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModified -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "Ubuntu : The new iso file was downloaded : $latestIsoUrl"
            } else {
                $logmessage= "Ubuntu : The iso file is already up to date."
            }
        } else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "Ubuntu : The ISO file did not exist locally and was downloaded : $latestIsoUrl"
        }
    } 

    else {
        $logmessage= "Ubuntu : No ISO files found in the directory."
    } 
$stamp + " : " + $logmessage >> $logfilepath  
}

function dlAll {
    debian
    kaliLinux
    ubuntu   
}

$choice = Read-Host "Choose an OS type : `n 1 - Debian `n 2 - Kali Linux `n 3 - Ubuntu `n 99 - Download all `n Your choice "

$osType = switch ($choice) {
    "1" { debian }
    "2" { kaliLinux }
    "3" { ubuntu }
    "99" {dlAll}
    Default { "Unknown" }
}


#$stamp + " : " + $logmessage >> $logfilepath
