-- JELAN HUB v2 — modular UI demo for Roblox Studio
-- Place as LocalScript in StarterPlayerScripts.
-- Client UI/word browser only. Server-authoritative powers (e.g. invulnerability)
-- must be implemented in YOUR own Roblox experience with server validation.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "JELAN_HUB_V2"; gui.ResetOnSpawn = false; gui.Parent = player:WaitForChild("PlayerGui")

local PURPLE = Color3.fromRGB(155, 55, 255)
local ORANGE = Color3.fromRGB(255, 125, 45)
local BG = Color3.fromRGB(16, 10, 25)
local PANEL = Color3.fromRGB(28, 18, 42)
local TEXT = Color3.fromRGB(245, 235, 255)
local MUTED = Color3.fromRGB(160, 145, 175)

local function round(o, n)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,n or 8); c.Parent=o
end
local function outline(o, col)
    local s=Instance.new("UIStroke"); s.Color=col or PURPLE; s.Thickness=1.2; s.Parent=o
end
local function label(parent, txt, size, pos, fontSize, color)
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1; l.Text=txt
    l.Size=size; l.Position=pos; l.Font=Enum.Font.Gotham; l.TextSize=fontSize or 14
    l.TextColor3=color or TEXT; l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextWrapped=true; l.Parent=parent; return l
end
local function button(parent, txt, size, pos)
    local b=Instance.new("TextButton"); b.Text=txt; b.Size=size; b.Position=pos
    b.BackgroundColor3=PANEL; b.TextColor3=TEXT; b.Font=Enum.Font.GothamMedium
    b.TextSize=14; b.Parent=parent; round(b,8); outline(b,ORANGE); return b
end
local function textbox(parent, placeholder, size, pos)
    local t=Instance.new("TextBox"); t.PlaceholderText=placeholder; t.Text=""
    t.Size=size; t.Position=pos; t.BackgroundColor3=Color3.fromRGB(24,16,35)
    t.TextColor3=TEXT; t.PlaceholderColor3=MUTED; t.Font=Enum.Font.Gotham
    t.TextSize=14; t.ClearTextOnFocus=false; t.Parent=parent; round(t,8); outline(t,ORANGE); return t
end

local root=Instance.new("Frame"); root.Size=UDim2.fromOffset(760,480)
root.Position=UDim2.new(.5,-380,.5,-240); root.BackgroundColor3=BG; root.Parent=gui
round(root,14); outline(root,PURPLE)

-- Header drag area
local top=Instance.new("Frame"); top.Size=UDim2.new(1,0,0,52); top.BackgroundColor3=Color3.fromRGB(22,12,35); top.Parent=root; round(top,12)
label(top,"👑 JELAN HUB  |  Survive Your Ideas",UDim2.new(1,-100,1,0),UDim2.fromOffset(16,0),19,PURPLE)
local close=button(top,"×",UDim2.fromOffset(38,34),UDim2.new(1,-46,0,8))
close.MouseButton1Click:Connect(function() gui.Enabled=false end)
local dragging, dragStart, startPos=false,nil,nil
top.Active=true
top.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  dragging=true; dragStart=i.Position; startPos=root.Position
  i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end
 end
end)
UserInputService.InputChanged:Connect(function(i)
 if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
  local d=i.Position-dragStart; root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)

local sidebar=Instance.new("Frame"); sidebar.Size=UDim2.fromOffset(72,420); sidebar.Position=UDim2.fromOffset(10,54)
sidebar.BackgroundColor3=Color3.fromRGB(20,12,31); sidebar.Parent=root; round(sidebar,10)
local pageArea=Instance.new("Frame"); pageArea.Size=UDim2.new(1,-96,1,-66); pageArea.Position=UDim2.fromOffset(88,58)
pageArea.BackgroundTransparency=1; pageArea.Parent=root

local pages={}
local function newPage(name)
 local p=Instance.new("Frame"); p.Name=name; p.Size=UDim2.fromScale(1,1); p.BackgroundTransparency=1; p.Visible=false; p.Parent=pageArea; pages[name]=p; return p
end
local function showPage(name)
 for n,p in pairs(pages) do p.Visible=(n==name) end
end
local menuNames={"Home","Auto Write","Word Finder","ESP","Radar","Survival","Powers","Players","Settings"}
local icons={"⌂","✎","⌕","◉","◎","♜","⚡","♟","⚙"}
for i,n in ipairs(menuNames) do
 local b=button(sidebar,icons[i],UDim2.fromOffset(54,38),UDim2.fromOffset(9,8+(i-1)*44))
 b.TextSize=20; b.MouseButton1Click:Connect(function() showPage(n) end)
end

