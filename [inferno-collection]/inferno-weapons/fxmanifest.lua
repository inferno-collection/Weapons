-- Inferno Collection Weapons Version 1.3 Beta
--
-- Copyright (c) 2019-2020, Christopher M, Inferno Collection. All rights reserved.
--
-- This project is licensed under the following:
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy, modify, and merge the software, under the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. THE SOFTWARE MAY NOT BE SOLD.
--

name "Weapons - Inferno Collection"

description "Adds fire modes to the weapons of your choice, as well as more realistic reloads (including disabling automatic reloads), consistent flashlights (stay turned on even when weapon is not being aimed), more blood when injured, and limping after being injured."

author "Inferno Collection (inferno-collection.com)"

version "1.3 Beta"

url "https://inferno-collection.com"

client_script "client.lua"

server_script "server.lua"

files {
    "nui.html",
    "images/*.png"
}

ui_page "nui.html"

game "gta5"

fx_version "bodacious"