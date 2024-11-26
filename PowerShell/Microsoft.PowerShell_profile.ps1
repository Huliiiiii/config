$env:HOME = $HOME
$ConfigPath = "D:\config"

$_src = "$ConfigPath\Powershell\Src"

Set-Alias sh "C:\Program Files\Git\git-bash.exe"

ssh-add "$Home/.ssh/id_rsa" *> $null

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
    # {
    #     Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    #         param($wordToComplete, $commandAst, $cursorPosition)
    #         $Local:word = $wordToComplete.Replace('"', '""')
    #         $Local:ast = $commandAst.ToString().Replace('"', '""')
    #         winget complete --word "$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    #             [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    #         }
    #     }
    # },
    (. "$_src/Aliases.ps1"),
    # PSReadline Settings
    (. "$_src/Function.ps1"),
    (. "$_src/PSRL.ps1" ),
    # bun auto complete
    (. "$_src/Completion/bun.ps1"),
    (Invoke-Expression  (&just --completions powershell | Out-String)),
    (Invoke-Expression "$(direnv hook pwsh)")
)  | ForEach-Object { Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action $_ }| Out-Null
