<#
.SCRIPT NAME
    Chrome Bookmarks Backup & Restore using PowerShell

.SYNOPSIS
    PowerShell script to back up and restore Chrome bookmarks.

.DESCRIPTION
    This script allows users to back up and restore Chrome bookmarks in JSON format.
    It provides a simple way to save the bookmarks file to the Documents folder or 
    restore bookmarks from an existing backup, using a File Explorer dialog for selection.

.AUTHOR
    Mezba Uddin

.VERSION
    1.0

.LASTUPDATED
    2024-11-06

.NOTES
    - Requires PowerShell with Windows Forms available.
    - Chrome should be closed before running the script to avoid file lock issues.

#>

# Load Windows Forms for File Explorer dialog
Add-Type -AssemblyName System.Windows.Forms

# Get the current user's name
$userName = $env:USERNAME

# Define the path to Chrome's default bookmarks file
$chromeProfilePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
$bookmarksFile = Join-Path -Path $chromeProfilePath -ChildPath "Bookmarks"

# Define the default backup file path in the user's Documents folder
$defaultBackupDestination = "C:\Users\$userName\Documents\$userName - Chrome Bookmarks Backup.json"

# Ask user whether they want to backup or restore bookmarks
Write-Host "Please choose an option:"
Write-Host "1. Backup Chrome bookmarks"
Write-Host "2. Restore Chrome bookmarks"
$action = Read-Host -Prompt "Enter 1 or 2"

if ($action -eq "1") {
    # Backup bookmarks
    if (Test-Path $bookmarksFile) {
        # Copy the bookmarks file to the default backup destination
        Copy-Item -Path $bookmarksFile -Destination $defaultBackupDestination -Force
        Write-Host "Chrome bookmarks have been successfully backed up to $defaultBackupDestination"
    } else {
        Write-Host "Chrome bookmarks file not found. Please ensure Chrome is installed and has a profile with bookmarks."
    }
}
elseif ($action -eq "2") {
    # Restore bookmarks
    # Open a File Explorer dialog to select the backup file
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.InitialDirectory = "C:\Users\$userName\Documents"
    $fileDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
    $fileDialog.Title = "Select the Chrome bookmarks backup file to restore"

    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $backupFile = $fileDialog.FileName
        
        # Confirm the restoration with Y/N prompt (default to No)
        $confirmation = Read-Host -Prompt "Are you sure you want to overwrite your current bookmarks with this backup? (Y/N) [Default: N]"
        
        if ($confirmation -eq "Y") {
            # Copy the backup file to the Chrome profile folder, overwriting the current bookmarks file
            Copy-Item -Path $backupFile -Destination $bookmarksFile -Force
            Write-Host "Chrome bookmarks have been successfully restored from the selected backup."
        } else {
            Write-Host "Restoration canceled by user."
        }
    } else {
        Write-Host "No file was selected. Restoration canceled."
    }
}
else {
    Write-Host "Invalid selection. Please enter 1 to Backup or 2 to Restore."
}
