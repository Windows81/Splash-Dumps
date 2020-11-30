param(
	[Parameter(Mandatory=$true)][string]$n,
	[Parameter(Mandatory=$true)][uint]$r=44100,
	[Parameter(Mandatory=$false)][string]$fl='anull')

# $n="ABSTRACT"; $r=44100 # Example

$e=$p=@();for($c=0;$c-lt48;$c++){$p+=($f=New-TemporaryFile);$a=ls dump -Name "$n*";$q=0;$a=(random -max 7 -min 0 -count 6)|%{$a[$_+6*($q++)]}; $t=(($a|%{"-i `"dump/$_`""}) + "-filter_complex amix=inputs=$($a.Count):duration=shortest,$fl,asetrate=$r -y -loglevel panic -f wav $f");$e+=(Start-Process ffmpeg ($t -join " ") -nonewwindow -passthru).id};Wait-Process -Id $e -ErrorAction SilentlyContinue;$f=New-TemporaryFile;$p|%{"file $($_.FullName.Replace("\","/"))"}|ffmpeg -safe 0 -protocol_whitelist "file,crypto,data,pipe" -f concat -i - -f wav $f -y -loglevel panic; ffplay $f -loop -1 -af volume=10dB