param(
    [string]$StaticSearchRoot = "",
    [string]$ConfigPath = ""
)

$ErrorActionPreference = "Stop"

function Resolve-ProjectPath {
    param([string]$RelativePath)
    return Join-Path $script:ProjectRoot $RelativePath
}

function Convert-ToStaticSearchPath {
    param([string]$Path)
    $resolved = (Resolve-Path -LiteralPath $Path).Path
    if ($IsWindows -or $resolved -match "^[A-Za-z]:\\") {
        return "/" + ($resolved -replace "\\", "/")
    }
    return $resolved
}

function Get-AntClasspath {
    $jars = New-Object System.Collections.Generic.List[string]
    if ($env:ANT_HOME) {
        foreach ($name in @("ant.jar", "ant-launcher.jar")) {
            $path = Join-Path $env:ANT_HOME "lib\$name"
            if (Test-Path -LiteralPath $path) { $jars.Add((Resolve-Path -LiteralPath $path).Path) }
        }
    }
    foreach ($path in @(
        "C:\Program Files\Android\Android Studio\lib\ant\lib\ant.jar",
        "C:\Program Files\Android\Android Studio\plugins\gradle\lib\ant\ant-launcher.jar"
    )) {
        if (Test-Path -LiteralPath $path) {
            $resolved = (Resolve-Path -LiteralPath $path).Path
            if (-not $jars.Contains($resolved)) { $jars.Add($resolved) }
        }
    }
    $antContrib = Resolve-ProjectPath "tools\lib\ant-contrib-1.0b3.jar"
    if (-not (Test-Path -LiteralPath $antContrib)) { throw "Missing $antContrib" }
    $jars.Add((Resolve-Path -LiteralPath $antContrib).Path)
    if ($jars.Count -eq 1) { throw "Could not find Apache Ant jars via ANT_HOME or Android Studio." }
    return ($jars -join [System.IO.Path]::PathSeparator)
}

function Ensure-XhtmlNamespace {
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    $changed = 0
    Get-ChildItem -LiteralPath (Resolve-ProjectPath "HTML") -Recurse -File -Filter "*.html" |
        Where-Object { $_.FullName -notlike "*\staticSearch\*" } |
        ForEach-Object {
            $text = [System.IO.File]::ReadAllText($_.FullName)
            if ($text -notmatch '<html\s+[^>]*xmlns=' -and $text -match '<html(?:\s|>)') {
                $text = [regex]::Replace($text, '<html(?=\s|>)', '<html xmlns="http://www.w3.org/1999/xhtml"', 1)
                [System.IO.File]::WriteAllText($_.FullName, $text, $utf8NoBom)
                $changed++
            }
        }
    Write-Host "XHTML namespace check complete. Updated $changed file(s)."
}

