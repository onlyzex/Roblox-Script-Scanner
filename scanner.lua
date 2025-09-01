-- ibra's simple scanner
local suspicious = {
    "require%(",
    "loadstring",
    "HttpGet",
    "HttpPost",
    "getfenv",
    "setfenv",
    "getrawmetatable",
    "setreadonly",
    "_G",
    "shared",
    "InsertService",
    "MarketplaceService",
    "while true do",
    "spawn%(",
    "pcall%(",
    "xpcall%(",
    "MainModule",
    "Loader",
    "Handler",
    "AntiLag"
}

-- Hasil scan disimpan di table
local results = {}

local function checkScript(scr)
    local success, source = pcall(function()
        return scr.Source
    end)
    if success and source then
        for _, word in ipairs(suspicious) do
            if string.find(source, word) then
                local msg = "⚠️ [Backdoor Warning] Script: " .. scr:GetFullName() .. " → contains: " .. word
                warn(msg)
                table.insert(results, msg)
            end
        end
    end
end

for _, descendant in ipairs(game:GetDescendants()) do
    if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
        checkScript(descendant)
    end
end

print("✅ Scan Done! Cek Output atau file log di BackdoorScanLog.txt") 

-- Simpan hasil ke file log (hanya bisa di Studio, bukan di game publish)
local HttpService = game:GetService("HttpService")
local log = table.concat(results, "\n")
if log == "" then
    log = "✅ Tidak ada kode/sc mencurigakan ditemukan." 
end

--show hasil logs ke file 
writefile("BackdoorScanLog.txt", log)
