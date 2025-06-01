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
        [Parameter(Mandatory = $true)]
        [string]$From,

        [Parameter(Mandatory = $true)]
        [string]$To
    )

    New-Item -ItemType SymbolicLink -Path $To -Target $From
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

function wezssh() {
    param(
        [Parameter(Position = 0)]
        [string]$target
    )

    Start-Process wezterm -WindowStyle Hidden -ArgumentList "ssh $target"
}

function dl {
    param (
        [string]$url,
        [string[]]$ExtraArgs
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
