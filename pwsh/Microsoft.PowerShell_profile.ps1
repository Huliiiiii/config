$env:HOME = $HOME

Set-Alias sh 'C:\Program Files\Git\git-bash.exe'

function wezssh() {
    param(
        [Parameter(Position = 0)]
        [string]$target
    )

    Start-Process wezterm -WindowStyle Hidden -ArgumentList "ssh $target"
}

ssh-add "$Home/.ssh/id_rsa" *> $null

function dl {
    param (
        [string]$url
        # [string[]]$ExtraArgs
    )

    if ([string]::IsNullOrWhiteSpace($url)) {
        Write-Error 'Error: URL cannot be empty.'
        return
    }

    do {
        Write-Host "Trying to download $url..."
        wget -c -t 0 --retry-connrefused --waitretry=5 @ExtraArgs $url
        $success = $LASTEXITCODE
        if ($success -ne 0) {
            Write-Host 'Download failed. Retrying in 5 seconds...'
            Start-Sleep -Seconds 5
        }
    } while ($success -ne 0)

    Write-Host 'Download completed successfully!'
}

[console]::OutputEncoding = [console]::InputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()

@(
    {
        $env:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
        Invoke-Expression (&starship init powershell)
    },
    {
        $shell = New-Object -ComObject Shell.Application

        $global:downloads = $shell.Namespace('shell:Downloads').Self.Path
        $global:documents = [System.Environment]::GetFolderPath('MyDocuments')
        $global:music = [System.Environment]::GetFolderPath('MyMusic')
    },
    {
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            param($wordToComplete, $commandAst, $cursorPosition)
            $Local:word = $wordToComplete.Replace('"', '""')
            $Local:ast = $commandAst.ToString().Replace('"', '""')
            winget complete --word "$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    },
    { . "$PSScriptRoot/Src/Aliases.ps1" },
    # PSReadline Settings
    { . "$PSScriptRoot/Src/Function.ps1" },
    { . "$PSScriptRoot/Src/PSRL.ps1" },
    # bun auto complete
    { . "$PSScriptRoot/Src/Completion/bun.ps1" },
    { Invoke-Expression (&just --completions powershell | Out-String) },
    { Invoke-Expression "$(direnv hook pwsh)" },
    {}
) | ForEach-Object { Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action $_ } | Out-Null
