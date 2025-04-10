import-module /modules/logging.psm1
Write-MRBMessage -Message "From my logging function" -Category INFO
Write-MRBMessage -Message "From my logging function" -Category WARNING
Write-MRBMessage -Message "From my logging function" -Category ERROR
Write-MRBMessage -Message "SCRIPT FAILED!!!!!!!" -Category ERROR