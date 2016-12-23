local acutil = require('acutil')
local teamname ="";
local charname ="";
local isLoaded = false;
local isWugushi = false;
local isNecro = false;
local necro_rank;
local timer;
local settings = {
}

local default_acc = {
}

local default = {
	debug_ = 0;
	list_hp = {
		641801, --1920,2688 Highly Condensed HP Potion
		641219, --1920,2688 Lv15 Condensed HP Potion
		640224, --1870,2618 Keista HP Potion Lv3
		641218, --1840,2576 Lv14 Condensed HP Potion
		641217, --1760,2464 Lv13 Condensed HP Potion
		641216, --1680,2352 Lv12 Condensed HP Potion
		640184, --1680,2352 Taumas HP Potion
		641215, --1600,2240 Lv11 Condensed HP Potion
		640223, --1560,2184 Keista HP Potion Lv2
		640178, --1520,2128 Kalejimas HP Potion
		641214, --1520,2128 Lv10 Condensed HP Potion
		641906, --1520,2128 Basic HP Potion Lv10
		641213, --1440,2016 Lv9 Condensed HP Potion
		641212, --1360,1904 Lv8 Condensed HP Potion
		640222, --1300,1820 Keista HP Potion Lv1
		641211, --1280,1792 Lv7 Condensed HP Potion
		641210, --1200,1680 Lv6 Condensed HP Potion
		641209, --1120,1568 Lv5 Condensed HP Potion
		641905, --1120,1568 Basic HP Potion Lv5
		640180, --1120,1568 Alemeth HP Potion
		641208, --1040,1456 Lv4 Condensed HP Potion
		641207, --960,1344 Lv3 Condensed HP Potion
		641206, --800,1232 Lv2 Condensed HP Potion
		641201, --800,1120 Lv1 Condensed HP Potion
		640004, --640,896 Large HP Potion
		640093, --?,640 Basic Large HP Potion
		640003, --320,448 HP Potion
		640092, --?,320 Basic HP Potion Supply
		640002, --190,266 Small HP Potion
		640091, --?,192 Basic Small HP Potion
		640072 --?,? Popolion Meat (lol)
		};
	list_sp ={
		640225, --1300,1820 Keista SP Potion Lv1
		640226, --1560,2184 Keista SP Potion Lv2
		640227, --1870,2618 Keista SP Potion Lv3
		641233, --765,1071 Lv15 Condensed SP Potion
		641802, --765,1071 Highly Condensed SP Potion
		641232, --735,1029 Lv14 Condensed SP Potion
		641231, --700,980 Lv13 Condensed SP Potion
		641230, --670,938 Lv12 Condensed SP Potion
		640185, --670,938 Rasvoy SP Potion
		641229, --640,896 Lv11 Condensed SP Potion
		641228, --605,847 Lv10 Condensed SP Potion
		640179, --605,847 Kalejimas SP Potion
		641908, --605,847 Basic SP Potion Lv10
		641227, --575,805 Lv9 Condensed SP Potion
		641226, --540,756 Lv8 Condensed SP Potion
		641225, --510,714 Lv7 Condensed SP Potion
		641224, --480,672 Lv6 Condensed SP Potion
		641223, --445,623 Lv5 Condensed SP Potion
		640181, --445,623 Alemeth SP Potion
		641907, --445,623 Basic SP Potion Lv5
		641222, --415,581 Lv4 Condensed SP Potion
		641221, --380,532 Lv3 Condensed SP Potion
		641220, --350,490 Lv2 Condensed SP Potion
		641202, --320,448 Lv1 Condensed SP Potion
		640096, --?,480 Basic Large SP Potion
		640007, --240,336 Large SP Potion
		640095, --?,240 Basic SP Potion
		640006, --120,168 SP Potion
		640094,	--?,144 Basic Small SP Potion
		640005  --70,98 Small SP Potion
	};
	list_sta = {
		641247,--78 Lv15 Condensed Stamina Pill
		641246,--76 Lv14 Condensed Stamina Pill
		641245,--74 Lv13 Condensed Stamina Pill
		641244,--72 Lv12 Condensed Stamina Pill
		641243,--70 Lv11 Condensed Stamina Pill
		641242,--68 Lv10 Condensed Stamina Pill
		641241,--66 Lv9 Condensed Stamina Pill
		641240,--64 Lv8 Condensed Stamina Pill
		641239,--62 Lv7 Condensed Stamina Pill
		641238,--60 Lv6 Condensed Stamina Pill
		641237,--58 Lv5 Condensed Stamina Pill
		641236,--56 Lv4 Condensed Stamina Pill
		641235,--54 Lv3 Condensed Stamina Pill tradeable
		641339,--54 Lv3 Condensed Stamina Pill
		641234,--52 Lv2 Condensed Stamina Pill
		641203,--50 Lv1 Condensed Stamina Pill
		640009,--40 Stamina Pill
		640010,--40 Big Stamina Pill
		640099,--40 Basic Big Stamina Pill
		640008,--30 Small Stamina Pill
		640098,--30 Basic Stamina Pill
		640097--15 Basic Small Stamina Pill
	};
	list_necro_fragment = {
		640140,--30, Fragmentation Jewel
		0
	};
	version = '1.7.1';
}

