local Suite = {}

local function useState(initial) 
    local current = initial
    return current, function(a) current = a end
end

local function useEffect(effect, dependencies) 
    local co_wrapper = coroutine.wrap(effect)
    local prev_dep = {}

    return function(...) 
        local current_dep = {...}
        local dep_changed = #current_dep ~= #prev_dep
        for i, dep in ipairs(current_dep) do 
            if dep ~= prev_dep[i] then
                dep_changed = true
                break
            end
        end

        if dep_changed then
            prev_dep = current_dep
            co_wrapper()
        end
    end
end

local HTTP = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local CGUI = game:GetService("CoreGui")
local PLRS = game:GetService("Players")
local Client = PLRS.LocalPlayer

local menuInitiated, setMenuInitiated = useState(false)
local interfaceSuite = game:GetObjects("rbxassetid://14084905066")[1]

function Suite:Render(Options)
    local function protectInterface() 
        if gethui() then 
            interfaceSuite.Parent = gethui()
        elseif (syn and syn.protect_gui) then
            interfaceSuite.Parent = CGUI
            syn.protect_gui(interfaceSuite)
        else
            interfaceSuite.Parent = CGUI
        end
    end

    
    local function setPageActive(page_name, active) 
        for _, page in ipairs(interfaceSuite:WaitForChild("Window"):WaitForChild("Content"):GetChildren()) do 
            if page:WaitForChild("ID").Value == page_name then 
                page.Visible = active
                break
            end
        end
    end
    
    protectInterface()
    setPageActive("Home", true)
    setMenuInitiated(true)
    
    
    local isGreyout, setGreyout = useState(false)
    local currentFilter, setFilter = useState("All")
    local isOpen, setOpen = useState(true)

end

return Suite