-- Home page
local home=newPage("Home")
label(home,"WELCOME TO JELAN",UDim2.new(1,0,0,34),UDim2.fromOffset(4,4),22,PURPLE)
label(home,"Modular menu • choose a feature from the left sidebar",UDim2.new(1,0,0,28),UDim2.fromOffset(4,42),14,MUTED)
local homeCard=Instance.new("Frame"); homeCard.Size=UDim2.new(1,-8,0,110); homeCard.Position=UDim2.fromOffset(4,84); homeCard.BackgroundColor3=PANEL; homeCard.Parent=home; round(homeCard,10); outline(homeCard)
label(homeCard,"Quick Status\\nUI: Loaded\\nWord library: Ready",UDim2.new(1,-20,1,-20),UDim2.fromOffset(12,10),16,TEXT)

local library={
 ["Bencana Alam"]={"Tsunami","Tornado","Earthquake","Meteor","Flood","Volcano","Hurricane","Typhoon","Landslide","Avalanche","Sinkhole","Wildfire","Drought","Asteroid","Solar Flare","Acid Rain","Sandstorm","Supernova","Mega Wave","Lightning Storm"},
 ["Nature"]={"Tree","Forest","Grass","Flower","Giant Tree","Mushroom","Vine","Roots","Jungle","Bamboo","Cactus","Coral","Crystal","Mountain","Ancient Tree"},
 ["Object"]={"Car","Bus","Truck","Plane","Train","Boat","House","Tower","Piano","Anvil","Rocket","Nuke","Tank","UFO","Satellite","Cube","Sphere","Bridge","Giant TV"},
 ["Cuaca"]={"Rain","Snow","Blizzard","Lightning","Thunder","Fog","Wind","Hail","Cloudy","Sunny","Heatwave","Cold Wave","Rainbow","Aurora","Acid Rain"},
 ["Memes / Anime"]={"Gojo","Sukuna","Mahoraga","Jogo","Toji","Luffy","Kaido","Zoro","Shanks","Naruto","Sasuke","Madara","Kurama","Goku","Vegeta","Beerus","Frieza","Broly","Saitama","Garou","Aizen","Ichigo","Muzan","Akaza","Denji","Makima","Sung Jinwoo","Beru","Igris","Eren Titan","Meruem","Hisoka","Dio","Jotaro","Skibidi","Tung Tung Tung Sahur","Tralalero Tralala"},
 ["Monsters"]={"Godzilla","King Kong","Kaiju","Titan","Demon","Zombie","Vampire","Golem","Kraken","Hydra","Behemoth","Dragon","Wyvern","Leviathan","Mimic","Werewolf","Chimera","Cerberus","Basilisk","Eldritch Horror","Shadow Beast","Abyssal Horror","Giant Spider","Slime King","Death Worm","Reaper","Lich","Dreadnought","Colossus","Nightmare"},
 ["Angels"]={"Angel","Archangel","Seraphim","Cherubim","Ophanim","Throne Angel","Guardian Angel","Fallen Angel","Dark Angel","Michael","Gabriel","Raphael","Uriel","Metatron","Heavenly Sentinel","Divine Warrior","Celestial Dragon","Angel of Light","Angel of Death","Biblically Accurate Angel"},
 ["Destroy"]={"Explosion","Black Hole","Meteor","Bomb","Shockwave","Collapse","Firestorm","Void"},
 ["Animals"]={"Lion","Tiger","Shark","Dinosaur","Whale","Eagle","Gorilla","Wolf","Snake","Phoenix"},
 ["Buildings"]={"Tower","Castle","House","Skyscraper","Bridge","Fortress","Bunker","Pyramid"},
 ["Vehicles"]={"Car","Tank","Helicopter","Jet","Rocket","Ship","Train","Motorcycle"},
 ["Food"]={"Pizza","Burger","Cake","Sushi","Taco","Donut","Watermelon","Giant Sandwich"},
 ["Weapons"]={"Sword","Gun","Knife","Bomb","Bow","Laser","Hammer","Axe"},
 ["Space"]={"Asteroid","Galaxy","Planet","Black Hole","Comet","Moon","Sun","Star"},
 ["Random"]={"Random","Chaos","Infinity","Lucky","Unlucky"},
 ["Custom Words"]={}
}

