## Tunneling el arte de encapsular la red


<img src="https://i.imgur.com/dUGlt6l.png" alt="Tunneling Red Team" width="400" height="300">


El objetivo principal del **tunneling** **es proteger el tráfico de red y** **encapsular un protocolo de red sobre otro protocolo de red encapsulador para así crear un túnel de información dentro de la red**, el cual se utiliza comúnmente para conexiones de red remotas, lo que permite acceder a recursos de red protegidos remotamente. Siendo una de las técnicas mas importantes durante las evaluaciones.

Esto permite que durante el proceso se puedan aplicar técnicas de pivoting o reenvío de puertos para utilizar un host pivote dentro de la red interna, como una máquina de lanzadera y permitir conectarse con otras redes no enrutadas como dispositivos críticos y otros del directorio activo, incluyendo el controlador AD y todo el perímetro.

Contextualizando, el tunneling y las técnicas de pivoting llegan hacer una de las técnicas cruciales al momento de realizar las pruebas por parte del «auditor», lo que permite evaluar la resistencia y fortaleza de las infraestructuras de red.

## **Contexto del tunneling en el Red Team**

El «auditor» tiene que ser capaz de superar los límites de la red, para de esta forma tratar de acceder a información y recursos confidenciales en entornos altamente protegidos, durante la evaluación por lo general se toquetea primero es el servidor web y el objetivo es abrirse camino usando las técnicas de tunneling.

## **Técnicas para realizar un buen tunneling**

Aunque existen una gran variedad de técnicas para realizarlo, podemos centrarnos en algunas de las que en mi punto de vista son las mejores y las que uso de manera habitual cuando tengo que proceder con algún proceso. Básicamente tocaremos ciertos protocolos o apoyándonos en algunas de las herramientas que en mi opinión van mejor que otras, aunque entre gustos y colores cada quien.

## **Socat Tunneling**

Podríamos crear un túnel TCP entre un puerto local (xxxx) y un puerto remoto 80 en la dirección IP x.x.x.x utilizando la herramienta de red «socat». La técnica crea un túnel TCP que reenvía todas las conexiones entrantes en el puerto local (xxxx) al puerto remoto 80 en la dirección IP x.x.x.x. Este tipo de túnel se puede utilizar para lograr enrutar el tráfico de red a través de una conexión cifrada o para saltar restricciones de firewall o de red, entre otros usos.

```
socat TCP-LISTEN:1234,fork TCP:2.2.2.2:80
```

- «**TCP-LISTEN:1234**«: Indica que socat debe escuchar en el puerto 1234 para nuevas conexiones entrantes.
- «**fork**«: Confirmar que el socat debe manejar las conexiones entrantes en un proceso separado.
- «**TCP:2.2.2.2:80**«: Esta opción indica que socat debe conectarse al puerto 80 en la dirección IP 2.2.2.2.

## **Reverse SSL Tunneling**

Crear un túnel SSL inverso que permita redirigir el tráfico desde un puerto remoto en un servidor a un puerto local en tu máquina, lo que establece una conexión SSL/TLS con un servidor remoto y poder lograr que todo el tráfico vaya desde el servidor al puerto local 80 de tu máquina a través de un tunel de «openssl s_client» a «nc» así como a su vez, monitorear el tráfico de red entrante en el puerto local 80 para fines de depuración o análisis.

```
openssl s_client -connect remote-server:1234 -servername x.x.x.x -quiet | nc -l -p 80 > logfile.log
```

- **openssl s_client -connect remote-server:1234 -servername example.com -quiet**: Esta parte del comando establece una conexión SSL con el servidor remoto y redirige el tráfico entrante al puerto local 80.
- **| nc -l -p 80 > logfile.log**: Aquí confirmamos que el tráfico entrante se redirige del puerto local 80 a un archivo de registro llamado «logfile.log», en cuanto al archivo puedes cambiar el nombre del archivo y el directorio según sea necesario.

## **Dynamic SSH tunneling**

Con esta técnica se puede crear un túnel SSH dinámico que permite al «auditor» enrutar todo el tráfico de red a través de una conexión SSH segura, usando el método de **Dynamic SSH tunneling** todo el tráfico de red viajara través de la conexión SSH cifrada hacia el servidor remoto, lo que proporciona una capa adicional de seguridad en redes «inseguras o públicas».

Aunque el objetivo principal es el permitir acceder a contenido restringido geográficamente, ya que la característica de esta conexión es simular parece estar originada en el servidor remoto en lugar de en la ubicación actual. Con el envió dinámico de puertos, se lograría abrir un puerto local en la máquina pivote, el protocolo SSH escuchará en este puerto y se comportará como un servidor proxy SOCKS (SOCKS4 o SOCKS5).

```
ssh user@ssh_server -D 127.0.0.1:1337 -N
```

- **ssh user@ssh_server**: Aquí establecemos la conexión SSH al servidor remoto Ej:»192.168.2.105″ con el nombre de usuario.
- **D 127.0.0.1:1337**: Con esta opción iniciamos un túnel dinámico SSH y especificamos el puerto local «1337» donde se va a escuchar para las conexiones SOCKS entrantes puedes usar cualquier puerto disponible.
- **N**: Comunicamos al protocolo SSH que no ejecute un comando remoto después de la autenticación, es decir no abra una sesión de shell remota. (**Ya que el objetivo es enviar todas solicitudes a todas las redes accesibles desde la máquina pivote a través del proxy usando CURL**)

