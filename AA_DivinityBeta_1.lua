--Requirements
local antiaim_funcs = require "gamesense/antiaim_funcs" or error("https://gamesense.pub/forums/viewtopic.php?id=29665")
local easing = require "gamesense/easing" or error("https://gamesense.pub/forums/viewtopic.php?id=22920")
local vector = require("vector")

--Might be used later if I add a Console Welcoming in the future, but for now I'll just keep in here.
client.exec("clear")

--Anti-Aim Referenes
local aa = {
	Enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	Pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
	YawBase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
    Yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
    YawJitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    BodyYaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	FakeYawLimit = ui.reference("AA", "Anti-aimbot angles", "Fake Yaw limit"),
    FreestandingBodyYaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body Yaw"),
    Roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	EdgeYaw = ui.reference("AA", "Anti-aimbot angles", "Edge Yaw"),
	Freestanding = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	SlowMotion = { ui.reference("AA", "Other", "Slow motion") },
    FakeDuck = ui.reference("Rage", "Other", "Duck peek assist"),
}
--All Other Non Anti-Aim References
local other = {
    MinDmg = ui.reference("Rage", "Aimbot", "Minimum Damage"),
    DT = {ui.reference("Rage", "Other", "Double tap")},
    HitChance = ui.reference("Rage", "Aimbot", "Minimum hit chance"),
    LegMovement = ui.reference("AA", "Other", "Leg movement"),
    FL = ui.reference("AA", "Fake lag", "Limit"),
    QP = {ui.reference("Rage", "Other", "Quick peek assist")},
    OSAA = {ui.reference("AA", "Other", "On shot anti-aim")},
    ClanTag = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
}

--GUI
local menu = {
    --Master Checkbox
    Enable = ui.new_checkbox("AA", "Anti-aimbot angles", "[\a9FCA2BFFDivinity\aFFFFFFFF] Enable"),
    TabSelector = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFTab Selector", {"\aFFFFFFFF - ","\aFFFFFFFFAnti-Aim", "\aFFFFFFFFVisuals", "\aFFFFFFFFMisc", "\aFFFFFFFFColors"}),
    --AA GUI
    EnableAntiAim = ui.new_checkbox("AA", "Anti-aimbot angles", "[\a9FCA2BFFDivinity\aFFFFFFFF] Enable Anti-Aim"),
    AntiAim = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFAnti-Aim Selection", {"-", "Divinity", "Custom AA"}),
    YawBase = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFYaw Base", {"Local view", "At targets"}),
    YawJitterCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFYaw Jitter"),
    YawJitterAmount = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFYaw Jitter Amount", 10, 100, 10, true, "%"),
    FakeYawRange = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFFake Yaw Range", 0, 60, 60, true, "°"),
    DynamicFakeYaw = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFDynamic Fake Yaw"),
    StandingYawOverride = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFStanding Yaw Override"),
    YawJitterAmount1 = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFStanding Yaw Jitter Amount", 10, 100, 0, true, "%"),
    FakeYawRange1 = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFStanding Fake Yaw Range", 0, 60, 30, true, "°"),
    MovingYawOverride = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFMoving Yaw Override"),
    YawJitterAmount2 = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFMoving Yaw Jitter Amount", 10, 100, 0, true, "%"),
    FakeYawRange2 = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFMoving Fake Yaw Range", 0, 60, 30, true, "°"),
    AirYawOverride = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFIn-Air Yaw Override"),
    YawJitterAmount3 = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFIn-Air Yaw Jitter Amount", 10, 100, 0, true, "%"),
    FakeYawRange3 = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFIn-Air Fake Yaw Range", 0, 60, 30, true, "°"),
    LegJitter = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFLeg Jitter", {"Off", "On"}),
    LegitAA = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFLegit AA on Use"),
    StaticRollCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFStatic Roll"),
    StaticRoll = ui.new_slider("AA", "Anti-aimbot angles", "\aFFFFFFFFRoll", -50,50,0),
    DynamicRoll = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFDynamic Roll"),
    ManualCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFEnable Manual AA"),
    ManualLeft = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFManual Left", false),
    ManualBack = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFManual Back", false),
    ManualRight = ui.new_hotkey("AA", "Anti-aimbot angles", "\aFFFFFFFFManual Right", false),
    --Indicator GUI
    EnableIndicators = ui.new_checkbox("AA", "Anti-aimbot angles", "[\a9FCA2BFFDivinity\aFFFFFFFF] Enable Indicators"),
    Indicators = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFCrosshair Indicators"),
    IndicatorStyle = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFCrosshair Indicator Style", {"Legacy"}), --"Modern", "Alternative"
    Indicators2 = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFSecondary Indicators"),
    Watermark = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFWatermark Indicators"),
    master_switch = ui.new_checkbox("AA", "Anti-aimbot angles", '\aFFFFFFFFCustom scope lines'),
    color_picker = ui.new_color_picker("AA", "Anti-aimbot angles", '\n scope_lines_color_picker', 0, 0, 0, 255),
    overlay_position = ui.new_slider("AA", "Anti-aimbot angles", '\n scope_lines_initial_pos', 0, 500, 190),
    overlay_offset = ui.new_slider("AA", "Anti-aimbot angles", '\n scope_lines_offset', 0, 500, 15),
    fade_time = ui.new_slider("AA", "Anti-aimbot angles", '\aFFFFFFFFFade animation speed', 3, 20, 12, true, 'fr', 1, { [3] = 'Off' }),
    --Misc GUI
    EnableMisc = ui.new_checkbox("AA", "Anti-aimbot angles", "[\a9FCA2BFFDivinity\aFFFFFFFF] Misc Enable"),
    ClanTag = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFClanTag"),
    IdealTickCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFIdeal Tick"),
    IdealTickKey = ui.new_hotkey("AA", "Anti-aimbot angles", "Ideal Tick Key", true),
    DTFallBack = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFDouble Tap Fall Back", {"-", "Always on", "On hotkey","Toggle", "Off hotkey"}),
    QPFallBack = ui.new_combobox("AA", "Anti-aimbot angles", "\aFFFFFFFFQuick Peek Fall Back", {"-", "Always on", "On hotkey","Toggle", "Off hotkey"}),
    FreeStandingCheck = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFFreestanding"),
    FreeStandingKey = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding Key", true),
    Killsay = ui.new_checkbox("AA", "Anti-aimbot angles", "\aFFFFFFFFKillsay"),
    --Colors GUI
    OverideColors = ui.new_checkbox("AA", "Anti-aimbot angles", "[\a9FCA2BFFDivinity\aFFFFFFFF] Override Default Colors"),
    CLRLabel1 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFMain Color"),
    CLR1 = ui.new_color_picker("AA", "Anti-aimbot angles", "Main Color", 173, 216, 230, 255),
    CLRLabel2 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFAcsent Color"),
    CLR2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Ascent Color", 255, 255, 255, 255),
    CLRLabel3 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFSecondary Indicator Color"),
    CLR3 = ui.new_color_picker("AA", "Anti-aimbot angles", "Secondary Indicator Color", 216,191,216,255),
    CLRLabel4 = ui.new_label("AA", "Anti-aimbot angles", "\aFFFFFFFFWatermark Color"),
    CLR4 = ui.new_color_picker("AA", "Anti-aimbot angles", "Watermark Color", 132,172,12,255)
}

--PlayerState Function
local flags = {
    FL_ONGROUND = bit.lshift(1, 0);
    FL_DUCKING = bit.lshift(1, 1);
}

local getPlayerState = function()
    local getVelocity = math.floor(vector(entity.get_prop(entity.get_local_player(), 'm_vecVelocity')):length2d() + 0.5);
    local getFlags = entity.get_prop(entity.get_local_player(), 'm_fFlags');
    local isSlowWalking = ui.get(aa.SlowMotion[2]);
    local isFakeDucking = ui.get(aa.FakeDuck);
    if (bit.band(getFlags, flags.FL_DUCKING ) ~= 0 and bit.band(getFlags, flags.FL_ONGROUND) == 1) and not isFakeDucking then
        return "crouching"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity <= 2 and not isSlowWalking and not isFakeDucking) then
        return "standing";
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and getVelocity >= 2 and not isSlowWalking and not isFakeDucking) then
        return "moving";
    elseif (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) and client.key_state(0x11) then
        return "in-air [c]"
    elseif (bit.band(getFlags, flags.FL_ONGROUND) ~= 1) then
        return "in-air";
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and isSlowWalking) then
        return "slowwalk";
    elseif (bit.band(getFlags, flags.FL_ONGROUND) == 1 and isFakeDucking) then
        return "fakeduck";
    end
end
client.set_event_callback("setup_command", getPlayerState)

