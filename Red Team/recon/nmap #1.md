## Nmap Lista de Comandos Guía

<img src="https://i.imgur.com/0HvAW3g.png" alt="Nmap Guia" width="400" height="300">


Nmap (Network Mapper) simplemente **es un escáner de red basado en (software libre) y de código abierto, el cual se utiliza para escanear redes así como durante una de las fases de Pentesting puntualmente en la fase de reconocimiento**, el cual permite al Tester descubrir hosts y servicios de una red, enviando paquetes para posteriormente analizar sus respuestas.

Veremos unos cuantos comandos de Nmap, pasando de básicos pasivos a los que se usan comúnmente durante un reconocimiento pasarás de **(Bot to Hero)**.

- Escaneo de un host

`nmap www.tusitio.com`

- **Escaneo para detectar el OS y servicios**

`nmap -A 127.0.0.1`

- **Simple / Escaneo de una ip**

`nmap 127.0.0.1`

- **Escaneo de una sub-red**

`nmap 127.0.0.1/24`

- **Escaneo de servicios estándar**

`nmap -sV 127.0.0.1`

- **Escaneo de un rango de direcciones**

`nmap 127.0.0.1-20`

- **Escaneo de un solo puerto**

`nmap -p 22 127.0.0.1`

- **Escaneo de un rango de puertos**

`nmap -p 1-100 127.0.0.1`

- **Escaneo de múltiples ips / guardados en un archivo de texto**

`nmap -iL lista-de-ips.txt`

- **Escaneo de todos los puertos total (65535)**

`nmap -p- 127.0.0.1`

- **Escaneo de los 100 puertos más comunes**

`nmap -F 127.0.0.1`

- **Escaneo usando el TCP SYN (por default)**

`nmap -sS 127.0.0.1`

- **Escaneo usando una conexión TCP**

`nmap -sT 127.0.0.1`

- **Escaneo de puertos UDP**

`nmap -sU -p 123,161,162 127.0.0.1`

- **Escaneo de puertos mas comunes e ignorar el descubrimiento DNS**

`nmap -Pn -F 127.0.0.1`

- **Escaneo y detección del banner**

`nmap -sV --version-duration 0 127.0.0.1`

- **Escaneo y detección del banner más agresiva**

`nmap -sV --version-Intensity 5 127.0.0.1`

- **Exportar los resultados en un archivo predeterminado**

`nmap -oN escaneo.txt 127.0.0.1`

- **Exportar los resultados en un archivo xml**

`nmap -oX escaneo.xml 127.0.0.1`

- **Exportar los resultados en un archivo grepeable**

`nmap -oG escaneo.txt 127.0.0.1`

- **Exportar los resultados en todos los formatos**

`nmap -oA escaneo 127.0.0.1`

- **Escanear usando los scripts predeterminados**

`nmap -sV -sC 127.0.0.1 /`

- **Escanear con un conjunto de scripts**

`nmap -sV --script=smb* 127.0.0.1`

- **Escanear usando un script específico**

`nmap -sV --script=http-shellshock 127.0.0.1`

- **Escaneo de aplicaciones web en rutas conocidas**

`nmap --script=http-enum 127.0.0.1/24`

- **Detección de los encabezados HTTP en todos los servicios web**

`nmap --script=http-headers 127.0.0.1/24`

- **Obtener la mayor información sobre la dirección IP**

`nmap --script=asn-query,whois,ipgeolocation-maxmind 127.0.0.1/24`

# **Mis Comandos Nmap**

Aunque prácticamente con la lista de comandos previamente publicados se podría realizar una lista muy extensa de combinaciones, 
al momento que requieras realizar un reconocimiento de host y puertos, logrando convertirte en un (**samurai**) del reconocimiento. 
Te dejo una lista de los comandos que más suelo usar.

```
nmap -sC -sV -O -T4 -n -Pn -vvv -oN  resultados 127.0.0.1
nmap -sC -sV -O -T4 -n -Pn -p- -vvv -oN resultados 127.0.0.1
nmap --min-rate 10000 -p- -vvv -oN resultados 127.0.0.1
nmap -sT --min-rate 10000 -p- -vvv -oN  resultados 127.0.0.1
nmap -sC -sV -vvv -oN resultados 127.0.0.1
```