local default_character = {
	turn_on = true;
	timer_check = 200;
	hp = 70;
	sp = 10;
	sta = 0;
	num_hp = 5000;
	num_sp = 300;
	num_sta = 0;
	mode = 0; -- mode 0: %, mode 1: number of hp/sp/sta
	subjob = true;
}

function AUTOPOT_Wugushi()
	local etc_pc = GetMyEtcObject();
	local poisonAmount = etc_pc['Wugushi_PoisonAmount'];
	local poisonMaxAmount = etc_pc['Wugushi_PoisonMaxAmount'];
	if poisonMaxAmount - poisonAmount > 199 then
		local invItemList = session.GetInvItemList();
		if invItemList ~= nil then
			local index = invItemList:Head();
			local invItemCount = invItemList:Count();
			for j = 0 , invItemCount - 1 do
				local invItem = invItemList:Element(index);
				if invItem ~= nil then
					local itemCls = GetIES(invItem:GetObject());
					if itemCls ~= nil then
						local Item_Poison = GetClass("item_poisonpot",itemCls.ClassName)
						if Item_Poison ~= nil then
							AUTOPOT_write_debug("Poison","work "..tostring(itemCls.ClassID));
							session.ResetItemList();-- clear list
							session.AddItemID(invItem:GetIESID(),1);--add to list 645569
							local resultlist = session.GetItemIDList();
							item.DialogTransaction("POISONPOT",resultlist);
							return;
						end
					end
				end
				index = invItemList:Next(index);
			end
		end
	end
end

function AUTOPOT_CAN_I_POT()
	if isLoaded == false then return 0; end
	if settings.acc[teamname].character[charname].turn_on == false then return 0; end
	local stat = info.GetStat(session.GetMyHandle());
	local isSit = control.IsRestSit();
	if stat.HP <= 0 then return 0; end
	if isSit == true then return 0;	end
	return 1;
end

function AUTOPOT_USE_POTION(potionlist)
	--Get your inventory item list
	local invItemList = session.GetInvItemList();
	if invItemList ~= nil then
		local index = invItemList:Head();
		local invItemCount = invItemList:Count();
		--Go through inventory and compare with the potion list if matches, use it.
		for j = 0 , invItemCount - 1 do
			local invItem = invItemList:Element(index);
			if invItem ~= nil then
				local itemCls = GetIES(invItem:GetObject());	
				if itemCls ~= nil then
					--Cycle through all the potions in potionlist
					for i = 0, #potionlist do
						if itemCls.ClassID == potionlist[i] then
							if item.GetCoolDown(itemCls.ClassID) == 0 then
								item.UseByGUID(invItem:GetIESID());
								AUTOPOT_write_debug("Potion","work "..tostring(itemCls.ClassID));
								return;
							end
						end
					end
				end
			end
			index = invItemList:Next(index);
		end
	end
end

function AUTOPOT_write_debug(type_pot,text)
	if settings.debug_ == 1 then
		CHAT_SYSTEM("[Autopot]"..type_pot..':'..text);
	end
end

function AUTOPOT_HELP()
	CHAT_SYSTEM('[Autopot]');
	CHAT_SYSTEM('/autopot');
	CHAT_SYSTEM('/autopot on/off');
	CHAT_SYSTEM('/autopot subjob');
	CHAT_SYSTEM('/autopot subjob on/off');
	CHAT_SYSTEM('/autopot show');
	CHAT_SYSTEM('/autopot set timer xxx (milisec)');
	CHAT_SYSTEM('/autopot set mode percent/value');
	CHAT_SYSTEM('/autopot set hp/sp/sta xx');
	CHAT_SYSTEM('Example:/autopot set hp 20');
end

function AUTOPOT_LOAD_SETTINGS()
	local s, err = acutil.loadJSON("../addons/autopot/settings.json");
	if err then
        settings = default;
		settings.acc = {};
		settings.acc[teamname] = default_acc;
		settings.acc[teamname].character = {}; 
		settings.acc[teamname].character[charname] = default_character;
    else
        settings = s;
		if settings.version ~= default.version then 
			settings = default;	
			settings.acc = {};
			settings.acc[teamname] = default_acc;
			settings.acc[teamname].character = {};
			settings.acc[teamname].character[charname] = default_character;
		end;
    end
	AUTOPOT_SAVE_SETTINGS();
	