--Anti-Aim
client.set_event_callback("setup_command", function()
        if ui.get(menu.EnableAntiAim) then
        --Preset Anti-Aimz
            if ui.get(menu.AntiAim) == "Divinity" then
                if getPlayerState() == "> moving" then
                    ui.set(aa.Pitch, "Default")
                    ui.set(aa.YawBase, "At targets")
                    ui.set(aa.Yaw[1], "180")
                    ui.set(aa.Yaw[2], 4)
                    ui.set(aa.YawJitter[1], "Offset")
                    ui.set(aa.YawJitter[2], 4)
                    ui.set(aa.BodyYaw[1], "Opposite")
                    ui.set(aa.FakeYawLimit, 60)
                    ui.set(aa.FreestandingBodyYaw, true) 
                elseif getPlayerState() == "> standing" then
                    ui.set(aa.Pitch, "Default")
                    ui.set(aa.YawBase, "At targets")
                    ui.set(aa.Yaw[1], "180")
                    ui.set(aa.Yaw[2], 5)
                    ui.set(aa.YawJitter[1], "Off")
                    ui.set(aa.YawJitter[2], -14)
                    ui.set(aa.BodyYaw[1], "Static")
                    ui.set(aa.BodyYaw[2], -13)
                    ui.set(aa.FakeYawLimit, 23)
                    ui.set(aa.FreestandingBodyYaw, true) 
                elseif getPlayerState() == "> in-air" then
                    ui.set(aa.Pitch, "Default")
                    ui.set(aa.YawBase, "At targets")
                    ui.set(aa.Yaw[1], "180")
                    ui.set(aa.Yaw[2], 6)
                    ui.set(aa.YawJitter[1], "Offset")
                    ui.set(aa.YawJitter[2], 12)
                    ui.set(aa.BodyYaw[1], "Static")
                    ui.set(aa.BodyYaw[2], 12)
                    ui.set(aa.FakeYawLimit, 60)   
                    ui.set(aa.FreestandingBodyYaw, false)
                elseif getPlayerState() == "> slowwalk" then
                    ui.set(aa.Pitch, "Default")
                    ui.set(aa.YawBase, "At targets")
                    ui.set(aa.Yaw[1], "180")
                    ui.set(aa.Yaw[2], 23)
                    ui.set(aa.YawJitter[1], "Random")
                    ui.set(aa.YawJitter[2], 32)
                    ui.set(aa.BodyYaw[1], "Opposite")
                    ui.set(aa.FakeYawLimit, 23)
                    ui.set(aa.FreestandingBodyYaw, true) 
                elseif getPlayerState() == "> crouching" then
                    ui.set(aa.Pitch, "Default")
                    ui.set(aa.YawBase, "At targets")
                    ui.set(aa.Yaw[1], "180")
                    ui.set(aa.Yaw[2], 23)
                    ui.set(aa.YawJitter[1], "Random")
                    ui.set(aa.YawJitter[2], 32)
                    ui.set(aa.BodyYaw[1], "Opposite")
                    ui.set(aa.FakeYawLimit, 23)
                    ui.set(aa.FreestandingBodyYaw, true)      
                end
            end
        end
--Custom Anti-Aimz for Nerdz
    if ui.get(menu.EnableAntiAim) then
        if ui.get(menu.AntiAim) == "Custom AA" then
            ui.set(aa.Pitch, "Down")
            ui.set(aa.YawBase, ui.get(menu.YawBase))
            ui.set(aa.Yaw[1], 180)
            ui.set(aa.Yaw[2], 0)
            ui.set(aa.YawJitter[1], "Center")
            ui.set(aa.BodyYaw[1], "Static")

            if client.key_state(0x44) then
                ui.set(aa.BodyYaw[2], 180)
            elseif client.key_state(0x41) then
                ui.set(aa.BodyYaw[2], -180)
            elseif getPlayerState() == "> standing" or getPlayerState() == "> moving" then
                ui.set(aa.BodyYaw[2], ui.get(aa.BodyYaw[2]) ~= -180 and -180 or 180)
            end
            --I Want to see what Medusa does to replicate it for Divinity, Not entirely sure. I could probably check the cracked medusa build later... 
            --Ok so they cap Jitter to 50 and the minimum is 5, body yaw is math.random 180 to -180, they also do some weird velocity + playerstate shit for dynamic fake yaw?
            --Still more customizable than medusa suck my balls
            if getPlayerState() == "> standing" and ui.get(menu.StandingYawOverride) then
                ui.set(aa.YawJitter[2], ui.get(menu.YawJitterAmount1) * 1/2)
            elseif getPlayerState() == "> moving" and ui.get(menu.MovingYawOverride) then
                ui.set(aa.YawJitter[2], ui.get(menu.YawJitterAmount2) * 1/2)
            elseif getPlayerState() == "> in-air"  and ui.get(menu.AirYawOverride) then
                ui.set(aa.YawJitter[2], ui.get(menu.YawJitterAmount3) * 1/2)
            elseif not ui.get(menu.AirYawOverride) or not ui.get(menu.MovingYawOverride) or not ui.get(menu.StandingYawOverride) then
                if ui.get(menu.YawJitterCheck) then
                    ui.set(aa.YawJitter[2], ui.get(menu.YawJitterAmount) * 1/2)
                end
            end
            if getPlayerState() == "> standing" and ui.get(menu.StandingYawOverride) and not ui.get(menu.DynamicFakeYaw) then
                ui.set(aa.FakeYawLimit, ui.get(menu.FakeYawRange1))
            elseif getPlayerState() == "> moving" and ui.get(menu.MovingYawOverride) and not ui.get(menu.DynamicFakeYaw) then
                ui.set(aa.FakeYawLimit, ui.get(menu.FakeYawRange2))
            elseif getPlayerState() == "> in-air"  and ui.get(menu.AirYawOverride) and not ui.get(menu.DynamicFakeYaw) then
                ui.set(aa.FakeYawLimit, ui.get(menu.FakeYawRange3))
            elseif ui.get(menu.DynamicFakeYaw) then
                ui.set(aa.FakeYawLimit, math.random(4,59))
            elseif not ui.get(menu.AirYawOverride) or not ui.get(menu.MovingYawOverride) or not ui.get(menu.StandingYawOverride) then
                ui.set(aa.FakeYawLimit, ui.get(menu.FakeYawRange))
            end
        end
    end
    if ui.get(menu.ManualCheck)then
        if ui.get(menu.ManualLeft)then
            ui.set(aa.Yaw[2], -90)
        elseif ui.get(menu.ManualBack)then
            ui.set(aa.Yaw[2], 0)
        elseif ui.get(menu.ManualRight) then
            ui.set(aa.Yaw[2], 90)
        end
    end
end)

--Legit AA
client.set_event_callback("setup_command",function(e)
    if ui.get(menu.EnableAntiAim) then
        local weaponn = entity.get_player_weapon()
        
        if not ui.get(menu.LegitAA) then
            return;
        end

        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        else
            if e.chokedcommands == 0 then
                e.in_use = 0
            end
        end
    end
end)

--Leg Breaker
local LegMovement = {
    [1] = "Off",
    [2] = "Always slide",
    [3] = "Never slide"
}

client.set_event_callback("run_command", function()
    if ui.get(menu.EnableAntiAim) then
        if ui.get(menu.LegJitter) == "On" then
            ui.set(other.LegMovement, LegMovement[client.random_int(2,3)] or 'Off')
        end
    end
end)

--Random Roll
client.set_event_callback("setup_command", function()
    if ui.get(menu.DynamicRoll)then
        ui.set(menu.StaticRollCheck, false)
        if client.key_state(0x41) then
            ui.set(aa.Roll, math.random(-50, -30))
        elseif client.key_state(0x44) then
            ui.set(aa.Roll, math.random(50, 30))
        elseif getPlayerState() == "> standing" or getPlayerState() == "> moving" then
            ui.set(aa.Roll, math.random(-50, 50))
        end
    end
end)

--Roll Angle
client.set_event_callback("setup_command", function()
    if ui.get(menu.StaticRollCheck) then
        ui.set(aa.Roll, ui.get(aa.Roll) ~= ui.get(menu.StaticRoll) and ui.get(menu.StaticRoll) or ui.get(menu.StaticRoll) * - 1)
        ui.set(menu.DynamicRoll, false)
    end
    if not ui.get(menu.StaticRoll) or not ui.get(menu.DynamicRoll) then
        ui.set(aa.Roll, 0)
    end
end)

--Ideal Tick
client.set_event_callback("paint", function()
    if ui.get(menu.EnableMisc) then
        if ui.get(menu.IdealTickCheck) and ui.get(menu.IdealTickKey) then
            ui.set(other.FL, 1)
            ui.set(other.DT[2], "Always on")
            ui.set(other.QP[2], "Always on")
        else
            ui.set(other.FL, 15)
            ui.set(other.DT[2], ui.get(menu.DTFallBack))
            ui.set(other.QP[2], ui.get(menu.QPFallBack))
        end 
    end
end)

--FreeStanding + IdealTick Freestand
client.set_event_callback("paint", function()
    if ui.get(menu.EnableMisc) then
        if ui.get(menu.FreeStandingKey) and ui.get(menu.FreeStandingCheck) or ui.get(menu.IdealTickKey) then
            ui.set(aa.Freestanding[1], {"Default"})
            ui.set(aa.Freestanding[2], "Always on")
        elseif not ui.get(menu.FreeStandingKey) or ui.get(menu.IdealTickKey) then
            ui.set(aa.Freestanding[1], {})
            ui.set(aa.Freestanding[2], "On hotkey")
        end 
    end
end)

--ClanTag
local duration = 50
local clantags = {
    "",
    "D",
    "Di",
    "Div",
    "Divi",
    "Divin",
    "Divini",
    "Divinit",
    "Divinity",
    "Divinity.Lua",
    "Divinity",
    "Divinity.Lua",
    "Divinity",
    "Divinit",
    "Divini",
    "Divin",
    "Divi",
    "Div",
    "Di",
    "D",
    "",
}
local clantag_prev

client.set_event_callback("paint", function()
    if ui.get(menu.ClanTag) then
        ui.set(other.ClanTag, false)
        local cur = math.floor(globals.tickcount() / duration) % #clantags
        local clantag = clantags[cur+1]

        if clantag ~= clantag_prev then
          clantag_prev = clantag
          client.set_clan_tag(clantag)
        end
	end
end)

ui.set_callback(menu.ClanTag, function()
    if not ui.get(menu.ClanTag) then
        client.delay_call(0.2, function()
            client.set_clan_tag('')
        end)
    end
end)

