local QBCore = exports['qb-core']:GetCoreObject()
local insideLester = false

local LesterHouse = PolyZone:Create({
    vector2(1273.87, -1714.95),
    vector2(1274.74, -1716.98),
    vector2(1278.85, -1714.55),
    vector2(1276.05, -1708.7),
    vector2(1270.41, -1711.36),
    vector2(1271.5, -1713.62),
    vector2(1273.06, -1713.11)
}, {
    name="LesterHouse",
    minZ=51.0,
    maxZ=57.0,
    debugGrid=false,
    gridDivisions=25
})

Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetEntityCoords(plyPed)
        insideLester = LesterHouse:isPointInside(coord)
        Citizen.Wait(500)
    end
end)

local function Success(success)
    local num1 = math.random(100, 500)
    local num2 = math.random(100, 500)

    if success then
        TriggerEvent("mhacking:hide")

        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = '新邮件',
            subject = "莱斯特",
            message = '按 ✔ 获取疯狂杰克的当前位置',
            button = {
                enabled = true,
                buttonEvent = 'qb-blackmarket:Getjacklocation',
            }
        })

        if num1 == num2 then
            QBCore.Functions.Notify('你的vpn刚刚烧了 :/', 'error', 5000)
        end

        QBCore.Functions.Notify('检查您的邮件', 'success', 5000)
    else
        TriggerEvent("mhacking:hide")

        if num1 == num2 then
            QBCore.Functions.Notify('你的vpn刚刚烧了 :/', 'error', 5000)
        end

        QBCore.Functions.Notify('你的黑客攻击失败了', 'error', 5000)
    end
end

RegisterNetEvent('qb-blackmarket:Uselaptop', function()
    if insideLester == true then
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start", math.random(6, 7), math.random(20, 20), Success)
        QBCore.Functions.Notify('你只需要连接莱斯特的 wifi', 'success', 5000)
    else
        QBCore.Functions.Notify('没有wifi', 'error', 5000)
    end
end)

RegisterNetEvent('qb-blackmarket:Getjacklocation', function(data)
    local model = Config.model
    local coords2 = Config.Coords[math.random(#Config.Coords)]

    RequestModel(model)
    while not HasModelLoaded(model) do
    Wait(0)
    end
    entity = CreatePed(0, model, coords2, true, false)
    SetNewWaypoint(coords2)
end)

RegisterNetEvent('qb-blackmarket:Jackmenu', function()
    local jackList = {}

    jackList[#jackList + 1] = {
        isMenuHeader = true,
        header = '疯狂杰克市场',
        icon = 'fa-solid fas fa-shop'
    }

    for k,v in pairs(Config.Items) do
        jackList[#jackList + 1] = {
            header = QBCore.Shared.Items[k].label,
            txt = '$'.. v,
            icon = k,
            params = {
                isServer = true,
                event = 'qb-blackmarket:Buyitems',
                args = {
                    item = k,
                    price = v,
                }
            }
        }
    end

    jackList[#jackList + 1] = {
        header = '关闭',
        icon = 'fas fa-xmark',
        params = {
            event = 'qb-menu:client:closeMenu',
        }
    }

    exports['qb-menu']:openMenu(jackList)
end)

Citizen.CreateThread(function()
local models = {
    Config.model,
  }
  exports['qb-target']:AddTargetModel(models, {
    options = {
      {
        num = 1,
        type = "client",
        event = "qb-blackmarket:Jackmenu",
        icon = 'fas fa-face-laugh-wink',
        label = '疯狂杰克',
        canInteract = function(entity, distance, data) 
          if GetEntityHealth(entity) <= 190 then return false end 
          return true
        end,

      }
    },
    distance = 1.5,
  })
end)
