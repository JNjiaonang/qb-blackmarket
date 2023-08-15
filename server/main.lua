local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('darklaptop', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName('vpn') then
        Player.Functions.RemoveItem('vpn', 1)
        TriggerClientEvent('qb-blackmarket:Uselaptop', source)
    end
end)

RegisterNetEvent('qb-blackmarket:Buyitems', function(cd)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cash = Player.Functions.GetMoney('cash')
    local item = cd.item
    local price = cd.price

    if cash >= price then
        if Player.Functions.AddItem(item, 1) then
            Player.Functions.RemoveMoney('cash', price)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
            TriggerClientEvent('QBCore:Notify', src, '物品购买成功!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, '无法将物品添加到库存.', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, '你没有足够的钱.', 'error')
    end
end)