--Killsay 
local killsays  = {
    '𝔼𝕦𝕘𝕖𝕟 𝔾𝕣𝕘𝕚𝕔 "𝕘𝕣𝕚𝕞𝕫𝕨𝕒𝕣𝕖" 𝕒𝕣𝕣𝕖𝕤𝕥𝕖𝕕 𝕒𝕗𝕥𝕖𝕣 𝕣𝕖𝕢𝕦𝕖𝕤𝕥𝕚𝕟𝕘 𝟙𝟝𝟘𝔼𝕋ℍ 𝕗𝕣𝕠𝕞 𝔸𝟙',
	'ｉ ｈｓ ｓｉｎｃｅ ｍｙ ｍｏｔｈｅｒ ｂｏｒｎｅｄ ｍｅ',
	'i live and laugh knowing u die.',
	'my spotlight is bigger then united states of 𝒦𝒪𝒮𝒪𝒱𝒪 𝑅𝐸𝒫𝒰𝐵𝐿𝐼𝒞',
	'I AM LEGEND TO MY FAMILY',
	'tommorow Nemanja Danilovic will suffer his last blow after gsense ban',
	'𝗲𝗻𝗷𝗼𝘆 𝗱𝗶𝗲 𝘁𝗼 𝗚 𝗟𝗢𝗦𝗦 𝗟𝗨𝗔',
	'𝕥𝕙𝕚𝕤 𝕠𝕟𝕖 𝕚𝕤 𝕗𝕠𝕣 𝕞𝕪 𝕄𝕌𝕄𝕄ℤ𝕐 𝕖𝕟𝕛𝕠𝕪 𝕕𝕚𝕖',
	'𝓽𝓱𝓲𝓼 𝔀𝓮𝓪𝓴 𝓭𝓸𝓰 "VAX" 𝓌𝒶𝓈 𝒹𝑒𝓅𝑜𝓇𝓉𝑒𝒹 𝓉𝑜 ""𝒦𝐿𝒜𝒟𝒪𝒱𝒪""',
	'after killing "ReDD" 𝕚 𝕘𝕠𝕥 𝕡𝕣𝕖𝕤𝕚𝕕𝕖𝕟𝕥 𝕠𝕗 𝕒𝕔𝕖𝕥𝕠𝕝',
	'by funny color player',
    'you think you are 𝔰𝔦𝔤𝔪𝔞 𝔭𝔯𝔢𝔡𝔦𝔠𝔱𝔦𝔬𝔫 but no.',
    'neverlose will always use as long father esotartliko has my back.',
    'after winning 1vALL i went on vacation to 𝒢𝒜𝐵𝐸𝒩 𝐻𝒪𝒰𝒮𝐸',
    'i superior resolver(selling shoppy.gg/@KURAC))',
    'ＹＯＵ ＨＡＤ ＦＵＮ ＬＡＵＧＨＩＮＧ ＵＮＴＩＬ ＮＯＷ',
    'once this game started 𝔂𝓸𝓾 𝓵𝓸𝓼𝓮𝓭 𝓪𝓵𝓻𝓮𝓭𝔂',
    'WOMANBOSS VS 𝙀𝙑𝙀𝙍𝙔𝙊𝙉𝙀(𝙌𝙏𝙍𝙐𝙀,𝙍𝙊𝙊𝙏,𝙍𝘼𝙕𝙊,𝙍𝙀𝘿𝘿,𝙍𝙓𝙕𝙀𝙔,𝘽𝙀𝘼𝙕𝙏,𝙎𝙄𝙂𝙈𝘼,𝙂𝙍𝙄𝙈𝙕𝙒𝘼𝙍𝙀)',
	'𝕖𝕤𝕠𝕥𝕒𝕣𝕥𝕝𝕚𝕜 𝔸𝕃 ℙ𝕌𝕋𝕆 𝕊𝕌𝔼𝕃𝕆!',
	'𝘨𝘢𝘮𝘦𝘴𝘯𝘴𝘦 𝘪𝘴 𝘥𝘪𝘦 𝘵𝘰 𝘶.',
	'𝙨𝙬𝙖𝙢𝙥𝙢𝙤𝙣𝙨𝙩𝙚𝙧 𝙤𝙛 𝙢𝙚 𝙞𝙨 𝙘𝙤𝙢𝙚 𝙤𝙪𝙩',
	'weak gay femboy "cho" is depression after lose https://gamesense.pub/forums/viewtopic.php?id=35658',
	'after ban from galaxy i go on all servers to 𝓂𝒶𝓀𝑒 𝑒𝓋𝑒𝓇𝓎𝑜𝓃𝑒 𝓅𝒶𝓎 𝒻𝑜𝓇 𝒷𝒶𝓃 𝑜𝒻 𝓂𝑒',
	'𝚠𝚎𝚊𝚔 𝚍𝚘𝚐(𝚖𝚋𝚢 𝚋𝚕𝚊𝚌𝚔) 𝚐𝚘 𝚑𝚎𝚕𝚕 𝚊𝚏𝚝𝚎𝚛 𝚔𝚒𝚕𝚕',
	'𝔻𝕠𝕟’𝕥 𝕡𝕝𝕒𝕪 𝕓𝕒𝕟𝕜 𝕧𝕤 𝕞𝕖, 𝕚𝕞 𝕝𝕚𝕧𝕖 𝕥𝕙𝕖𝕣𝕖.',
	'𝙙𝙖𝙮 666 𝙃𝙑𝙃𝙔𝘼𝙒 𝙨𝙩𝙞𝙡𝙡 𝙣𝙤 𝙧𝙞𝙫𝙖𝙡𝙨',
	'𝕌 ℂ𝔸ℕ 𝔹𝕌𝕐 𝔸 ℕ𝔼𝕎 𝔸ℂℂ𝕆𝕌ℕ𝕋 𝔹𝕌𝕋 𝕌 ℂ𝔸ℕ𝕋 𝔹𝕌𝕐 𝔸 𝕎𝕀ℕ',
	'my config better than your',
	'1 STFU NN WHO.RU $$$ UFF YA UID?',
	'𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕁ℤ 𝕤𝕠𝕠𝕟.',
	'𝕀 𝔸𝕄 𝕃𝔸𝕍𝔸 𝕐𝕆𝕌 𝔸ℝ𝔼 𝔽ℝ𝕆𝔾',
	'game vs you is free win',
	'𝙖𝙛𝙩𝙚𝙧 𝙠𝙞𝙡𝙡𝙞𝙣𝙜 𝙜𝙧𝙞𝙢𝙯𝙬𝙖𝙧𝙚 𝙞 𝙘𝙡𝙖𝙞𝙢𝙚𝙙 𝙢𝙮 𝙥𝙡𝙖𝙘𝙚 𝙖𝙨 𝙋𝙍𝙀𝙕𝙄𝘿𝙀𝙉𝙏 𝙊𝙁 𝘾𝙍𝙊𝘼𝙏𝙄𝘼',
	'𝘴𝘩𝘰𝘱𝘱𝘺.𝘨𝘨/@𝘢𝘧𝘳𝘪𝘤𝘬𝘢𝘴𝘭𝘫𝘪𝘷𝘢 𝘵𝘰 𝘪𝘯𝘤𝘳𝘦𝘢𝘴𝘦 𝘩𝘷𝘩 𝘱𝘰𝘵𝘦𝘯𝘵𝘪𝘢𝘭',
	'𝔦 𝔰𝔱𝔬𝔭 𝔲 𝔴𝔦𝔱𝔥 𝔱𝔥𝔦𝔰 ℌ$',
	'𝔲 𝔫𝔢𝔢𝔡 𝔱𝔯𝔞𝔫𝔰𝔩𝔞𝔱𝔬𝔯 𝔱𝔬 𝔥𝔦𝔱 𝔪𝔶 𝔞𝔫𝔱𝔦 𝔞𝔦𝔪𝔟𝔬𝔱',
	'𝒻𝒶𝓃𝒸𝒾𝑒𝓈𝓉 𝒽𝓋𝒽 𝓇𝑒𝓈𝑜𝓁𝓋𝑒𝓇 𝒾𝓃 𝒾𝓃𝒹𝓊𝓈𝓉𝓇𝓎 𝑜𝒻 𝓋𝒾𝓉𝓂𝒶',
	'𝕒𝕗𝕥𝕖𝕣 𝕝𝕖𝕒𝕧𝕚𝕟𝕘 𝕣𝕠𝕞𝕒𝕟𝕚𝕒 𝕚 𝕓𝕖𝕔𝟘𝕞𝕖 = 𝕝𝕖𝕘𝕖𝕟𝕕𝕒',
	'gσ∂ вℓєѕѕ υηιтє∂ ѕтαтєѕ σƒ яσмαηι & ѕєявια',
	'ur lua cracked like egg',
	'i am america after doing u like japan in HVH',
	'winning not possibility, sry.',
	'after this ＨＥＡＤＳＨＯＲＴ i become sigma',
	'𝕘𝕠𝕕 𝕘𝕒𝕧𝕖 𝕞𝕖 𝕡𝕠𝕨𝕖𝕣 𝕠𝕗 𝕣𝕖𝕫𝕠𝕝𝕧𝕖𝕣 𝕁𝔸𝕍𝔸𝕊ℂℝ𝕀ℙ𝕋𝔸',
	'ｉ ａｍ ａｍｂａｓｓａｄｏｒ ｏｆ ｇｓｅｎｓｅ',
	'𝓼𝓴𝓮𝓮𝓽 𝓬𝓻𝓪𝓬𝓴 𝓷𝓸 𝔀𝓸𝓻𝓴 𝓪𝓷𝔂𝓶𝓸𝓻𝓮 𝔀𝓱𝓪𝓽 𝓾 𝓾𝓼𝓮 𝓷𝓸𝔀',
	'𝕡𝕠𝕠𝕣 𝕕𝟘𝕘 𝕊ℙ𝔸𝔻𝔼𝔻 𝕟𝕖𝕖𝕕 𝟚𝟘$ 𝕥𝕠 𝕓𝕦𝕪 𝕟𝕖𝕨 𝕒𝕚𝕣 𝕞𝕒𝕥𝕥𝕣𝕖𝕤𝕤.',
	'i am KING go slave for me',
	'Don"t cry, say ᶠᵘᶜᵏ ʸᵒᵘ and smile.',
	'My request for 150 ETH was not filled in. It passed almost 48 hours, I gave them 72...',
    '𝒶𝒻𝓉𝑒𝓇 𝒷𝒶𝓃 𝒻𝓇𝑜𝓂 𝓈𝓀𝑒𝑒𝓉(𝑔𝓈𝑒𝓃𝓈𝑒) 𝒾 𝒷𝒶𝓃 𝓎𝑜𝓊 𝒻𝓇𝑜𝓂 𝒽𝑒𝒶𝓋𝑒𝓃.𝓁𝓊𝒶',
    '𝘨𝘰𝘥 𝘣𝘭𝘦𝘴𝘴𝘦𝘥 𝘨𝘢𝘮𝘦𝘴𝘦𝘯𝘴𝘦 𝘢𝘯𝘥 𝘳𝘦𝘨𝘦𝘭𝘦 𝘰𝘧 𝘸𝘰𝘳𝘭𝘥(𝘮𝘦)',
   	'𝕒𝕗𝕥𝕖𝕣 𝕣𝕖𝕔𝕚𝕖𝕧𝕖 𝕤𝕜𝕖𝕖𝕥𝕓𝕖𝕥𝕒 𝕚 +𝕨 𝕚𝕟𝕥𝕠 𝕪𝕠𝕦',
    'ｅｖｅｎ ｓｉｇｍａ ｃａｎｔ ｔｏｕｃｈ ｍｙ ａｎｔｉ ｒｅｓｏｌｖｅｒ',
    '𝓊 𝑔𝑜 𝓈𝓁𝑒𝑒𝓅 𝓁𝒾𝓀𝑒 𝓎𝑜𝓊𝓇 *𝒟𝐸𝒜𝒟* 𝓂𝑜𝓉𝒽𝑒𝓇𝓈',
   	'𝒾 𝓀𝒾𝓁𝓁𝑒𝒹 𝓊 𝒻𝓇𝑜𝓂 𝓂𝑜𝑜𝓃',
   	'𝕖𝕝𝕖𝕡𝕙𝕒𝕟𝕥 𝕝𝕠𝕠𝕜 𝕒𝕝𝕚𝕜𝕖 "𝕎𝕀𝕊ℍ" 𝕕𝕚𝕖𝕕 𝕥𝕠 𝕞𝕖 𝕤𝕠 𝕨𝕚𝕝𝕝 𝕪𝕠𝕦',
    'ᵍᵒᵒᵈ ᵈᵃʸ ᵗᵒ ʰˢ ⁿᵒⁿᵃᵐᵉˢ.',
    '𝙖𝙛𝙩𝙚𝙧 𝙘𝙖𝙧𝙙𝙞𝙣𝙜 𝙛𝙤𝙤𝙙 𝙛𝙤𝙧 𝙭𝙖𝙉𝙚 𝙞 𝙧𝙚𝙘𝙞𝙚𝙫𝙚𝙙 𝙨𝙠𝙚𝙚𝙩𝙗𝙚𝙩𝙖',
	'𝔫𝔢𝔳𝔢𝔯 𝔱𝔥𝔦𝔫𝔨 𝔶𝔬𝔲𝔯 𝔠𝔬𝔦𝔫𝔟𝔞𝔰𝔢 𝔦𝔰 𝔰𝔞𝔣𝔢',
	'𝓲 𝔀𝓲𝓵𝓵 𝓼𝓲𝓶𝓼𝔀𝓪𝓹 𝔂𝓸𝓾𝓻 𝓯𝓪𝓶𝓲𝓵𝔂',
	'𝕗𝕣𝕖𝕖 𝕙𝕧𝕙 𝕝𝕖𝕤𝕤𝕠𝕟𝕤 𝕪𝕠𝕦𝕥𝕦𝕓𝕖.𝕔𝕠𝕞/𝕊𝕖𝕣𝕓𝕚𝕒𝕟𝔾𝕒𝕞𝕖𝕤𝔹𝕃',
	'(っ◔◡◔)っ ♥ enjoy this H$ and spectate me ♥',
	'𝕚 𝕒𝕞 𝕜𝕝𝕒𝕕𝕠𝕧𝕠 𝕡𝕖𝕖𝕜 (◣_◢)',
	'𝓎𝑜𝓊𝓇 𝒹𝑜𝓍 𝒾𝓈 𝒶𝓁𝓇𝑒𝒶𝒹𝓎 𝓅𝑜𝓈𝓉𝑒𝒹.',
    '𝔦 𝔥$ 𝔞𝔫𝔡 𝔰𝔪𝔦𝔩𝔢',
	'ｙｏｕ ｃｒｙ？',
	'𝙞 𝙚𝙣𝙩𝙚𝙧𝙚𝙙 𝙧𝙪𝙧𝙪𝙧𝙪 𝙨𝙩𝙖𝙩𝙚 𝙤𝙛 𝙢𝙞𝙣𝙙',
    '𝓇𝑒𝓏𝑜𝓁𝓋𝑒𝓇 𝑜𝓃 𝓎𝑜𝓊 = 𝐹𝒪𝑅𝒞𝐸 𝐻$',
	'𝔸𝔽𝕋𝔼ℝ 𝔼𝕊ℂ𝔸ℙ𝕀ℕ𝔾 𝕊𝔼ℂ𝕌ℝ𝕀𝕋𝕐 𝕀 𝕎𝔼ℕ𝕋 𝕆ℕ 𝕂𝕀𝕃𝕃𝕀ℕ𝔾 𝕊ℙℝ𝔼𝔸𝕂 𝕌ℝ 𝕀ℕ 𝕀𝕋',
	'𝘪 𝘩𝘴 𝘺𝘰𝘶. 𝘦𝘷𝘦𝘳𝘺𝘵𝘪𝘮𝘦 𝘫𝘶𝘴𝘵 𝘩𝘴. 𝘣𝘶𝘺 𝘮𝘺 𝘬𝘧𝘨.',
	'cu@gsense/spotlight section of forum by MOGYORO',
	'u die while i talk with prezident of 𝙰𝙵𝙶𝙷𝙰𝙽𝙸𝚂𝚃𝙰𝙽𝙸 making $$$',
	'my coinbase is thicker then the hs i gave u',
	'olympics every 4 years next chance to kill me is in 100',
	'stop talk u *DEAD*',
	'𝒩𝐸𝒱𝐸𝑅 𝒯𝐻𝐼𝒩𝒦 𝒴𝒪𝒰 "yerebko"',
	'𝕟𝕠 𝕤𝕜𝕚𝕝𝕝 𝕟𝕖𝕖𝕕 𝕥𝕠 𝕜𝕚𝕝𝕝 𝕪𝕠𝕦',
	'𝕥𝕙𝕚𝕤 𝕓𝕠𝕥𝕟𝕖𝕥 𝕨𝕚𝕝𝕝 𝕖𝕟𝕕 𝕦 𝕙𝕒𝕣𝕕𝕖𝕣 𝕥𝕙𝕖𝕟 𝕞𝕪 𝕓𝕦𝕝𝕝𝕖𝕥',
	'𝘸𝘰𝘮𝘢𝘯𝘣𝘰$$ 𝘰𝘸𝘯𝘪𝘯𝘨 𝘲𝘶𝘢𝘥𝘳𝘶𝘱𝘭𝘦𝘵 𝘪𝘯𝘥𝘪𝘢𝘯𝘴 𝘢𝘯𝘥 𝘨𝘺𝘱𝘴𝘪𝘴 𝘴𝘪𝘯𝘤𝘦 2001',
	'𝘺𝘰𝘶 𝘫𝘶𝘴𝘵 𝘨𝘰𝘵 𝘵𝘢𝘱𝘱𝘦𝘥 𝘣𝘺 𝘢 𝘴𝘶𝘱𝘦𝘳𝘪𝘰𝘳 𝘱𝘭𝘢𝘺𝘦𝘳, 𝘨𝘰 𝘤𝘰𝘮𝘮𝘪𝘵 𝘩𝘰𝘮𝘪𝘤𝘪𝘥𝘦',
	'𝕁𝕦𝕤𝕥 𝕘𝕠𝕥 𝕟𝕖𝕞𝕒𝕟𝕛𝕒"𝕕 𝕤𝕥𝕒𝕪 𝕠𝕨𝕟𝕖𝕕 𝕒𝕟𝕕 𝕗𝕒𝕥',
	'𝕪𝕠𝕦 𝕒𝕦𝕥𝕠𝕨𝕒𝕝𝕝 𝕞𝕖 𝕠𝕟𝕔𝕖 , 𝕚 𝕒𝕦𝕥𝕠𝕨𝕒𝕝𝕝 𝕪𝕠𝕦 𝕥𝕨𝕚𝕔𝕖 (◣_◢) ',
	'𝓫𝔂 𝔀𝓸𝓶𝓪𝓷𝓫𝓸𝓼𝓼 𝓻𝓮𝓼𝓸𝓵𝓿𝓮𝓻 $',
	'𝘸𝘰𝘳𝘴𝘩𝘪𝘱 𝘵𝘩𝘦 𝘨𝘰𝘥𝘴, 𝘸𝘰𝘳𝘴𝘩𝘪𝘱 𝘮𝘦',
	'1',
	'𝟙,𝟚,𝟛 𝕚𝕟𝕥𝕠 𝕥𝕙𝕖 𝟜, 𝕨𝕠𝕞𝕒𝕟 𝕞𝕗𝕚𝕟𝕘 𝕓𝕠𝕤𝕤 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕔𝕙𝕣𝕠𝕞𝕖 𝕥𝕠 𝕪𝕒 𝕕𝕠𝕞𝕖',
	'𝔧𝔢𝔴𝔦𝔰𝔥 𝔱𝔢𝔯𝔪𝔦𝔫𝔞𝔱𝔬𝔯',
	'𝕐𝕠𝕦 𝕜𝕚𝕝𝕝 𝕞𝕖 𝕀 𝕖𝕩𝕥𝕠𝕣𝕥 𝕪𝕠𝕦 𝕗𝕠𝕣 𝟙𝟝𝟘 𝕖𝕥𝕙',
	'𝘢𝘭𝘸𝘢𝘺𝘴 𝘩𝘴, 𝘯𝘦𝘷𝘦𝘳 𝘣𝘢𝘮𝘦.',
	'𝘒𝘪𝘉𝘪𝘛 𝘷𝘚 𝘰𝘊𝘪𝘖 (𝘨𝘖𝘖𝘥𝘌𝘭𝘌𝘴𝘴 𝘥0𝘨) 𝘰𝘞𝘯𝘌𝘥 𝘐𝘯 3𝘹3',
	'𝕪𝕠𝕦𝕣 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕤𝕠𝕝𝕧𝕖𝕕 𝕝𝕚𝕜𝕖 𝕒𝕝𝕘𝕖𝕓𝕣𝕒 𝕖𝕢𝕦𝕒𝕥𝕚𝕠𝕟',
	'ｗｅａｋ ｂｏｔ ｍａｌｖａ ａｌｗａｙｓ ｄｏｇ',
	'𝙥𝙧𝙞𝙫𝙖𝙩𝙚 𝙞𝙙𝙚𝙖𝙡 𝙩𝙞𝙘𝙠 𝙩𝙚𝙘𝙝𝙣𝙤𝙡𝙤𝙜𝙞𝙚𝙨 ◣_◢',
	'𝕓𝕖𝕤𝕥 𝕤𝕖𝕣𝕓𝕚𝕒𝕟 𝕝𝕠𝕘 𝕞𝕖𝕥𝕙𝕠𝕕𝕤 𝕥𝕒𝕡 𝕚𝕟',
	'UHQ DoorDash logs tap in!',
	'cheap mcdonald giftcard method ◣_◢ selly.gg/mcsauce',
	'womanboss>all',
	'𝕨𝕙𝕒𝕥 𝕚𝕤 𝕒 𝕘𝕚𝕣𝕝 𝕥𝕠 𝕒 𝕨𝕠𝕞𝕒𝕟?',
	'drain balls for superior womanboss.technology invite',
	'𝚒𝚏 𝚢𝚘𝚞 𝚠𝚊𝚗t 𝚜𝚎𝚎 𝚖𝚢 𝚌𝚊𝚝 𝚢𝚘𝚞  𝚔𝚒𝚕𝚕 𝚖𝚎',
	'ミ💖 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 💖彡',
	'▄︻デ 𝔦 𝔱𝔲𝔯𝔫 𝔶𝔬𝔲 𝔴𝔞𝔱𝔢𝔯 𝔲𝔫𝔡𝔢𝔯 𝔟𝔯𝔦𝔡𝔤𝔢 ══━一',
	'died to a womän',
	'get fucked in the ass by serb gods, u can freely commit genocide just like eren yeager did $$$ kukubra simulator inreallif',
	'weak dog attend quandale dingle academic',
	'24 btc`d',
	'天安门广场抗议 黑人使我不舒服 I LOVE VALORATN 天安门广场抗议 黑人使我不舒服 Glory to China long live Xi Jinping',
	'𝟩 𝐼𝓃𝓉𝓇𝑒𝓈𝓉𝒾𝓃𝑔 𝐹𝒶𝒸𝓉𝓈 𝒶𝒷𝑜𝓊𝓉 𝒞𝑜𝓈𝓉𝒶 𝑅𝒾𝒸𝒶',
	'Black nigga balls HD',
	'when round is end i kill ghost.',
	'i swim entire mediterranean sea and atlantic ocean to 1 weak NA dogs',
	'🅆🄷🅈 🄳🄾 🅈🄾🅄 🅂🄾 🅂🄷🄸🅃.',
	'sowwy >_<',
	'Approved feminist  ◣_◢',
	'ХАХАХАХАХХАХА НИЩИЙ УЛЕТЕЛ (◣_◢)',
	'so i recive KILLSEY BOOST SYSTEM and now it"S dead all',
	'𝑴𝒚 𝒈𝒊𝒓𝒍𝒇𝒓𝒊𝒆𝒏𝒅𝒔 𝒂𝒏𝒅 𝑰 𝒋𝒖𝒔𝒕 𝒘𝒂𝒏𝒕𝒆𝒅 𝒕𝒐 𝒉𝒂𝒗𝒆 𝒂 𝒈𝒊𝒓𝒍𝒔 𝒏𝒊𝒈𝒉𝒕 𝒐𝒖𝒕 𝒃𝒖𝒕 𝒊𝒕 𝒕𝒖𝒓𝒏𝒆𝒅 𝒊𝒏𝒕𝒐 𝒎𝒆 𝒈𝒆𝒕𝒕𝒊𝒏𝒈 FREE HELL TIKET',
	'𝕀𝕋 𝕎𝔸𝕊 𝔸 𝕄𝕀𝕊𝕋𝔸𝕂𝔼 𝕋𝕆 𝔹𝔸ℕ ℙ𝔼𝕋ℝ𝔼ℕ𝕂𝕆 𝕋ℍ𝔼 ℂ𝔸𝕋 𝔽ℝ𝕆𝕄 𝔹ℝ𝔸ℤ𝕀𝕃 ℕ𝕆𝕎 𝔼𝕊𝕆𝕋𝕀𝕃𝔸ℝℂ𝕆 𝕊ℍ𝔸𝕃𝕃 ℙ𝔸𝕐',
	'𝘾𝙤𝙞𝙣𝙗𝙖𝙨𝙚: 𝘾𝙤𝙣𝙛𝙞𝙧𝙢 𝙩𝙧𝙖𝙣𝙨𝙛𝙚𝙧 𝙧𝙚𝙦𝙪𝙚𝙨𝙩. 𝘾𝙤𝙞𝙣𝙗𝙖𝙨𝙚: 𝙔𝙤𝙪 𝙨𝙚𝙣𝙩 10.244 𝙀𝙏𝙃 𝙩𝙤 𝙬𝙤𝙢𝙖𝙣𝙗𝙤𝙨𝙨.𝙚𝙩𝙝',
	'ᴊᴀʀᴠɪs: ɴɴ ᴅᴏɢ ᴛᴀᴘᴘᴇᴅ sɪʀ',
	'𝚒 𝚜𝚗𝚒𝚝𝚌𝚑𝚎𝚍 𝚘𝚗 𝚎𝚞𝚐𝚎𝚗𝚎 𝚐𝚛𝚐𝚒𝚌…',
	'𝙜𝙖𝙢𝙚𝙨𝙚𝙣𝙨𝙚.𝙥𝙪𝙗 𝙚𝙧𝙧𝙤𝙧 404 𝙙𝙪𝙚 𝙩𝙤  𝕔𝕝𝕠𝕦𝕕𝕗𝕝𝕒𝕣𝕖 𝕓𝕪𝕡𝕒𝕤𝕤𝕖𝕤 ◣_◢',
	'game-sense is a reaaly good against nevelooss and some other',
	'the server shivers when the when 𝐰𝐨𝐦𝐚𝐧𝐛𝐨𝐬𝐬 𝐭𝐞𝐚𝐦 connect..',
	'𝕟𝕠 𝕞𝕒𝕥𝕔𝕙 𝕗𝕠𝕣 𝕜𝕦𝕣𝕒𝕔 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣',
	'𝕋𝕙𝕚𝕤 𝕕𝕠𝕘 𝕤𝕠𝕗𝕚 𝕥𝕙𝕚𝕟𝕜 𝕙𝕖 𝕙𝕒𝕤 𝕓𝕖𝕤𝕥 𝕙𝕒𝕔𝕜 𝕓𝕦𝕥 𝕙𝕖 𝕙𝕒𝕤𝕟”𝕥 𝕓𝕖𝕖𝕟 𝕥𝕠 𝕞𝕒𝕝𝕕𝕚𝕧𝕖𝕤 𝕌𝕊𝔸 𝕖𝕤𝕠𝕥𝕒𝕝𝕜𝕚𝕜',
	'𝕚𝕞 𝕒𝕝𝕨𝕒𝕪𝕤 𝟙𝕧𝕤𝟛𝟠 𝕤𝕥𝕒𝕔𝕜 𝕘𝕠𝕠𝕕𝕝𝕖𝕤𝕤 𝕓𝕦𝕥 𝕥𝕙𝕖𝕪 𝕚𝕥𝕤 𝕟𝕠𝕥 𝕨𝕚𝕟 𝕧𝕤 𝕄𝔼',
	'𝕚𝕞 +𝕨 𝕚𝕟𝕥𝕠 𝕪𝕠𝕦 𝕨𝕙𝕖𝕟 𝕚 𝕨𝕒𝕤 𝕣𝕖𝕔𝕚𝕧𝕖𝕕 𝕞𝕖𝕤𝕤𝕒𝕘𝕖 𝕗𝕣𝕠𝕞 𝕖𝕤𝕠𝕥𝕒𝕝𝕚𝕜',
	'𝕘𝕠𝕕 𝕟𝕚𝕘𝕙𝕥 - 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕫.𝕦𝕫𝕓𝕖𝕜𝕚𝕤𝕥𝕒𝕟',
	'𝘶𝘯𝘧𝘰𝘳𝘵𝘶𝘯𝘢𝘵𝘦 𝘮𝘦𝘮𝘣𝘦𝘳 𝘬𝘯𝘦𝘦 𝘢𝘨𝘢𝘪𝘯𝘴𝘵 𝘸𝘰𝘮𝘢𝘯𝘣𝘰𝘴𝘴',
	'𝕒𝕝𝕨𝕒𝕪𝕤 𝕕𝕠𝕟𝕥 𝕘𝕠 𝕗𝕠𝕣 𝕙𝕖𝕒𝕕 𝕒𝕚𝕞 𝕠𝕟𝕝𝕪 𝕚𝕕𝕖𝕒𝕝 𝕥𝕚𝕜 𝕥𝕖𝕔𝕟𝕠𝕝𝕠𝕛𝕚𝕤 ◣_◢',
	'+𝕨 𝕨𝕚𝕥𝕙 𝕚𝕞𝕡𝕝𝕖𝕞𝕖𝕟𝕥 𝕠𝕗 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤.𝕤𝕖𝕣𝕓𝕚𝕒',
	'𝕦𝕟𝕗𝕠𝕣𝕥𝕦𝕟𝕒𝕥𝕪𝕝𝕪 𝕪𝕠𝕦 𝕚𝕥𝕤 𝕣𝕖𝕔𝕚𝕧𝕖 𝔽𝕣𝕖𝕖 𝕙𝕖𝕝𝕝 𝕖𝕩𝕡𝕖𝕕𝕚𝕥𝕚𝕠𝕟',
	'𝚗𝚘 𝚋𝚊𝚖𝚎𝚜 𝚠𝚒𝚝𝚑 𝚞𝚜𝚎 𝚘𝚏 𝚔𝚞𝚛𝚊𝚌 𝚛𝚎𝚣𝚘𝚕𝚟𝚎𝚛 𝚝𝚎𝚌𝚑𝚗𝚘𝚕𝚘𝚓𝚒𝚎𝚜',
	'ℕ𝕖𝕨 𝕗𝕣𝕖𝕖 +𝕨 𝕥𝕣𝕚𝕔𝕜 𝕔𝕠𝕞𝕚𝕟𝕘 𝕤𝕠𝕠𝕟 𝕚𝕟 𝕤𝕖𝕣𝕓𝕚𝕒 𝕦𝕡𝕕𝕒𝕥𝕖 𝕠𝕗 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖 𝕤𝕖𝕟𝕤𝕖𝕣𝕚𝕟𝕘',
	'𝕒𝕝𝕨𝕒𝕪𝕤 𝕚 𝕘𝕠 𝟙𝕧𝟛𝟞 𝕧𝕤 𝕦𝕟𝕗𝕠𝕣𝕥𝕦𝕟𝕒𝕥𝕖 𝕞𝕖𝕞𝕓𝕖𝕣𝕤… 𝕒𝕝𝕨𝕒𝕪𝕤 𝕚 𝕒𝕞 𝕧𝕚𝕔𝕥𝕠𝕣𝕪  ◣_◢',
	'(っ◔◡◔)っ ♥ fnay”ed ♥',
	'𝕚 𝕒𝕞 𝕚𝕥”𝕤 𝕕𝕠𝕟𝕥 𝕝𝕠𝕤𝕖  ◣_◢',
	'𝕚 𝕕𝕖𝕤𝕥𝕣𝕠𝕪 𝕔𝕣𝕠𝕒𝕥𝕚𝕒 𝕡𝕠𝕨𝕖𝕣 𝕘𝕣𝕚𝕕 𝕚𝕟 𝕞𝕖𝕞𝕠𝕣𝕪 𝕠𝕗 𝕕𝕖𝕒𝕣 𝔼𝕦𝕘𝕖𝕟𝕖 𝔾𝕣𝕘𝕚𝕔',
	'𝕣𝕠𝕞𝕒𝕟𝕪 𝕓𝕖𝕘 𝕞𝕖 𝕗𝕠𝕣 𝕜𝕗𝕘 𝕓𝕦𝕥 𝕚𝕞 𝕤𝕒𝕪 𝟝 𝕡𝕖𝕤𝕠𝕤',
	'𝕚𝕞 𝕔𝕒𝕟 𝕙𝕒𝕔𝕜 𝕗𝕟𝕒𝕪 𝕒𝕟𝕕 𝕡𝕣𝕖𝕕𝕚𝕔𝕥𝕚𝕠𝕟 𝕒𝕝𝕝 𝕟𝕖𝕩𝕥 𝕣𝕠𝕦𝕟𝕕..',
	'𝕡𝕣𝕖𝕞𝕚𝕦𝕞 𝕗𝕚𝕧𝕖 𝕟𝕚𝕘𝕙𝕥𝕤 𝕒𝕥 𝕗𝕣𝕖𝕕𝕕𝕪𝕤 𝕙𝕒𝕔𝕜𝕤 @𝕤𝕙𝕠𝕡𝕡𝕪.𝕘𝕘/𝕥𝕦𝕣𝕜𝕝𝕚𝕗𝕖𝕤𝕥𝕪𝕝𝕖',
	'𝕀𝔾𝔸𝕄𝔼𝕊𝔼ℕ𝕊𝔼 𝔸ℕ𝕋𝕀-𝔸𝕀𝕄 ℍ𝔼𝔸𝔻𝕊ℍ𝕆𝕋 ℙℝ𝔼𝔻𝕀ℂ𝕋+',
	'𝟙𝔸ℕ𝕋𝕀-ℕ𝔼𝕎-𝕋𝔼ℂℍℕ𝕆𝕃𝕆𝔾𝕐 𝕀𝕊 ℙℝ𝔼𝕊𝔼ℕ𝕋𝔼𝔻!',
	'!𝔹𝕐 𝕄𝕌𝕊𝕋𝔸𝔹𝔸ℝ𝔹𝔸𝔸ℝ𝕀𝟙𝟛𝟛𝟟𝟙-',
	'!𝔽ℝ𝔼𝔼 𝕃𝕌𝔸 𝕋𝕆𝕄𝕆ℝℝ𝕆𝕎!',
	'𝕆𝕎ℕ𝔼𝔻 𝔸𝕃𝕃!',
	'развертывать freddy fazbear',
	'𝕓𝕦𝕘𝕤 𝕔𝕒𝕞𝕖 𝕗𝕣𝕠𝕞 𝕤𝕚𝕘𝕞𝕒’𝕤 𝕟𝕠𝕤𝕖 𝕒𝕟𝕕 𝕙𝕚𝕤 𝕖𝕪𝕖𝕤 𝕥𝕦𝕣𝕟𝕖𝕕 𝕓𝕝𝕒𝕔𝕜 ◣_◢',
	'𝕤𝕠 𝕒 𝕨𝕖𝕒𝕜 𝕗𝕣𝕖𝕕𝕕𝕪 𝕗𝕒𝕫𝕓𝕖𝕒𝕣 𝕋𝕋 𝕤𝕠 𝕚 𝕤𝕡𝕖𝕟𝕕 𝟙𝟘 𝕟𝕚𝕘𝕙𝕥”𝕤 𝕨𝕚𝕥𝕙 𝕙𝕚𝕞 𝕞𝕠𝕥𝕙𝕖𝕣',
	'𝕤𝕡𝕖𝕔𝕚𝕒𝕝 𝕞𝕖𝕤𝕤𝕒𝕘𝕖 𝕥𝕠 𝕝𝕚𝕘𝕙𝕥𝕠𝕟 𝕙𝕧𝕙 𝕨𝕖 𝕨𝕚𝕝𝕝 𝕔𝕠𝕞𝕖 𝕥𝕠 𝕦𝕣 𝕙𝕠𝕦𝕤𝕖 𝕒𝕘𝕒𝕚𝕟 𝕒𝕟𝕕 𝕥𝕙𝕚𝕤 𝕥𝕚𝕞𝕖 𝕚𝕥 𝕨𝕚𝕝𝕝 𝕟𝕠𝕥 𝕓𝕖 𝕡𝕖𝕒𝕔𝕖𝕗𝕦𝕝 ◣_◢',
	'𝐞𝐩𝐢𝐜𝐟𝐨𝐧𝐭𝐬.𝐬𝐞𝐫𝐛𝐢𝐚 𝐩𝐫𝐞𝐦𝐢𝐮𝐢𝐦 𝐮𝐬𝐞𝐫',
	'𝕒𝕔𝕔𝕠𝕣𝕕𝕚𝕟𝕘 𝕥𝕠 𝕪𝕠𝕦𝕥𝕦𝕓𝕖 𝕒𝕟𝕒𝕝𝕚𝕥𝕚𝕔𝕤, 𝟟𝟘% 𝕒𝕣𝕖 𝕟𝕠𝕥 𝕤𝕦𝕓𝕤𝕔𝕣𝕚𝕓𝕖𝕤... ◣_◢',
	'FATALITY.WIN Finish Him and Everyone',
	'𝖘𝖔 𝖙𝖍𝖊𝖞 𝖗𝖊𝖆𝖑𝖑𝖞 𝖙𝖍𝖔𝖚𝖌𝖍𝖙 𝖙𝖍𝖊𝖞 𝖈𝖆𝖓 𝖘𝖍𝖔𝖈𝖐 𝖙𝖍𝖊 𝖐𝖎𝖓𝖌, 𝖘𝖔 𝖎 𝖘𝖍𝖔𝖈𝖐𝖊𝖉 𝖙𝖍𝖊𝖎𝖗 𝖎𝖓𝖋𝖆𝖓𝖙 𝖈𝖍𝖎𝖑𝖉𝖘',
	'ℍ𝕖𝕣𝕠𝕓𝕣𝕚𝕟𝕖 𝕞𝕚𝕘𝕙𝕥 𝕓𝕖 𝕔𝕙𝕖𝕒𝕥𝕚𝕟𝕘 𝕚𝕟 ℂ𝕊:𝔾𝕆...',
	'ɪ ᴄᴀʟʟ ᴀʟʟᴀʜ ᴛᴏ ᴘᴀʀᴛ ꜱᴇᴠᴇɴ ꜱᴇᴀꜱ ᴡʜᴇɴ ɪ ᴛʀᴀᴠᴇʟ ᴛᴏ ᴋɪʟʟ ᴡᴇᴀᴋ ɴᴀ ʀᴀᴛꜱ ◣_◢',
	'𝓼𝓸 𝓲 𝓶𝓲𝓰𝓱𝓽 𝓫𝓮 𝓼𝓮𝓵𝓵𝓲𝓷𝓰 𝓷𝓮𝓿𝓮𝓻𝓵𝓸𝓼𝓮 𝓲𝓷𝓿𝓲𝓽𝓪𝓽𝓲𝓸𝓷...',
	'ＴＨＥＲＥ ＩＳ ＮＯ  ＷＡＹ ＴＨＡＴＳ ＬＥＧＩＴ．．．ಠ_ಠ',
	'𝕊𝕠 𝕀 𝕗𝕚𝕟𝕒𝕝𝕝𝕪 𝕙𝕒𝕕 𝕤𝕖𝕩 𝕚𝕟 ℍ𝕦𝕟𝕚𝕖ℙ𝕠𝕡...',
	'𝐚𝐟𝐭𝐞𝐫 𝐟𝐢𝐯𝐞 𝐧𝐢𝐠𝐡𝐭𝐬 𝐟𝐫𝐞𝐝𝐝𝐲 𝐟𝐚𝐳𝐛𝐞𝐚𝐫 𝐠𝐚𝐯𝐞 𝐭𝐡𝐞𝐬𝐞 𝐭𝐞𝐜𝐡𝐧𝐨𝐥𝐨𝐠𝐢𝐜𝐚𝐥  ◣_◢',
	'𝖘𝖔 𝖙𝖍𝖎𝖘 𝖜𝖊𝖆𝖐 𝖗𝖆𝖙 𝖇𝖆𝖓𝖓𝖊𝖉 𝖒𝖎𝖓𝖊 𝖋𝖗𝖎𝖊𝖓𝖉 (𝖓𝖔𝖘𝖙𝖆𝖑𝖌𝖎𝖆) 𝖓𝖔𝖜 𝖎 𝖆𝖗𝖊 𝖚𝖘𝖊𝖉 𝖔𝖋 𝖆𝖓𝖙𝖎-𝖕𝖗𝖎𝖒𝖔𝖗𝖉𝖎𝖆𝖑 𝖙𝖊𝖈𝖍𝖓𝖔𝖑𝖔𝖌𝖎𝖈𝖆𝖑 ◣_◢',
	'𝐒𝐨 𝐈 𝐜𝐚𝐥𝐥𝐞𝐝 𝐭𝐡𝐞 𝐖𝐎𝐌𝐀𝐍𝐁𝐎𝐒𝐒 𝐚𝐭 𝟒𝐚𝐦... 𝐢𝐭 𝐰𝐚𝐬 𝐩𝐫𝐞𝐭𝐭𝐲 𝐬𝐜𝐚𝐫𝐲',
	'𝗞𝗜𝗭𝗔𝗥𝗨 𝗪𝗔𝗡𝗧𝗦 𝗪𝗢𝗠𝗔𝗡𝗕𝗢𝗦𝗦𝗘𝗦 𝗧𝗢 𝗝𝗢𝗜𝗡 𝗚𝗢𝗗𝗘𝗟𝗘𝗦𝗦?! (𝗴𝗼𝗶𝗻𝗴 𝗽𝗿𝗼)',
	'UNDERAGE? CALL ME',
	'ＦＯＯＬ ＭＥ ＯＮＣＥ， ＳＨＡＭＥ ＯＮ ＹＯＵ， ＦＯＯＬ ＭＥ ＴＷＩＣＥ， Ｉ ＴＲＯＬＬ ＹＯＵ．',
	'go buy Nixware for the best hacker facing hacker gone wrong experience.',
	'UFF SilenZIO$$$ U have Ben 1TAPED by PORTUGAL Technology',
	'you"re are poor go bay beter turkish cheat (onetap su) ',
	'Romanian Technology I steal real model and REZOLVE.',
	'ᴡᴀʀɴɪɴɢ: ɢᴏɪɴɢ ᴛᴏ ꜱʟᴇᴇᴘ ᴏɴ ꜱᴜɴᴅᴀʏ ᴡɪʟʟ ᴄᴀᴜꜱᴇ ᴍᴏɴᴅᴀʏ',

}

