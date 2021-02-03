local deepcopy = require "deepcopy"
local json = require "json"

local network_handler = {}

network_handler.socket = nil
network_handler.server_socket = nil
network_handler.is_host = false
network_handler.host_ip = nil
network_handler.host_port = nil
network_handler.is_connected = false
network_handler.receive_buffer = {}
network_handler.receive_buffer_consumer_index = 1
network_handler.receive_buffer_producer_index = 1
network_handler.send_buffer = {}
network_handler.send_buffer_consumer_index = 1
network_handler.send_buffer_producer_index = 1
network_handler.max_buffer_items = 4000
network_handler.random_seed = nil

function network_handler.send(data)
    if network_handler.is_connected == false then
        return
    end

    network_handler.socket:send(data)
end

function network_handler.try_receive()
    if network_handler.is_connected == false then
        return
    end

    return network_handler.socket:receive()
end


function network_handler.produce_receive_buffer()

    if network_handler.is_connected == false then
        return false
    end


    local data = network_handler.try_receive()

    if data == nil then
        return false
    end


    network_handler.receive_buffer[network_handler.receive_buffer_producer_index] = data
    network_handler.receive_buffer_producer_index = network_handler.receive_buffer_producer_index + 1

    if network_handler.receive_buffer_producer_index > network_handler.max_buffer_items then
        network_handler.receive_buffer_producer_index = 1
    end

    return true

end

function network_handler.consume_receive_buffer()

    if network_handler.receive_buffer_consumer_index == network_handler.receive_buffer_producer_index then
        return nil
    end

    data = network_handler.receive_buffer[network_handler.receive_buffer_consumer_index]

    network_handler.receive_buffer_consumer_index = network_handler.receive_buffer_consumer_index + 1

    if network_handler.receive_buffer_consumer_index > network_handler.max_buffer_items then
        network_handler.receive_buffer_consumer_index = 1
    end

    return data

end

function network_handler.produce_send_buffer(data)

    network_handler.send_buffer[network_handler.send_buffer_producer_index] = deepcopy(data)
    network_handler.send_buffer_producer_index = network_handler.send_buffer_producer_index + 1

    if network_handler.send_buffer_producer_index > network_handler.max_buffer_items then
        network_handler.send_buffer_producer_index = 1
    end

end

function network_handler.consume_send_buffer()

    if network_handler.is_connected == false then
        return false
    end

    if network_handler.send_buffer_producer_index == network_handler.send_buffer_consumer_index then
        return false
    end

    network_handler.send(network_handler.send_buffer[network_handler.send_buffer_consumer_index])

    network_handler.send_buffer_consumer_index = network_handler.send_buffer_consumer_index + 1

    if network_handler.send_buffer_consumer_index > network_handler.max_buffer_items then
        network_handler.send_buffer_consumer_index = 1
    end

    return true
end


function network_handler.start_server()
    local socket = require("socket")
    network_handler.server_socket = assert(socket.bind("*", network_handler.host_port))
    local ip, port = network_handler.server_socket:getsockname()
    --print("Please connect to port " .. port)

    network_handler.server_socket:settimeout(60)

    network_handler.socket, err = network_handler.server_socket:accept()

    network_handler.socket:settimeout(0)

    network_handler.is_connected = true

    math.randomseed(os.time())
    network_handler.random_seed = math.random(2147483647)

    network_handler.send(tostring(network_handler.random_seed) .. "\n")

    -- Wait for seed ACK
    local line, err = nil, nil

    while line == nil do
        line, err = network_handler.try_receive()
    end



    --local line, err = nil, nil

    --while line == nil do
    --    line, err = network_handler.try_receive()
    --end

    --print("Received line: " .. line)

    --network_handler.send(json.encode({a="test", b="test2"}) .. "\n")


    -- Create test send buffer from host -> client

    --network_handler.produce_send_buffer(json.encode({a="test", b="test2"}) .. "\n")
    
    --network_handler.produce_send_buffer(json.encode({c="test", d="awesome"}) .. "\n")
    
    --network_handler.produce_send_buffer(json.encode({f="test", g="test2"}) .. "\n")

    --print("After producing send buffer entries: " .. network_handler.send_buffer_producer_index)

    --print("Consuming: " .. network_handler.send_buffer_consumer_index)

    --while network_handler.consume_send_buffer() do
        
    --    print("Consuming: " .. network_handler.send_buffer_consumer_index)

    --end

end

function network_handler.start_client()
    print ("Starting client: " .. network_handler.host_ip .. ":" .. network_handler.host_port)
    local socket = require("socket")
    network_handler.socket = assert(socket.tcp())
    network_handler.socket:settimeout(0)
    network_handler.socket:connect(network_handler.host_ip, network_handler.host_port);
    
    network_handler.is_connected = true

    -- Wait for server seed
    local line, err = nil, nil

    while line == nil do
        line, err = network_handler.try_receive()
    end

    network_handler.random_seed = tonumber(line)

    network_handler.send("ACK\n")

    --while network_handler.receive_buffer_producer_index < 4 do
    --    network_handler.produce_receive_buffer()
    --    print("Waiting for receive buffer: " .. network_handler.receive_buffer_producer_index)
    --end

    -- Read from receive buffer

    --local data = 1

    --data = network_handler.consume_receive_buffer()

    --while data ~= nil do
        
    --    print("Received: ")
    --    print(json.decode(data))

    --    data = network_handler.consume_receive_buffer()
    --end

    --network_handler.send("hello world\n");

    --while line == nil do
    --    line, err = network_handler.try_receive()
    --end

    --print("Received line: ", json.decode(line))
    
end

function network_handler.close_sockets()

    network_handler.socket:close()
    if network_handler.is_host then
        network_handler.server_socket:close()
    end

end
  

function network_handler.open_connection_form(on_form_close_callback)
    network_handler.is_connected = false
    menu = forms.newform(300, 140, "Gauntlet Netplay Init", on_form_close_callback)
    local windowsize = client.getwindowsize()
    local form_xpos = (client.xpos() + 120*windowsize - 142)
    local form_ypos = (client.ypos() + 80*windowsize + 10)
    forms.setlocation(menu, form_xpos, form_ypos)
    label_ip = forms.label(menu,"IP:",8,0,32,24)
    port_ip = forms.label(menu,"Port:",8,30,32,24)
    textbox_ip = forms.textbox(menu,"127.0.0.1",240,24,nil,40,0)
    textbox_port = forms.textbox(menu,"65367",240,24,nil,40,30)
    
    local function on_host_click()
        network_handler.is_host = true
        network_handler.host_port = tonumber(forms.gettext(textbox_port))

        network_handler.start_server()

        forms.destroyall()
    end

    local function on_client_click()
        network_handler.is_host = false
        network_handler.host_ip = forms.gettext(textbox_ip)
        network_handler.host_port = tonumber(forms.gettext(textbox_port))
        
        network_handler.start_client()
        
        forms.destroyall()
    end


    button_host = forms.button(menu, "Host", on_host_click, 80,60,48,24)
    button_join = forms.button(menu, "Join", on_client_click, 160,60,48,24)
end


return network_handler