#Modules file created by Mark Bakker, this is module for logging purposes, like writing to file, console and sending mail
Function Write-MRBMessage {
	Param(
		[Parameter(Mandatory = $true)] $Message,
		[Parameter(Mandatory = $true)]
        [ValidateSet('INFO','WARNING','ERROR')]
        [string]$Category
		#[Parameter(Mandatory = $true)] $LogFile
        #[Parameter(Mandatory = $false)][boolean]$NoNewLine = $true
	)
	Try	{
		$Date = ((Get-Date -f dd-MM-yyyy-HH:mm:ss).tostring())
        $Cat = $Null
        switch ($Category) { 
	        "ERROR" {
                $MessageColor = 'red'
                $Cat = 'ERR'
            }
	        "WARNING" {
                $MessageColor = 'yellow'
                $Cat = 'WAR'
            } 
	        "INFO" {
                $MessageColor = 'Green'
                $Cat = 'INF'
            } 
	        default {Write-Host "The category of the message could not be determined" -ForegroundColor Red -BackgroundColor Black}
	    }

        Write-Host -Object "[" -NoNewline -ForegroundColor Cyan
        Write-Host -Object $Date -NoNewline -ForegroundColor White
        Write-Host -Object "]" -NoNewline -ForegroundColor Cyan
        Write-Host -Object " - " -NoNewline -ForegroundColor Green

        Write-Host -Object "[" -NoNewline -ForegroundColor Cyan
        Write-Host -Object $Cat -NoNewline -ForegroundColor White
        Write-Host -Object "]" -NoNewline -ForegroundColor Cyan

        Write-Host -Object " - " -NoNewline -ForegroundColor Green
        Write-Host -Object "[" -NoNewline -ForegroundColor Cyan
        Write-Host -Object $Message -NoNewline -ForegroundColor $MessageColor

        if ($NoNewLine) {
            Write-Host -Object "]" -ForegroundColor Cyan -NoNewline
        }
        else {
            Write-Host -Object "]" -ForegroundColor Cyan
        }

		#$Message = $Date + "   " + $Message
		#Out-File $LogFile -encoding ASCII -input $message -append
        
        $Date = $Null
        $Message = $Null
        $MessageColor = $Null
	}
	Catch {
		Write-Host "ERROR While trying to write message : $($_.Exception.Message), SCRIPT QUITS with ERROR -1 !!" -BackgroundColor Black -ForegroundColor Red
	}
}

Function Send-MRBMail {
    Param(
        [Parameter(Mandatory = $true)] $Message,
        [Parameter(Mandatory = $true)] $Subject,
        [Parameter(Mandatory = $false)] $Attach,
        [Parameter(Mandatory = $true)] $smtpserver,
        [Parameter(Mandatory = $true)] $MailRecipient
    )
	Try	{
        $MailSender = "Powershell-Automation@example.com"
        if ($Attach) {
		    Send-MailMessage -To $MailRecipient -From $MailSender -Body $Message -Subject $Subject -SmtpServer $smtpServer -Priority High -ErrorAction Stop -Attachments $Attach
        }
        else {
            Send-MailMessage -To $MailRecipient -From $MailSender -Body $Message -Subject $Subject -SmtpServer $smtpServer -Priority High -ErrorAction Stop
        }
	}
	Catch {
        Write-Warning "ERROR While sending e-mail, the error returned = $($_.Exception.Message) @line number : $($_.InvocationInfo.ScriptLineNumber)"
	}
}


Function Send-MRBMail2 {
    Param(
        [Parameter(Mandatory = $true)] $Message,
        [Parameter(Mandatory = $true)] $Subject,
        [Parameter(Mandatory = $false)] $Attach,
        [Parameter(Mandatory = $true)] $smtpserver,
        [Parameter(Mandatory = $true)] $MailRecipient
    )
	Try	{
        $MailSender = "Powershell-Automation@example.com"
        if ($Attach) {
		    Send-MailMessage -To $MailRecipient -From $MailSender -Body $Message -Subject $Subject -SmtpServer $smtpServer -Priority High -ErrorAction Stop -Attachments $Attach
        }
        else {
            Send-MailMessage -To $MailRecipient -From $MailSender -Body $Message -Subject $Subject -SmtpServer $smtpServer -Priority High -ErrorAction Stop
        }
	}
	Catch {
        Write-Warning "ERROR While sending e-mail, the error returned = $($_.Exception.Message) @line number : $($_.InvocationInfo.ScriptLineNumber)"
	}
}



