<#
.SYNOPSIS
    X (Twitter) Thread Compiler to Markdown.
.DESCRIPTION
    Compiles a public X thread into a clean, markdown document without requiring API keys.
.EXAMPLE
    .\Compiler.ps1 -ThreadUrl "https://x.com"
#>

param (
    [Parameter(Mandatory = \$true)]
    [string]\$ThreadUrl
)

# Force TLS 1.2/1.3 for secure connection bypass
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

# Convert standard x.com / twitter.com URLs to FXTwitter/FixTweet syndication endpoint to bypass modern login walls
if (\$ThreadUrl -match "https://(www\.)?(x|twitter)\.com/(?<user>[^/]+)/status/(?<id>\d+)") {
    \$Username = \(Matches['user']\)StatusId = \(Matches['id']\)ApiUrl = "https://fxtwitter.com\(Username/status/\)StatusId"
} else {
    Write-Error "Invalid X (Twitter) Status URL format."
    return
}

Write-Host "[*] Fetching thread data via syndication gateway..." -ForegroundColor Cyan

try {
    # Request raw JSON object payload containing the main tweet and its conversational replies
    \(Response = Invoke-RestMethod -Uri\)ApiUrl -Method Get -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    
    if (-not \(Response -or -not\)Response.tweet) {
        Write-Error "Failed to parse API metadata payload."
        return
    }

    \(MainTweet =\)Response.tweet
    \(OutputDirectory = Join-Path\)PSScriptRoot "CompiledThreads"
    if (-not (Test-Path \$OutputDirectory)) { New-Item -ItemType Directory -Path \(OutputDirectory \vert{} Out-Null }\)SafeFileName = "\((\)Username)_\((\)StatusId).md"
    \$OutputPath = Join-Path \(OutputDirectory\)SafeFileName

    # Initialize Markdown Buffer
    \(MarkdownBuffer = @()\)MarkdownBuffer += "# X Thread by @\$Username"
    \$MarkdownBuffer += "Original Link: [\(ThreadUrl](\)ThreadUrl)"
    \$MarkdownBuffer += "Compiled on: \$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    \$MarkdownBuffer += "---`n"

    # Process Main Starting Tweet
    Write-Host "[+] Processing Root Tweet..." -ForegroundColor Green
    \$MarkdownBuffer += "### [Tweet 1]"
    \(MarkdownBuffer +=\)MainTweet.text
    if (\(MainTweet.media -and\)MainTweet.media.all) {
        foreach (\(mediaItem in\)MainTweet.media.all) {
            if (\$mediaItem.type -eq "photo") {
                \$MarkdownBuffer += "![Image](\((\)mediaItem.url))"
            }
        }
    }
    \$MarkdownBuffer += "`n---"

    # Attempt to extract subsequent replies from the same author inside the same data packet
    # Many modern proxy layers embed continuous replies by identical Author IDs in a chronological list
    if ($Response.thread) {
        $ThreadTweets = $Response.thread | Where-Object { $_.author.id -eq $MainTweet.author.id }
        $Count = 2
        
        foreach ($reply in $ThreadTweets) {
            Write-Host "[+] Appending Thread Piece #$Count..." -ForegroundColor Green
            $MarkdownBuffer += "### [Tweet $Count]"
            $MarkdownBuffer += $reply.text
            if ($reply.media -and $reply.media.all) {
                foreach ($mediaItem in $reply.media.all) {
                    if ($mediaItem.type -eq "photo") {
                        $MarkdownBuffer += "![Image]($($mediaItem.url))"
                    }
                }
            }
            $MarkdownBuffer += "`n---"
            \$Count++
        }
    }

    # Save to disk
    \(MarkdownBuffer \vert{} Out-File -FilePath\)OutputPath -Encoding utf8
    Write-Host "[SUCCESS] Thread compiled perfectly into: \$OutputPath" -ForegroundColor Gold

} catch {
    Write-Error "Error compiling thread structural node. Exception Details: \$_"
}
