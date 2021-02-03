local function start_server()
  local socket = require("socket")
  local server = assert(socket.bind("*", HOST_PORT))
  local ip, port = server:getsockname()
  print("Please connect to port " .. port)

  server:settimeout(60)

  local tcp, err = server:accept()

  tcp:settimeout(0)

  local line, err = nil, nil

  while line == nil do
    line, err = tcp:receive()
  end
  
  print("Received line: " .. line)
  
  tcp:send("back from server ;-)\n")

  tcp:close()
  server:close()
end

local function start_client()
  print ("Starting client: " .. HOST_IP .. ":" .. HOST_PORT)
  local host, port = HOST_IP, HOST_PORT
  local socket = require("socket")
  local tcp = assert(socket.tcp())
  tcp:settimeout(0)
  tcp:connect(host, port);

  tcp:send("hello world\n");
  
  while line == nil do
    line, err = tcp:receive()
  end
  
  print("Received line: " .. line)

  tcp:close()
end

local function on_form_close()

  -- TODO: here we would start the main gauntlet.
  forms.destroyall()
  
  print("All forms destroyed, beginning gauntlet.")
end

local function connection_form()
	menu = forms.newform(300, 140, "Gauntlet Netplay Init", on_form_close)
	local windowsize = client.getwindowsize()
	local form_xpos = (client.xpos() + 120*windowsize - 142)
	local form_ypos = (client.ypos() + 80*windowsize + 10)
	forms.setlocation(menu, form_xpos, form_ypos)
	label_ip = forms.label(menu,"IP:",8,0,32,24)
	port_ip = forms.label(menu,"Port:",8,30,32,24)
	textbox_ip = forms.textbox(menu,"127.0.0.1",240,24,nil,40,0)
	textbox_port = forms.textbox(menu,"65367",240,24,nil,40,30)
  
  local function on_host_click()
    IS_HOST = true
    HOST_PORT = tonumber(forms.gettext(textbox_port))
    start_server()

    
    forms.destroyall()
  end
  
  local function on_client_click()
    IS_HOST = false
    HOST_IP = forms.gettext(textbox_ip)
    HOST_PORT = tonumber(forms.gettext(textbox_port))
    
    start_client()
    
    forms.destroyall()
  end


	button_host = forms.button(menu, "Host", on_host_click, 80,60,48,24)
	button_join = forms.button(menu, "Join", on_client_click, 160,60,48,24)
end

connection_form()