end

function AUTOPOT_SAVE_SETTINGS()
	table.sort(settings)
	acutil.saveJSON("../addons/autopot/settings.json", settings);
end

--/autopot on/off
--/autopot help
--/autopot set hp xx (percent)
function AUTOPOT_CHAT_CMD(command)
	local cmd  = ''
    local cmd1 = ''
    local cmd2 = ''
	
	if #command > 0 then
		cmd = table.remove(command, 1)
		if cmd == 'help' then AUTOPOT_HELP() end;
		if cmd == 'on' then settings.acc[teamname].character[charname].turn_on = true	CHAT_SYSTEM("[Autopot] Turn "..cmd) end;
		if cmd == 'off' then settings.acc[teamname].character[charname].turn_on = false CHAT_SYSTEM("[Autopot] Turn "..cmd) end;
		if cmd == 'debug' then 
			if settings.debug_ == 1 then settings.debug_ = 0; else settings.debug_ = 1; end
			CHAT_SYSTEM("debug:"..tostring(settings.debug_));
		end
		if cmd == 'show' then
			local mode = "";
			if settings.acc[teamname].character[charname].mode == 0 then mode = "percent" else mode = "value" end;
			CHAT_SYSTEM('[Autopot] '..teamname.." "..charname.."");
			CHAT_SYSTEM('Turn on: '..tostring(settings.acc[teamname].character[charname].turn_on));
			CHAT_SYSTEM('Timer: '..tostring(settings.acc[teamname].character[charname].timer_check));
			if isWugushi then CHAT_SYSTEM('Wugushi: '..tostring(settings.acc[teamname].character[charname].subjob).."|"..tostring(isWugushi)) end
			if isNecro then CHAT_SYSTEM('Necro: '..tostring(settings.acc[teamname].character[charname].subjob).."|"..tostring(isNecro)) end
			CHAT_SYSTEM('Mode: '..mode);
			CHAT_SYSTEM('Type pot: percent | value');
			CHAT_SYSTEM("Hp: "..tostring(settings.acc[teamname].character[charname].hp).." | "..tostring(settings.acc[teamname].character[charname].num_hp));
			CHAT_SYSTEM("Sp: "..tostring(settings.acc[teamname].character[charname].sp).." | "..tostring(settings.acc[teamname].character[charname].num_sp));
			CHAT_SYSTEM("Sta: "..tostring(settings.acc[teamname].character[charname].sta).." | "..tostring(settings.acc[teamname].character[charname].num_sta));
		end
	else 
		settings.acc[teamname].character[charname].turn_on = not settings.acc[teamname].character[charname].turn_on; 
		CHAT_SYSTEM("[Autopot] Turn "..tostring(settings.acc[teamname].character[charname].turn_on))
	end
	
	if #command > 0 then
		cmd1 = table.remove(command, 1)
		if cmd == 'subjob' and (isWugushi or isNecro) then
			if cmd1 == 'on' then settings.acc[teamname].character[charname].subjob = true;
			elseif cmd1 == 'off' then settings.acc[teamname].character[charname].subjob = false;
			else settings.acc[teamname].character[charname].subjob = not settings.acc[teamname].character[charname].subjob; 
			end
			local wugu = "";
			if settings.acc[teamname].character[charname].subjob == true then wugu = "turn on" else wugu = "turn off" end;
			if isWugushi then CHAT_SYSTEM('Wugushi auto poison: '..wugu);
			else CHAT_SYSTEM('Necro auto: '..wugu); end
		end
	end
	
	if #command > 0 then
		cmd2 = table.remove(command, 1)
		if cmd == 'set' then
			local done = false;
			local error__ = false;
			if type(tonumber(cmd2)) == 'number' then
				local num__ = tonumber(cmd2);
				if settings.acc[teamname].character[charname].mode == 0 and (num__ <0 or num__ >=100 ) and cmd1 ~= "timer" then 
					CHAT_SYSTEM("[Autopot] Error value input need:");
					CHAT_SYSTEM("0 <= value input < 100");
					error__ = true;
					done = true;
				end
				
				if cmd1 == "hp" and done == false then 
					if settings.acc[teamname].character[charname].mode == 0 then settings.acc[teamname].character[charname].hp = num__;
					else settings.acc[teamname].character[charname].num_hp = num__; end;
					done = true
				end;
				
				if cmd1 == "sp" and done == false then 
					if settings.acc[teamname].character[charname].mode == 0 then settings.acc[teamname].character[charname].sp = num__;
					else settings.acc[teamname].character[charname].num_sp = num__; end;
					done = true
				end;
				
				if cmd1 == "sta" and done == false then 
					if settings.acc[teamname].character[charname].mode == 0 then settings.acc[teamname].character[charname].sta = num__;
					else settings.acc[teamname].character[charname].num_sta = num__; end;
					done = true
				end;
				
				if cmd1 == "timer" and done == false then
					settings.acc[teamname].character[charname].timer_check = num__;
					done = true;
				end;
			else
				if cmd1 == 'mode' and done == false then 
					if cmd2 == 'percent' then settings.acc[teamname].character[charname].mode = 0; done =true end;
					if cmd2 == 'value' then settings.acc[teamname].character[charname].mode = 1; done = true end;
				end;
			end;
			if error__ == false then
				if done then CHAT_SYSTEM("[Autopot] Set "..cmd1.." to "..cmd2);
				else CHAT_SYSTEM("[Autopot] Error "..cmd.." "..cmd1.." "..cmd2) AUTOPOT_HELP() end;
			end;
		else CHAT_SYSTEM("[Autopot] Error "..cmd.." "..cmd1.." "..cmd2) AUTOPOT_HELP() end;
	end
	
	AUTOPOT_SAVE_SETTINGS()
