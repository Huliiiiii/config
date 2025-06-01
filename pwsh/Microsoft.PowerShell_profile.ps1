[console]::OutputEncoding = [console]::InputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()

. "$PSScriptRoot/Src/PSRL.ps1"

@(
    {
        $env:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
        Invoke-Expression (&starship init powershell)
    },
    {
        Invoke-Expression "$(direnv hook pwsh)"
    },
    {
        Invoke-Expression (&just --completions powershell | Out-String)
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
    {
        # set path alias
        $shell = New-Object -ComObject Shell.Application

        $global:downloads = $shell.Namespace('shell:Downloads').Self.Path
        $global:documents = [System.Environment]::GetFolderPath('MyDocuments')
        $global:music = [System.Environment]::GetFolderPath('MyMusic')
    },
    (. "$PSScriptRoot/Src/Aliases.ps1"),
    (. "$PSScriptRoot/Src/Function.ps1"),
    (. "$PSScriptRoot/Src/Completion/bun.ps1"),
    {}
) | ForEach-Object {
    Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action $_
} | Out-Null