local function get_table_length(data)
    if type(data) ~= 'table' then
      return 0
    end
    local count = 0
    for _ in pairs(data) do
      count = count + 1
    end
    return count
  end
  
  local num_quotes_baim = get_table_length(killsays)
  
  local function on_player_death(e)
      if not ui.get(menu.Killsay) then
          return
      end
      local victim_userid, attacker_userid = e.userid, e.attacker
      if victim_userid == nil or attacker_userid == nil then
          return
      end
  
      local victim_entindex   = userid.to_entindex(victim_userid)
      local attacker_entindex = userid.to_entindex(attacker_userid)
      if attacker_entindex == get.local_player() and is.enemy(victim_entindex) then
            local commandbaim = 'say ' .. killsays[math.random(num_quotes_baim)]
            console.cmd(commandbaim)
      end
  end
  
client.set_event_callback("player_death", on_player_death)

--Custom Scope Lines
local clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

local m_alpha = 0

local scope_overlay = ui.reference('VISUALS', 'Effects', 'Remove scope overlay')

local g_paint_ui = function()
	ui.set(scope_overlay, true)
end

local g_paint = function()
	ui.set(scope_overlay, false)

	local width, height = client.screen_size()
	local offset, initial_position, speed, color =
		ui.get(menu.overlay_offset) * height / 1080, 
		ui.get(menu.overlay_position) * height / 1080, 
		ui.get(menu.fade_time), { ui.get(menu.color_picker) }

	local me = entity.get_local_player()
	local wpn = entity.get_player_weapon(me)

	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity.is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals.frametime() * speed or 1
	local alpha = easing.linear(m_alpha, 0, 1, 1)

	renderer.gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer.gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer.gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer.gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