function New-PatchedRunner {
    param([string]$SourceRoot)
    $toolsDir = Resolve-ProjectPath "tools"
    $runner = Join-Path $toolsDir ".staticSearch-runner-$PID"
    if (Test-Path -LiteralPath $runner) {
        $resolvedRunner = (Resolve-Path -LiteralPath $runner).Path
        if (-not $resolvedRunner.StartsWith((Resolve-Path $toolsDir).Path, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove unexpected runner path: $resolvedRunner"
        }
        Remove-Item -LiteralPath $resolvedRunner -Recurse -Force
    }
    Copy-Item -LiteralPath $SourceRoot -Destination $runner -Recurse
    $buildXml = Join-Path $runner "build.xml"
    $text = [System.IO.File]::ReadAllText($buildXml)
    $text = $text -replace "`r?`n\s*<arg value=`"ssPatternsetFile=\$\{ssPatternsetFile\}`"/>", ""
    [System.IO.File]::WriteAllText($buildXml, $text, (New-Object System.Text.UTF8Encoding $false))
    return $runner
}

function New-PortableConfig {
    param(
        [string]$SourceConfig,
        [string]$SourceRoot
    )
    $target = Resolve-ProjectPath ".config_staticSearch.windows-$PID.xml"
    $text = [System.IO.File]::ReadAllText($SourceConfig)
    $stopwords = [System.Security.SecurityElement]::Escape((Convert-ToStaticSearchPath (Join-Path $SourceRoot "xsl\english_stopwords.txt")))
    $dictionary = [System.Security.SecurityElement]::Escape((Convert-ToStaticSearchPath (Join-Path $SourceRoot "xsl\english_words.txt")))
    $text = [regex]::Replace($text, '<stopwordsFile>.*?</stopwordsFile>', "<stopwordsFile>$stopwords</stopwordsFile>")
    $text = [regex]::Replace($text, '<dictionaryFile>.*?</dictionaryFile>', "<dictionaryFile>$dictionary</dictionaryFile>")
    [System.IO.File]::WriteAllText($target, $text, (New-Object System.Text.UTF8Encoding $false))
    return $target
}

function Protect-WindowsReservedStaticSearchNames {
    $output = Resolve-ProjectPath "HTML\staticSearch"
    $reservedNames = @("con", "prn", "aux", "nul") +
        (1..9 | ForEach-Object { "com$_" }) +
        (1..9 | ForEach-Object { "lpt$_" })
    foreach ($name in $reservedNames) {
        $source = Join-Path $output "stems\$name.json"
        $target = Join-Path $output "stems\_$name.json"
        if (Test-Path -LiteralPath $source) {
            Copy-Item -LiteralPath $source -Destination $target -Force
            Remove-Item -LiteralPath $source -Force
            Write-Host "Renamed Windows-reserved stem $name.json to _$name.json."
        }
    }
    $debugJs = Join-Path $output "ssSearch-debug.js"
    $text = [System.IO.File]::ReadAllText($debugJs)
    $text = $text.Replace("self.jsonDirectory + 'stems/' + stemsToFind[i] + this.versionString + '.json'", "self.jsonDirectory + 'stems/' + (/^(con|prn|aux|nul|com[1-9]|lpt[1-9])$/i.test(stemsToFind[i]) ? '_' + stemsToFind[i] : stemsToFind[i]) + this.versionString + '.json'")
    [System.IO.File]::WriteAllText($debugJs, $text, (New-Object System.Text.UTF8Encoding $false))
    $minJs = Join-Path $output "ssSearch.js"
    $text = [System.IO.File]::ReadAllText($minJs)
    $text = $text.Replace('c.jsonDirectory+"stems/"+b[e]+this.versionString+".json"', 'c.jsonDirectory+"stems/"+(/^(con|prn|aux|nul|com[1-9]|lpt[1-9])$/i.test(b[e])?"_"+b[e]:b[e])+this.versionString+".json"')
    [System.IO.File]::WriteAllText($minJs, $text, (New-Object System.Text.UTF8Encoding $false))
}

function Sync-SearchIndexPage {
    $source = Resolve-ProjectPath "HTML\search.html"
    $targetDir = Resolve-ProjectPath "HTML\search"
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    $text = [System.IO.File]::ReadAllText($source)
    if ($text -notmatch '<base\s') { $text = $text.Replace("<head>", "<head>`r`n    <base href=`"../`"/>") }
    [System.IO.File]::WriteAllText((Join-Path $targetDir "index.html"), $text, (New-Object System.Text.UTF8Encoding $false))
    Write-Host "Updated HTML/search/index.html."
}

$script:ProjectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
if (-not $StaticSearchRoot) { $StaticSearchRoot = Resolve-ProjectPath "..\..\staticseachDocs\staticSearch-1.4.7\staticSearch-1.4.7" }
if (-not $ConfigPath) { $ConfigPath = Resolve-ProjectPath "config_staticSearch.xml" }
$StaticSearchRoot = (Resolve-Path -LiteralPath $StaticSearchRoot).Path
$ConfigPath = (Resolve-Path -LiteralPath $ConfigPath).Path
$java = (Get-Command java.exe).Source
$antClasspath = Get-AntClasspath

Ensure-XhtmlNamespace
$runner = New-PatchedRunner -SourceRoot $StaticSearchRoot
$portableConfig = New-PortableConfig -SourceConfig $ConfigPath -SourceRoot $StaticSearchRoot
try {
    Write-Host "Running Project Endings StaticSearch..."
    & $java -Xmx4g -cp $antClasspath org.apache.tools.ant.Main -f (Join-Path $runner "build.xml") "-DssConfigFile=$(Convert-ToStaticSearchPath $portableConfig)" allButValidate
    if ($LASTEXITCODE -ne 0) { throw "StaticSearch build failed with exit code $LASTEXITCODE." }
    Protect-WindowsReservedStaticSearchNames
    Sync-SearchIndexPage
    $output = Resolve-ProjectPath "HTML\staticSearch"
    Write-Host "StaticSearch build complete."
    Write-Host "Stem JSON files: $([System.IO.Directory]::GetFiles((Join-Path $output 'stems'), '*.json').Length)"
    Write-Host "Filter JSON files: $([System.IO.Directory]::GetFiles((Join-Path $output 'filters'), '*.json').Length)"
}
finally {
    if (Test-Path -LiteralPath $runner) {
        $resolvedRunner = (Resolve-Path -LiteralPath $runner).Path
        if ($resolvedRunner.StartsWith((Resolve-Path (Resolve-ProjectPath "tools")).Path, [StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item -LiteralPath $resolvedRunner -Recurse -Force
            Write-Host "Removed temporary StaticSearch runner."
        }
    }
    if (Test-Path -LiteralPath $portableConfig) {
        Remove-Item -LiteralPath $portableConfig -Force
        Write-Host "Removed temporary portable StaticSearch configuration."
    }
}
