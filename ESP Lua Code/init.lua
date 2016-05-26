--servidor UDP no ip 192.168.4.1 na porta 53
--Configurar AP
wifi.setmode(wifi.SOFTAP);
cfg={}
cfg.ssid="Wifi-Car Teste"
cfg.pwd="12345678"
cfg.ip="192.168.4.1"
cfg.max="1"--so e possivel 1 ligacao de cada vez
cfg.netmask="255.255.255.0"
cfg.gateway="192.168.4.1"
wifi.ap.setip(cfg)
wifi.ap.config(cfg)
--Fim Configuraçao AP
------------------
--Configurar alertas para desconeçoes de dispositivo e meter pinos desligados
---Dispositivo desconectado
wifi.eventmon.register(wifi.eventmon.AP_STADISCONNECTED, function(T) 
gpio.write(f, gpio.LOW)
gpio.write(t, gpio.LOW)
gpio.write(e, gpio.LOW)
gpio.write(d, gpio.LOW)
for i=1,15 do 
gpio.write(l, gpio.HIGH)
tmr.delay(20000)   
gpio.write(l, gpio.LOW)
tmr.delay(20000)end
end)
--Quando começa a ficar muito longe "ainda em teste"
wifi.eventmon.register(wifi.eventmon.AP_PROBEREQRECVED, function(T)
--print(T.RSSI)
if T.RSSI < -85 then
  --node.restart()
  gpio.write(f, gpio.LOW)
  gpio.write(t, gpio.LOW)
  gpio.write(e, gpio.LOW)
  gpio.write(d, gpio.LOW) 
  for i=1,15 do 
  gpio.write(l, gpio.HIGH)
  tmr.delay(20000)   
  gpio.write(l, gpio.LOW)
  tmr.delay(20000)end
end
end)
--Dar sinal que alguem se conectou com sucesso Blink 2x
wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T) 
  gpio.write(l, gpio.HIGH)
  tmr.delay(100000)   
  gpio.write(l, gpio.LOW)
  tmr.delay(100000) 
  gpio.write(l, gpio.HIGH)
  tmr.delay(100000)   
  gpio.write(l, gpio.LOW)
  tmr.delay(100000)     
end)
--Fim configuraçao de alertas
------------------
--Inicializaçao variaveis
bat = 0 --bateria no pino ADC o zero nao e o pino so a inicializaçao da variavel
--Fim Inicializaçao variaveis
---------------------------
--Configurar portas 
d = 4--0 --gpio16 direita
f = 5--6 --gpio12 frente
e = 6--5 --gpio14 esquerda
t = 7--7 --gpio13 tras
l = 8--4--12 --gpio2 luz
--modo output pinos
gpio.mode(f, gpio.OUTPUT)
gpio.mode(t, gpio.OUTPUT)
gpio.mode(e, gpio.OUTPUT)
gpio.mode(d, gpio.OUTPUT)
gpio.mode(l, gpio.OUTPUT)
--iniciam todos a 0 
gpio.write(l, gpio.LOW)
gpio.write(f, gpio.LOW)
gpio.write(t, gpio.LOW)
gpio.write(e, gpio.LOW)
gpio.write(d, gpio.LOW)
--Fim configuraçao Portas
-------------------------
--Configurar o servidor UDP e escutar o que recebe/controlo dos pinos
svr=net.createServer(net.UDP, 2)   
svr:on("receive",function(svr,pl)
if pl == "ONf" then
gpio.write(t, gpio.HIGH)
elseif pl == "OFFf" then
gpio.write(t, gpio.LOW)
elseif pl == "ONt" then
gpio.write(f, gpio.HIGH)
elseif pl == "OFFt" then
gpio.write(f, gpio.LOW)
elseif pl == "ONe" then
gpio.write(e, gpio.HIGH)
elseif pl == "OFFe" then
gpio.write(e, gpio.LOW)
elseif pl == "ONd" then
gpio.write(d, gpio.HIGH)
elseif pl == "OFFd" then
gpio.write(d, gpio.LOW)
elseif pl == "ONl" then
gpio.write(l, gpio.HIGH)
elseif pl == "OFFl" then
gpio.write(l, gpio.LOW)
elseif pl == "OFF" then
gpio.write(f, gpio.LOW)
gpio.write(t, gpio.LOW)
gpio.write(e, gpio.LOW)
gpio.write(d, gpio.LOW)
end
-- Fim configuraçao e controlo dos pinos
----------------------------------------
--Serviços Adicionas apos cada linha recebida
bat=adc.read(0)-- le o pino ADC(bateria)
svr:send(bat)  --envia a informaçao da bareria
--Fim serviços adicionais
------------------------------------------------
end) 
svr:listen(53)--escuta a Porta 53 UDP