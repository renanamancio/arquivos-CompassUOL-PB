-Acesse a AWS com o link informado e as credencias da Compass UOL
-Clicar em Administrator Access
-Verificar se está conectado na região "US-EAST-1"
-Acessar o dashboard do EC2
-Criar pares de chaves e guardar em uma pasta em local seguro
	-Nomear o par de chaves: EC2-PB-AWS
	-Tipo de chave RSA, formato .pem
-Acessar Dashboard do Internet Gateway
-Criar um novo Gateway
	-Nomear: ec2-serverest-gateway
	-Associar a VPC disponível
-Acessar a Tabela de Rotas
	-Selecionar Rotas, Editar rotas
	-Destino: 0.0.0.0/0
	-Selecionar o Gateway de Internet criado
	-Nomear o valor com os nomes sugerido pelo PB
	-Repetir com as demais rotas, exceto a que não tem nada
-Acessar o Dashboard do EC2
-Criar nova instância
-Nomear: Linux ServeRest
-Adicionar tags:
	-Name, caso não tiver configurada
	-Project
	-CostCenter
-Para todas as tags, colocar somente "Instâncias" e "Volumes" em tipos de recursos
-Selecionar o par de chaves criado anteriormente
-Configurações de rede:
	-Permitir tráfego SSH
		-Qualquer lugar
	-Permitir tráfego HTTPS
	-Permitir tráfego HTTP
	-Clicar em editar:
		-Habilitar o "Atribuir IP público automaticamente",
	-Adicionar regra de grupo de segurança:
		-TCP Personalizado
		-Intervalo de portas: 3000
		-Tipos de origem: Qualquer Lugar
-Executar instância
-Conectar a sua Instância
	-Salvar o IP público: 3.92.30.28
-Acessar a pasta onde armazenou o par de chaves via GIT BASH HERE
-Executar os comandos:
```bash
Ideapad@DESKTOP-RC3K0Q5 MINGW64 ~/Documents/EC2-AWS
$ chmod 400 "ECS-PB-AWS.pem"
```

```bash
Ideapad@DESKTOP-RC3K0Q5 MINGW64 ~/Documents/EC2-AWS
$ ssh -i "ECS-PB-AWS.pem" ec2-user@ec2-3-92-30-28.compute-1.amazonaws.com
```

-Máquina EC2 conectada
-Verificar se precisa de atualizações:
```bash
[ec2-user@ip-172-31-47-146 ~]$ sudo yum update -y
```
-Instalar pacotes:
```bash
[ec2-user@ip-172-31-47-146 ~]$ sudo yum install gcc-c++ make -y
```
-Verificar se há o curl instalado:
```bash
[ec2-user@ip-172-31-47-146 ~]$ curl --version
```
-Criar a pasta serverestApi
```bash
[ec2-user@ip-172-31-47-146 ~]$ mkdir serverestApi
```
-Acessar a pasta recém criada:
```bash
[ec2-user@ip-172-31-47-146 ~]$ cd serverestApi
```
-Instalar o node.js
```bash
[ec2-user@ip-172-31-47-146 serverestApi]$ sudo yum install -y nodejs
```
-Verificar se o node.js foi instalado corretamente
```bash
[ec2-user@ip-172-31-47-146 serverestApi]$ node --version
v18.20.8
```
-Verificar se o npm está instalado
```
[ec2-user@ip-172-31-47-146 serverestApi]$ npm --version
10.8.2
```
-Executar o Serverest
```bash
[ec2-user@ip-172-31-47-146 serverestApi]$ npx serverest@latest
```
-Usar o IP público para acessar a ServeRest:
	-3.92.30.28:3000
-Rotinas do EC2
	-Conectar ao endereço informado pela Compass: https://academy-compass.awsapps.com/start/#
	-Acessar o Dashboard do EC2
	-Clicar em Instâncias
		-Sempre deve estar zerado, com nenhuma em execução
	-Selecionar a instância da lista
	-Clicar em Estado da instância e iniciar instância
	-Selecionar e clicar em Conectar
		-Sempre copiar o ip público
	-Abrir pasta do par de chaves, abri terminal
	-Executar comando chmod informado
	-Acessar a pasta da serverestApi
	-Executar npx serverest@latest
	-Usando o ip público copiado, fazer as sessões de teste
	-Interromper a ServeRest: CTRL + C
	-Executar "exit" no terminal
	-Na AWS, selecionar instâncias, Estado da Instância, Interromper Instância
		-Sempre limpe o filtro. Não clicar em Interromper e excluir
	