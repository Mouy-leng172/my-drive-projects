param(
    [switch]$Run
)

# Safe backup script: by default it previews (no copy). Use -Run to perform the backup.

$date = Get-Date -Format yyyyMMdd
$src = 'C:\'
$dest = "D:\Backup_C_$date\"
$log = "D:\Backup_C_${date}_robocopy.log"

$exclusionsFiles = @('pagefile.sys','hiberfil.sys','swapfile.sys')
$exclusionsDirs = @('System Volume Information','$RECYCLE.BIN')

$baseArgs = @('/E','/Z','/R:3','/W:5','/COPYALL','/XJ','/XA:SH','/TEE')
$xfArgs = foreach ($f in $exclusionsFiles) { "/XF `"$f`"" }
$xdArgs = foreach ($d in $exclusionsDirs) { "/XD `"$d`"" }

$previewSwitch = '/L'
if ($Run) { $previewSwitch = '' }

$cmd = "robocopy `"$src`" `"$dest`" $previewSwitch " + ($baseArgs -join ' ') + ' ' + ($xfArgs -join ' ') + ' ' + ($xdArgs -join ' ')

Write-Host "Destination folder: $dest"
Write-Host "Log: $log"
Write-Host ""
Write-Host "Robocopy command (shown):"
Write-Host $cmd
Write-Host ""

if ($Run) {
    Write-Host "Running robocopy..."
    # Use cmd.exe to ensure robocopy runs with conventional argument parsing
    cmd.exe /c $cmd
    Write-Host "Robocopy finished. Check the log at $log"
} else {
    Write-Host "Preview only (no files copied). Rerun with -Run to execute the backup."
}
