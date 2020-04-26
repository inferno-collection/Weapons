-- Inferno Collection Weapons Version 1.24 Alpha
--
-- Copyright (c) 2019-2020, Christopher M, Inferno Collection. All rights reserved.
--
-- This project is licensed under the following:
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to use, copy, modify, and merge the software, under the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. THE SOFTWARE MAY NOT BE SOLD.
--

--
--		Nothing past this point needs to be edited, all the settings for the resource are found ABOVE this line.
--		Do not make changes below this line unless you know what you are doing!
--

-- Master Flashlight storage variable
local Flashlights = {}

-- Adds new flashlight request to array
RegisterServerEvent('Weapons:Server:New')
AddEventHandler('Weapons:Server:New', function(x1, y1, z1, x2, y2, z2) Flashlights[source] = {x1, y1, z1, x2, y2, z2} end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Updates all clients for this tick
        TriggerClientEvent('Weapons:Client:Return', -1, Flashlights)
        -- Clears the variable ready to be updated next tick
        Flashlights = {}
    end
end)