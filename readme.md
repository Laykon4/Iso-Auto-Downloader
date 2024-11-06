# ISO Auto-Downloader

### Automate the Download of Latest ISO Files (Debian only for now)

ISO Auto-Downloader is a tool designed to automate the process of fetching the latest versions of ISO files from specified sources. The tool checks for new releases, compares with locally stored files, and downloads updates only when a new version is available. This is ideal for users who need the most recent ISO versions without manually checking for updates.

## Features

- **Automated Version Check**: Detects the latest ISO version available from the specified URL.
- **Smart Downloading**: Downloads only when a new ISO version is available, saving bandwidth and storage.
- **Easy Scheduling**: Integrates with task schedulers (like Windows Task Scheduler or CRON) to run periodically.
- **Customizable Sources**: Works with any website or file repository that follows a predictable URL structure. **(Not yet implemented, coming in the future)**
  
## Getting Started

### Prerequisites

- **PowerShell (v5 or higher)** for running the script.
- **Internet Access** to fetch files from the specified URLs.
- **Permission to Write** to the target directory where ISO files will be saved.

### Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/Laykon4/iso-auto-downloader.git
    cd iso-auto-downloader
    ```

2. Open the PowerShell script in a text editor to configure your preferred download URLs and local save paths.

3. Optional: Set up the script in Task Scheduler (Windows) for periodic checks.

### Usage

1. Run the script directly in PowerShell:

    ```powershell
    .\iso-auto-downloader.ps1
    ```

2. The script will:
   - Access the target URL directory.
   - Retrieve the latest ISO filename based on specified patterns.
   - Compare the latest remote version with any locally stored versions.
   - Download the new ISO file if an update is available.

### Configuration

Edit the following variables in the script as needed:
- `$debianUrl`: URL of the ISO file directory.
- `$localPath`: Directory path where downloaded ISOs will be stored.
- `$isoPattern`: Regular expression pattern for identifying ISO files in the directory.

### Example

An example configuration might look like this:

```powershell
$debianUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
$localPath = "C:\ISO\debian-latest.iso"
$isoPattern = "debian-[\d.]+-amd64-netinst\.iso"
```

## Scheduling Automatic Downloads

To set up automatic downloads:

### Windows Task Scheduler

1. Open Task Scheduler and create a new task.
2. Set the trigger (e.g., daily or weekly).
3. Under **Actions**, add the path to the PowerShell script as the executable.
4. Save and start the task to ensure it runs correctly.

    ___Not tested yet with cron___

## Troubleshooting

- **404 Error**: Verify that the URL and ISO pattern are correct and that the file exists.
- **Permission Denied**: Ensure that the script has write access to the local save path.
- **No Download Detected**: Confirm that the remote URL structure has not changed, or adjust `$isoPattern` as necessary.

## Contributing

Feel free to contribute by submitting issues or pull requests! Collaboration is welcome to improve URL handling, add support for more ISO sources, or streamline configuration.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.