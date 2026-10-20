param (
    [Parameter(Mandatory = \$true)]
    [string]\$MarkdownFilePath
)

if (-not (Test-Path \$MarkdownFilePath)) {
    Write-Error "Target markdown file path not found."
    return
}

\$Content = Get-Content -Path \(MarkdownFilePath -Raw\)HtmlPath = \(MarkdownFilePath -replace "\.md\)", ".html"

# Basic native regex translation engine to build an offline reader file
\$HtmlBody = \(Content -replace "^# (.*)\)", "<h1>`\$1</h1>" `
                     -replace "^### (.*)$", "<h3>`\$1</h3>" `
                     -replace "---", "<hr/>" `
                     -replace "!\[Image\](.*?)", "<img src='`$1' style='max-width:100%; border-radius:8px; margin: 15px 0;' /><br/>" `
                     -replace "\[(.*?)\](.*?)", "<a href='`$2' target='_blank'>`\$1</a>"

\$HtmlTemplate = @"
<!DOCTYPE html>
<html>
<head>
    <title>X Compiled Thread Reader</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; max-width: 650px; margin: 40px auto; padding: 0 20px; background-color: #0f1419; color: #e7e9ea; }
        h1 { border-bottom: 1px solid #2f3336; padding-bottom: 10px; color: #fff; }
        h3 { color: #1d9bf0; margin-top: 30px; }
        a { color: #1d9bf0; text-decoration: none; }
        a:hover { text-decoration: underline; }
        hr { border: 0; height: 1px; background: #2f3336; margin: 20px 0; }
    </style>
</head>
<body>
    \$HtmlBody
</body>
</html>
"@

HtmlTemplate | Out-File -FilePath HtmlPath -Encoding utf8
Write-Host "[*] Interactive offline HTML reader page compiled successfully: \$HtmlPath" -ForegroundColor Green
