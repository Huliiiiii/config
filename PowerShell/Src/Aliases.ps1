function Get-SR-History {
    Invoke-Expression(Invoke-RestMethod 'https://xingqiong-oss.oss-cn-hangzhou.aliyuncs.com/pc/down/s_gf.ps1')
}

Set-Alias sr-data Get-SR-History

function Start-Obsidian {
    $cmd = 'Start-Process	"C:\Users\Fox\AppData\Local\Programs\Obsidian\Obsidian.exe"'
    New-Window($cmd)
}

Set-Alias obsidian Start-Obsidian