```
curl --head [http://10.10.10.10](http://10.10.10.10/) --proxy socks5://127.0.0.1:1337
HTTP/1.1 302 Found
Date: Sat, 05 Nov 2022 12:30:45 GMT
Server: Apache/2.4.39 (Win64) OpenSSL/1.1.1c PHP/8.1
X-Powered-By: PHP/8.1
Location: http://10.10.10.10/panel/
Content-Type: text/html; charset=UTF-8
```

## **Proxychains** **Tunneling**

Proxychains es una de mis herramienta favoritas durante alguna «auditoria» esta permite que el tráfico de red pase a través de uno o más servidores bajo proxy SOCKS. Esta es una herramienta muy útil cuando no puede pasar a través de un proxy de forma nativa, en pocas palabras puede hacer que una aplicación se comunique a través de una cadena de servidores proxy en lugar de conectarse directamente a un servidor.

Esta herramienta admite varios tipos de servidores proxy, incluyendo proxies HTTP, SOCKS4 y SOCKS5 asi como establecer autenticación de usuario y encriptación de tráfico lo que permite proteger la privacidad y la seguridad de nuestra conexión. La utilidad principal de **Proxychains** es cuando se necesita acceder a un servidor remoto a través de un proxy para evitar restricciones de red.

1.) Instalar la herramienta proxychains en tu sistema operativo. Puedes hacerlo mediante comandos:
```
sudo apt install proxychains (basadas en debian)
sudo pacman syu proxychains (basadas en arch)
sudo emerge -a proxychains (gentoo)
sudo yum install proxychains (fedora)
```
2.) Procedemos a editar el archivo de configuración de proxychains en la ruta => /etc/proxychains.conf agregamos la lista de proxy(s) SOCKS a través de los cuales nos queremos conectar.

```
[ProxyList]
socks4  127.0.0.1 1337
```

3.) Procedemos hacer tunneling con proxychains, simplemente agrega «proxychains» antes del comando que deseas ejecutar, esto conectará a través de SSH al servidor ssh_server y establecerá un túnel SOCKS en el puerto 1337.

```
proxychains ssh user@ssh_server -D 127.0.0.1:1337 -N
```

4.) Vía CURL a través del túnel SOCKS establecido, por lo que la conexión al sitio web se realizará a través del servidor SSH. tenemos que asegurarnos que el servicio del proxy esté ejecutándose antes de hacer el tunneling.

```
proxychains curl --head http://10.10.10.10
```

## **Chisel HTTP Tunneling**

Si hablamos de Chisel, posiblemente podemos afirmar que es una de las herramientas mas poderosas en el campo del tunneling, esta encapsulará una sesión TCP en un túnel HTTP , la comunicación está totalmente encriptada a través de SSH, y admite autenticación mutua, reconexión automática y tiene su servidor proxy SOCKS 5 privado. Para ser mas concretos con Chisel se puede hacer todo lo que otras herramientas hacen u otros métodos de protocolos ofrecen.

1.) Máquina de pivote

```
chisel server -p 8080 --host 192.168.100.105 -v
```

- p 8080: indica que el servidor proxy se ejecutará en el puerto 8080.
- –host 192.168.2.105: Espeficar la dirección IP del host en el que se ejecutará el servidor proxy. En este caso, el servidor proxy se ejecutará en el host con la dirección IP 192.168.100.105.
- «-v»: Una opción para exponer el «verbose» o «verboso», lo que significa que se imprimirán mensajes detallados en la consola para informar sobre el estado de la ejecución del comando.

2.) Máquina del auditor:

```
chisel client -v http://192.168.100.105:8080 127.0.0.1:33333:10.10.10.20:80
```

Iniciará un cliente que se conectará a un servidor proxy en la dirección IP 192.168.2.105 en el puerto 8080, y establecerá un túnel entre el puerto local 33333 en el cliente y el puerto 80 en el host remoto 10.10.10.20 a través del servidor proxy. Además, se imprimirán mensajes detallados en la consola por el comando (-v) lo que permite observar el estado de la ejecución del comando.

3.) Verificación y estado de los encabezados

```
curl --head http://127.0.0.1:33333
```

Enviamos la solicitud HTTP que se realiza a la dirección IP local del cliente en el puerto 33333 utilizando el protocolo HTTP. La respuesta que se obtendremos será solo los encabezados de la respuesta HTTP del servidor que esté escuchando en el puerto 80 del host remoto especificado anteriormente.

## **reGeorg Tunneling**

Esta herramienta funciona mediante una webShell para crear un proxy SOCKS local. Esta característica resulta particularmente útil cuando el «auditor» se encuentra en una situación desafiante donde toda la comunicación TCP, los servicios de enlace y el tráfico saliente se encuentran bloqueados.

En lugar de reenviar el puerto local, la herramienta establece un proxy SOCKS local para comunicarse con la webShell. Aunque muchas herramientas nuevas usan este proceso de implementación en varios escenarios donde se requiere la utilización de un webshell en la máquina comprometida para establecer la conexión desde la máquina del «auditor».

Como toda maniobra de webShell primero hay que cargar el archivo de túnel (aspx|ashx|jsp|php) en el servidor web de destino puedes usar la extensión que se acorde al escenario que se tenga en frente.

```
python reGeorgSocksProxy.py -p 8080 -u http://server:8080/tunnel.jsp
```

Descargar **reGeorg**: **[Aqui](https://github.com/sensepost/reGeorg)**

## **Herramientas y mas herramientas**

Aunque existen cientos de herramientas para tunneling-pitvoting, las que te presento en el articulo posiblemente sean las mas usadas, cabe recalcar que cada «auditor» maneja sus técnicas y sus comandos oneliner, en varios repositorios de GitHub puedes encontrar cientos de herramientas, en cuanto al uso que se le y como se lo ponga en practica ya es cuestión de cada uno pues las posibilidades son infinitas.