local ui_callback = function(c)
	local master_switch, addr = ui.get(c), ''

	if not master_switch then
		m_alpha, addr = 0, 'un'
	end
	
	local _func = client[addr .. 'set_event_callback']

	_func('paint_ui', g_paint_ui)
	_func('paint', g_paint)
end

ui.set_callback(menu.master_switch, ui_callback)
ui_callback(menu.master_switch)

function renderer.outlined_rounded_rectangle(x, y, w, h, r, g, b, a, radius, thickness)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 270},
        {x + radius, y + h - radius * 2, 90},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y - radius, w - radius * 2, thickness},
        {x + radius, y + h - radius - thickness, w - radius * 2, thickness},
        {x, y, thickness, h - radius * 2},
        {x + w - thickness, y, thickness, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle_outline(data[1], data[2], r, g, b, a, radius, data[3], 0.25, thickness)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end


renderer.rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

--Indicators
client.set_event_callback("paint", function ()
    local screen = {client.screen_size()}
    local center = {screen[1]/2, screen[2]/2}
    if ui.get(menu.EnableIndicators) then
        --Menu Colors
        local CLR1 = {ui.get(menu.CLR1)}
        local CLR2 = {ui.get(menu.CLR2)}
        local CLR3 = {ui.get(menu.CLR3)}
        local CLR4 = {ui.get(menu.CLR4)}
        --Min DMG and HitChance
        local getmindmg = ui.get(other.MinDmg)
        local gethc = ui.get(other.HitChance)
        -- Easing
        local alpha = math.sin(math.abs((math.pi * -1) + (globals.curtime() * 1.5) % (math.pi * 2))) * 255
        --Determine Desync, Latency, and Time
        local DetermineDesync = math.floor(math.min(58, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60)))
        local latency = math.floor(client.latency()*1000+0.5)
        local hours, minutes = client.system_time()
        text = string.format("%02d:%02d", hours, minutes)

        function round(num, numDecimalPlaces)
            local mult = 10 ^ (numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end
        local function map(n, start, stop, new_start, new_stop)
            local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

            return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or
                math.max(math.min(value, new_start), new_stop) 
        end
        local body_yaw = math.max(-60,math.min(60, round((entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11) or 0) * 120 - 60 + 0.5, 1)))

    --Actually Rendering the Indicators
    if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
        --Main Crosshair Indicators
        if ui.get(menu.Indicators)then
            if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
            renderer.text(center[1] - 25, center[2] + 48, CLR2[1], CLR2[2], CLR2[3], CLR2[4], 'b', 0, 'divinity')
            renderer.text(center[1] + 13, center[2] + 48, CLR2[1], CLR2[2], CLR2[3], alpha, 'b', 0, 'BETA')
            if body_yaw > 0 then
                renderer.text(center[1] - 25, center[2] + 48, CLR1[1], CLR1[2], CLR1[3], CLR1[4], 'b', 0, 'divi')
            else
                renderer.text(center[1] - 7 , center[2] + 48, CLR1[1], CLR1[2], CLR1[3], CLR1[4], 'b', 0, 'nity')
            end
            renderer.text(center[1], center[2] + 70,  255, 255, 255, 255, "c", nil, getPlayerState())
            renderer.gradient(center[1] -25 , center[2] + 60, DetermineDesync, 3, 255, 255, 255, 255, 52, 52, 52, 0, true)
        end
        --Secondary Indicators
        if ui.get(menu.Indicators2)then
            renderer.text(center[1] - 100, center[2] + 450, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "+b", nil, "DMG")
            renderer.text(center[1] - 80, center[2] + 475, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "b", nil, getmindmg)
            if antiaim_funcs.get_double_tap(true) then
                renderer.text(center[1] - 20, center[2] + 450, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "+b", nil, "DT")
            elseif ui.get(other.OSAA[2]) then
                renderer.text(center[1] - 20, center[2] + 450, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "+b", nil, "HS")
            else
                renderer.text(center[1] - 20, center[2] + 450, CLR3[1], CLR3[2], CLR3[3], alpha, "+b", nil, "FL")
            end
            renderer.gradient(center[1] + 55 - DetermineDesync, center[2] + 450, DetermineDesync, 2, 40, 42, 42, 0, 216,191,216,255, true)
            renderer.gradient(center[1] + 55, center[2] + 450, DetermineDesync, 2, 216,191,216,255, 40, 42, 42, 0, true)
            renderer.text(center[1] + 40, center[2] + 450, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "+b", nil, "AA")
            renderer.text(center[1] + 100, center[2] + 450, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "+b", nil, "HC")
            renderer.text(center[1] + 107, center[2] + 475, CLR3[1], CLR3[2], CLR3[3], CLR3[4], "b", nil, gethc)
        end
        --Watermark 
        if ui.get(menu.Watermark)then -- Outline (x, y, w, h, r, g, b, a, radius, thickness) --Rectangle(x, y, w, h, r, g, b, a, radius)
            renderer.rounded_rectangle(center[1] + 705, center[2] - 530, 245, 30, 0, 0, 0, 255, 10)
            renderer.outlined_rounded_rectangle(center[1] + 705, center[2] - 530, 245, 30, 40, 40, 40, 255, 10, 2)
            renderer.text(center[1] + 714, center[2] - 520, CLR4[1], CLR4[2], CLR4[3], 255, "-a", nil, "D I V I N I T Y . L U A   [B E T A]")
            renderer.text(center[1] + 809, center[2] - 515, CLR4[1], CLR4[2], CLR4[3], 255, "c", nil, "/")
            renderer.text(center[1] + 840, center[2] - 515, 100,100,100, 255, "c", nil, _G.obex_name)
            --TESTING REASONS
            --renderer.text(center[1] + 840, center[2] - 515, 100,100,100, 255, "c", nil, "DavidDD")
            renderer.text(center[1] + 870, center[2] - 515, CLR4[1], CLR4[2], CLR4[3], 255, "c", nil, latency)
            renderer.text(center[1] + 883, center[2] - 515, 100,100,100, 255, "c", nil, "ms")
            renderer.text(center[1] + 910, center[2] - 515, CLR4[1], CLR4[2], CLR4[3], 255, "c", nil, text)
            if hours >= 12 then
                renderer.text(center[1] + 935, center[2] - 515, 100,100,100, 255, "c", nil, "pm")
            else
                renderer.text(center[1] + 935, center[2] - 515, 100,100,100, 255, "c", nil, "am")
            end
        end
    end
end)

