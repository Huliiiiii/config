# yazi
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file "$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

function mklink {
    param(
        [Parameter(Mandatory=$true)]
        [string]$From,

        [Parameter(Mandatory=$true)]
        [string]$To
    )
    
    New-Item -ItemType SymbolicLink -Path $To -Target $From
}

function _webui {
    $CurrentDir = Get-Location
    
    try {
        Set-Location F:\src\stable-diffusion-webui-reForge
        $ScriptPath = '.\webui-user.bat' 
        Start-Process -Wait -NoNewWindow cmd.exe -ArgumentList "/c $ScriptPath"
    } finally {
        Set-Location -Path $CurrentDir
    }
}

function proxy {
    $proxy = 'http://127.0.0.1:7890'
    $env:HTTP_PROXY = $proxy
    Write-Output "Set HTTP_PROXY to $env:http_proxy"
    $env:HTTPS_PROXY = $proxy
    Write-Output "Set HTTPS_PROXY to $env:https_proxy"
}

function unproxy {
    $env:HTTP_PROXY = $null
    $env:HTTPS_PROXY = $null

    Write-Output 'Reset proxy'
}