end

function AUTOPOT_CHECK(frame)
	if AUTOPOT_CAN_I_POT() == 0 then return 1; end
	if os.clock()*1000 < timer + settings.acc[teamname].character[charname].timer_check then return 1; else timer = os.clock()*1000; end
	
	--Wugushi
	if isWugushi and settings.acc[teamname].character[charname].subjob then AUTOPOT_Wugushi(); end
	
	local stat = info.GetStat(session.GetMyHandle());
	--HP
	if (stat.HP < settings.acc[teamname].character[charname].hp*stat.maxHP/100 and settings.acc[teamname].character[charname].mode == 0) or 
		(settings.acc[teamname].character[charname].mode == 1 and stat.HP < settings.acc[teamname].character[charname].num_hp) 
	then AUTOPOT_USE_POTION(settings.list_hp); end
	--SP
	if (stat.SP < settings.acc[teamname].character[charname].sp*stat.maxSP/100 and settings.acc[teamname].character[charname].mode == 0) or 
		(settings.acc[teamname].character[charname].mode == 1 and stat.SP < settings.acc[teamname].character[charname].num_sp) 
	then AUTOPOT_USE_POTION(settings.list_sp); end
	--STA
	if (stat.Stamina < settings.acc[teamname].character[charname].sta*stat.MaxStamina/100 and settings.acc[teamname].character[charname].mode == 0) or 
		(settings.acc[teamname].character[charname].mode == 1 and stat.Stamina < settings.acc[teamname].character[charname].num_sta) 
	then AUTOPOT_USE_POTION(settings.list_sta); end
	--Necro
	if isNecro and settings.acc[teamname].character[charname].subjob then
		local max_fragment_necro = 300;
		if session.GetJobGrade(2009) == 3 then max_fragment_necro = 900 end;
		
		local myEtcPc = GetMyEtcObject();
		local num_fragment_necro = myEtcPc.Necro_DeadPartsCnt;
		if (max_fragment_necro - num_fragment_necro) > 29 then AUTOPOT_USE_POTION(settings.list_necro_fragment); end
	end	
	return 1;
end

function AUTOPOT_ON_INIT(addon, frame)
	isWugushi = false;
	isNecro = false;
	local index = 0;
	while 1 do
		local jobid = session.GetHaveJobIdByIndex(index);
		if jobid == 3006 then isWugushi = true; break;
		elseif jobid == 2009 then isNecro = true; break;
		elseif jobid == -1 then break; end
		index = index + 1;
	end
	teamname = info.GetFamilyName(session.GetMyHandle());
	charname = info.GetName(session.GetMyHandle());
	
	if isLoaded == false then
		AUTOPOT_LOAD_SETTINGS(); 
		acutil.slashCommand('/autopot',AUTOPOT_CHAT_CMD);
		CHAT_SYSTEM("[Autopot ver"..default.version.."] loader. Type '/autopot help' for show help");
		isLoaded = true;
	end;
	if settings.acc[teamname] == nil then
		settings.acc[teamname] = default_acc;
		settings.acc[teamname].character = {};
	end
	
	if settings.acc[teamname].character[charname] == nil then
		settings.acc[teamname].character[charname] = default_character;
	end
	
	timer = os.clock()*1000;
	frame:ShowWindow(1);
	frame:RunUpdateScript("AUTOPOT_CHECK", 0, 0, 0, 1);
end