-- Auto Write page: controls separated from word browsing
local aw=newPage("Auto Write")
label(aw,"AUTO WRITE",UDim2.new(1,0,0,34),UDim2.fromOffset(4,0),21,PURPLE)
local awPanel=Instance.new("Frame"); awPanel.Size=UDim2.new(.56,-8,1,-44); awPanel.Position=UDim2.fromOffset(4,42); awPanel.BackgroundColor3=PANEL; awPanel.Parent=aw; round(awPanel,10); outline(awPanel)
label(awPanel,"Controls",UDim2.new(1,-20,0,28),UDim2.fromOffset(12,8),16,ORANGE)
label(awPanel,"Selected word: (choose in Word Finder)",UDim2.new(1,-20,0,40),UDim2.fromOffset(12,42),13,MUTED)
local autoBtn=button(awPanel,"Auto Write: OFF",UDim2.new(1,-24,0,38),UDim2.fromOffset(12,90))
autoBtn.MouseButton1Click:Connect(function() autoBtn.Text=autoBtn.Text=="Auto Write: OFF" and "Auto Write: ON" or "Auto Write: OFF" end)
local delayBox=textbox(awPanel,"Delay seconds (e.g. 1)",UDim2.new(1,-24,0,34),UDim2.fromOffset(12,138))
label(awPanel,"Use only in experiences where you have permission.",UDim2.new(1,-24,0,48),UDim2.fromOffset(12,184),12,MUTED)

-- Word Finder page
local wf=newPage("Word Finder")
label(wf,"WORD FINDER / LIBRARY",UDim2.new(1,0,0,32),UDim2.fromOffset(4,0),20,PURPLE)
local search=textbox(wf,"Search words...",UDim2.new(1,-8,0,34),UDim2.fromOffset(4,38))
local cat=textbox(wf,"Category name (e.g. Monsters / Angels)",UDim2.new(.42,-8,0,34),UDim2.fromOffset(4,80))
local customBox=textbox(wf,"Add custom word...",UDim2.new(.42,-8,0,34),UDim2.new(.42,4,0,80))
local add=button(wf,"＋ Add",UDim2.new(.16,-4,0,34),UDim2.new(.84,0,0,80))
local results=Instance.new("ScrollingFrame"); results.Size=UDim2.new(1,-8,1,-126); results.Position=UDim2.fromOffset(4,122); results.BackgroundColor3=PANEL; results.BorderSizePixel=0; results.ScrollBarThickness=5; results.Parent=wf; round(results,10)
local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,4); layout.Parent=results
local selectedWord=""
local function renderWords()
 for _,x in ipairs(results:GetChildren()) do if x:IsA("TextButton") then x:Destroy() end end
 local c=library[cat.Text] or library["Memes / Anime"]; local q=string.lower(search.Text)
 for _,w in ipairs(c) do if q=="" or string.find(string.lower(w),q,1,true) then
  local b=button(results,w,UDim2.new(1,-10,0,32),UDim2.new())
  b.MouseButton1Click:Connect(function() selectedWord=w; search.PlaceholderText="Selected: "..w end)
 end end
 task.defer(function() results.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+8) end)
end
cat.FocusLost:Connect(renderWords); search:GetPropertyChangedSignal("Text"):Connect(renderWords)
add.MouseButton1Click:Connect(function()
 local key=cat.Text
 if library[key] and customBox.Text~="" then table.insert(library[key],customBox.Text); customBox.Text=""; renderWords() end
end)
renderWords()

-- Other feature pages are independent panels with clear status/permission notes
for _,name in ipairs({"ESP","Radar","Survival","Powers","Players","Settings"}) do
 local p=newPage(name)
 label(p,string.upper(name),UDim2.new(1,0,0,34),UDim2.fromOffset(4,0),21,PURPLE)
 local box=Instance.new("Frame"); box.Size=UDim2.new(1,-8,0,150); box.Position=UDim2.fromOffset(4,42); box.BackgroundColor3=PANEL; box.Parent=p; round(box,10); outline(box)
 label(box,name.." Controls",UDim2.new(1,-20,0,28),UDim2.fromOffset(12,8),16,ORANGE)
 if name=="Powers" then
  label(box,"WalkSpeed / Jump settings (local preview only).\\nInvulnerability / God Mode must be implemented and validated on your own game's server.",UDim2.new(1,-24,0,100),UDim2.fromOffset(12,44),14,MUTED)
 elseif name=="Survival" then
  label(box,"Survival tips, safe-spot notes, and helper UI. No forced server changes.",UDim2.new(1,-24,0,80),UDim2.fromOffset(12,44),14,MUTED)
 elseif name=="ESP" or name=="Radar" or name=="Players" then
  label(box,"Player information UI can be added for your own experience with privacy and game rules in mind.",UDim2.new(1,-24,0,80),UDim2.fromOffset(12,44),14,MUTED)
 else
  label(box,"Theme, RGB, config, and keybind preferences.",UDim2.new(1,-24,0,80),UDim2.fromOffset(12,44),14,MUTED)
 end
end
showPage("Home")

-- Animated accent
task.spawn(function()
 local h=0
 while gui.Parent do
  h=(h+.004)%1; local c=Color3.fromHSV(h,.8,1)
  for _,o in ipairs(root:GetDescendants()) do local s=o:FindFirstChildOfClass("UIStroke"); if s then s.Color=c end end
  task.wait(.05)
 end
end)