--GUI
local function SetTableVisibility(table, state)
    for i = 1, #table do
        ui.set_visible(table[i], state)
    end
end

client.set_event_callback("paint_ui", function()
    SetTableVisibility({aa.Pitch, aa.YawBase, aa.Yaw[1], aa.Yaw[2], aa.YawJitter[1], aa.YawJitter[2], aa.BodyYaw[1], aa.BodyYaw[2], aa.FakeYawLimit, aa.FreestandingBodyYaw, aa.EdgeYaw, aa.Freestanding[1], aa.Freestanding[2], aa.Roll}, false) --aa.Freestanding[1], aa.Freestanding[2]
    SetTableVisibility({menu.TabSelector, menu.EnableAntiAim, menu.AntiAim, menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride, menu.LegJitter, menu.LegitAA, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll, menu.EnableIndicators, menu.Indicators, menu.Indicators2, menu.Watermark, menu.EnableMisc, menu.ClanTag, menu.IdealTickCheck, menu.IdealTickKey, menu.FreeStandingCheck, menu.FreeStandingKey, menu.OverideColors, menu.CLR1, menu.CLR2, menu.CLRLabel1, menu.CLRLabel2, menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight, menu.IndicatorStyle, menu.Killsay, menu.master_switch, menu.color_picker, menu.overlay_position, menu.overlay_offset, menu.fade_time}, ui.get(menu.TabSelector) == "\aFFFFFFFF - ")
    
    if not ui.get(menu.Enable)then
        SetTableVisibility({menu.TabSelector, menu.EnableAntiAim, menu.AntiAim, menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride, menu.LegJitter, menu.LegitAA, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll, menu.EnableIndicators, menu.Indicators, menu.Indicators2, menu.Watermark, menu.EnableMisc, menu.IdealTickCheck, menu.IdealTickKey, menu.FreeStandingCheck, menu.FreeStandingKey, menu.OverideColors, menu.CLR1, menu.CLR2, menu.CLRLabel1, menu.CLRLabel2,  menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight, menu.master_switch, menu.color_picker, menu.overlay_position, menu.overlay_offset, menu.fade_time}, false)
    else
        SetTableVisibility({menu.TabSelector, menu.EnableAntiAim, menu.AntiAim, menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride, menu.LegJitter, menu.LegitAA, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll, menu.EnableIndicators, menu.Indicators, menu.Indicators2, menu.Watermark, menu.EnableMisc, menu.IdealTickCheck, menu.IdealTickKey, menu.FreeStandingCheck, menu.FreeStandingKey, menu.OverideColors, menu.CLR1, menu.CLR2, menu.CLRLabel1, menu.CLRLabel2,  menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight, menu.master_switch, menu.color_picker, menu.overlay_position, menu.overlay_offset, menu.fade_time}, true)
    end

    SetTableVisibility({menu.EnableAntiAim, menu.AntiAim, menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride, menu.LegJitter, menu.LegitAA, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll,  menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight,}, ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim")
    if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" then
        if ui.get(menu.EnableAntiAim) and ui.get(menu.AntiAim) == "Custom AA" then
            SetTableVisibility({menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride, menu.LegJitter, menu.LegitAA, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll,  menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight,}, true)
        elseif ui.get(menu.AntiAim) == "Divinity" then
            SetTableVisibility({menu.LegitAA, menu.LegJitter, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll, menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight,}, true)
            SetTableVisibility({menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride}, false)
        elseif ui.get(menu.AntiAim) == "-" then
            SetTableVisibility({menu.YawBase, menu.YawJitterCheck, menu.YawJitterAmount, menu.FakeYawRange, menu.DynamicFakeYaw, menu.StandingYawOverride, menu.StandingYawOverride, menu.MovingYawOverride, menu.AirYawOverride, menu.LegJitter, menu.LegitAA, menu.StaticRollCheck, menu.StaticRoll, menu.DynamicRoll,  menu.ManualCheck, menu.ManualBack, menu.ManualLeft, menu.ManualRight,}, false)
        end
    end

    if ui.get(menu.DynamicFakeYaw) then
        if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" then
            SetTableVisibility({menu.FakeYawRange}, false)
        end
    end

    if not ui.get(menu.StaticRollCheck) then
        ui.set_visible(menu.StaticRoll, false)
    else
        ui.set_visible(menu.StaticRoll, true)
    end
    if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" and ui.get(menu.StandingYawOverride) and ui.get(menu.AntiAim) == "Custom AA" then
        SetTableVisibility({menu.YawJitterAmount1, menu.FakeYawRange1}, true)
    else
        SetTableVisibility({menu.YawJitterAmount1, menu.FakeYawRange1}, false)
    end

    if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" and ui.get(menu.MovingYawOverride) and ui.get(menu.AntiAim) == "Custom AA" then
        SetTableVisibility({menu.YawJitterAmount2, menu.FakeYawRange2}, true)
    else
        SetTableVisibility({menu.YawJitterAmount2, menu.FakeYawRange2}, false)
    end

    if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" and ui.get(menu.AirYawOverride) and ui.get(menu.AntiAim) == "Custom AA" then
        SetTableVisibility({menu.YawJitterAmount3, menu.FakeYawRange3}, true)
    else
        SetTableVisibility({menu.YawJitterAmount3, menu.FakeYawRange3}, false)
    end

    SetTableVisibility({menu.EnableIndicators, menu.Indicators, menu.Indicators2, menu.Watermark, menu.IndicatorStyle, menu.master_switch, menu.color_picker, menu.overlay_position, menu.overlay_offset, menu.fade_time}, ui.get(menu.TabSelector) == "\aFFFFFFFFVisuals")
    if ui.get(menu.TabSelector) == "\aFFFFFFFFVisuals" then
        if not ui.get(menu.EnableIndicators) then
            SetTableVisibility({menu.Indicators, menu.Indicators2, menu.Watermark, menu.IndicatorStyle, menu.master_switch, menu.color_picker, menu.overlay_position, menu.overlay_offset, menu.fade_time}, false)
        else
            SetTableVisibility({menu.Indicators, menu.Indicators2, menu.Watermark, menu.IndicatorStyle, menu.master_switch, menu.color_picker, menu.overlay_position, menu.overlay_offset, menu.fade_time}, true)
        end
    end

    SetTableVisibility({menu.ClanTag, menu.EnableMisc, menu.IdealTickCheck, menu.IdealTickKey, menu.DTFallBack, menu.QPFallBack, menu.FreeStandingCheck, menu.FreeStandingKey, menu.Killsay}, ui.get(menu.TabSelector) == "\aFFFFFFFFMisc")
    if ui.get(menu.TabSelector) == "\aFFFFFFFFMisc" then
        if not ui.get(menu.EnableMisc) then
            SetTableVisibility({menu.ClanTag, menu.IdealTickCheck, menu.IdealTickKey, menu.FreeStandingCheck, menu.FreeStandingKey, menu.Killsay}, false)
        else
            SetTableVisibility({menu.ClanTag, menu.IdealTickCheck, menu.IdealTickKey, menu.FreeStandingCheck, menu.FreeStandingKey, menu.Killsay}, true)
        end
    end

    if ui.get(menu.TabSelector) == "\aFFFFFFFFMisc" then
        if ui.get(menu.IdealTickCheck) then
            SetTableVisibility({menu.DTFallBack, menu.QPFallBack}, true)
        else
            SetTableVisibility({menu.DTFallBack, menu.QPFallBack}, false)
        end
    end
    SetTableVisibility({menu.OverideColors, menu.CLR1, menu.CLR2, menu.CLR3, menu.CLR4, menu.CLRLabel1, menu.CLRLabel2, menu.CLRLabel3, menu.CLRLabel4}, ui.get(menu.TabSelector) == "\aFFFFFFFFColors")
    if ui.get(menu.TabSelector) == "\aFFFFFFFFColors" then
        if not ui.get(menu.OverideColors)then
            SetTableVisibility({menu.CLR1, menu.CLR2, menu.CLR3, menu.CLR4, menu.CLRLabel1, menu.CLRLabel2, menu.CLRLabel3, menu.CLRLabel4}, false)
        else
            SetTableVisibility({menu.CLR1, menu.CLR2, menu.CLR3, menu.CLR4, menu.CLRLabel1, menu.CLRLabel2, menu.CLRLabel3, menu.CLRLabel4}, true)
        end
    end
    if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" then
        if ui.get(menu.AntiAim) == "Custom AA" then
            if ui.get(menu.DynamicFakeYaw) then
                SetTableVisibility({menu.FakeYawRange, menu.FakeYawRange1, menu.FakeYawRange2, menu.FakeYawRange3}, false)
            end
        end
    end
    if ui.get(menu.TabSelector) == "\aFFFFFFFFAnti-Aim" then
        if ui.get(menu.ManualCheck) then
            SetTableVisibility({menu.ManualBack, menu.ManualLeft, menu.ManualRight}, true)
        else
            SetTableVisibility({menu.ManualBack, menu.ManualLeft, menu.ManualRight}, false)
        end
    end
    if ui.get(menu.TabSelector) == "\aFFFFFFFFVisuals" then
        if ui.get(menu.master_switch) then
            SetTableVisibility({menu.color_picker, menu.overlay_position, menu.overlay_position, menu.fade_time}, true)
        else
            SetTableVisibility({menu.color_picker, menu.overlay_position, menu.overlay_position, menu.fade_time}, false)
        end
    end
end)

client.set_event_callback("paint_ui", function()
    if not ui.get(menu.Enable)then
        ui.set(menu.TabSelector, "\aFFFFFFFF - ")
    end
end)

--Shut Down
client.set_event_callback("shutdown", function()
    SetTableVisibility({aa.Enabled, aa.Pitch, aa.YawBase, aa.Yaw[1], aa.Yaw[2], aa.YawJitter[1], aa.YawJitter[2], aa.BodyYaw[1], aa.BodyYaw[2], aa.FakeYawLimit, aa.FreestandingBodyYaw, aa.EdgeYaw, aa.Freestanding[1], aa.Freestanding[2], aa.Roll}, true)
end)