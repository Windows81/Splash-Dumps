param(
	[Parameter(Mandatory = $true)][string]$n,
	[Parameter(Mandatory = $false)][uint]$sr = 44100,
	[Parameter(Mandatory = $false)][string]$fl = 'anull')

$e = $p = @()
$l = Get-ChildItem dump -Name "$($n)_*"
for ($c = $q = 0; $c -lt 48; $q = 0 * $c++) {
	$p += ($f = New-TemporaryFile)
	$r = Get-Random -min 0 -max 7 -count 6
	$a = $r | ForEach-Object { $l[$_ + 20 * ($_ -ge 4) + 4 * ($q++)] }
	$d = $a | ForEach-Object { "-i `"dump/$_`"" }
	$t = "$d -filter_complex amix=inputs=$($a.Count):duration=shortest,$fl,asetrate=$sr -y -loglevel panic -f wav $f"
	$e += (Start-Process ffmpeg ($t -join " ") -nonewwindow -passthru).id
}

Wait-Process -Id $e -ErrorAction SilentlyContinue
$f = New-TemporaryFile
$p | ForEach-Object { "file $($_.FullName.Replace("\","/"))" } |
ffmpeg -safe 0 -protocol_whitelist "file,crypto,data,pipe" -f concat -i - -f wav $f -y -loglevel panic
ffplay $f -loop -1 -af volume=10dB