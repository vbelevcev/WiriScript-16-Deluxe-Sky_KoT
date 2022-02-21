--[[
--------------------------------
THIS FILE IS PART OF WIRISCRIPT
Discord Nowiry#2663
Deluxe
Discord Sky_KoT#8064
--------------------------------
]]
util.require_natives(1640181023)
--require("natives-1640181023")
require "wiriscript.functions"
--require 'lua_imGUI V3'
require 'lua_imGUI V2-1'
json = require 'pretty.json'
ufo = require "wiriscript.ufo"
guided_missile = require "wiriscript.guided_missile"
UI = UI.new()

local version = 16
local scriptdir = filesystem.scripts_dir()
local wiridir = scriptdir .. '\\WiriScript\\'
local languagedir = wiridir .. 'language\\'
local config_file = wiridir .. 'config.ini'
local profiles_list = {}
local spoofname = true
local spoofrid = true
local spoofcrew = true
local usingprofile = false
local showing_intro = false
worldptr = memory.rip(memory.scan('48 8B 05 ? ? ? ? 45 ? ? ? ? 48 8B 48 08 48 85 C9 74 07') + 3)
if worldptr == 0 then 
	error('pattern scan failed: CPedFactory') 
end

local image = "DIA_CLIFFORD" ------ Картинка уведомлений https://wiki.rage.mp/index.php?title=Notification_Pictures
local audible = true
local delay = 10--задержка--300 по умолчанию
local shake, delay = 0, 300 --тряска камеры по умолчанию и задержка цикла
-------------------------------------
-----------------------------------
-- FILE SYSTEM
-----------------------------------

if not filesystem.exists(wiridir) then
	filesystem.mkdir(wiridir)
end

if not filesystem.exists(languagedir) then
	filesystem.mkdir(languagedir)
end

if not filesystem.exists(wiridir .. '\\profiles') then
	filesystem.mkdir(wiridir .. '\\profiles')
end

if not filesystem.exists(wiridir .. '\\handling') then
	filesystem.mkdir(wiridir .. '\\handling') 
end

if filesystem.exists(wiridir .. '\\logo.png') then
	os.remove(wiridir .. '\\logo.png')
end

if filesystem.exists(wiridir .. '\\config.data') then
	os.remove(wiridir .. '\\config.data')
end

if filesystem.exists(scriptdir .. '\\savednames.data') then
	os.remove(scriptdir .. '\\savednames.data')
end

if filesystem.exists(filesystem.resources_dir() .. '\\wiriscript_logo.png') then
	os.remove(filesystem.resources_dir() .. '\\wiriscript_logo.png')
end

if filesystem.exists(wiridir .. '\\profiles.data') then
	os.remove(wiridir .. '\\profiles.data')
end

-----------------------------------
-- CONSTANTS
-----------------------------------

-- label =  'weapon ID'
local weapons = {
--[[
WT_SNIP_RMT ="weapon_remotesniper",
WT_GNADE_SMK ="weapon_smokegrenade",
WT_ELCFEN ="weapon_electric_fence",
WT_PIST ="weapon_rammed_by_car",
WT_PIST ="weapon_run_over_by_car",
WT_RAGE ="weapon_cougar",
WT_V_PLRLSR ="vehicle_weapon_player_laser",
WT_INVALID ="0",
WT_INVALID ="WT_INVALID"
--]]
WT_EMPL = "weapon_emplauncher",
WT_UNARMED = "weapon_unarmed",
WT_KNIFE = "w_me_knife_01", 
WT_NGTSTK = "w_me_nightstick", 
WT_HAMMER = "w_me_hammer", 
WT_BAT = "w_me_bat", 
WT_CROWBAR = "w_me_crowbar", 
WT_GOLFCLUB = "w_me_gclub", 
WT_BOTTLE = "w_me_bottle", 
WT_DAGGER = "w_me_dagger", 
WT_SHATCHET = "w_me_hatchet", 
WT_KNUCKLE = "weapon_knuckle", 
WT_MACHETE = "weapon_machete", 
WT_FLASHLIGHT = "weapon_flashlight", 
WT_SWBLADE = "weapon_switchblade", 
WT_BATTLEAXE = "weapon_battleaxe", 
WT_POOLCUE = "weapon_poolcue", 
WT_WRENCH = "weapon_wrench", 
WT_HATCHET = "weapon_stone_hatchet",
--["-3- Дробовики"] = "Shotguns",
WT_SG_PMP = "weapon_pumpshotgun",
WT_SG_PMP2 = "weapon_pumpshotgun_mk2",
WT_SG_SOF = "weapon_sawnoffshotgun",
WT_SG_BLP = "weapon_bullpupshotgun",
WT_SG_ASL = "weapon_assaultshotgun",
WT_MUSKET = "weapon_musket",
WT_HVYSHOT = "weapon_heavyshotgun",
WT_DBSHGN = "weapon_dbshotgun",
WT_AUTOSHGN = "weapon_autoshotgun",
WT_CMBSHGN= "weapon_combatshotgun",
--["-4- Тяжелое оружие"] = "Heavy Weapons",
WT_GL = "weapon_grenadelauncher",
WT_RPG = "weapon_rpg",
WT_MINIGUN = "weapon_minigun",
WT_FWRKLNCHR = "weapon_firework",
WT_RAILGUN = "weapon_railgun",
WT_HOMLNCH = "weapon_hominglauncher",
WT_CMPGL = "weapon_compactlauncher",
WT_RAYMINIGUN = "weapon_rayminigun",
--["-5- Метательное"] = "Throwables",
WT_GNADE = "weapon_grenade",
WT_GNADE_STK = "weapon_stickybomb",
WT_PRXMINE = "weapon_proxmine",
WT_PIPEBOMB = "weapon_pipebomb",
WT_BZGAS = "weapon_bzgas",
WT_MOLOTOV = "weapon_molotov",
WT_FIRE= "weapon_fireextinguisher",
WT_BALL = "weapon_ball",
WT_SNWBALL = "weapon_snowball",
WT_FLAREGUN = "weapon_flare",
--["-6- Пистолеты"] = "Handguns",
WT_PIST = "weapon_pistol",
WT_PIST2  = "weapon_pistol_mk2",
WT_PIST_CBT = "weapon_combatpistol",
WT_PIST_50 = "weapon_pistol50",
WT_SNSPISTOL = "weapon_snspistol",
WT_SNSPISTOL2 = "weapon_snspistol_mk2",
WT_HEAVYPSTL = "weapon_heavypistol",
WT_VPISTOL = "weapon_vintagepistol",
WT_CERPST = "weapon_ceramicpistol",
WT_MKPISTOL = "weapon_marksmanpistol",
WT_REVOLVER = "weapon_revolver",
WT_REVOLVER2 = "weapon_revolver_mk2",
WT_REV_DA = "weapon_doubleaction",
WT_REV_NV= "weapon_navyrevolver",
WT_GDGTPST = "weapon_gadgetpistol",
WT_PIST_AP = "weapon_appistol",
WT_STUN = "weapon_stungun",
WT_FLAREGUN = "weapon_flaregun",
WT_RAYPISTOL = "weapon_raypistol",
--["-7-Пулеметы"] = "Submachine Guns",
WT_SMG_MCR = "weapon_microsmg",
WT_MCHPIST = "weapon_machinepistol",
WT_MINISMG = "weapon_minismg",
WT_SMG = "weapon_smg",
WT_SMG2 = "weapon_smg_mk2",
WT_SMG_ASL = "weapon_assaultsmg",
WT_COMBATPDW = "weapon_combatpdw",
WT_MG = "weapon_mg",
WT_MG_CBT = "weapon_combatmg",
WT_MG_CBT2 = "weapon_combatmg_mk2",
WT_GUSENBERG = "weapon_gusenberg",
WT_RAYCARBINE = "weapon_raycarbine",
--["-8-Assault Rifles"] = "Assault Rifles",
WT_RIFLE_ASL = "weapon_assaultrifle",
WT_RIFLE_ASL2 = "weapon_assaultrifle_mk2",
WT_RIFLE_CBN = "weapon_carbinerifle",
WT_RIFLE_CBN2 = "weapon_carbinerifle_mk2",
WT_RIFLE_ADV = "weapon_advancedrifle",
WT_RIFLE_SCBN = "weapon_specialcarbine",
WT_SPCARBINE2 = "weapon_specialcarbine_mk2",
WT_BULLRIFLE = "weapon_bullpuprifle",
WT_BULLRIFLE2 = "weapon_bullpuprifle_mk2",
WT_CMPRIFLE = "weapon_compactrifle",
WT_MLTRYRFL = "weapon_militaryrifle",
--["-9- Снайперские"] = "Sniper Rifles",
WT_SNIP_RIF = "weapon_sniperrifle",
WT_SNIP_HVY = "weapon_heavysniper",
WT_SNIP_HVY2 = "weapon_heavysniper_mk2",
WT_MKRIFLE = "weapon_marksmanrifle",
WT_MKRIFLE2 = "weapon_marksmanrifle_mk2",
--["-10- Спецоружие в миссиях"] = "Miscellaneous",
WT_PETROL = "weapon_petrolcan",
WT_PARA= "gadget_parachute",
WT_FIRE = "weapon_fireextinguisher",
WT_hazardcan = "weapon_hazardcan"	
}

--['name shown in Stand'] = 'weapon ID'
local melee_weapons = {
WT_UNARMED = "weapon_unarmed",
WT_KNIFE = "w_me_knife_01", 
WT_NGTSTK = "w_me_nightstick", 
WT_HAMMER = "w_me_hammer", 
WT_BAT = "w_me_bat", 
WT_CROWBAR = "w_me_crowbar", 
WT_GOLFCLUB = "w_me_gclub", 
WT_BOTTLE = "w_me_bottle", 
WT_DAGGER = "w_me_dagger", 
WT_SHATCHET = "w_me_hatchet", 
WT_KNUCKLE = "weapon_knuckle", 
WT_MACHETE = "weapon_machete", 
WT_FLASHLIGHT = "weapon_flashlight", 
WT_SWBLADE = "weapon_switchblade", 
WT_BATTLEAXE = "weapon_battleaxe", 
WT_POOLCUE = "weapon_poolcue", 
WT_WRENCH = "weapon_wrench", 
WT_HATCHET = "weapon_stone_hatchet"
}

local shotguns_weapons = 
{
--["-3- Дробовики"] = "Shotguns",
WT_SG_PMP = "weapon_pumpshotgun",
WT_SG_PMP2 = "weapon_pumpshotgun_mk2",
WT_SG_SOF = "weapon_sawnoffshotgun",
WT_SG_BLP = "weapon_bullpupshotgun",
WT_SG_ASL = "weapon_assaultshotgun",
WT_MUSKET = "weapon_musket",
WT_HVYSHOT = "weapon_heavyshotgun",
WT_DBSHGN = "weapon_dbshotgun",
WT_AUTOSHGN = "weapon_autoshotgun",
WT_CMBSHGN= "weapon_combatshotgun"
}

local heavy_weapons = 
{
--["-4- Тяжелое оружие"] = "Heavy Weapons",
WT_GL = "weapon_grenadelauncher",
WT_RPG = "weapon_rpg",
WT_MINIGUN = "weapon_minigun",
WT_FWRKLNCHR = "weapon_firework",
WT_RAILGUN = "weapon_railgun",
WT_HOMLNCH = "weapon_hominglauncher",
WT_CMPGL = "weapon_compactlauncher",
WT_RAYMINIGUN = "weapon_rayminigun"
}


local throwables_weapons = 
{
--["-5- Метательное"] = "Throwables",
WT_GNADE = "weapon_grenade",
WT_GNADE_STK = "weapon_stickybomb",
WT_PRXMINE = "weapon_proxmine",
WT_PIPEBOMB = "weapon_pipebomb",
WT_BZGAS = "weapon_bzgas",
WT_MOLOTOV = "weapon_molotov",
WT_FIRE= "weapon_fireextinguisher",
WT_BALL = "weapon_ball",
WT_SNWBALL = "weapon_snowball",
WT_FLAREGUN = "weapon_flare"
}


local handguns_weapons = 
{
--["-6- Пистолеты"] = "Handguns",
WT_PIST = "weapon_pistol",
WT_PIST2  = "weapon_pistol_mk2",
WT_PIST_CBT = "weapon_combatpistol",
WT_PIST_50 = "weapon_pistol50",
WT_SNSPISTOL = "weapon_snspistol",
WT_SNSPISTOL2 = "weapon_snspistol_mk2",
WT_HEAVYPSTL = "weapon_heavypistol",
WT_VPISTOL = "weapon_vintagepistol",
WT_CERPST = "weapon_ceramicpistol",
WT_MKPISTOL = "weapon_marksmanpistol",
WT_REVOLVER = "weapon_revolver",
WT_REVOLVER2 = "weapon_revolver_mk2",
WT_REV_DA = "weapon_doubleaction",
WT_REV_NV= "weapon_navyrevolver",
WT_GDGTPST = "weapon_gadgetpistol",
WT_PIST_AP = "weapon_appistol",
WT_STUN = "weapon_stungun",
WT_FLAREGUN = "weapon_flaregun",
WT_RAYPISTOL = "weapon_raypistol"
}

local submachine_weapons = 
{
--["-7-Пулеметы"] = "Submachine Guns",
WT_SMG_MCR = "weapon_microsmg",
WT_MCHPIST = "weapon_machinepistol",
WT_MINISMG = "weapon_minismg",
WT_SMG = "weapon_smg",
WT_SMG2 = "weapon_smg_mk2",
WT_SMG_ASL = "weapon_assaultsmg",
WT_COMBATPDW = "weapon_combatpdw",
WT_MG = "weapon_mg",
WT_MG_CBT = "weapon_combatmg",
WT_MG_CBT2 = "weapon_combatmg_mk2",
WT_GUSENBERG = "weapon_gusenberg",
WT_RAYCARBINE = "weapon_raycarbine"
}


local rifles_weapons = 
{
--["-8-Assault Rifles"] = "Assault Rifles",
WT_RIFLE_ASL = "weapon_assaultrifle",
WT_RIFLE_ASL2 = "weapon_assaultrifle_mk2",
WT_RIFLE_CBN = "weapon_carbinerifle",
WT_RIFLE_CBN2 = "weapon_carbinerifle_mk2",
WT_RIFLE_ADV = "weapon_advancedrifle",
WT_RIFLE_SCBN = "weapon_specialcarbine",
WT_SPCARBINE2 = "weapon_specialcarbine_mk2",
WT_BULLRIFLE = "weapon_bullpuprifle",
WT_BULLRIFLE2 = "weapon_bullpuprifle_mk2",
WT_CMPRIFLE = "weapon_compactrifle",
WT_MLTRYRFL = "weapon_militaryrifle"
}

local sniper_weapons = 
{
--["-9- Снайперские"] = "Sniper Rifles",
WT_SNIP_RIF = "weapon_sniperrifle",
WT_SNIP_HVY = "weapon_heavysniper",
WT_SNIP_HVY2 = "weapon_heavysniper_mk2",
WT_MKRIFLE = "weapon_marksmanrifle",
WT_MKRIFLE2 = "weapon_marksmanrifle_mk2"
}

local misc_weapons = 
{
--["-10- Спецоружие в миссиях"] = "Miscellaneous",
WT_PETROL = "weapon_petrolcan",
WT_PARA= "gadget_parachute",
WT_FIRE = "weapon_fireextinguisher",
WT_hazardcan = "weapon_hazardcan"
}
--[[
--]]

local peds = {
-- here you can modify which peds are available to choose
-- ['name shown in Stand'] = 'ped model ID'
--здесь вы можете изменить, какие прохожие доступны для выбора
 --['Имя'] = 'Хеш или имя файла'
--Мой список прохожих

["Franklin 02 (p_)"] = "p_franklin_02",
["Lamar Davis 02 (cs)"] = "cs_lamardavis_02",
["Lamar Davis 02 (ig)"] = "ig_lamardavis_02",
["Chop 02 (a_c)"] = "a_c_chop_02",
["Dre 2 (csb)"] = "csb_ary_02",
["CSB Ballas Leader (csb)"] = "csb_ballas_leader",
["Billionaire (csb)"] = "csb_billionaire",
["Golfer A (csb)"] = "csb_golfer_a",
["Golfer B (csb)"] = "csb_golfer_b",
["Imani (Hacker) (csb)"] = "csb_imani",
["Jio 02 (csb)"] = "csb_jio_02",
["Johnny Guns (csb)"] = "csb_johnny_guns",
["Mjo 02 (csb)"] = "csb_mjo_02",
["Musician 00  (csb)"] = "csb_musician_00",
["Party promo (csb)"] = "csb_party_promo",
["Req Officer (csb)"] = "csb_req_officer",
["Security A (csb)"] = "csb_security_a",
["Soundeng 00 (csb)"] = "csb_soundeng_00",
["Vagos Leader (csb)"] = "csb_vagos_leader",
["Vernon (csb)"] = "csb_vernon",
["Dre 2 (ig)"] = "ig_ary_02",
["Ballas Leader (ig)"] = "ig_ballas_leader",
["Billionaire (ig)"] = "ig_billionaire",
["Entourage A (ig)"] = "ig_entourage_a",
["Entourage B (ig)"] = "ig_entourage_b",
["Golfer A (ig)"] = "ig_golfer_a",
["Golfer B (ig)"] = "ig_golfer_b",
["Imani (hacker girl) (ig)"] = "ig_imani",
["Jio 02 (ig)"] = "ig_jio_02",
["Johnny Guns (ig)"] = "ig_johnny_guns",
["Mjo 02 (ig)"] = "ig_mjo_02",
["Musician 00 (ig)"] = "ig_musician_00",
["Party promo (ig)"] = "ig_party_promo",
["Req Officer (ig)"] = "ig_req_officer",
["Security A (ig)"] = "ig_security_a",
["Soundeng 00 (ig)"] = "ig_soundeng_00",
["Vagos Leader (ig)"] = "ig_vagos_leader",
["Vernon (ig)"] = "ig_vernon",
["Vincent 3 (ig)"] = "ig_vincent_3",
["Studio Assist 01 (s_f_m)"] = "s_f_m_studioassist_01",
["Highsec 05 (s_m_m)"] = "s_m_m_highsec_05",
["Studio Assist 02 (s_m_m)"] = "s_m_m_studioassist_02",
["Studio Prod 01 (s_m_m)"] = "s_m_m_studioprod_01",
["Studio Soueng 02 (s_m_m)"] = "s_m_m_studiosoueng_02",
["Studio Party 01 (a_f_y)"] = "a_f_y_studioparty_01",
["Studio Party 02 (a_f_y)"] = "a_f_y_studioparty_02",
["Studio Party 01 (a_m_m)"] = "a_m_m_studioparty_01",
["Studio Party 01 (a_m_y)"] = "a_m_y_studioparty_01",
["Goons 01 (g_m_m)"] = "g_m_m_goons_01",
["Car club woman 1"] = "a_f_y_carclub_01",
["Car club man 1"] = "a_m_y_carclub_01",
["Tattoo Cust 1"] = "a_m_y_tattoocust_01",
["Avisch Wartzman 2"] = "csb_avischwartzman_02",
["Drug Dealer"] = "csb_drugdealer",
["Hao 2"] = "csb_hao_02",
["Mimi"] = "csb_mimi",
["Moodyman 2"] = "csb_moodyman_02",
["Sessanta"] = "csb_sessanta",
["Prisoners 1"] = "g_m_m_prisoners_01",
["Slasher 1"] = "g_m_m_slasher_01",
["Avisch Wartzman 2"] = "ig_avischwartzman_02",
["Benny 2"] = "ig_benny_02",
["Drug Dealer"] = "ig_drugdealer",
["Hao 2"] = "ig_hao_02",
["LilDee "] = "ig_lildee",
["Mimi"] = "ig_mimi",
["Moodyman 2"] = "ig_moodyman_02",
["Sessanta "] = "ig_sessanta",
["Autoshop 2"] = "s_f_m_autoshop_01",
["RetailStaff 1"] = "s_f_m_retailstaff_01",
["Autoshop 1"] = "s_m_m_autoshop_03",
["RaceOrg 1"] = "s_m_m_raceorg_01",
["Tattoo 1"] = "s_m_m_tattoo_01",
["Panther"] = "a_c_panther",
["Dr Dre (Ary)"] = "csb_ary",
["English Dave 2"] = "csb_englishdave_02",
["Gustavo"] = "csb_gustavo",
["Helmsman Pavel"] = "csb_helmsmanpavel",
["Island Dj"] = "csb_isldj_00",
["Island Dj 1"] = "csb_isldj_01",
["Island Dj 2"] = "csb_isldj_02",
["Island Dj 3"] = "csb_isldj_03",
["DJ Moodymann Island Dj 4"] = "csb_isldj_04",
["Jio"] = "csb_jio",
["Juan Strickler"] = "csb_juanstrickler",
["Miguel Madrazo"] = "csb_miguelmadrazo",
["Mjo"] = "csb_mjo",
["Sss"] = "csb_sss",
["Patricia 2"] = "cs_patricia_02",
["Dr Dre (Ary)"] = "ig_ary",
["English Dave 2"] = "ig_englishdave_02",
["Gustavo"] = "ig_gustavo",
["Helmsman Pavel"] = "ig_helmsmanpavel",
["Island Dj"] = "ig_isldj_00",
["Island Dj 1"] = "ig_isldj_01",
["Island Dj 2"] = "ig_isldj_02",
["Island Dj 3"] = "ig_isldj_03",
["DJ Moodymann Island Dj 4"] = "ig_isldj_04",
["DJ Moodymann Girl"] = "ig_isldj_04_d_01",
["DJ Moodymann Girl 1"] = "ig_isldj_04_d_02",
["DJ Moodymann Girl 2"] = "ig_isldj_04_e_01",
["Jackie"] = "ig_jackie",
["Jio"] = "ig_jio",
["Juan Strickler"] = "ig_juanstrickler",
["Kaylee"] = "ig_kaylee",
["Miguel Madrazo"] = "ig_miguelmadrazo",
["Mjo"] = "csb_mjo",
["Sss"] = "csb_sss",
["Patricia 2"] = "cs_patricia_02",
["Dr Dre (Ary)"] = "ig_ary",
["English Dave 2"] = "ig_englishdave_02",
["Gustavo"] = "ig_gustavo",
["Helmsman Pavel"] = "ig_helmsmanpavel",
["Island Dj"] = "ig_isldj_00",
["Island Dj 1"] = "ig_isldj_01",
["Island Dj 2"] = "ig_isldj_02",
["Island Dj 3"] = "ig_isldj_03",
["DJ Moodymann Island Dj 4"] = "ig_isldj_04",
["DJ Moodymann Girl"] = "ig_isldj_04_d_01",
["DJ Moodymann Girl 1"] = "ig_isldj_04_d_02",
["DJ Moodymann Girl 2"] = "ig_isldj_04_e_01",
["Jackie"] = "ig_jackie",
["Jio"] = "ig_jio",
["Juan Strickler"] = "ig_juanstrickler",
["Kaylee"] = "ig_kaylee",
["Miguel Madrazo"] = "ig_miguelmadrazo",
["Mjo"] = "ig_mjo",
["Old Rich Guy"] = "ig_oldrichguy",
["Pilot"] = "ig_pilot",
["Sss"] = "ig_sss",
["Beach Young Female 2"] = "a_f_y_beach_02",
["Club Customer Female 4"] = "a_m_y_clubcust_04",
["Beach Old Male 2"] = "a_m_o_beach_02",
["Beach Young Male 4"] = "a_m_y_beach_04",
["Club Customer Male 4"] = "a_m_y_clubcust_04",
["Cartel Guard 1"] = "g_m_m_cartelguards_01",
["Cartel Guard 2"] = "g_m_m_cartelguards_02",
["Beach Bar Staff"] = "s_f_y_beachbarstaff_01",
["Club Bartender Female 2"] = "s_f_y_clubbar_02",
["Bouncer 2"] = "s_m_m_bouncer_02",
["Drug Processer"] = "s_m_m_drugprocess_01",
["Field Worker"] = "s_m_m_fieldworker_01",
["High Security 4"] = "s_m_m_highsec_04",
["Abigail Mathers"] = "csb_abigail",
["Abigail Mathers"] = "ig_abigail",
["Abner"] = "u_m_y_abner",
["African American Male"] = "a_m_m_afriamer_01",
["Agatha Baker"] = "csb_agatha",
["Agatha Baker"] = "ig_agatha",
["Agent"] = "csb_agent",
["Agent"] = "ig_agent",
["Agent 14"] = "csb_mp_agent14",
["Agent 14"] = "ig_mp_agent14",
["Air Hostess"] = "s_f_y_airhostess_01",
["Air Worker Male"] = "s_m_y_airworker",
["Al Di Napoli Male"] = "u_m_m_aldinapoli",
["Alan Jerome"] = "csb_alan",
["Alien"] = "s_m_m_movalien_01",
["Altruist Cult Mid-Age Male"] = "a_m_m_acult_01",
["Altruist Cult Old Male"] = "a_m_o_acult_01",
["Altruist Cult Old Male 2"] = "a_m_o_acult_02",
["Altruist Cult Young Male"] = "a_m_y_acult_01",
["Altruist Cult Young Male 2"] = "a_m_y_acult_02",
["Amanda De Santa"] = "cs_amandatownley",
["Amanda De Santa"] = "ig_amandatownley",
["Ammu-Nation City Clerk"] = "s_m_y_ammucity_01",
["Ammu-Nation Rural Clerk"] = "s_m_m_ammucountry",
["Andreas Sanchez"] = "cs_andreas",
["Andreas Sanchez"] = "ig_andreas",
["Anita Mendoza"] = "csb_anita",
["Anton Beaudelaire"] = "csb_anton",
["Anton Beaudelaire"] = "u_m_y_antonb",
["Armenian Boss"] = "g_m_m_armboss_01",
["Armenian Goon"] = "g_m_m_armgoon_01",
["Armenian Goon 2"] = "g_m_y_armgoon_02",
["Armenian Lieutenant"] = "g_m_m_armlieut_01",
["Armoured Van Security"] = "s_m_m_armoured_01",
["Armoured Van Security 2"] = "s_m_m_armoured_02",
["Armoured Van Security Male"] = "mp_s_m_armoured_01",
["Army Mechanic"] = "s_m_y_armymech_01",
["Ashley Butler"] = "cs_ashley",
["Ashley Butler"] = "ig_ashley",
["Australian Shepherd"] = "a_c_shepherd",
["Autopsy Tech"] = "s_m_y_autopsy_01",
["Autoshop Worker"] = "s_m_m_autoshop_01",
["Autoshop Worker 2"] = "s_m_m_autoshop_02",
["Avery Duggan"] = "csb_avery",
["Avery Duggan"] = "ig_avery",
["Avon Goon"] = "mp_m_avongoon",
["Avon Hertz"] = "csb_avon",
["Avon Hertz"] = "ig_avon",
["Avon Juggernaut"] = "u_m_y_juggernaut_01",
["Azteca"] = "g_m_y_azteca_01",
["Baby D"] = "u_m_y_babyd",
["Ballas East Male"] = "g_m_y_ballaeast_01",
["Ballas Female"] = "g_f_y_ballas_01",
["Ballas OG"] = "csb_ballasog",
["Ballas OG"] = "ig_ballasog",
["Ballas Original Male"] = "g_m_y_ballaorig_01",
["Ballas South Male"] = "g_m_y_ballasout_01",
["Bank Manager"] = "cs_bankman",
["Bank Manager"] = "ig_bankman",
["Bank Manager Male"] = "u_m_m_bankman",
["Barber Female"] = "s_f_m_fembarber",
["Barman"] = "s_m_y_barman_01",
["Barry"] = "cs_barry",
["Barry"] = "ig_barry",
["Bartender"] = "s_f_y_bartender_01",
["Bartender (Rural)"] = "s_m_m_cntrybar_01",
["Baywatch Female"] = "s_f_y_baywatch_01",
["Baywatch Male"] = "s_m_y_baywatch_01",
["Beach Female"] = "a_f_m_beach_01",
["Beach Male"] = "a_m_m_beach_01",
["Beach Male 2"] = "a_m_m_beach_02",
["Beach Muscle Male"] = "a_m_y_musclbeac_01",
["Beach Muscle Male 2"] = "a_m_y_musclbeac_02",
["Beach Old Male"] = "a_m_o_beach_01",
["Beach Tramp Female"] = "a_f_m_trampbeac_01",
["Beach Tramp Male"] = "a_m_m_trampbeac_01",
["Beach Young Female"] = "a_f_y_beach_01",
["Beach Young Male"] = "a_m_y_beach_01",
["Beach Young Male 2"] = "a_m_y_beach_02",
["Beach Young Male 3"] = "a_m_y_beach_03",
["Benny"] = "ig_benny",
["Benny Mechanic (Female)"] = "mp_f_bennymech_01",
["Best Man"] = "ig_bestmen",
["Beth"] = "u_f_y_beth",
["Beverly Felton"] = "cs_beverly",
["Beverly Felton"] = "ig_beverly",
["Beverly Hills Female"] = "a_f_m_bevhills_01",
["Beverly Hills Female 2"] = "a_f_m_bevhills_02",
["Beverly Hills Male"] = "a_m_m_bevhills_01",
["Beverly Hills Male 2"] = "a_m_m_bevhills_02",
["Beverly Hills Young Female"] = "a_f_y_bevhills_01",
["Beverly Hills Young Female 2"] = "a_f_y_bevhills_02",
["Beverly Hills Young Female 3"] = "a_f_y_bevhills_03",
["Beverly Hills Young Female 4"] = "a_f_y_bevhills_04",
["Beverly Hills Young Female 5"] = "a_f_y_bevhills_05",
["Beverly Hills Young Male"] = "a_m_y_bevhills_01",
["Beverly Hills Young Male 2"] = "a_m_y_bevhills_02",
["Bigfoot"] = "cs_orleans",
["Bigfoot"] = "ig_orleans",
["Bike Hire Guy"] = "u_m_m_bikehire_01",
["Biker Chic Female"] = "u_f_y_bikerchic",
["Biker Cocaine Female"] = "mp_f_cocaine_01",
["Biker Cocaine Male"] = "mp_m_cocaine_01",
["Biker Counterfeit Female"] = "mp_f_counterfeit_01",
["Biker Counterfeit Male"] = "mp_m_counterfeit_01",
["Biker Forgery Female"] = "mp_f_forgery_01",
["Biker Forgery Male"] = "mp_m_forgery_01",
["Biker Meth Female"] = "mp_f_meth_01",
["Biker Meth Male"] = "mp_m_meth_01",
["Biker Weed Female"] = "mp_f_weed_01",
["Biker Weed Male"] = "mp_m_weed_01",
["Black Ops Soldier"] = "s_m_y_blackops_01",
["Black Ops Soldier 2"] = "s_m_y_blackops_02",
["Black Ops Soldier 3"] = "s_m_y_blackops_03",
["Black Street Male"] = "a_m_y_stbla_01",
["Black Street Male 2"] = "a_m_y_stbla_02",
["Blane"] = "u_m_m_blane",
["Boar"] = "a_c_boar",
["Boat-Staff Female"] = "mp_f_boatstaff_01",
["Boat-Staff Male"] = "mp_m_boatstaff_01",
["Bodybuilder Female"] = "a_f_m_bodybuild_01",
["Bogdan"] = "csb_bogdan",
["Bogdan Goon"] = "mp_m_bogdangoon",
["Bouncer"] = "s_m_m_bouncer_01",
["Brad"] = "cs_brad",
["Brad"] = "ig_brad",
["Brad's Cadaver"] = "cs_bradcadaver",
["Breakdancer Male"] = "a_m_y_breakdance_01",
["Bride"] = "csb_bride",
["Bride"] = "ig_bride",
["Brucie Kibbutz"] = "csb_brucie2",
["Brucie Kibbutz"] = "ig_brucie2",
["Bryony"] = "csb_bryony",
["Burger Drug Worker"] = "csb_burgerdrug",
["Burger Drug Worker"] = "u_m_y_burgerdrug_01",
["Busboy"] = "s_m_y_busboy_01",
["Business Casual"] = "a_m_y_busicas_01",
["Business Female 2"] = "a_f_m_business_02",
["Business Male"] = "a_m_m_business_01",
["Business Young Female"] = "a_f_y_business_01",
["Business Young Female 2"] = "a_f_y_business_02",
["Business Young Female 3"] = "a_f_y_business_03",
["Business Young Female 4"] = "a_f_y_business_04",
["Business Young Male"] = "a_m_y_business_01",
["Business Young Male 2"] = "a_m_y_business_02",
["Business Young Male 3"] = "a_m_y_business_03",
["Busker"] = "s_m_o_busker_01",
["Caleb"] = "u_m_y_caleb",
["Car 3 Guy 1"] = "csb_car3guy1",
["Car 3 Guy 1"] = "ig_car3guy1",
["Car 3 Guy 2"] = "csb_car3guy2",
["Car 3 Guy 2"] = "ig_car3guy2",
["Car Buyer"] = "cs_carbuyer",
["Carol"] = "u_f_o_carol",
["Casey"] = "cs_casey",
["Casey"] = "ig_casey",
["Casino Cashier"] = "u_f_m_casinocash_01",
["Casino Guests"] = "g_m_m_casrn_01",
["Casino Staff"] = "s_f_y_casino_01",
["Casino Staff"] = "s_m_y_casino_01",
["Casino Thief"] = "u_m_y_croupthief_01",
["Casino shop owner"] = "u_f_m_casinoshop_01",
["Casual Casino Guest"] = "a_f_y_gencaspat_01",
["Casual Casino Guests"] = "a_m_y_gencaspat_01",
["Cat"] = "a_c_cat_01",
["Celeb 1"] = "csb_celeb_01",
["Celeb 1"] = "ig_celeb_01",
["Chef"] = "csb_chef",
["Chef 2"] = "csb_chef2",
["Chef"] = "ig_chef",
["Chef 2"] = "ig_chef2",
["Chef 01"] = "s_m_y_chef_01",
["Chemical Plant Security"] = "s_m_m_chemsec_01",
["Chemical Plant Worker"] = "g_m_m_chemwork_01",
["Chimp"] = "a_c_chimp",
["Chinese Boss"] = "g_m_m_chiboss_01",
["Chinese Goon"] = "csb_chin_goon",
["Chinese Goon"] = "g_m_m_chigoon_01",
["Chinese Goon 2"] = "g_m_m_chigoon_02",
["Chinese Goon Older"] = "g_m_m_chicold_01",
["Chip"] = "u_m_y_chip",
["Chop"] = "a_c_chop",
["Claude Speed"] = "mp_m_claude_01",
["Clay Jackson (The Pain Giver)"] = "ig_claypain",
["Clay Simons (The Lost)"] = "cs_clay",
["Clay Simons (The Lost)"] = "ig_clay",
["Cletus"] = "csb_cletus",
["Cletus"] = "ig_cletus",
["Clown"] = "s_m_y_clown_01",
["Club Bartender Female"] = "s_f_y_clubbar_01",
["Club Bartender Male"] = "s_m_y_clubbar_01",
["Club Customer Female 1"] = "a_f_y_clubcust_01",
["Club Customer Female 2"] = "a_f_y_clubcust_02",
["Club Customer Female 3"] = "a_f_y_clubcust_03",
["Club Customer Male 1"] = "a_m_y_clubcust_01",
["Club Customer Male 2"] = "a_m_y_clubcust_02",
["Club Customer Male 3"] = "a_m_y_clubcust_03",
["Clubhouse Bar Female"] = "mp_f_chbar_01",
["Construction Worker"] = "s_m_y_construct_01",
["Construction Worker 2"] = "s_m_y_construct_02",
["Cop"] = "csb_cop",
["Cop Female"] = "s_f_y_cop_01",
["Cop Male"] = "s_m_y_cop_01",
["Cormorant"] = "a_c_cormorant",
["Corpse Female"] = "u_f_m_corpse_01",
["Corpse Young Female"] = "u_f_y_corpse_01",
["Corpse Young Female 2"] = "u_f_y_corpse_02",
["Cow"] = "a_c_cow",
["Coyote"] = "a_c_coyote",
["Crew Member"] = "s_m_m_ccrew_01",
["Cris Formage"] = "cs_chrisformage",
["Cris Formage"] = "ig_chrisformage",
["Crow"] = "a_c_crow",
["Curtis"] = "u_m_m_curtis",
["Customer"] = "csb_customer",
["Cyclist Male"] = "a_m_y_cyclist_01",
["Cyclist Male"] = "u_m_y_cyclist_01",
["DJ Aurelia"] = "ig_djtalaurelia",
["DJ Black Madonna"] = "csb_djblamadon",
["DJ Black Madonna"] = "ig_djblamadon",
["DJ Dixon Manager"] = "ig_djdixmanager",
["DJ Fotios"] = "ig_djsolfotios",
["DJ Ignazio"] = "ig_djtalignazio",
["DJ Jakob"] = "ig_djsoljakob",
["DJ Mike T"] = "ig_djsolmike",
["DJ Rob T"] = "ig_djsolrobt",
["DJ Rupert"] = "ig_djblamrupert",
["DJ Ryan H"] = "ig_djblamryanh",
["DJ Ryan S"] = "ig_djblamryans",
["DOA Man"] = "u_m_m_doa_01",
["DW Airport Worker"] = "s_m_y_dwservice_01",
["DW Airport Worker 2"] = "s_m_y_dwservice_02",
["Dale"] = "cs_dale",
["Dale"] = "ig_dale",
["Dave Norton"] = "cs_davenorton",
["Dave Norton"] = "ig_davenorton",
["Dead Courier"] = "u_m_y_corpse_01",
["Dead Hooker"] = "mp_f_deadhooker",
["Dealer"] = "s_m_y_dealer_01",
["Dean"] = "u_m_o_dean",
["Debbie (Agatha´s Secretary)"] = "u_f_m_debbie_01",
["Debra"] = "cs_debra",
["Deer"] = "a_c_deer",
["Denise"] = "cs_denise",
["Denise"] = "ig_denise",
["Denise's Friend"] = "csb_denise_friend",
["Devin"] = "cs_devin",
["Devin"] = "ig_devin",
["Devin's Security"] = "s_m_y_devinsec_01",
["Dima Popov"] = "csb_popov",
["Dima Popov"] = "ig_popov",
["Dixon"] = "csb_dix",
["Dixon"] = "ig_dix",
["Dock Worker"] = "s_m_m_dockwork_01",
["Dock Worker"] = "s_m_y_dockwork_01",
["Doctor"] = "s_m_m_doctor_01",
["Dolphin"] = "a_c_dolphin",
["Dom Beasley"] = "cs_dom",
["Dom Beasley"] = "ig_dom",
["Doorman"] = "s_m_y_doorman_01",
["Downhill Cyclist"] = "a_m_y_dhill_01",
["Downtown Female"] = "a_f_m_downtown_01",
["Downtown Male"] = "a_m_y_downtown_01",
["Dr. Friedlander"] = "cs_drfriedlander",
["Dr. Friedlander"] = "ig_drfriedlander",
["Dressy Female"] = "a_f_y_scdressy_01",
["Drowned Corpse"] = "u_f_m_drowned_01",
["Duggan Secruity"] = "s_m_y_westsec_01",
["Duggan Security 2"] = "s_m_y_westsec_02",
["East SA Female"] = "a_f_m_eastsa_01",
["East SA Female 2"] = "a_f_m_eastsa_02",
["East SA Male"] = "a_m_m_eastsa_01",
["East SA Male 2"] = "a_m_m_eastsa_02",
["East SA Young Female"] = "a_f_y_eastsa_01",
["East SA Young Female 2"] = "a_f_y_eastsa_02",
["East SA Young Female 3"] = "a_f_y_eastsa_03",
["East SA Young Male"] = "a_m_y_eastsa_01",
["East SA Young Male 2"] = "a_m_y_eastsa_02",
["Ed Toh"] = "u_m_m_edtoh",
["Eileen"] = "u_f_o_eileen",
["English Dave"] = "csb_englishdave",
["English Dave"] = "ig_englishdave",
["Epsilon Female"] = "a_f_y_epsilon_01",
["Epsilon Male"] = "a_m_y_epsilon_01",
["Epsilon Male 2"] = "a_m_y_epsilon_02",
["Epsilon Tom"] = "cs_tomepsilon",
["Epsilon Tom"] = "ig_tomepsilon",
["Ex-Army Male"] = "mp_m_exarmy_01",
["Ex-Mil Bum"] = "u_m_y_militarybum",
["Executive PA Female"] = "mp_f_execpa_01",
["Executive PA Female 2"] = "mp_f_execpa_02",
["Executive PA Male"] = "mp_m_execpa_01",
["FIB Architect"] = "u_m_m_fibarchitect",
["FIB Mugger"] = "u_m_y_fibmugger_01",
["FIB Office Worker"] = "s_m_m_fiboffice_01",
["FIB Office Worker 2"] = "s_m_m_fiboffice_02",
["FIB Security"] = "mp_m_fibsec_01",
["FIB Security"] = "s_m_m_fibsec_01",
["FIB Suit"] = "cs_fbisuit_01",
["FIB Suit"] = "ig_fbisuit_01",
["FOS Rep"] = "csb_fos_rep",
["Fabien"] = "cs_fabien",
["Fabien"] = "ig_fabien",
["Factory Worker Female"] = "s_f_y_factory_01",
["Factory Worker Male"] = "s_m_y_factory_01",
["Families CA Male"] = "g_m_y_famca_01",
["Families DD Male"] = "mp_m_famdd_01",
["Families DNF Male"] = "g_m_y_famdnf_01",
["Families FOR Male"] = "g_m_y_famfor_01",
["Families Female"] = "g_f_y_families_01",
["Families Gang Member"] = "csb_ramp_gang",
["Families Gang Member"] = "ig_ramp_gang",
["Farmer"] = "a_m_m_farmer_01",
["Fat Black Female"] = "a_f_m_fatbla_01",
["Fat Cult Female"] = "a_f_m_fatcult_01",
["Fat Latino Male"] = "a_m_m_fatlatin_01",
["Fat White Female"] = "a_f_m_fatwhite_01",
["Female Agent"] = "a_f_y_femaleagent",
["Female Club Dancer (Burlesque)"] = "u_f_y_danceburl_01",
["Female Club Dancer (Leather)"] = "u_f_y_dancelthr_01",
["Female Club Dancer (Rave)"] = "u_f_y_dancerave_01",
["Ferdinand Kerimov (Mr. K)"] = "cs_mrk",
["Ferdinand Kerimov (Mr. K)"] = "ig_mrk",
["Financial Guru"] = "u_m_o_finguru_01",
["Fireman Male"] = "s_m_y_fireman_01",
["Fish"] = "a_c_fish",
["Fitness Female"] = "a_f_y_fitness_01",
["Fitness Female 2"] = "a_f_y_fitness_02",
["Floyd Hebert"] = "cs_floyd",
["Floyd Hebert"] = "ig_floyd",
["Formel Casino Guest"] = "a_f_y_smartcaspat_01",
["Formel Casino Guests"] = "a_m_y_smartcaspat_01",
["Franklin"] = "player_one",
["Freemode Female"] = "mp_f_freemode_01",
["Freemode Male"] = "mp_m_freemode_01",
["GURK"] = "cs_gurk",
["Gabriel"] = "u_m_y_gabriel",
["Gaffer"] = "s_m_m_gaffer_01",
["Gang Female (Import-Export)"] = "g_f_importexport_01",
["Gang Male (Import-Export)"] = "g_m_importexport_01",
["Garbage Worker"] = "s_m_y_garbage",
["Gardener"] = "s_m_m_gardener_01",
["Gay Male"] = "a_m_y_gay_01",
["Gay Male 2"] = "a_m_y_gay_02",
["General Fat Male"] = "a_m_m_genfat_01",
["General Fat Male 2"] = "a_m_m_genfat_02",
["General Hot Young Female"] = "a_f_y_genhot_01",
["General Street Old Female"] = "a_f_o_genstreet_01",
["General Street Old Male"] = "a_m_o_genstreet_01",
["General Street Young Male"] = "a_m_y_genstreet_01",
["General Street Young Male 2"] = "a_m_y_genstreet_02",
["Generic DJ"] = "ig_djgeneric_01",
["Georgina Cheng"] = "csb_georginacheng",
["Georgina Cheng"] = "ig_georginacheng",
["Gerald"] = "csb_g",
["Gerald"] = "ig_g",
["Glen-Stank Male"] = "u_m_m_glenstank_01",
["Golfer Male"] = "a_m_m_golfer_01",
["Golfer Young Female"] = "a_f_y_golfer_01",
["Golfer Young Male"] = "a_m_y_golfer_01",
["Griff"] = "u_m_m_griff_01",
["Grip"] = "s_m_y_grip_01",
["Groom"] = "csb_groom",
["Groom"] = "ig_groom",
["Grove Street Dealer"] = "csb_grove_str_dlr",
["Guadalope"] = "cs_guadalope",
["Guido"] = "u_m_y_guido_01",
["Gun Vendor"] = "u_m_y_gunvend_01",
["Hairdresser Male"] = "s_m_m_hairdress_01",
["Hammerhead Shark"] = "a_c_sharkhammer",
["Hangar Mechanic"] = "u_m_y_smugmech_01",
["Hao"] = "csb_hao",
["Hao"] = "ig_hao",
["Hasidic Jew Male"] = "a_m_m_hasjew_01",
["Hasidic Jew Young Male"] = "a_m_y_hasjew_01",
["Hawk"] = "a_c_chickenhawk",
["Heli-Staff Female"] = "mp_f_helistaff_01",
["Hen"] = "a_c_hen",
["Hick"] = "csb_ramp_hic",
["Hick"] = "ig_ramp_hic",
["High Security"] = "s_m_m_highsec_01",
["High Security 2"] = "s_m_m_highsec_02",
["High Security 3"] = "s_m_m_highsec_03",
["Highway Cop"] = "s_m_y_hwaycop_01",
["Hiker Female"] = "a_f_y_hiker_01",
["Hiker Male"] = "a_m_y_hiker_01",
["Hillbilly Male"] = "a_m_m_hillbilly_01",
["Hillbilly Male 2"] = "a_m_m_hillbilly_02",
["Hippie Female"] = "a_f_y_hippie_01",
["Hippie Male"] = "a_m_y_hippy_01",
["Hippie Male"] = "u_m_y_hippie_01",
["Hipster"] = "csb_ramp_hipster",
["Hipster"] = "ig_ramp_hipster",
["Hipster Female"] = "a_f_y_hipster_01",
["Hipster Female 2"] = "a_f_y_hipster_02",
["Hipster Female 3"] = "a_f_y_hipster_03",
["Hipster Female 4"] = "a_f_y_hipster_04",
["Hipster Male"] = "a_m_y_hipster_01",
["Hipster Male 2"] = "a_m_y_hipster_02",
["Hipster Male 3"] = "a_m_y_hipster_03",
["Hooker"] = "s_f_y_hooker_01",
["Hooker 2"] = "s_f_y_hooker_02",
["Hooker 3"] = "s_f_y_hooker_03",
["Hospital Scrubs Female"] = "s_f_y_scrubs_01",
["Hot Posh Female"] = "u_f_y_hotposh_01",
["Huang"] = "csb_huang",
["Huang"] = "ig_huang",
["Hugh Welsh"] = "csb_hugh",
["Humpback"] = "a_c_humpback",
["Hunter"] = "cs_hunter",
["Hunter"] = "ig_hunter",
["Husky"] = "a_c_husky",
["IAA Security"] = "s_m_m_ciasec_01",
["Impotent Rage"] = "u_m_y_imporage",
["Imran Shinowa"] = "csb_imran",
["Indian Male"] = "a_m_m_indian_01",
["Indian Old Female"] = "a_f_o_indian_01",
["Indian Young Female"] = "a_f_y_indian_01",
["Indian Young Male"] = "a_m_y_indian_01",
["Jack Howitzer"] = "csb_jackhowitzer",
["Jane"] = "u_f_y_comjane",
["Janet"] = "cs_janet",
["Janet"] = "ig_janet",
["Janitor"] = "csb_janitor",
["Janitor"] = "s_m_m_janitor",
["Jay Norris"] = "ig_jay_norris",
["Jesco White (Tapdancing Hillbilly)"] = "u_m_o_taphillbilly",
["Jesus"] = "u_m_m_jesus_01",
["Jetskier"] = "a_m_y_jetski_01",
["Jewel Heist Driver"] = "hc_driver",
["Jewel Heist Gunman"] = "hc_gunman",
["Jewel Heist Hacker"] = "hc_hacker",
["Jewel Thief"] = "u_m_m_jewelthief",
["Jeweller Assistant"] = "cs_jewelass",
["Jeweller Assistant"] = "ig_jewelass",
["Jeweller Assistant"] = "u_f_y_jewelass_01",
["Jeweller Security"] = "u_m_m_jewelsec_01",
["Jimmy Boston"] = "cs_jimmyboston",
["Jimmy Boston"] = "ig_jimmyboston",
["Jimmy Boston 2"] = "ig_jimmyboston_02",
["Jimmy De Santa"] = "cs_jimmydisanto",
["Jimmy De Santa"] = "ig_jimmydisanto",
["Jimmy De Santa 2"] = "cs_jimmydisanto2",
["Jimmy De Santa 2"] = "ig_jimmydisanto2",
["Jogger Female"] = "a_f_y_runner_01",
["Jogger Male"] = "a_m_y_runner_01",
["Jogger Male 2"] = "a_m_y_runner_02",
["John Marston"] = "mp_m_marston_01",
["Johnny Klebitz"] = "cs_johnnyklebitz",
["Johnny Klebitz"] = "ig_johnnyklebitz",
["Josef"] = "cs_josef",
["Josef"] = "ig_josef",
["Josh"] = "cs_josh",
["Josh"] = "ig_josh",
["Juggalo Female"] = "a_f_y_juggalo_01",
["Juggalo Male"] = "a_m_y_juggalo_01",
["Justin"] = "u_m_y_justin",
["Karen Daniels"] = "cs_karen_daniels",
["Karen Daniels"] = "ig_karen_daniels",
["Kerry McIntosh"] = "ig_kerrymcintosh",
["Kerry McIntosh 2"] = "ig_kerrymcintosh_02",
["Kifflom Guy"] = "u_m_y_baygor",
["Killer Whale"] = "a_c_killerwhale",
["Korean Boss"] = "g_m_m_korboss_01",
["Korean Female"] = "a_f_m_ktown_01",
["Korean Female 2"] = "a_f_m_ktown_02",
["Korean Lieutenant"] = "g_m_y_korlieut_01",
["Korean Male"] = "a_m_m_ktown_01",
["Korean Old Female"] = "a_f_o_ktown_01",
["Korean Old Male"] = "a_m_o_ktown_01",
["Korean Young Male"] = "a_m_y_ktown_01",
["Korean Young Male"] = "g_m_y_korean_01",
["Korean Young Male 2"] = "a_m_y_ktown_02",
["Korean Young Male 2"] = "g_m_y_korean_02",
["LS Metro Worker Male"] = "s_m_m_lsmetro_01",
["Lacy Jones 2"] = "ig_lacey_jones_02",
["Lamar Davis"] = "cs_lamardavis",
["Lamar Davis"] = "ig_lamardavis",
["Latino Handyman Male"] = "s_m_m_lathandy_01",
["Latino Street Male 2"] = "a_m_m_stlat_02",
["Latino Street Young Male"] = "a_m_y_stlat_01",
["Latino Young Male"] = "a_m_y_latino_01",
["Lauren"] = "u_f_y_lauren",
["Lazlow"] = "cs_lazlow",
["Lazlow"] = "ig_lazlow",
["Lazlow 2"] = "cs_lazlow_2",
["Lazlow 2"] = "ig_lazlow_2",
["Lester Crest"] = "cs_lestercrest",
["Lester Crest"] = "ig_lestercrest",
["Lester Crest (Doomsday Heist)"] = "ig_lestercrest_2",
["Lester Crest 2"] = "cs_lestercrest_2",
["Lester Crest 3"] = "cs_lestercrest_3",
["Lester Crest 3"] = "ig_lestercrest_3",
["Life Invader"] = "cs_lifeinvad_01",
["Life Invader"] = "ig_lifeinvad_01",
["Life Invader 2"] = "ig_lifeinvad_02",
["Life Invader Male"] = "s_m_m_lifeinvad_01",
["Line Cook"] = "s_m_m_linecook",
["Love Fist Willy"] = "u_m_m_willyfist",
["MC Clubhouse Mechanic"] = "s_m_y_xmech_02",
["Magenta"] = "cs_magenta",
["Magenta"] = "ig_magenta",
["Maid"] = "s_f_m_maid_01",
["Malc"] = "ig_malc",
["Male Club Dancer (Burlesque)"] = "u_m_y_danceburl_01",
["Male Club Dancer (Leather)"] = "u_m_y_dancelthr_01",
["Male Club Dancer (Rave)"] = "u_m_y_dancerave_01",
["Malibu Male"] = "a_m_m_malibu_01",
["Mani"] = "u_m_y_mani",
["Manuel"] = "cs_manuel",
["Manuel"] = "ig_manuel",
["Mariachi"] = "s_m_m_mariachi_01",
["Marine"] = "csb_ramp_marine",
["Marine"] = "s_m_m_marine_01",
["Marine 2"] = "s_m_m_marine_02",
["Marine Young"] = "s_m_y_marine_01",
["Marine Young 2"] = "s_m_y_marine_02",
["Marine Young 3"] = "s_m_y_marine_03",
["Mark Fostenburg"] = "u_m_m_markfost",
["Marnie Allen"] = "cs_marnie",
["Marnie Allen"] = "ig_marnie",
["Martin Madrazo"] = "cs_martinmadrazo",
["Mary-Ann Quinn"] = "cs_maryann",
["Mary-Ann Quinn"] = "ig_maryann",
["Mask Salesman"] = "s_m_y_shop_mask",
["Maude"] = "csb_maude",
["Maude"] = "ig_maude",
["Maxim Rashkovsky"] = "csb_rashcosvki",
["Maxim Rashkovsky"] = "ig_rashcosvki",
["Mechanic"] = "s_m_y_xmech_01",
["Merryweather Merc"] = "csb_mweather",
["Meth Addict"] = "a_m_y_methhead_01",
["Mexican"] = "csb_ramp_mex",
["Mexican"] = "ig_ramp_mex",
["Mexican Boss"] = "g_m_m_mexboss_01",
["Mexican Boss 2"] = "g_m_m_mexboss_02",
["Mexican Gang Member"] = "g_m_y_mexgang_01",
["Mexican Goon"] = "g_m_y_mexgoon_01",
["Mexican Goon 2"] = "g_m_y_mexgoon_02",
["Mexican Goon 3"] = "g_m_y_mexgoon_03",
["Mexican Labourer"] = "a_m_m_mexlabor_01",
["Mexican Rural"] = "a_m_m_mexcntry_01",
["Mexican Thug"] = "a_m_y_mexthug_01",
["Michael"] = "player_zero",
["Michelle"] = "cs_michelle",
["Michelle"] = "ig_michelle",
["Midlife Crisis Casino Bikers"] = "a_m_m_mlcrisis_01",
["Migrant Female"] = "s_f_y_migrant_01",
["Migrant Male"] = "s_m_m_migrant_01",
["Milton McIlroy"] = "cs_milton",
["Milton McIlroy"] = "ig_milton",
["Mime Artist"] = "s_m_y_mime",
["Minuteman Joe"] = "cs_joeminuteman",
["Minuteman Joe"] = "ig_joeminuteman",
["Miranda"] = "u_f_m_miranda",
["Miranda 2"] = "u_f_m_miranda_02",
["Mistress"] = "u_f_y_mistress",
["Misty"] = "mp_f_misty_01",
["Molly"] = "cs_molly",
["Molly"] = "ig_molly",
["Money Man"] = "csb_money",
["Money Man"] = "ig_money",
["Motocross Biker"] = "a_m_y_motox_01",
["Motocross Biker 2"] = "a_m_y_motox_02",
["Mountain Lion"] = "a_c_mtlion",
["Movie Astronaut"] = "s_m_m_movspace_01",
["Movie Corpse (Suited)"] = "u_m_o_filmnoir",
["Movie Director"] = "u_m_m_filmdirector",
["Movie Premiere Female"] = "cs_movpremf_01",
["Movie Premiere Female"] = "s_f_y_movprem_01",
["Movie Premiere Male"] = "cs_movpremmale",
["Movie Premiere Male"] = "s_m_m_movprem_01",
["Movie Star Female"] = "u_f_o_moviestar",
["Mrs. Phillips"] = "cs_mrsphillips",
["Mrs. Phillips"] = "ig_mrsphillips",
["Mrs. Rackman"] = "csb_mrs_r",
["Mrs. Thornhill"] = "cs_mrs_thornhill",
["Mrs. Thornhill"] = "ig_mrs_thornhill",
["Natalia"] = "cs_natalia",
["Natalia"] = "ig_natalia",
["Nervous Ron"] = "cs_nervousron",
["Nervous Ron"] = "ig_nervousron",
["Nigel"] = "cs_nigel",
["Nigel"] = "ig_nigel",
["Niko Bellic"] = "mp_m_niko_01",
["O'Neil Brothers"] = "ig_oneil",
["OG Boss"] = "a_m_m_og_boss_01",
["Office Garage Mechanic (Female)"] = "mp_f_cardesign_01",
["Old Man 1"] = "cs_old_man1a",
["Old Man 1"] = "ig_old_man1a",
["Old Man 2"] = "cs_old_man2",
["Old Man 2"] = "ig_old_man2",
["Omega"] = "cs_omega",
["Omega"] = "ig_omega",
["Ortega"] = "csb_ortega",
["Ortega"] = "ig_ortega",
["Oscar"] = "csb_oscar",
["Paige Harris"] = "csb_paige",
["Paige Harris"] = "ig_paige",
["Paparazzi Male"] = "a_m_m_paparazzi_01",
["Paparazzi Young Male"] = "u_m_y_paparazzi",
["Paramedic"] = "s_m_m_paramedic_01",
["Party Target"] = "u_m_m_partytarget",
["Partygoer"] = "u_m_y_party_01",
["Patricia"] = "cs_patricia",
["Patricia"] = "ig_patricia",
["Pest Control"] = "s_m_y_pestcont_01",
["Peter Dreyfuss"] = "cs_dreyfuss",
["Peter Dreyfuss"] = "ig_dreyfuss",
["Pig"] = "a_c_pig",
["Pigeon"] = "a_c_pigeon",
["Pilot"] = "s_m_m_pilot_01",
["Pilot"] = "s_m_y_pilot_01",
["Pilot 2"] = "s_m_m_pilot_02",
["Pogo the Monkey"] = "u_m_y_pogo_01",
["Polynesian"] = "a_m_m_polynesian_01",
["Polynesian Goon"] = "g_m_y_pologoon_01",
["Polynesian Goon 2"] = "g_m_y_pologoon_02",
["Polynesian Young"] = "a_m_y_polynesian_01",
["Poodle"] = "a_c_poodle",
["Poppy Mitchell"] = "u_f_y_poppymich",
["Poppy Mitchell 2"] = "u_f_y_poppymich_02",
["Porn Dude"] = "csb_porndudes",
["Postal Worker Male"] = "s_m_m_postal_01",
["Postal Worker Male 2"] = "s_m_m_postal_02",
["Priest"] = "cs_priest",
["Priest"] = "ig_priest",
["Princess"] = "u_f_y_princess",
["Prison Guard"] = "s_m_m_prisguard_01",
["Prisoner"] = "s_m_y_prisoner_01",
["Prisoner"] = "u_m_y_prisoner_01",
["Prisoner (Muscular)"] = "s_m_y_prismuscl_01",
["Prologue Driver"] = "csb_prologuedriver",
["Prologue Driver"] = "u_m_y_proldriver_01",
["Prologue Host Female"] = "a_f_m_prolhost_01",
["Prologue Host Male"] = "a_m_m_prolhost_01",
["Prologue Host Old Female"] = "u_f_o_prolhost_01",
["Prologue Mourner Female"] = "u_f_m_promourn_01",
["Prologue Mourner Male"] = "u_m_m_promourn_01",
["Prologue Security"] = "csb_prolsec",
["Prologue Security"] = "u_m_m_prolsec_01",
["Prologue Security 2"] = "cs_prolsec_02",
["Prologue Security 2"] = "ig_prolsec_02",
["Pros"] = "mp_g_m_pros_01",
["Pug"] = "a_c_pug",
["Rabbit"] = "a_c_rabbit_01",
["Ranger Female"] = "s_f_y_ranger_01",
["Ranger Male"] = "s_m_y_ranger_01",
["Rat"] = "a_c_rat",
["Reporter"] = "csb_reporter",
["Republican Space Ranger"] = "u_m_y_rsranger_01",
["Retriever"] = "a_c_retriever",
["Rhesus"] = "a_c_rhesus",
["Rival Paparazzo"] = "u_m_m_rivalpap",
["Road Cyclist"] = "a_m_y_roadcyc_01",
["Robber"] = "s_m_y_robber_01",
["Rocco Pelosi"] = "csb_roccopelosi",
["Rocco Pelosi"] = "ig_roccopelosi",
["Rottweiler"] = "a_c_rottweiler",
["Rural Meth Addict Female"] = "a_f_y_rurmeth_01",
["Rural Meth Addict Male"] = "a_m_m_rurmeth_01",
["Russian Drunk"] = "cs_russiandrunk",
["Russian Drunk"] = "ig_russiandrunk",
["SWAT"] = "s_m_y_swat_01",
["Sacha Yetarian"] = "ig_sacha",
["Sales Assistant (High-End)"] = "s_f_m_shop_high",
["Sales Assistant (Low-End)"] = "s_f_y_shop_low",
["Sales Assistant (Mid-Price)"] = "s_f_y_shop_mid",
["Salton Female"] = "a_f_m_salton_01",
["Salton Male"] = "a_m_m_salton_01",
["Salton Male 2"] = "a_m_m_salton_02",
["Salton Male 3"] = "a_m_m_salton_03",
["Salton Male 4"] = "a_m_m_salton_04",
["Salton Old Female"] = "a_f_o_salton_01",
["Salton Old Male"] = "a_m_o_salton_01",
["Salton Young Male"] = "a_m_y_salton_01",
["Salvadoran Boss"] = "g_m_y_salvaboss_01",
["Salvadoran Goon"] = "g_m_y_salvagoon_01",
["Salvadoran Goon 2"] = "g_m_y_salvagoon_02",
["Salvadoran Goon 3"] = "g_m_y_salvagoon_03",
["Scientist"] = "s_m_m_scientist_01",
["Screenwriter"] = "csb_screen_writer",
["Screenwriter"] = "ig_screen_writer",
["Seagull"] = "a_c_seagull",
["Security Guard"] = "s_m_m_security_01",
["Securoserve Guard (Male)"] = "mp_m_securoguard_01",
["Sheriff Female"] = "s_f_y_sheriff_01",
["Sheriff Male"] = "s_m_y_sheriff_01",
["Shopkeeper (Male)"] = "mp_m_shopkeep_01",
["Simeon Yetarian"] = "cs_siemonyetarian",
["Simeon Yetarian"] = "ig_siemonyetarian",
["Skater Female"] = "a_f_y_skater_01",
["Skater Male"] = "a_m_m_skater_01",
["Skater Young Male"] = "a_m_y_skater_01",
["Skater Young Male 2"] = "a_m_y_skater_02",
["Skid Row Female"] = "a_f_m_skidrow_01",
["Skid Row Male"] = "a_m_m_skidrow_01",
["Snow Cop Male"] = "s_m_m_snowcop_01",
["Soloman"] = "csb_sol",
["Soloman"] = "ig_sol",
["Soloman Manager"] = "ig_djsolmanager",
["Solomon Richards"] = "cs_solomon",
["Solomon Richards"] = "ig_solomon",
["South Central Female"] = "a_f_m_soucent_01",
["South Central Female 2"] = "a_f_m_soucent_02",
["South Central Latino Male"] = "a_m_m_socenlat_01",
["South Central MC Female"] = "a_f_m_soucentmc_01",
["South Central Male"] = "a_m_m_soucent_01",
["South Central Male 2"] = "a_m_m_soucent_02",
["South Central Male 3"] = "a_m_m_soucent_03",
["South Central Male 4"] = "a_m_m_soucent_04",
["South Central Old Female"] = "a_f_o_soucent_01",
["South Central Old Female 2"] = "a_f_o_soucent_02",
["South Central Old Male"] = "a_m_o_soucent_01",
["South Central Old Male 2"] = "a_m_o_soucent_02",
["South Central Old Male 3"] = "a_m_o_soucent_03",
["South Central Young Female"] = "a_f_y_soucent_01",
["South Central Young Female 2"] = "a_f_y_soucent_02",
["South Central Young Female 3"] = "a_f_y_soucent_03",
["South Central Young Male"] = "a_m_y_soucent_01",
["South Central Young Male 2"] = "a_m_y_soucent_02",
["South Central Young Male 3"] = "a_m_y_soucent_03",
["South Central Young Male 4"] = "a_m_y_soucent_04",
["Sports Biker"] = "u_m_y_sbike",
["Spy Actor"] = "u_m_m_spyactor",
["Spy Actress"] = "u_f_y_spyactress",
["Stag Party Groom"] = "u_m_y_staggrm_01",
["Steve Haines"] = "cs_stevehains",
["Steve Haines"] = "ig_stevehains",
["Stingray"] = "a_c_stingray",
["Street Art Male"] = "u_m_m_streetart_01",
["Street Performer"] = "s_m_m_strperf_01",
["Street Preacher"] = "s_m_m_strpreach_01",
["Street Punk"] = "g_m_y_strpunk_01",
["Street Punk 2"] = "g_m_y_strpunk_02",
["Street Vendor"] = "s_m_m_strvend_01",
["Street Vendor Young"] = "s_m_y_strvend_01",
["Stretch"] = "cs_stretch",
["Stretch"] = "ig_stretch",
["Stripper"] = "csb_stripper_01",
["Stripper"] = "s_f_y_stripper_01",
["Stripper 2"] = "csb_stripper_02",
["Stripper 2"] = "s_f_y_stripper_02",
["Stripper Lite"] = "s_f_y_stripperlite",
["Stripper Lite (Female)"] = "mp_f_stripperlite",
["Sunbather Male"] = "a_m_y_sunbathe_01",
["Surfer"] = "a_m_y_surfer_01",
["Sweatshop Worker"] = "s_f_m_sweatshop_01",
["Sweatshop Worker Young"] = "s_f_y_sweatshop_01",
["Tale of Us 1"] = "csb_talcc",
["Tale of Us 1"] = "ig_talcc",
["Tale of Us 2"] = "csb_talmm",
["Tale of Us 2"] = "ig_talmm",
["Talina"] = "ig_talina",
["Tanisha"] = "cs_tanisha",
["Tanisha"] = "ig_tanisha",
["Tao Cheng"] = "cs_taocheng",
["Tao Cheng"] = "ig_taocheng",
["Tao Cheng (Casino)"] = "cs_taocheng2",
["Tao Cheng (Casino)"] = "ig_taocheng2",
["Tao's Translator"] = "cs_taostranslator",
["Tao's Translator"] = "ig_taostranslator",
["Tao's Translator (Casino)"] = "cs_taostranslator2",
["Tao's Translator (Casino)"] = "ig_taostranslator2",
["Tattoo Artist"] = "u_m_y_tattoo_01",
["Taylor"] = "u_f_y_taylor",
["Tennis Coach"] = "cs_tenniscoach",
["Tennis Coach"] = "ig_tenniscoach",
["Tennis Player Female"] = "a_f_y_tennis_01",
["Tennis Player Male"] = "a_m_m_tennis_01",
["Terry"] = "cs_terry",
["Terry"] = "ig_terry",
["The Lost MC Female"] = "g_f_y_lost_01",
["The Lost MC Male"] = "g_m_y_lost_01",
["The Lost MC Male 2"] = "g_m_y_lost_02",
["The Lost MC Male 3"] = "g_m_y_lost_03",
["Thornton Duggan"] = "csb_thornton",
["Thornton Duggan"] = "ig_thornton",
["Tiger Shark"] = "a_c_sharktiger",
["Tom"] = "cs_tom",
["Tom Connors"] = "csb_tomcasino",
["Tom Connors"] = "ig_tomcasino",
["Tony Prince"] = "csb_tonyprince",
["Tony Prince"] = "ig_tonyprince",
["Tonya"] = "csb_tonya",
["Tonya"] = "ig_tonya",
["Topless"] = "a_f_y_topless_01",
["Tourist Female"] = "a_f_m_tourist_01",
["Tourist Male"] = "a_m_m_tourist_01",
["Tourist Young Female"] = "a_f_y_tourist_01",
["Tourist Young Female 2"] = "a_f_y_tourist_02",
["Tracey De Santa"] = "cs_tracydisanto",
["Tracey De Santa"] = "ig_tracydisanto",
["Traffic Warden"] = "csb_trafficwarden",
["Traffic Warden"] = "ig_trafficwarden",
["Tramp Female"] = "a_f_m_tramp_01",
["Tramp Male"] = "a_m_m_tramp_01",
["Tramp Old Male"] = "a_m_o_tramp_01",
["Tramp Old Male"] = "u_m_o_tramp_01",
["Transport Worker Male"] = "s_m_m_gentransport",
["Transvestite Male"] = "a_m_m_tranvest_01",
["Transvestite Male 2"] = "a_m_m_tranvest_02",
["Trevor"] = "player_two",
["Trucker Male"] = "s_m_m_trucker_01",
["Tyler Dixon"] = "ig_tylerdix",
["Tyler Dixon 2"] = "ig_tylerdix_02",
["UPS Driver"] = "s_m_m_ups_01",
["UPS Driver 2"] = "s_m_m_ups_02",
["US Coastguard"] = "s_m_y_uscg_01",
["Undercover Cop"] = "csb_undercover",
["United Paper Man"] = "cs_paper",
["United Paper Man"] = "ig_paper",
["Ushi"] = "u_m_y_ushi",
["Vagos Female"] = "g_f_y_vagos_01",
["Vagos Funeral"] = "mp_m_g_vagfun_01",
["Vagos Funeral Speaker"] = "ig_vagspeak",
["Vagos Speak"] = "csb_vagspeak",
["Valet"] = "s_m_y_valet_01",
["Vespucci Beach Male"] = "a_m_y_beachvesp_01",
["Vespucci Beach Male 2"] = "a_m_y_beachvesp_02",
["Vince"] = "u_m_m_vince",
["Vincent (Casino)"] = "csb_vincent",
["Vincent (Casino)"] = "ig_vincent",
["Vincent (Casino) 2"] = "csb_vincent_2",
["Vincent (Casino) 2"] = "ig_vincent_2",
["Vinewood Douche"] = "a_m_y_vindouche_01",
["Vinewood Female"] = "a_f_y_vinewood_01",
["Vinewood Female 2"] = "a_f_y_vinewood_02",
["Vinewood Female 3"] = "a_f_y_vinewood_03",
["Vinewood Female 4"] = "a_f_y_vinewood_04",
["Vinewood Male"] = "a_m_y_vinewood_01",
["Vinewood Male 2"] = "a_m_y_vinewood_02",
["Vinewood Male 3"] = "a_m_y_vinewood_03",
["Vinewood Male 4"] = "a_m_y_vinewood_04",
["Wade"] = "cs_wade",
["Wade"] = "ig_wade",
["Waiter"] = "s_m_y_waiter_01",
["Warehouse Mechanic (Male)"] = "mp_m_waremech_01",
["Warehouse Technician"] = "s_m_y_waretech_01",
["Weapon Exp (Male)"] = "mp_m_weapexp_01",
["Weapon Work (Male)"] = "mp_m_weapwork_01",
["Wei Cheng"] = "cs_chengsr",
["Wei Cheng"] = "ig_chengsr",
["Wendy"] = "csb_wendy",
["Wendy"] = "ig_wendy",
["Westie"] = "a_c_westy",
["White Street Male"] = "a_m_y_stwhi_01",
["White Street Male 2"] = "a_m_y_stwhi_02",
["Window Cleaner"] = "s_m_y_winclean_01",
["Yoga Female"] = "a_f_y_yoga_01",
["Yoga Male"] = "a_m_y_yoga_01",
["Zimbor"] = "cs_zimbor",
["Zimbor"] = "ig_zimbor",
["Zombie"] = "u_m_y_zombie_01"
}
--[[
Список  случайных прохожих
local random_peds = { --добавьте модели здесь, если хотите
"a_f_y_carclub_01",
"a_m_y_carclub_01",
"a_m_y_tattoocust_01",
"csb_avischwartzman_02",
"csb_drugdealer",
"csb_hao_02",
"csb_mimi",
"csb_moodyman_02",
"csb_sessanta",
"g_m_m_prisoners_01",
"g_m_m_slasher_01",
"ig_avischwartzman_02",
"ig_benny_02",
"ig_drugdealer",
"ig_hao_02",
"ig_lildee",
"ig_mimi",
"ig_moodyman_02",
"ig_sessanta",
"s_f_m_autoshop_01",
"s_f_m_retailstaff_01",
"s_m_m_autoshop_03",
"s_m_m_raceorg_01",
"s_m_m_tattoo_01",
"a_c_panther",
"csb_ary",
"csb_englishdave_02",
"csb_gustavo",
"csb_helmsmanpavel",
"csb_isldj_00",
"csb_isldj_01",
"csb_isldj_02",
"csb_isldj_03",
"csb_isldj_04",
"csb_jio",
"csb_juanstrickler",
"csb_miguelmadrazo",
"csb_mjo",
"csb_sss",
"cs_patricia_02",
"ig_ary",
"ig_englishdave_02",
"ig_gustavo",
"ig_helmsmanpavel",
"ig_isldj_00",
"ig_isldj_01",
"ig_isldj_02",
"ig_isldj_03",
"ig_isldj_04",
"ig_isldj_04_d_01",
"ig_isldj_04_d_02",
"ig_isldj_04_e_01",
"ig_jackie",
"ig_jio",
"ig_juanstrickler",
"ig_kaylee",
"ig_miguelmadrazo",
"ig_mjo",
"ig_oldrichguy",
"ig_pilot",
"ig_sss",
"a_f_y_beach_02",
"a_f_y_clubcust_04",
"a_m_o_beach_02",
"a_m_y_beach_04",
"a_m_y_clubcust_04",
"g_m_m_cartelguards_01",
"g_m_m_cartelguards_02",
"s_f_y_beachbarstaff_01",
"s_f_y_clubbar_02",
"s_m_m_bouncer_02",
"s_m_m_drugprocess_01",
"s_m_m_fieldworker_01",
"s_m_m_highsec_04",
"csb_abigail",
"ig_abigail",
"u_m_y_abner",
"a_m_m_afriamer_01",
"csb_agatha",
"ig_agatha",
"csb_agent",
"ig_agent",
"csb_mp_agent14",
"ig_mp_agent14",
"s_f_y_airhostess_01",
"s_m_y_airworker",
"u_m_m_aldinapoli",
"csb_alan",
"s_m_m_movalien_01",
"a_m_m_acult_01",
"a_m_o_acult_01",
"a_m_o_acult_02",
"a_m_y_acult_01",
"a_m_y_acult_02",
"cs_amandatownley",
"ig_amandatownley",
"s_m_y_ammucity_01",
"s_m_m_ammucountry",
"cs_andreas",
"ig_andreas",
"csb_anita",
"csb_anton",
"u_m_y_antonb",
"g_m_m_armboss_01",
"g_m_m_armgoon_01",
"g_m_y_armgoon_02",
"g_m_m_armlieut_01",
"s_m_m_armoured_01",
"s_m_m_armoured_02",
"mp_s_m_armoured_01",
"s_m_y_armymech_01",
"cs_ashley",
"ig_ashley",
"a_c_shepherd",
"s_m_y_autopsy_01",
"s_m_m_autoshop_01",
"s_m_m_autoshop_02",
"csb_avery",
"ig_avery",
"mp_m_avongoon",
"csb_avon",
"ig_avon",
"u_m_y_juggernaut_01",
"g_m_y_azteca_01",
"u_m_y_babyd",
"g_m_y_ballaeast_01",
"g_f_y_ballas_01",
"csb_ballasog",
"ig_ballasog",
"g_m_y_ballaorig_01",
"g_m_y_ballasout_01",
"cs_bankman",
"ig_bankman",
"u_m_m_bankman",
"s_f_m_fembarber",
"s_m_y_barman_01",
"cs_barry",
"ig_barry",
"s_f_y_bartender_01",
"s_m_m_cntrybar_01",
"s_f_y_baywatch_01",
"s_m_y_baywatch_01",
"a_f_m_beach_01",
"a_m_m_beach_01",
"a_m_m_beach_02",
"a_m_y_musclbeac_01",
"a_m_y_musclbeac_02",
"a_m_o_beach_01",
"a_f_m_trampbeac_01",
"a_m_m_trampbeac_01",
"a_f_y_beach_01",
"a_m_y_beach_01",
"a_m_y_beach_02",
"a_m_y_beach_03",
"ig_benny",
"mp_f_bennymech_01",
"ig_bestmen",
"u_f_y_beth",
"cs_beverly",
"ig_beverly",
"a_f_m_bevhills_01",
"a_f_m_bevhills_02",
"a_m_m_bevhills_01",
"a_m_m_bevhills_02",
"a_f_y_bevhills_01",
"a_f_y_bevhills_02",
"a_f_y_bevhills_03",
"a_f_y_bevhills_04",
"a_f_y_bevhills_05",
"a_m_y_bevhills_01",
"a_m_y_bevhills_02",
"cs_orleans",
"ig_orleans",
"u_m_m_bikehire_01",
"u_f_y_bikerchic",
"mp_f_cocaine_01",
"mp_m_cocaine_01",
"mp_f_counterfeit_01",
"mp_m_counterfeit_01",
"mp_f_forgery_01",
"mp_m_forgery_01",
"mp_f_meth_01",
"mp_m_meth_01",
"mp_f_weed_01",
"mp_m_weed_01",
"s_m_y_blackops_01",
"s_m_y_blackops_02",
"s_m_y_blackops_03",
"a_m_y_stbla_01",
"a_m_y_stbla_02",
"u_m_m_blane",
"a_c_boar",
"mp_f_boatstaff_01",
"mp_m_boatstaff_01",
"a_f_m_bodybuild_01",
"csb_bogdan",
"mp_m_bogdangoon",
"s_m_m_bouncer_01",
"cs_brad",
"ig_brad",
"cs_bradcadaver",
"a_m_y_breakdance_01",
"csb_bride",
"ig_bride",
"csb_brucie2",
"ig_brucie2",
"csb_bryony",
"csb_burgerdrug",
"u_m_y_burgerdrug_01",
"s_m_y_busboy_01",
"a_m_y_busicas_01",
"a_f_m_business_02",
"a_m_m_business_01",
"a_f_y_business_01",
"a_f_y_business_02",
"a_f_y_business_03",
"a_f_y_business_04",
"a_m_y_business_01",
"a_m_y_business_02",
"a_m_y_business_03",
"s_m_o_busker_01",
"u_m_y_caleb",
"csb_car3guy1",
"ig_car3guy1",
"csb_car3guy2",
"ig_car3guy2",
"cs_carbuyer",
"u_f_o_carol",
"cs_casey",
"ig_casey",
"u_f_m_casinocash_01",
"g_m_m_casrn_01",
"s_f_y_casino_01",
"s_m_y_casino_01",
"u_m_y_croupthief_01",
"u_f_m_casinoshop_01",
"a_f_y_gencaspat_01",
"a_m_y_gencaspat_01",
"a_c_cat_01",
"csb_celeb_01",
"ig_celeb_01",
"csb_chef",
"csb_chef2",
"ig_chef",
"ig_chef2",
"s_m_y_chef_01",
"s_m_m_chemsec_01",
"g_m_m_chemwork_01",
"a_c_chimp",
"g_m_m_chiboss_01",
"csb_chin_goon",
"g_m_m_chigoon_01",
"g_m_m_chigoon_02",
"g_m_m_chicold_01",
"u_m_y_chip",
"a_c_chop",
"mp_m_claude_01",
"ig_claypain",
"cs_clay",
"ig_clay",
"csb_cletus",
"ig_cletus",
"s_m_y_clown_01",
"s_f_y_clubbar_01",
"s_m_y_clubbar_01",
"a_f_y_clubcust_01",
"a_f_y_clubcust_02",
"a_f_y_clubcust_03",
"a_m_y_clubcust_01",
"a_m_y_clubcust_02",
"a_m_y_clubcust_03",
"mp_f_chbar_01",
"s_m_y_construct_01",
"s_m_y_construct_02",
"csb_cop",
"s_f_y_cop_01",
"s_m_y_cop_01",
"a_c_cormorant",
"u_f_m_corpse_01",
"u_f_y_corpse_01",
"u_f_y_corpse_02",
"a_c_cow",
"a_c_coyote",
"s_m_m_ccrew_01",
"cs_chrisformage",
"ig_chrisformage",
"a_c_crow",
"u_m_m_curtis",
"csb_customer",
"a_m_y_cyclist_01",
"u_m_y_cyclist_01",
"ig_djtalaurelia",
"csb_djblamadon",
"ig_djblamadon",
"ig_djdixmanager",
"ig_djsolfotios",
"ig_djtalignazio",
"ig_djsoljakob",
"ig_djsolmike",
"ig_djsolrobt",
"ig_djblamrupert",
"ig_djblamryanh",
"ig_djblamryans",
"u_m_m_doa_01",
"s_m_y_dwservice_01",
"s_m_y_dwservice_02",
"cs_dale",
"ig_dale",
"cs_davenorton",
"ig_davenorton",
"u_m_y_corpse_01",
"mp_f_deadhooker",
"s_m_y_dealer_01",
"u_m_o_dean",
"u_f_m_debbie_01",
"cs_debra",
"a_c_deer",
"cs_denise",
"ig_denise",
"csb_denise_friend",
"cs_devin",
"ig_devin",
"s_m_y_devinsec_01",
"csb_popov",
"ig_popov",
"csb_dix",
"ig_dix",
"s_m_m_dockwork_01",
"s_m_y_dockwork_01",
"s_m_m_doctor_01",
"a_c_dolphin",
"cs_dom",
"ig_dom",
"s_m_y_doorman_01",
"a_m_y_dhill_01",
"a_f_m_downtown_01",
"a_m_y_downtown_01",
"cs_drfriedlander",
"ig_drfriedlander",
"a_f_y_scdressy_01",
"u_f_m_drowned_01",
"s_m_y_westsec_01",
"s_m_y_westsec_02",
"a_f_m_eastsa_01",
"a_f_m_eastsa_02",
"a_m_m_eastsa_01",
"a_m_m_eastsa_02",
"a_f_y_eastsa_01",
"a_f_y_eastsa_02",
"a_f_y_eastsa_03",
"a_m_y_eastsa_01",
"a_m_y_eastsa_02",
"u_m_m_edtoh",
"u_f_o_eileen",
"csb_englishdave",
"ig_englishdave",
"a_f_y_epsilon_01",
"a_m_y_epsilon_01",
"a_m_y_epsilon_02",
"cs_tomepsilon",
"ig_tomepsilon",
"mp_m_exarmy_01",
"u_m_y_militarybum",
"mp_f_execpa_01",
"mp_f_execpa_02",
"mp_m_execpa_01",
"u_m_m_fibarchitect",
"u_m_y_fibmugger_01",
"s_m_m_fiboffice_01",
"s_m_m_fiboffice_02",
"mp_m_fibsec_01",
"s_m_m_fibsec_01",
"cs_fbisuit_01",
"ig_fbisuit_01",
"csb_fos_rep",
"cs_fabien",
"ig_fabien",
"s_f_y_factory_01",
"s_m_y_factory_01",
"g_m_y_famca_01",
"mp_m_famdd_01",
"g_m_y_famdnf_01",
"g_m_y_famfor_01",
"g_f_y_families_01",
"csb_ramp_gang",
"ig_ramp_gang",
"a_m_m_farmer_01",
"a_f_m_fatbla_01",
"a_f_m_fatcult_01",
"a_m_m_fatlatin_01",
"a_f_m_fatwhite_01",
"a_f_y_femaleagent",
"u_f_y_danceburl_01",
"u_f_y_dancelthr_01",
"u_f_y_dancerave_01",
"cs_mrk",
"ig_mrk",
"u_m_o_finguru_01",
"s_m_y_fireman_01",
"a_c_fish",
"a_f_y_fitness_01",
"a_f_y_fitness_02",
"cs_floyd",
"ig_floyd",
"a_f_y_smartcaspat_01",
"a_m_y_smartcaspat_01",
"player_one",
"mp_f_freemode_01",
"mp_m_freemode_01",
"cs_gurk",
"u_m_y_gabriel",
"s_m_m_gaffer_01",
"g_f_importexport_01",
"g_m_importexport_01",
"s_m_y_garbage",
"s_m_m_gardener_01",
"a_m_y_gay_01",
"a_m_y_gay_02",
"a_m_m_genfat_01",
"a_m_m_genfat_02",
"a_f_y_genhot_01",
"a_f_o_genstreet_01",
"a_m_o_genstreet_01",
"a_m_y_genstreet_01",
"a_m_y_genstreet_02",
"ig_djgeneric_01",
"csb_georginacheng",
"ig_georginacheng",
"csb_g",
"ig_g",
"u_m_m_glenstank_01",
"a_m_m_golfer_01",
"a_f_y_golfer_01",
"a_m_y_golfer_01",
"u_m_m_griff_01",
"s_m_y_grip_01",
"csb_groom",
"ig_groom",
"csb_grove_str_dlr",
"cs_guadalope",
"u_m_y_guido_01",
"u_m_y_gunvend_01",
"s_m_m_hairdress_01",
"a_c_sharkhammer",
"u_m_y_smugmech_01",
"csb_hao",
"ig_hao",
"a_m_m_hasjew_01",
"a_m_y_hasjew_01",
"a_c_chickenhawk",
"mp_f_helistaff_01",
"a_c_hen",
"csb_ramp_hic",
"ig_ramp_hic",
"s_m_m_highsec_01",
"s_m_m_highsec_02",
"s_m_m_highsec_03",
"s_m_y_hwaycop_01",
"a_f_y_hiker_01",
"a_m_y_hiker_01",
"a_m_m_hillbilly_01",
"a_m_m_hillbilly_02",
"a_f_y_hippie_01",
"a_m_y_hippy_01",
"u_m_y_hippie_01",
"csb_ramp_hipster",
"ig_ramp_hipster",
"a_f_y_hipster_01",
"a_f_y_hipster_02",
"a_f_y_hipster_03",
"a_f_y_hipster_04",
"a_m_y_hipster_01",
"a_m_y_hipster_02",
"a_m_y_hipster_03",
"s_f_y_hooker_01",
"s_f_y_hooker_02",
"s_f_y_hooker_03",
"s_f_y_scrubs_01",
"u_f_y_hotposh_01",
"csb_huang",
"ig_huang",
"csb_hugh",
"a_c_humpback",
"cs_hunter",
"ig_hunter",
"a_c_husky",
"s_m_m_ciasec_01",
"u_m_y_imporage",
"csb_imran",
"a_m_m_indian_01",
"a_f_o_indian_01",
"a_f_y_indian_01",
"a_m_y_indian_01",
"csb_jackhowitzer",
"u_f_y_comjane",
"cs_janet",
"ig_janet",
"csb_janitor",
"s_m_m_janitor",
"ig_jay_norris",
"u_m_o_taphillbilly",
"u_m_m_jesus_01",
"a_m_y_jetski_01",
"hc_driver",
"hc_gunman",
"hc_hacker",
"u_m_m_jewelthief",
"cs_jewelass",
"ig_jewelass",
"u_f_y_jewelass_01",
"u_m_m_jewelsec_01",
"cs_jimmyboston",
"ig_jimmyboston",
"ig_jimmyboston_02",
"cs_jimmydisanto",
"ig_jimmydisanto",
"cs_jimmydisanto2",
"ig_jimmydisanto2",
"a_f_y_runner_01",
"a_m_y_runner_01",
"a_m_y_runner_02",
"mp_m_marston_01",
"cs_johnnyklebitz",
"ig_johnnyklebitz",
"cs_josef",
"ig_josef",
"cs_josh",
"ig_josh",
"a_f_y_juggalo_01",
"a_m_y_juggalo_01",
"u_m_y_justin",
"cs_karen_daniels",
"ig_karen_daniels",
"ig_kerrymcintosh",
"ig_kerrymcintosh_02",
"u_m_y_baygor",
"a_c_killerwhale",
"g_m_m_korboss_01",
"a_f_m_ktown_01",
"a_f_m_ktown_02",
"g_m_y_korlieut_01",
"a_m_m_ktown_01",
"a_f_o_ktown_01",
"a_m_o_ktown_01",
"a_m_y_ktown_01",
"g_m_y_korean_01",
"a_m_y_ktown_02",
"g_m_y_korean_02",
"s_m_m_lsmetro_01",
"ig_lacey_jones_02",
"cs_lamardavis",
"ig_lamardavis",
"s_m_m_lathandy_01",
"a_m_m_stlat_02",
"a_m_y_stlat_01",
"a_m_y_latino_01",
"u_f_y_lauren",
"cs_lazlow",
"ig_lazlow",
"cs_lazlow_2",
"ig_lazlow_2",
"cs_lestercrest",
"ig_lestercrest",
"ig_lestercrest_2",
"cs_lestercrest_2",
"cs_lestercrest_3",
"ig_lestercrest_3",
"cs_lifeinvad_01",
"ig_lifeinvad_01",
"ig_lifeinvad_02",
"s_m_m_lifeinvad_01",
"s_m_m_linecook",
"u_m_m_willyfist",
"s_m_y_xmech_02",
"cs_magenta",
"ig_magenta",
"s_f_m_maid_01",
"ig_malc",
"u_m_y_danceburl_01",
"u_m_y_dancelthr_01",
"u_m_y_dancerave_01",
"a_m_m_malibu_01",
"u_m_y_mani",
"cs_manuel",
"ig_manuel",
"s_m_m_mariachi_01",
"csb_ramp_marine",
"s_m_m_marine_01",
"s_m_m_marine_02",
"s_m_y_marine_01",
"s_m_y_marine_02",
"s_m_y_marine_03",
"u_m_m_markfost",
"cs_marnie",
"ig_marnie",
"cs_martinmadrazo",
"cs_maryann",
"ig_maryann",
"s_m_y_shop_mask",
"csb_maude",
"ig_maude",
"csb_rashcosvki",
"ig_rashcosvki",
"s_m_y_xmech_01",
"csb_mweather",
"a_m_y_methhead_01",
"csb_ramp_mex",
"ig_ramp_mex",
"g_m_m_mexboss_01",
"g_m_m_mexboss_02",
"g_m_y_mexgang_01",
"g_m_y_mexgoon_01",
"g_m_y_mexgoon_02",
"g_m_y_mexgoon_03",
"a_m_m_mexlabor_01",
"a_m_m_mexcntry_01",
"a_m_y_mexthug_01",
"player_zero",
"cs_michelle",
"ig_michelle",
"a_m_m_mlcrisis_01",
"s_f_y_migrant_01",
"s_m_m_migrant_01",
"cs_milton",
"ig_milton",
"s_m_y_mime",
"cs_joeminuteman",
"ig_joeminuteman",
"u_f_m_miranda",
"u_f_m_miranda_02",
"u_f_y_mistress",
"mp_f_misty_01",
"cs_molly",
"ig_molly",
"csb_money",
"ig_money",
"a_m_y_motox_01",
"a_m_y_motox_02",
"a_c_mtlion",
"s_m_m_movspace_01",
"u_m_o_filmnoir",
"u_m_m_filmdirector",
"cs_movpremf_01",
"s_f_y_movprem_01",
"cs_movpremmale",
"s_m_m_movprem_01",
"u_f_o_moviestar",
"cs_mrsphillips",
"ig_mrsphillips",
"csb_mrs_r",
"cs_mrs_thornhill",
"ig_mrs_thornhill",
"cs_natalia",
"ig_natalia",
"cs_nervousron",
"ig_nervousron",
"cs_nigel",
"ig_nigel",
"mp_m_niko_01",
"ig_oneil",
"a_m_m_og_boss_01",
"mp_f_cardesign_01",
"cs_old_man1a",
"ig_old_man1a",
"cs_old_man2",
"ig_old_man2",
"cs_omega",
"ig_omega",
"csb_ortega",
"ig_ortega",
"csb_oscar",
"csb_paige",
"ig_paige",
"a_m_m_paparazzi_01",
"u_m_y_paparazzi",
"s_m_m_paramedic_01",
"u_m_m_partytarget",
"u_m_y_party_01",
"cs_patricia",
"ig_patricia",
"s_m_y_pestcont_01",
"cs_dreyfuss",
"ig_dreyfuss",
"a_c_pig",
"a_c_pigeon",
"s_m_m_pilot_01",
"s_m_y_pilot_01",
"s_m_m_pilot_02",
"u_m_y_pogo_01",
"a_m_m_polynesian_01",
"g_m_y_pologoon_01",
"g_m_y_pologoon_02",
"a_m_y_polynesian_01",
"a_c_poodle",
"u_f_y_poppymich",
"u_f_y_poppymich_02",
"csb_porndudes",
"s_m_m_postal_01",
"s_m_m_postal_02",
"cs_priest",
"ig_priest",
"u_f_y_princess",
"s_m_m_prisguard_01",
"s_m_y_prisoner_01",
"u_m_y_prisoner_01",
"s_m_y_prismuscl_01",
"csb_prologuedriver",
"u_m_y_proldriver_01",
"a_f_m_prolhost_01",
"a_m_m_prolhost_01",
"u_f_o_prolhost_01",
"u_f_m_promourn_01",
"u_m_m_promourn_01",
"csb_prolsec",
"u_m_m_prolsec_01",
"cs_prolsec_02",
"ig_prolsec_02",
"mp_g_m_pros_01",
"a_c_pug",
"a_c_rabbit_01",
"s_f_y_ranger_01",
"s_m_y_ranger_01",
"a_c_rat",
"csb_reporter",
"u_m_y_rsranger_01",
"a_c_retriever",
"a_c_rhesus",
"u_m_m_rivalpap",
"a_m_y_roadcyc_01",
"s_m_y_robber_01",
"csb_roccopelosi",
"ig_roccopelosi",
"a_c_rottweiler",
"a_f_y_rurmeth_01",
"a_m_m_rurmeth_01",
"cs_russiandrunk",
"ig_russiandrunk",
"s_m_y_swat_01",
"ig_sacha",
"s_f_m_shop_high",
"s_f_y_shop_low",
"s_f_y_shop_mid",
"a_f_m_salton_01",
"a_m_m_salton_01",
"a_m_m_salton_02",
"a_m_m_salton_03",
"a_m_m_salton_04",
"a_f_o_salton_01",
"a_m_o_salton_01",
"a_m_y_salton_01",
"g_m_y_salvaboss_01",
"g_m_y_salvagoon_01",
"g_m_y_salvagoon_02",
"g_m_y_salvagoon_03",
"s_m_m_scientist_01",
"csb_screen_writer",
"ig_screen_writer",
"a_c_seagull",
"s_m_m_security_01",
"mp_m_securoguard_01",
"s_f_y_sheriff_01",
"s_m_y_sheriff_01",
"mp_m_shopkeep_01",
"cs_siemonyetarian",
"ig_siemonyetarian",
"a_f_y_skater_01",
"a_m_m_skater_01",
"a_m_y_skater_01",
"a_m_y_skater_02",
"a_f_m_skidrow_01",
"a_m_m_skidrow_01",
"s_m_m_snowcop_01",
"csb_sol",
"ig_sol",
"ig_djsolmanager",
"cs_solomon",
"ig_solomon",
"a_f_m_soucent_01",
"a_f_m_soucent_02",
"a_m_m_socenlat_01",
"a_f_m_soucentmc_01",
"a_m_m_soucent_01",
"a_m_m_soucent_02",
"a_m_m_soucent_03",
"a_m_m_soucent_04",
"a_f_o_soucent_01",
"a_f_o_soucent_02",
"a_m_o_soucent_01",
"a_m_o_soucent_02",
"a_m_o_soucent_03",
"a_f_y_soucent_01",
"a_f_y_soucent_02",
"a_f_y_soucent_03",
"a_m_y_soucent_01",
"a_m_y_soucent_02",
"a_m_y_soucent_03",
"a_m_y_soucent_04",
"u_m_y_sbike",
"u_m_m_spyactor",
"u_f_y_spyactress",
"u_m_y_staggrm_01",
"cs_stevehains",
"ig_stevehains",
"a_c_stingray",
"u_m_m_streetart_01",
"s_m_m_strperf_01",
"s_m_m_strpreach_01",
"g_m_y_strpunk_01",
"g_m_y_strpunk_02",
"s_m_m_strvend_01",
"s_m_y_strvend_01",
"cs_stretch",
"ig_stretch",
"csb_stripper_01",
"s_f_y_stripper_01",
"csb_stripper_02",
"s_f_y_stripper_02",
"s_f_y_stripperlite",
"mp_f_stripperlite",
"a_m_y_sunbathe_01",
"a_m_y_surfer_01",
"s_f_m_sweatshop_01",
"s_f_y_sweatshop_01",
"csb_talcc",
"ig_talcc",
"csb_talmm",
"ig_talmm",
"ig_talina",
"cs_tanisha",
"ig_tanisha",
"cs_taocheng",
"ig_taocheng",
"cs_taocheng2",
"ig_taocheng2",
"cs_taostranslator",
"ig_taostranslator",
"cs_taostranslator2",
"ig_taostranslator2",
"u_m_y_tattoo_01",
"u_f_y_taylor",
"cs_tenniscoach",
"ig_tenniscoach",
"a_f_y_tennis_01",
"a_m_m_tennis_01",
"cs_terry",
"ig_terry",
"g_f_y_lost_01",
"g_m_y_lost_01",
"g_m_y_lost_02",
"g_m_y_lost_03",
"csb_thornton",
"ig_thornton",
"a_c_sharktiger",
"cs_tom",
"csb_tomcasino",
"ig_tomcasino",
"csb_tonyprince",
"ig_tonyprince",
"csb_tonya",
"ig_tonya",
"a_f_y_topless_01",
"a_f_m_tourist_01",
"a_m_m_tourist_01",
"a_f_y_tourist_01",
"a_f_y_tourist_02",
"cs_tracydisanto",
"ig_tracydisanto",
"csb_trafficwarden",
"ig_trafficwarden",
"a_f_m_tramp_01",
"a_m_m_tramp_01",
"a_m_o_tramp_01",
"u_m_o_tramp_01",
"s_m_m_gentransport",
"a_m_m_tranvest_01",
"a_m_m_tranvest_02",
"player_two",
"s_m_m_trucker_01",
"ig_tylerdix",
"ig_tylerdix_02",
"s_m_m_ups_01",
"s_m_m_ups_02",
"s_m_y_uscg_01",
"csb_undercover",
"cs_paper",
"ig_paper",
"u_m_y_ushi",
"g_f_y_vagos_01",
"mp_m_g_vagfun_01",
"ig_vagspeak",
"csb_vagspeak",
"s_m_y_valet_01",
"a_m_y_beachvesp_01",
"a_m_y_beachvesp_02",
"u_m_m_vince",
"csb_vincent",
"ig_vincent",
"csb_vincent_2",
"ig_vincent_2",
"a_m_y_vindouche_01",
"a_f_y_vinewood_01",
"a_f_y_vinewood_02",
"a_f_y_vinewood_03",
"a_f_y_vinewood_04",
"a_m_y_vinewood_01",
"a_m_y_vinewood_02",
"a_m_y_vinewood_03",
"a_m_y_vinewood_04",
"cs_wade",
"ig_wade",
"s_m_y_waiter_01",
"mp_m_waremech_01",
"s_m_y_waretech_01",
"mp_m_weapexp_01",
"mp_m_weapwork_01",
"cs_chengsr",
"ig_chengsr",
"csb_wendy",
"ig_wendy",
"a_c_westy",
"a_m_y_stwhi_01",
"a_m_y_stwhi_02",
"s_m_y_winclean_01",
"a_f_y_yoga_01",
"a_m_y_yoga_01",
"cs_zimbor",
"ig_zimbor",
"slod_human",
"slod_large_quadped ",
"slod_small_quadped",
"strm_peds_mpShare",
"strm_peds_mpTattRTs",
"u_m_y_zombie_01"
}
--]]
--]]
-- these are the buzzard's gunner weapons
--это оружие наводчика. Вы можете включить некоторые (убедитесь, что артиллеристы могут использовать их с вертолета)
local gunner_weapon_list = {
WT_MG 	= "weapon_mg",
WT_EMPL 		= "weapon_emplauncher",
WT_STUN			= "weapon_stungun",
WT_RAYPISTOL	= "weapon_raypistol",
WT_RIFLE_SCBN 	= "weapon_specialcarbine",
WT_SG_PMP		= "weapon_pumpshotgun",
WT_MG_CBT 	= "weapon_combatmg",
WT_MG_CBT2 = "weapon_combatmg_mk2",
WT_RIFLE_HVY 	= "weapon_heavysniper",
WT_GL = "weapon_grenadelauncher",
WT_RPG = "weapon_rpg",
WT_MINIGUN = "weapon_minigun",
WT_FWRKLNCHR = "weapon_firework",
WT_RAILGUN = "weapon_railgun",
WT_HOMLNCH = "weapon_hominglauncher",
WT_CMPGL = "weapon_compactlauncher",
WT_RAYMINIGUN = "weapon_rayminigun"
}

--]]
-- used to change minitank's weapon
--используется для замены оружия минитанка --used to change minitank's weapon
local modIndex =
{
	WT_V_PLRBUL 	= - 1,
	MINITANK_WEAP2 	=   1,
	MINITANK_WEAP3 	=   2
}

-- [name] = {"keyboard; controller", index}
local imputs = {
	INPUT_JUMP			= {'Spacebar; X', 22},
	INPUT_VEH_ATTACK		= {'Mouse L; RB', 69},
	INPUT_VEH_AIM			= {'Mouse R; LB', 68},
	INPUT_VEH_DUCK			= {'X; A', 73},
	INPUT_VEH_HORN			= {'E; L3', 86},
	INPUT_VEH_CINEMATIC_UP_ONLY 	= {'Numpad +; none', 96},
	INPUT_VEH_CINEMATIC_DOWN_ONLY 	= {'Numpad -; none', 97}
}


local veh_weapons = {
	{"weapon_vehicle_rocket"	, "WT_V_SPACERKT"	, PAD.IS_CONTROL_JUST_PRESSED},
	{"weapon_raypistol"		, "WT_RAYPISTOL"	, PAD.IS_CONTROL_PRESSED},
	{"weapon_firework"		, "WT_FWRKLNCHR"	, PAD.IS_CONTROL_JUST_PRESSED},
	{"vehicle_weapon_tank"		, "WT_V_TANK"		, PAD.IS_CONTROL_JUST_PRESSED},
	{"vehicle_weapon_player_lazer"	, "WT_V_PLRBUL"		, PAD.IS_CONTROL_PRESSED}
}


local formations = {
	{'Freedom to Move', 0},
	{'Circle Around Leader', 1},
	{'Line', 3},
	{'Arrow Formation', 4},
}


local proofs = {
	bullet 		= false,
	fire 		= false,
	explosion 	= false,
	collision 	= false,
	melee 		= false,
	steam 		= false,
	drown 		= false
}


NULL = 0
NOTIFICATION_RED = 6
NOTIFICATION_BLACK = 2

---------------------------------
-- CONFIG
---------------------------------

if filesystem.exists(config_file) then
	local loaded = ini.load(config_file)
	for s, t in pairs(loaded) do
		for k, v in pairs(t) do
			if config[ s ] and config[ s ][ k ] ~= nil then
				config[ s ][ k ] = v
			end
		end
	end
end


if config.general.language ~= 'english' then
	local file = languagedir .. '\\' .. config.general.language .. '.json'
	if not filesystem.exists(file) then
		notification.normal('Translation file not found', NOTIFICATION_RED)
	else
		file = io.open(file, 'r')
		local content = file:read('a')
        	file:close()
		if string.len(content) > 0 then 
			local loaded = json.parse(content, false)
			menunames = loaded
        	end
	end
end

-----------------------------------
-- HTTP
-----------------------------------

async_http.init('pastebin.com', '/raw/EhH1C6Dh', function(output)
	local cversion = tonumber(output)
	if cversion then 
		if cversion > version then	
    	    		notification.normal('WiriScript v' .. output .. ' is available', NOTIFICATION_RED)
			menu.hyperlink(menu.my_root(), 'Get WiriScript v' .. output, 'https://cutt.ly/get-wiriscript', '')
    		end
	end
end, function()
	util.log('[WiriScript] Failed to check for updates.')
end)
async_http.dispatch()


async_http.init('pastebin.com', '/raw/WMUmGzNj', function(output)
	if string.match(output, '^#') ~= nil then
		local msg = string.match(output, '^#(.+)')
        	notification.help('~b~' .. '~italic~' .. 'Nowiry: ' .. '~s~' .. msg)
	end
end, function()
    util.log('[WiriScript] Failed to get message.')
end)
async_http.dispatch()

-------------------------------------
-- INTRO
-------------------------------------

local function ADD_TEXT_TO_SINGLE_LINE(scaleform, text, font, colour)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "ADD_TEXT_TO_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(text)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(font)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(colour)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(true)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end


local function HIDE(scaleform)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "HIDE")
	GRAPHICS.BEGIN_TEXT_COMMAND_SCALEFORM_STRING("STRING")
	HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME("presents")
	GRAPHICS.END_TEXT_COMMAND_SCALEFORM_STRING()
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.16)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end


local function SETUP_SINGLE_LINE(scaleform)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SETUP_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(70.0)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(125.0)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING('left')
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end


if SCRIPT_MANUAL_START then
	showing_intro = true
	local state = 0
	local stime = cTime()
	AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "clown_die_wrapper", PLAYER.PLAYER_PED_ID(), "BARRY_02_SOUNDSET", true, 20)
	
	create_tick_handler(function()	
		local scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE("OPENING_CREDITS")	
		while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(scaleform) do
			wait()
		end

		if state == 0 then
			SETUP_SINGLE_LINE(scaleform)
	
ADD_TEXT_TO_SINGLE_LINE(scaleform, 'a', '$font5', "HUD_COLOUR_WHITE")
ADD_TEXT_TO_SINGLE_LINE(scaleform, 'nowiry', '$font2', "HUD_COLOUR_BLUE")
ADD_TEXT_TO_SINGLE_LINE(scaleform, 'production', '$font5', "HUD_COLOUR_WHITE")
ADD_TEXT_TO_SINGLE_LINE(scaleform, 'Deluxe', '$font2', "HUD_COLOUR_BLUE")
ADD_TEXT_TO_SINGLE_LINE(scaleform, 'edtion', '$font5', "HUD_COLOUR_WHITE")
			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_SINGLE_LINE")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_CREDIT_BLOCK")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

			AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "Pre_Screen_Stinger", PLAYER.PLAYER_PED_ID(), "DLC_HEISTS_FINALE_SCREEN_SOUNDS", true, 20)
			state = 1
			stime = cTime()
		end

		if cTime() - stime >= 4000 and state == 1 then
			HIDE(scaleform)
			state = 2
			stime = cTime()
		end

		if cTime() - stime >= 3000 and state == 2 then
			SETUP_SINGLE_LINE(scaleform)

ADD_TEXT_TO_SINGLE_LINE(scaleform, 'wiriscript', '$font2', 'HUD_COLOUR_TREVOR')
ADD_TEXT_TO_SINGLE_LINE(scaleform, 'v'..version, '$font5', 'HUD_COLOUR_WHITE')

			
			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_SINGLE_LINE")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_CREDIT_BLOCK")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

			AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "SPAWN", PLAYER.PLAYER_PED_ID(), "BARRY_01_SOUNDSET", true, 20)
			state = 3
			stime = cTime()
		end

		if cTime() - stime >= 4000 and state == 3 then
			HIDE(scaleform)
			state = 4
			stime = cTime()
		end
		if cTime() - stime >= 3000 and state == 4 then
			showing_intro = false
			return false
		end
		GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)
		return true
	end)
end

-----------------------------------------------------Сетевые опции--------------------------------------------------
online = menu.list(menu.my_root(), menuname('Sky_KoT', 'Online'), {}, "", function(); end)
stand = menu.list(online, menuname('Stand', 'Stand'), {}, "")
-----STAND-----
menu.action(stand, menuname('Stand', menuname('Stand', 'kickall')), {}, "", function(on_click)
menu.trigger_commands("kickall")
end)
menu.action(stand, menuname('Stand', menuname('Stand', 'crashall')),  {}, "", function(on_click)
menu.trigger_commands("crashall")
end)
menu.action(stand, menuname('Stand', menuname('Stand', 'historyadd')),  {}, "", function(on_click)
menu.trigger_commands("historyadd")
end)
menu.action(stand, menuname('Stand', menuname('Stand', 'historyadd')), {}, "", function(on_click)
menu.trigger_commands("historyaddrid")
end)
menu.action(stand, menuname('Stand', 'forcequittosp'), {}, "", function(on_click)
menu.trigger_commands("forcequittosp")
end)
menu.action(stand, menuname('Stand', menuname('Stand', 'playerlist')), {}, "Быстро открывает список игроков для вашего удобства", function(on_click)
menu.trigger_commands("playerlist")
end)
--[[
--]]

-------------------------------------
-- SPOOFING PROFILE
-------------------------------------

local profiles_root = menu.list(online, menuname('Spoofing Profile', 'Spoofing Profile'), {'profiles'}, '')

function add_profile(profile, name)
	local name = name or profile.name
	local rid = profile.rid
	local profile_actions = menu.list(profiles_root, name, {'profile' .. name}, '')

	menu.divider(profile_actions, name)

	menu.action(profile_actions, menuname('Spoofing Profile - Profile', 'Enable Spoofing Profile'), {'enable' .. name}, '', function()
		usingprofile = true 
		if spoofname then
			menu.trigger_commands('spoofedname ' .. profile.name)
			menu.trigger_commands('spoofname on')
		end
		if spoofrid then
			menu.trigger_commands('spoofedrid ' .. rid)
			menu.trigger_commands('spoofrid hard')
		end
		if spoofcrew and profile.crew and not equals(profile.crew, {}) then
			menu.trigger_commands(
				'crewid ' 		.. profile.crew.icon 	.. ';' ..
				'crewtag ' 		.. profile.crew.tag 	.. ';' ..
				'crewname ' 	.. profile.crew.name 	.. ';' ..
				'crewmotto ' 	.. profile.crew.motto 	.. ';' ..
				'crewaltbadge '	.. string.lower( profile.crew.alt_badge ) .. '; crew on'
			)
		end
	end)

	menu.action(profile_actions, menuname('Spoofing Profile - Profile', 'Delete'), {}, '', function()
		os.remove(wiridir .. '\\profiles\\' .. name .. '.json')
		local restore_profile
		restore_profile = menu.action(recycle_bin, name, {}, menuname('Notification', 'Click to restore'), function()
			save_profile(profile)
			menu.delete(restore_profile)
		end)
		profiles_list[ key_of(profiles_list, profile) ] = nil
		menu.delete(profile_actions)
		notification.normal(menuname('Notification', 'Profile moved to recycle bin'))
	end)
	
	menu.divider(profile_actions, menuname('Spoofing Profile - Profile', 'Spoofing Options') )
	
	menu.toggle(profile_actions, menuname('Spoofing Profile - Profile', 'Name'), {}, '', function(toggle)
		spoofname = toggle
	end, true)

	menu.toggle(profile_actions, menuname('Spoofing Profile - Profile', 'SCID') .. ' ' .. rid, {}, '', function(toggle)
		spoofrid = toggle
	end, true)

	if profile.crew and not equals(profile.crew, {}) then
		menu.toggle(profile_actions, menuname('Spoofing Profile - Profile', 'Crew Spoofing'), {}, '', function(toggle)
			spoofcrew = toggle
		end, true)
		local crewinfo = menu.list(profile_actions, menuname('Spoofing Profile - Profile', 'Crew'))
		for k, value in pairs_by_keys(profile.crew) do
			local name = k:gsub('_', " ")
			name = cap_each_word(name)
			menu.action(crewinfo, name .. ': ' .. value, {}, 'Click to copy to clipboard.', function()
				util.copy_to_clipboard(v)
			end)
		end
	end
end


function save_profile(profile)
	local key = profile.name 
	if includes(profiles_list, profile) then
		notification.normal('This spoofing profile already exists', NOTIFICATION_RED)
		return
	elseif profiles_list[ profile.name ] ~= nil then
		local n = 0
		for k in pairs(profiles_list) do
			if k:match(profile.name) then
				n = n + 1
			end
		end
		key = profile.name .. ' (' .. (n + 1) .. ')' 
	end
	profiles_list[ key ] =  profile
	local file = io.open(wiridir .. '\\profiles\\' .. key .. '.json', 'w')
	local content = json.stringify(profile, nil, 4)
	file:write(content)
	file:close()
	add_profile(profile, key)
	notification.normal('Spoofing profile created')
end

menu.action(profiles_root, menuname('Spoofing Profile', 'Disable Spoofing Profile'), {'disableprofile'}, '', function()
	if usingprofile then 
		menu.trigger_commands('spoofname off; spoofrid off; crew off')
		usingprofile = false
	else
		notification.normal('You are not using any spoofing profile', NOTIFICATION_RED)
	end
end)

-------------------------------------
-- ADD SPOOFING PROFILE
-------------------------------------

local newname
local newrid
local newprofile = menu.list(profiles_root, menuname('Spoofing Profile', 'Add Profile'), {'addprofile'}, menuname('Help', 'Manually creates a new spoofing profile.'))

menu.divider(newprofile, menuname('Spoofing Profile', 'Add Profile') )


menu.text_input(newprofile, menuname('Spoofing Profile - Add Profile', 'Name'), {'profilename'}, 'Type the profile\'s name.', function(name)
	newname = name
end)

menu.text_input(newprofile, menuname('Spoofing Profile - Add Profile', 'SCID'), {'profilerid'}, 'Type the profile\'s SCID.', function(rid)
	newrid = rid
end)

menu.action(newprofile, menuname('Spoofing Profile - Add Profile', 'Save Spoofing Profile'), {'saveprofile'}, '', function()
	if newname == nil or newrid == nil then
		notification.normal('Name and SCID are required', NOTIFICATION_RED)
		return
	end
	local profile = {['name'] = newname, ['rid'] = newrid}
	save_profile(profile)
end)


recycle_bin = menu.list(profiles_root, menuname('Spoofing Profile', 'Recycle Bin'), {}, menuname('Help', 'Temporary stores the deleted profiles. Profiles are permanetly erased when the script stops'))

menu.divider(profiles_root, menuname('Spoofing Profile', 'Spoofing Profile') )


for _, path in ipairs(filesystem.list_files(wiridir .. '\\profiles')) do
	local filename, ext = string.match(path, '^.+\\(.+)%.(.+)$')
	if ext == 'json' then
		local file = io.open(path, 'r')
		local content = file:read('a')
		file:close()
		if string.len(content) > 0 then
			local profile = json.parse(content, false)
			if profile.name and profile.rid then
				profile.rid = tonumber(profile.rid)
				profiles_list[ filename ] = profile
				add_profile(profile, filename)
			end
		end
	else os.remove(path) end
end


generate_features = function(pid)
	menu.divider(menu.player_root(pid),'WS v16 Deluxe')		
	
	developer(menu.action, menu.player_root(pid), 'CPed', {}, '', function()
		local addr = entities.handle_to_pointer(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hex = string.format("%x", addr)
		util.copy_to_clipboard(string.upper( hex ))
	end)

	-------------------------------------
	-- CREATE SPOOFING PROFILE
	-------------------------------------

	menu.action(menu.player_root(pid), menuname('Player', 'Create Spoofing Profile'), {}, '', function()
		local profile = {name = PLAYER.GET_PLAYER_NAME(pid), rid = players.get_rockstar_id(pid), crew = get_player_clan(pid)}
		save_profile(profile)
	end)

----------------------------------------------Подмена IP----------------------------------------------
spoofpresets = menu.list(online, menuname('Sky_KoT', 'IP'), {}, menuname('Sky_KoT', 'stand may show coordinates incorrectly in the list of players'), function(); end)

menu.action(spoofpresets, menuname('Sky_KoT', 'IPOn'), {}, "", function()
menu.trigger_commands("spoofip on")
end)

menu.action(spoofpresets, menuname('Sky_KoT', 'IPOff'), {}, "", function()
menu.trigger_commands("spoofip off")
end)

----------------------------------------------------------------------------------------------------------------------------------
ipplayer = menu.list(spoofpresets, "IP player", {}, "", function(); end)

--Presents players
menu.action(ipplayer , "IPplayer", {}, "", function()
menu.trigger_commands("spoofedip " .. "123.456.789.000")					   
menu.trigger_commands("spoofip on")
end)

--[[ 
Presents Presents players

menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
menu.action(ipplayer , "", {}, "", function()
menu.trigger_commands("spoofedip " .. "")
menu.trigger_commands("spoofip on")
end)
--]]
----------------------------------------------------------------------------------------------------------------------------------

ipworld = menu.list(spoofpresets, menuname('Sky_KoT', 'ipworld'), {}, "", function(); end)

menu.action(ipworld, "Россия", {}, "", function()
sel = math.random(1,3)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "109.252." .. tostring(math.random(40, 45)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "92.100." .. tostring(math.random(178, 182)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 3 then
menu.trigger_commands("spoofedip " .. "217.107." .. tostring(math.random(82, 98)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 4 then
menu.trigger_commands("spoofedip " .. "95.24." .. tostring(math.random(0, 31)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Китай", {}, "", function()
menu.trigger_commands("spoofedip " .. "42.123." .. tostring(math.random(0, 31)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Австралия", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.168." .. tostring(math.random(40, 53)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Австрия", {}, "", function()
menu.trigger_commands("spoofedip " .. "194.166." .. tostring(math.random(250, 252)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Австрия 2 (старое)", {}, "", function(on_click)
	menu.trigger_commands("spoofedip " .. "194.166.250." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Албания", {}, "", function()
menu.trigger_commands("spoofedip " .. "79.106." .. tostring(math.random(160, 191)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Бельгия", {}, "", function()
menu.trigger_commands("spoofedip " .. "94.111." .. tostring(math.random(2, 4)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Болгария", {}, "", function()
menu.trigger_commands("spoofedip " .. "90.154." .. tostring(math.random(162, 164)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Великобритания", {}, "", function()
sel = math.random(1,4)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "81.109." .. tostring(math.random(120, 130)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "217.33." .. tostring(math.random(88, 90)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 3 then
menu.trigger_commands("spoofedip " .. "2.217." .. tostring(math.random(20, 30)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 4 then
menu.trigger_commands("spoofedip " .. "86.0." .. tostring(math.random(54, 60)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Великобритания (старое)", {}, "", function(on_click)
menu.trigger_commands("spoofedip " .. "81.109.120." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Венгрия", {}, "", function()
menu.trigger_commands("spoofedip " .. "84.2." .. tostring(math.random(137, 137)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Германия", {}, "", function()
sel = math.random(1,4)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "84.56." .. tostring(math.random(218, 231)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "46.223." .. tostring(math.random(234, 251)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 3 then
menu.trigger_commands("spoofedip " .. "93." .. tostring(math.random(192, 255)) .. "." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 4 then
menu.trigger_commands("spoofedip " .. "89.14." .. tostring(math.random(120, 124)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Греция", {}, "", function()
menu.trigger_commands("spoofedip " .. "2.85." .. tostring(math.random(227, 227)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Дания", {}, "", function()
sel = math.random(1,2)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "83.92." .. tostring(math.random(121, 124)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "87.104." .. tostring(math.random(64, 127)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Испания", {}, "", function()
menu.trigger_commands("spoofedip " .. "93.176." .. tostring(math.random(154, 155)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Ирландия", {}, "", function()
menu.trigger_commands("spoofedip " .. "84.203." .. tostring(math.random(0, 10)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Италия", {}, "", function()
sel = math.random(1,2)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "5.89." .. tostring(math.random(190, 197)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "217.200." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Италия (старое)", {}, "", function(on_click)
	menu.trigger_commands("spoofedip " .. "5.89.190." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Нидерланды", {}, "", function()
sel = math.random(1,4)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "217.123." .. tostring(math.random(124, 125)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "217." .. tostring(math.random(100, 105)) .. "." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 3 then
menu.trigger_commands("spoofedip " .. "139.156." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 4 then
menu.trigger_commands("spoofedip " .. "94.212." .. tostring(math.random(40, 47)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Нидерланды (старое)", {}, "", function(on_click)
	menu.trigger_commands("spoofedip " .. "217.123.124." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Литва", {}, "", function()
menu.trigger_commands("spoofedip " .. "90.140." .. tostring(math.random(13, 13)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Норвегия", {}, "", function()
menu.trigger_commands("spoofedip " .. "80.213." .. tostring(math.random(174, 181)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Польша", {}, "", function()
sel = math.random(1,3)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "178.36." .. tostring(math.random(221, 229)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "193.17." .. tostring(math.random(174, 174)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 3 then
menu.trigger_commands("spoofedip " .. "217." .. tostring(math.random(96, 99)) .. "." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Португалия", {}, "", function()
menu.trigger_commands("spoofedip " .. "94.61." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Румыния", {}, "", function()
menu.trigger_commands("spoofedip " .. "79.117." .. tostring(math.random(0, 127)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "США Чикаго", {}, "", function()
menu.trigger_commands("spoofedip " .. "73.110." .. tostring(math.random(149, 151)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "США Балтимор", {}, "", function()
menu.trigger_commands("spoofedip " .. "69.67." .. tostring(math.random(80, 95)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "США Техас", {}, "AT&T / IBM", function()
menu.trigger_commands("spoofedip " .. "198.81.193." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Словакия", {}, "", function()
menu.trigger_commands("spoofedip " .. "90.64." .. tostring(math.random(50, 55)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Словения", {}, "", function()
menu.trigger_commands("spoofedip " .. "77.111." .. tostring(math.random(53, 53)) .. "." .. tostring(math.random(0, 255)))
end)
menu.action(ipworld, "Финляндия", {}, "", function()
menu.trigger_commands("spoofedip " .. "88.113." .. tostring(math.random(64, 83)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Франция", {}, "", function()
menu.trigger_commands("spoofedip " .. "2.10." .. tostring(math.random(134, 151)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Швейцария", {}, "", function()
sel = math.random(1,2)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "85.0." .. tostring(math.random(41, 43)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "84.73." .. tostring(math.random(0, 115)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(ipworld, "Швеция", {}, "", function()
sel = math.random(1,2)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "78.72." .. tostring(math.random(240, 245)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "151.252." .. tostring(math.random(128, 172)) .. "." .. tostring(math.random(0, 255)))
end
end)
menu.action(ipworld, "Хорватия", {}, "", function()
menu.trigger_commands("spoofedip " .. "185.133." .. tostring(math.random(132, 135)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Чешская республика", {}, "", function()
menu.trigger_commands("spoofedip " .. "185.91." .. tostring(math.random(164, 166)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipworld, "Хохляндия Донецк (тест)", {}, "", function()
sel = math.random(1,3)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "95.47." .. tostring(math.random(95, 47)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "109.254." .. tostring(math.random(109, 4)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 3 then
menu.trigger_commands("spoofedip " .. "178." .. tostring(math.random(96, 99)) .. "." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
end
end)


ipceo = menu.list(spoofpresets, menuname('Sky_KoT', 'ipceo'), {}, "", function(); end)
menu.action(ipceo, "Computer Problem Solving (US)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.146." .. tostring(math.random(48, 123)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipceo, "US Department of Defense", {}, "", function()
menu.trigger_commands("spoofedip " .. "155.21." .. tostring(math.random(224, 255)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipceo, "NASA (US)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.169." .. tostring(math.random(48, 123)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipceo, "Apple (US)", {}, "", function()
menu.trigger_commands("spoofedip " .. "17.234." .. tostring(math.random(0, 127)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipceo, "Akamai (NL)", {}, "", function()
menu.trigger_commands("spoofedip " .. "23.66." .. tostring(math.random(16, 31)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipceo, "Microsoft (US)", {}, "", function()
menu.trigger_commands("spoofedip " .. "40.89." .. tostring(math.random(224, 255)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(ipceo, "Microsoft (NL)", {}, "", function()
menu.trigger_commands("spoofedip " .. "51.144." .. tostring(math.random(0, 255)) .. "." .. tostring(math.random(0, 255)))
end)

t2spoofpresets = menu.list(spoofpresets, menuname('Sky_KoT', 't2spoofpresets'), {}, "", function(); end)

menu.action(t2spoofpresets, "Take-Two (UK)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.227." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (US)", {}, "", function()
sel = math.random(1,2)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "192.81." .. tostring(math.random(240, 244)) .. "." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "139.138." .. tostring(math.random(231, 232)) .. "." .. tostring(math.random(0, 255)))
end
end)

menu.action(t2spoofpresets, "Take-Two (AU)", {}, "", function()
sel = math.random(1,2)
if sel == 1 then
menu.trigger_commands("spoofedip " .. "139.138.226." .. tostring(math.random(0, 255)))
elseif sel == 2 then
menu.trigger_commands("spoofedip " .. "139.138.244." .. tostring(math.random(0, 255)))
end
end)

menu.action(t2spoofpresets, "Take-Two (DE)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.233." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (ES)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.247." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (HU)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.236." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (CZ)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.237." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (IN)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.224." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (SG)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.228." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (JP)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.229." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (CN)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.230." .. tostring(math.random(0, 255)))
end)

menu.action(t2spoofpresets, "Take-Two (HK)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.138.238." .. tostring(math.random(0, 255)))
end)


ipvpn = menu.list(spoofpresets, menuname('Sky_KoT', 'VPN IP'), {}, "", function(); end)

octospoofpresets = menu.list(ipvpn, "Хостинг OVH", {}, "", function(); end)

menu.action(octospoofpresets, "OVH (AU)", {}, "", function()
menu.trigger_commands("spoofedip " .. "139.99." .. tostring(math.random(232, 234)) .. "." .. tostring(math.random(0, 255)))
end)

menu.action(octospoofpresets, "OVH (DE)", {}, "", function()
menu.trigger_commands("spoofedip " .. "145.239.235." .. tostring(math.random(40, 111)))
end)

menu.action(octospoofpresets, "OVH (UK)", {}, "", function()
menu.trigger_commands("spoofedip " .. "51.89.208." .. tostring(math.random(88, 95)))
end)

menu.action(octospoofpresets, "OVH (US)", {}, "", function()
menu.trigger_commands("spoofedip " .. "51.81.119." .. tostring(math.random(0, 15)))
end)

menu.action(octospoofpresets, "OVH (CA)", {}, "", function()
menu.trigger_commands("spoofedip " .. "192.99.250." .. tostring(math.random(208, 223)))
end)

tempestpresets = menu.list(ipvpn, menuname('Sky_KoT', 'tempestpresets'), {}, "", function(); end)

menu.action(tempestpresets, "Tempest Hosting (US-NY)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.252." .. tostring(math.random(128, 255)))
end)

menu.action(tempestpresets, "Tempest Hosting (US-CA)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.252." .. tostring(math.random(0, 127)))
end)

menu.action(tempestpresets, "Tempest Hosting (US-FL)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.254." .. tostring(math.random(128, 255)))
end)

menu.action(tempestpresets, "Tempest Hosting (CA)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.253." .. tostring(math.random(128, 255)))
end)

menu.action(tempestpresets, "Tempest Hosting (NL)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.253." .. tostring(math.random(0, 127)))
end)

menu.action(tempestpresets, "Tempest Hosting (UK)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.255." .. tostring(math.random(0, 127)))
end)

menu.action(tempestpresets, "Tempest Hosting (RU)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.253." .. tostring(math.random(127, 255)))
end)

menu.action(tempestpresets, "Tempest Hosting (JP)", {}, "", function()
menu.trigger_commands("spoofedip " .. "142.252.254." .. tostring(math.random(0, 127)))
end)
--[[--]]
	---------------------
	---------------------
	-- TROLLING 
	---------------------
	---------------------

	local trolling_list = menu.list(menu.player_root(pid), menuname('Player', 'Trolling & Griefing'), {}, '')	
	
-----------------------------------------------------------------------------------------------------------------------------------Крыса ворует авто---------------------
function kick_from_veh(pid)
--log("Kicking " .. pid .. " from vehicle.")
    menu.trigger_commands("vehkick" .. PLAYER.GET_PLAYER_NAME(pid))
end

function npc_jack(target, nearest)
    npc_jackthr = util.create_thread(function(thr)
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
        local last_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, true)
        kick_from_veh(target)
        local st = os.time()
        while not VEHICLE.IS_VEHICLE_SEAT_FREE(last_veh, -1) do 
            if os.time() - st >= 10 then
                util.toast("Не удалось освободить автокресло за 10 секунд")
                util.stop_thread()
            end
            util.yield()
        end
        local hash = 0xC3B52966
        request_model_load(hash)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player_ped, -2.0, 0.0, 0.0)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        local ped = entities.create_ped(28, hash, coords, 30.0)
        ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
        PED.SET_PED_FLEE_ATTRIBUTES(ped, 0, false)
        PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
        PED.SET_PED_INTO_VEHICLE(ped, last_veh, -1)
        VEHICLE.SET_VEHICLE_ENGINE_ON(last_veh, true, true, false)
		VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(last_veh, true)--
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(last_veh, 4)--
        TASK.TASK_VEHICLE_DRIVE_TO_COORD(ped, last_veh, math.random(1000), math.random(1000), math.random(100), 100, 1, ENTITY.GET_ENTITY_MODEL(last_veh), 786996, 5, 0)
        util.toast("Авто украдено!")
        util.stop_thread()
    end)
	end
	
menu.toggle(trolling_list, menuname('Sky_KoT', 'spectate'), {}, "", function(on)
spectate = on
if spectate then
menu.trigger_commands('spectate '..PLAYER.GET_PLAYER_NAME(pid)..' on')
else
menu.trigger_commands('spectate '..PLAYER.GET_PLAYER_NAME(pid)..' off')
end
end)
	
 menu.action(trolling_list, menuname('Sky_KoT', 'ratjack'), {"ratjack"}, "", function(on_click)
npc_jack(pid, false)
end)

------------------------------------------------Нападающие автомобили------------------------------------------------------------------
--local trolly_vehicles = menu.list(trolling_list, "Нападающие автомобили")
local trolly_vehicles = menu.list(trolling_list, menuname('Trolling', 'Trolly Vehicles'), {}, '')

menu.toggle(trolly_vehicles, menuname('Sky_KoT', 'spectate'), {}, "", function(on)
spectate = on
if spectate then
menu.trigger_commands('spectate '..PLAYER.GET_PLAYER_NAME(pid)..' on')
else
menu.trigger_commands('spectate '..PLAYER.GET_PLAYER_NAME(pid)..' off')
end
end)
	-------------------------------------
	-- TROLLY BANDITO--RC Бандито
	-------------------------------------
local rc_bandito = menu.list(trolly_vehicles, "RC Бандито")

	local banditos = {
		godmode = false, 
		explosive_bandito_exists = false
	}


	local function spawn_trolly_vehicle(pid, vehicleHash, pedHash)
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local coords_ptr = alloc()
		local nodeId = alloc()
		local coords

		local vehicle = VEHICLE.CREATE_VEHICLE(vehicleHash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, false)
		NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(vehicle), false)
		VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
		
		for i = 0, 50 do
			VEHICLE.SET_VEHICLE_MOD(vehicle, i, VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i) - 1, false)
		end
		
		local driver = entities.create_ped(5, pedHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		PED.SET_PED_INTO_VEHICLE(driver, vehicle, -1)

		if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 100, 0, 0, 0, coords_ptr, nodeId) then
			pos.x = pos.x + math.random(-20,20)
			pos.y = pos.y + math.random(-20,20)
			PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
			coords = memory.read_vector3(coords_ptr)
			memory.free(coords_ptr); memory.free(nodeId)
		else
			coords = memory.read_vector3(coords_ptr)
			memory.free(coords_ptr); memory.free(nodeId)
		end

		VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
		VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vehicle, true)
		VEHICLE.SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(vehicle, false)
		ENTITY.SET_ENTITY_COORDS(vehicle, coords.x, coords.y, coords.z)
		SET_ENT_FACE_ENT(vehicle, player_ped)

		PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
		TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, player_ped, 6, 500.0, 786988, 0.0, 0.0, true)
		SET_PED_CAN_BE_KNOCKED_OFF_VEH(driver, 1)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(pedHash); STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(vehicleHash)
		return vehicle, driver
	end

	menu.divider(rc_bandito, 'Bandito')

	menu.click_slider(rc_bandito, menuname('Trolling - Trolly Vehicles', 'Send Bandito(s)'), {'sendbandito'}, '', 1,25,1,1, function(quantity)
		local bandito_hash = joaat("rcbandito")
		local ped_hash = joaat("mp_m_freemode_01")
		REQUEST_MODELS(bandito_hash, ped_hash)
		for i = 1, quantity do
			local vehicle, driver = spawn_trolly_vehicle(pid, bandito_hash, ped_hash)
			ADD_BLIP_FOR_ENTITY(vehicle, 646, 4)
			ENTITY.SET_ENTITY_INVINCIBLE(vehicle, banditos.godmode)
			ENTITY.SET_ENTITY_VISIBLE(driver, false, 0)
			wait(150)
		end
	end)

	menu.toggle(rc_bandito, menuname('Trolling - Trolly Vehicles', 'Invincible'), {}, '', function(toggle)
		banditos.godmode = toggle
	end)

	menu.action(rc_bandito, menuname('Trolling - Trolly Vehicles', 'Send Explosive Bandito'), {'explobandito'}, '', function()
		local bandito_hash = joaat("rcbandito")
		local ped_hash = joaat("mp_m_freemode_01")
		REQUEST_MODELS(bandito_hash, ped_hash)
		
		if banditos.explosive_bandito_exists then
			notification.normal('Explosive bandito already sent', NOTIFICATION_RED)
			return
		end
		banditos.explosive_bandito_exists = true
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local bandito = spawn_trolly_vehicle(pid, bandito_hash, ped_hash)
		VEHICLE.SET_VEHICLE_MOD(bandito, 5, 3, false)
		VEHICLE.SET_VEHICLE_MOD(bandito, 48, 5, false)
		VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(bandito, 128, 0, 128)
		VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(bandito, 128, 0, 128)
		ADD_BLIP_FOR_ENTITY(bandito, 646, 27)
		VEHICLE.ADD_VEHICLE_PHONE_EXPLOSIVE_DEVICE(bandito)

		while not ENTITY.IS_ENTITY_DEAD(bandito) do
			wait()
			local a = ENTITY.GET_ENTITY_COORDS(p)
			local b = ENTITY.GET_ENTITY_COORDS(bandito)
			if vect.dist(a,b) < 3.0 then
				VEHICLE.DETONATE_VEHICLE_PHONE_EXPLOSIVE_DEVICE()
			end
		end

		banditos.explosive_bandito_exists = false
	end)

	menu.action(rc_bandito, menuname('Trolling - Trolly Vehicles', 'Delete Bandito(s)'), {}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(p, false)
		DELETE_NEARBY_VEHICLES(pos, "rcbandito", 1000.0)
	end)
	
	-------------------------------------
	-- GO KART
	-------------------------------------
local gokart = menu.list(trolly_vehicles, "Go-Kart")
	local gokart_godmode = false
	menu.divider(gokart, 'Go-Kart')

	menu.click_slider(gokart, menuname('Trolling - Trolly Vehicles', 'Send Go-Kart(s)'), {'sendgokart'}, '',1, 15, 1, 1, function(quantity)
		local vehicleHash = joaat("veto2")
		local pedHash = joaat("mp_m_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
			local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 748, 5)
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 111, 13, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 67, 5, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 101, 1, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, -1, -1, 2)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 148, 5, 2)
			PED.SET_PED_PROP_INDEX(driver, 0, 91, 0, true)
			wait(150)
		end	
end)

menu.toggle(gokart, menuname('Trolling - Trolly Vehicles', 'Invincible'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(gokart, menuname('Trolling - Trolly Vehicles', 'Delete Go-Karts'), {}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(p, false)
		DELETE_NEARBY_VEHICLES(pos, "veto2", 1000.0)
end)
	
-----------------Розовый енот на велике--------------------
local racoon_bmx = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Racoon_Bmx'))
local gokart_godmode = false
--local racoon_bmx_godmode = true

menu.click_slider(racoon_bmx, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
		local vehicleHash = joaat("bmx")
		local pedHash = joaat("mp_f_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
--add_blip_for_entity(gokart, 442, 46)
			ADD_BLIP_FOR_ENTITY(gokart, 442, 61)
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 33, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 20, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 15, 35, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 27, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 102, 20, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 60, 3, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 77, 8, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 15, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 155, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 262, 20, 0)
			PED.SET_PED_PROP_INDEX(driver, 4, 13, 0, true)
			wait(150)
		end
	end)
menu.toggle(racoon_bmx, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
--bmx_godmode = toggle
gokart_godmode = toggle
end)

menu.action(racoon_bmx, menuname('Sky_KoT', 'Delete'), {}, "", function()
--DELETE_ALL_VEHICLES_GIVEN_MODEL('bmx')
--DELETE_ALL_PEDS_GIVEN_MODEL('mp_f_freemode_01')
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "bmx", 1000.0)
DELETE_NEARBY_PEDS(pos, "mp_f_freemode_01", 1000.0)
end)

-----------------------Racoon dune5-----------------------------------
local dune5 = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Racoon dune5'))
local gokart_godmode = false

menu.click_slider(dune5, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("dune5")
local pedHash = joaat("mp_f_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 531, 31)	
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 33, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 20, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 15, 35, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 27, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 102, 20, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 60, 3, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 77, 8, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 15, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 155, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 262, 20, 0)
			PED.SET_PED_PROP_INDEX(driver, 4, 13, 0, true)
			wait(0)
		end
end)
	
menu.toggle(dune5, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(dune5, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "dune5", 50000.0)
end)

-----------------------Racoon_Phantom-----------------------------------
local phantom2 = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Racoon_Phantom'))
local gokart_godmode = false

menu.click_slider(phantom2, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("phantom2")
local pedHash = joaat("mp_m_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 528, 24)	
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 33, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 20, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 15, 35, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 27, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 102, 20, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 60, 3, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 77, 8, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 15, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 155, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 262, 20, 0)
			PED.SET_PED_PROP_INDEX(driver, 4, 13, 0, true)
			wait(100)
		end
end)
	
menu.toggle(phantom2, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(phantom2, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "phantom2", 10000.0)
end)
-----------------Halloween sanctus-------------------
local rc_sanctus = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Halloween_Sanctus'))
local gokart_godmode = false

menu.click_slider(rc_sanctus, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("sanctus")
local pedHash = joaat("mp_f_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 378, 75)	
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 25, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 191, 2, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 79, 29, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 32, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 140, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 102, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 218, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 381, 0, 0)
			PED.SET_PED_PROP_INDEX(driver, 0, 15, 7, true)
			wait(100)
		end
end)
	
menu.toggle(rc_sanctus, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(rc_sanctus, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "sanctus", 10000.0)
end)

-----------------Halloween_Deathbike2-------------------
local Deathbike2 = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Halloween_Deathbike2'))
local gokart_godmode = false

menu.click_slider(Deathbike2, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("Deathbike2")
local pedHash = joaat("mp_f_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 378, 75)	
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 25, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 191, 2, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 79, 29, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 32, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 140, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 102, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 218, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 381, 0, 0)
			PED.SET_PED_PROP_INDEX(driver, 0, 15, 7, true)
			wait(100)
		end
end)
	
menu.toggle(Deathbike2, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(Deathbike2, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "DEATHBIKE2", 10000.0)
end)

-----------------Halloween Deathbike3-------------------
local Deathbike3= menu.list(trolly_vehicles, menuname('Sky_KoT', 'Halloween_Deathbike3'))
local gokart_godmode = false

menu.click_slider(Deathbike3, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("Deathbike3")
local pedHash = joaat("mp_f_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 378, 75)	
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 25, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 191, 2, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 79, 29, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 32, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 140, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 102, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 218, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 381, 0, 0)
			PED.SET_PED_PROP_INDEX(driver, 0, 15, 7, true)
			wait(100)
		end
end)
	
menu.toggle(Deathbike3, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(Deathbike3, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "Deathbike3", 10000.0)
end)

-----------------------Deluxo-----------------------------------
local Deluxo = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Deluxo'))
local gokart_godmode = false

menu.click_slider(Deluxo, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("Deluxo")
local pedHash = joaat("mp_m_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
			ADD_BLIP_FOR_ENTITY(gokart, 756, 5)	
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 25, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 191, 2, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 79, 29, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 32, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 140, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 102, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 218, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 2, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 381, 0, 0)
			PED.SET_PED_PROP_INDEX(driver, 0, 15, 7, true)
			wait(100)
		end
end)
	
menu.toggle(Deluxo, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(Deluxo, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "Deluxo", 10000.0)
end)

-----------------LIMO2--------------------

local Limo2 = menu.list(trolly_vehicles, menuname('Sky_KoT', 'Limo2'))
local gokart_godmode = false

menu.click_slider(Limo2, menuname('Sky_KoT', 'Send'), {''}, '',1, 50, 1, 1, function(quantity)
local vehicleHash = joaat("limo2")
local pedHash = joaat("mp_f_freemode_01")
		REQUEST_MODELS(vehicleHash, pedHash)
		
for i = 1, quantity do
local gokart, driver = spawn_trolly_vehicle(pid, vehicleHash, pedHash)
--add_blip_for_entity(gokart, 442, 46)
			ADD_BLIP_FOR_ENTITY(gokart, 442, 61)
			ENTITY.SET_ENTITY_INVINCIBLE(gokart, gokart_godmode)
			VEHICLE.SET_VEHICLE_COLOURS(gokart, 89, 0)
			VEHICLE.TOGGLE_VEHICLE_MOD(gokart, 18, true)
			VEHICLE.MODIFY_VEHICLE_TOP_SPEED(gokart, 250)
			ENTITY.SET_ENTITY_INVINCIBLE(driver, gokart_godmode)
			PED.SET_PED_COMPONENT_VARIATION(driver, 0, 33, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 1, 20, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 2, 15, 35, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 3, 27, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 4, 102, 20, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 5, 60, 3, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 6, 77, 8, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 7, 15, 1, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 8, 155, 4, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 9, 0, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 10, 78, 0, 0)
			PED.SET_PED_COMPONENT_VARIATION(driver, 11, 262, 20, 0)
			PED.SET_PED_PROP_INDEX(driver, 4, 13, 0, true)
			wait(150)
		end
	end)
	
menu.toggle(Limo2, menuname('Sky_KoT', 'GM'), {}, '', function(toggle)
gokart_godmode = toggle
end)

menu.action(Limo2, menuname('Sky_KoT', 'Delete'), {}, "", function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "limo2", 50000.0)
end)
--[[
--]]

	-------------------------------------
	-- ENEMY VEHICLES
	-------------------------------------
local enemy_vehicles = menu.list(trolling_list, menuname('Trolling', 'Enemy Vehicles'), {}, '')
	local minitank = menu.list(enemy_vehicles, "Minitank")
	local minitanks =
{
godmode = false
}

	

	menu.divider(minitank, menuname('Trolling - Enemy Vehicles', 'Minitank'))

	menu.click_slider(minitank, menuname('Trolling - Enemy Vehicles', 'Send Minitank(s)'), {'sendminitank'}, '', 1, 25, 1, 1, function(quantity)
		local minitank_hash = joaat("minitank")
		local ped_hash = joaat("s_m_y_blackops_01")
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		
		REQUEST_MODELS(minitank_hash, ped_hash)
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, joaat("ARMY"), joaat("ARMY"))
		
		for i = 1, quantity do
			local weapon = minitanks.weapon or random(modIndex)
			local coords_ptr = alloc()
			local nodeId = alloc()
			local coords

			local vehicle = VEHICLE.CREATE_VEHICLE(minitank_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, false)
			NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(vehicle), false)

			if ENTITY.DOES_ENTITY_EXIST(vehicle) then
				local driver = entities.create_ped(5, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				PED.SET_PED_INTO_VEHICLE(driver, vehicle, -1)

				if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
					pos.x = pos.x + math.random(-20,20)
					pos.y = pos.y + math.random(-20,20)
					PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
					coords = memory.read_vector3(coords_ptr)
				end

				coords = memory.read_vector3(coords_ptr)
				memory.free(coords_ptr)
				memory.free(nodeId)

				ENTITY.SET_ENTITY_COORDS(vehicle, coords.x, coords.y, coords.z)
				ADD_BLIP_FOR_ENTITY(vehicle, 742, 4)
				ENTITY.SET_ENTITY_INVINCIBLE(vehicle, minitanks.godmode)
				VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
				VEHICLE.SET_VEHICLE_MOD(vehicle, 10, weapon, false)
				VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
				SET_ENT_FACE_ENT(vehicle, player_ped)

				PED.SET_PED_RELATIONSHIP_GROUP_HASH(driver, joaat("ARMY"))
				PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
				PED.SET_PED_COMBAT_ATTRIBUTES(driver, 3, false)
				
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
				TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
				PED.SET_PED_KEEP_TASK(driver, true)
				ENTITY.SET_ENTITY_VISIBLE(driver, false, 0)

				create_tick_handler(function()
					if TASK.GET_SCRIPT_TASK_STATUS(driver, 0x2E85A751) == 7 then
						TASK.CLEAR_PED_TASKS(driver)
						TASK.TASK_COMBAT_PED(driver, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0)
						PED.SET_PED_KEEP_TASK(driver, true)
					end
					return (not ENTITY.IS_ENTITY_DEAD(vehicle))
				end)

				wait(150)
			end			
		end

		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(minitank_hash)
	end)

	menu.toggle(minitank, menuname('Trolling - Enemy Vehicles', 'Invincible'), {}, '', function(toggle)
		minitanks.godmode = toggle
	end)

	-------------------------------------
	-- MINITANK WEAPON
	-------------------------------------

	local menu_minitank_weapon = menu.list(minitank, menuname('Trolling - Enemy Vehicles', 'Minitank Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '')

	menu.divider(menu_minitank_weapon, HUD._GET_LABEL_TEXT("PM_WEAPONS"))

	menu.action(menu_minitank_weapon, HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '', function()
		minitanks.weapon = nil
		menu.set_menu_name(menu_minitank_weapon, menuname('Trolling - Enemy Vehicles', 'Minitank Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"))
		menu.focus(menu_minitank_weapon)
	end)

	for label, weapon in pairs_by_keys(modIndex) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(menu_minitank_weapon, strg, {}, '', function()
			minitanks.weapon = weapon
			menu.set_menu_name(menu_minitank_weapon, menuname('Trolling - Enemy Vehicles', 'Minitank Weapon') .. ': ' .. strg)
			menu.focus(menu_minitank_weapon)
		end)
	end

	menu.action(minitank, menuname('Trolling - Enemy Vehicles', 'Delete Minitank(s)'), {}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(p, false)
		DELETE_NEARBY_VEHICLES(pos, "minitank", 1000.0)
	end)

	-------------------------------------
	-- ENEMY BUZZARD
	-------------------------------------
local buzzard = menu.list(enemy_vehicles, "Buzzard")
	local buzzard_visible = true
	local gunner_weapon = "weapon_mg"
	
	menu.divider(buzzard, menuname('Trolling - Enemy Vehicles', 'Buzzard'))

	menu.click_slider(buzzard, menuname('Trolling - Enemy Vehicles', 'Send Buzzard(s)'), {'sendbuzzard'}, '', 1, 5, 1, 1, function(quantity)
		local heli_hash = joaat("buzzard2")
		local ped_hash = joaat("s_m_y_blackops_01")
		local player_ped =  PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local player_group_hash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(player_ped)

		REQUEST_MODELS(ped_hash, heli_hash)
		
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, joaat("ARMY"), player_group_hash)
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, player_group_hash, joaat("ARMY"))
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, joaat("ARMY"), joaat("ARMY"))

		for i = 1, quantity do
			local heli = VEHICLE.CREATE_VEHICLE(heli_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, false)
			NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(heli), false)

			if ENTITY.DOES_ENTITY_EXIST(heli) then
				local pilot = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)

				pos.x = pos.x + math.random(-20,20)
				pos.y = pos.y + math.random(-20,20)
				pos.z = pos.z + 30
				
				ENTITY.SET_ENTITY_COORDS(heli, pos.x, pos.y, pos.z)
				NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(heli), false)
				ENTITY.SET_ENTITY_INVINCIBLE(heli, buzzard_godmode)
				ENTITY.SET_ENTITY_VISIBLE(heli, buzzard_visible, 0)	
				VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
				VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
				ADD_BLIP_FOR_ENTITY(heli, 422, 4)

				PED.SET_PED_MAX_HEALTH(pilot, 500)
				ENTITY.SET_ENTITY_HEALTH(pilot, 500)
				ENTITY.SET_ENTITY_INVINCIBLE(pilot, buzzard_godmode)
				ENTITY.SET_ENTITY_VISIBLE(pilot, buzzard_visible, 0)
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
				TASK.TASK_HELI_MISSION(pilot, heli, 0, player_ped, 0.0, 0.0, 0.0, 23, 40.0, 40.0, -1.0, 0, 10, -1.0, 0)
				PED.SET_PED_KEEP_TASK(pilot, true)
				
				for seat = 1, 2 do 
					local ped = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
					PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
					WEAPON.GIVE_WEAPON_TO_PED(ped, joaat(gunner_weapon), -1, false, true)
					PED.SET_PED_COMBAT_ATTRIBUTES(ped, 20, true)
					PED.SET_PED_MAX_HEALTH(ped, 500)
					ENTITY.SET_ENTITY_HEALTH(ped, 500)
					ENTITY.SET_ENTITY_INVINCIBLE(ped, buzzard_godmode)
					ENTITY.SET_ENTITY_VISIBLE(ped, buzzard_visible, 0)
					PED.SET_PED_SHOOT_RATE(ped, 1000)
					PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, joaat("ARMY"))
					TASK.TASK_COMBAT_HATED_TARGETS_AROUND_PED(ped, 1000, 0)
				end
				
				wait(100)
			end
		end

		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
	end)
	
	menu.toggle(buzzard, menuname('Trolling - Enemy Vehicles', 'Invincible'), {}, '', function(toggle)
		buzzard_godmode = toggle
	end)

	local menu_gunner_weapon_list = menu.list(buzzard, menuname('Trolling - Enemy Vehicles', 'Gunners Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("WT_MG"))
	
	menu.divider(menu_gunner_weapon_list, HUD._GET_LABEL_TEXT("PM_WEAPONS"))

	for label, weapon in pairs_by_keys(gunner_weapon_list) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(menu_gunner_weapon_list, strg, {}, '', function()
			gunner_weapon = weapon
			menu.set_menu_name(menu_gunner_weapon_list, 'Gunner\'s Weapon: ' .. strg)
			menu.focus(menu_gunner_weapon_list)
		end)
	end

	menu.toggle(buzzard, menuname('Trolling - Enemy Vehicles', 'Visible'), {}, '', function(toggle)
		buzzard_visible = toggle
	end, true)
	
menu.action(buzzard, 'Удалить созданные Buzzards', {}, '', function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "buzzard2", 10000.0)
end)

	-------------------------------------
	-- ENEMY BUZZARD
	-------------------------------------
local buzzard = menu.list(enemy_vehicles, "Buzzard")
	local buzzard_visible = true
	local gunner_weapon = "weapon_mg"
	
	menu.divider(buzzard, menuname('Trolling - Enemy Vehicles', 'Buzzard'))

	menu.click_slider(buzzard, menuname('Trolling - Enemy Vehicles', 'Send Buzzard(s)'), {'sendbuzzard'}, '', 1, 5, 1, 1, function(quantity)
		local heli_hash = joaat("SWIFT2")
		local ped_hash = joaat("csb_johnny_guns")
		local player_ped =  PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local player_group_hash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(player_ped)

		REQUEST_MODELS(ped_hash, heli_hash)
		
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, joaat("ARMY"), player_group_hash)
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, player_group_hash, joaat("ARMY"))
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, joaat("ARMY"), joaat("ARMY"))

		for i = 1, quantity do
			local heli = VEHICLE.CREATE_VEHICLE(heli_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, false)
			NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(heli), false)

			if ENTITY.DOES_ENTITY_EXIST(heli) then
				local pilot = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)

				pos.x = pos.x + math.random(-20,20)
				pos.y = pos.y + math.random(-20,20)
				pos.z = pos.z + 30
				
				ENTITY.SET_ENTITY_COORDS(heli, pos.x, pos.y, pos.z)
				NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(heli), false)
				ENTITY.SET_ENTITY_INVINCIBLE(heli, buzzard_godmode)
				ENTITY.SET_ENTITY_VISIBLE(heli, buzzard_visible, 0)	
				VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
				VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
				ADD_BLIP_FOR_ENTITY(heli, 422, 4)

				PED.SET_PED_MAX_HEALTH(pilot, 500)
				ENTITY.SET_ENTITY_HEALTH(pilot, 500)
				ENTITY.SET_ENTITY_INVINCIBLE(pilot, buzzard_godmode)
				ENTITY.SET_ENTITY_VISIBLE(pilot, buzzard_visible, 0)
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
				TASK.TASK_HELI_MISSION(pilot, heli, 0, player_ped, 0.0, 0.0, 0.0, 23, 40.0, 40.0, -1.0, 0, 10, -1.0, 0)
				PED.SET_PED_KEEP_TASK(pilot, true)
				
				for seat = 1, 2 do 
					local ped = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
					PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
					WEAPON.GIVE_WEAPON_TO_PED(ped, joaat(gunner_weapon), -1, false, true)
					PED.SET_PED_COMBAT_ATTRIBUTES(ped, 20, true)
					PED.SET_PED_MAX_HEALTH(ped, 500)
					ENTITY.SET_ENTITY_HEALTH(ped, 500)
					ENTITY.SET_ENTITY_INVINCIBLE(ped, buzzard_godmode)
					ENTITY.SET_ENTITY_VISIBLE(ped, buzzard_visible, 0)
					PED.SET_PED_SHOOT_RATE(ped, 1000)
					PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, joaat("ARMY"))
					TASK.TASK_COMBAT_HATED_TARGETS_AROUND_PED(ped, 1000, 0)
				end
				
				wait(100)
			end
		end

		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
	end)
	
	menu.toggle(buzzard, menuname('Trolling - Enemy Vehicles', 'Invincible'), {}, '', function(toggle)
		buzzard_godmode = toggle
	end)

	local menu_gunner_weapon_list = menu.list(buzzard, menuname('Trolling - Enemy Vehicles', 'Gunners Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("WT_MG"))
	
	menu.divider(menu_gunner_weapon_list, HUD._GET_LABEL_TEXT("PM_WEAPONS"))

	for label, weapon in pairs_by_keys(gunner_weapon_list) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(menu_gunner_weapon_list, strg, {}, '', function()
			gunner_weapon = weapon
			menu.set_menu_name(menu_gunner_weapon_list, 'Gunner\'s Weapon: ' .. strg)
			menu.focus(menu_gunner_weapon_list)
		end)
	end

	menu.toggle(buzzard, menuname('Trolling - Enemy Vehicles', 'Visible'), {}, '', function(toggle)
		buzzard_visible = toggle
	end, true)
	
menu.action(buzzard, 'Удалить созданные Buzzards', {}, '', function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
DELETE_NEARBY_VEHICLES(pos, "SWIFT2", 10000.0)
end)
	-------------------------------------
	-- HOSTILE JET
	-------------------------------------
local lazer = menu.list(enemy_vehicles, "Lazer")

menu.divider(lazer, 'Lazer')
menu.click_slider(lazer, menuname('Trolling - Enemy Vehicles', 'Send Lazer(s)'), {'sendlazer'}, '', 1, 15, 1, 1, function(quantity)
		local jet_hash = joaat("lazer")
		local ped_hash = joaat("s_m_y_blackops_01")
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		REQUEST_MODELS(jet_hash, ped_hash)
		
		for i = 1, quantity do
			local jet = VEHICLE.CREATE_VEHICLE(jet_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, false)
			NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(jet), false)

			if ENTITY.DOES_ENTITY_EXIST(jet) then
				local pilot = entities.create_ped(5, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				PED.SET_PED_INTO_VEHICLE(pilot, jet, -1)

				pos.x = pos.x + math.random(-80,80)
				pos.y = pos.y + math.random(-80,80)
				pos.z = pos.z + 500

				ENTITY.SET_ENTITY_COORDS(jet, pos.x, pos.y, pos.z)
				SET_ENT_FACE_ENT(jet, player_ped)
				ADD_BLIP_FOR_ENTITY(jet, 16, 4)
				VEHICLE._SET_VEHICLE_JET_ENGINE_ON(jet, true)
				VEHICLE.SET_VEHICLE_FORWARD_SPEED(jet, 60)
				VEHICLE.CONTROL_LANDING_GEAR(jet, 3)
				ENTITY.SET_ENTITY_INVINCIBLE(jet, jet_godmode)
				VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(jet, true)
				
				TASK.TASK_PLANE_MISSION(pilot, jet, 0, player_ped, 0, 0, 0, 6, 100, 0, 0, 80, 50)
				PED.SET_PED_COMBAT_ATTRIBUTES(pilot, 1, true)
				relationship:hostile(pilot)
				wait(150)
			end
		end
		
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(jet_hash)
	end)

	menu.toggle(lazer, menuname('Trolling - Enemy Vehicles', 'Invincible'), {}, '', function(toggle)
		jet_godmode = toggle
	end, jet_godmode)

	menu.action(lazer, menuname('Trolling - Enemy Vehicles', 'Delete Lazers'), {}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(p, false)
		DELETE_NEARBY_VEHICLES(pos, "lazer", 50000.0)
	end)
	
	-------------------------------------
	-- ATTACKER OPTIONS
	-------------------------------------

	local attacker = {
		spawned 	= {},
		stationary 	= false,
		godmode 	= false
	}
	local attacker_options = menu.list(trolling_list, menuname('Trolling', 'Attacker Options'), {}, '')
	
	menu.divider(attacker_options, menuname('Trolling', 'Attacker Options'))

	menu.click_slider(attacker_options, menuname('Trolling - Attacker Options', 'Spawn Attacker'), {'attacker'}, '', 1, 15, 1, 1, function(quantity)
		local weapon = attacker.weapon or random(weapons)
		local model = attacker.model or random(peds)
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local modelHash = joaat(model)
		local weaponHash = joaat(weapon)
		
		for i = 1, quantity do
			local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
			pos.x = pos.x + math.random(-3,3)
			pos.y = pos.y + math.random(-3,3)
			pos.z = pos.z - 1.0
			
			REQUEST_MODELS(modelHash)
			local ped = entities.create_ped(0, modelHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			insert_once(attacker.spawned, model)
			NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.PED_TO_NET(ped), PLAYER.PLAYER_ID(), true)
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.PED_TO_NET(ped), true)
			SET_ENT_FACE_ENT(ped, player_ped)
			WEAPON.GIVE_WEAPON_TO_PED(ped, weaponHash, -1, true, true)
			WEAPON.SET_CURRENT_PED_WEAPON(ped, weaponHash, false)
			ENTITY.SET_ENTITY_INVINCIBLE(ped, attacker.godmode)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
			TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
			PED.SET_PED_AS_ENEMY(ped, true)
			
			if attacker.stationary then 
				PED.SET_PED_COMBAT_MOVEMENT(ped, 0) 
			end
			
			PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, 1)
			PED.SET_PED_CONFIG_FLAG(ped, 208, true)
			relationship:hostile(ped)
			STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(modelHash)

			wait(100)
		end
	end)

	local ped_list = menu.list(attacker_options, menuname('Trolling - Attacker Options', 'Set Model') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '')

	menu.divider(ped_list, menuname('Trolling - Attacker Options', 'Attacker Model List'))
	
	menu.action(ped_list, HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '', function()
		attacker.model = nil
		menu.set_menu_name(ped_list, menuname('Trolling - Attacker Options', 'Set Model') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"))
		menu.focus(ped_list)
	end)

	-- creates the attacker appearance list
	for k, model in pairs_by_keys(peds) do 
		menu.action(ped_list, menuname('Ped Models', k), {}, '', function()
			attacker.model = model
			menu.set_menu_name(ped_list, menuname('Trolling - Attacker Options', 'Set Model')..': '..k)
			menu.focus(ped_list)
		end)
	end

	menu.click_slider(attacker_options, menuname('Trolling - Attacker Options', 'Clone Player (Enemy)'), {'enemyclone'}, '', 1, 50, 1, 1, function(quantity)
		local weapon = attacker.weapon or random(weapons)
		local weapon_hash = joaat(weapon)
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		for i = 1, quantity do
			pos.x = pos.x + math.random(-3,3)
			pos.y = pos.y + math.random(-3,3)
			pos.z = pos.z - 1.0
			local clone = PED.CLONE_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 1, 1, 1)
			insert_once(attacker.spawned, "mp_f_freemode_01"); insert_once(attacker.spawned, "mp_m_freemode_01")
			WEAPON.GIVE_WEAPON_TO_PED(clone, weapon_hash, -1, true, true)
			WEAPON.SET_CURRENT_PED_WEAPON(clone, weapon_hash, false)
			ENTITY.SET_ENTITY_COORDS(clone, pos.x, pos.y, pos.z)
			ENTITY.SET_ENTITY_INVINCIBLE(clone, attacker.godmode)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(clone, true)
			TASK.TASK_COMBAT_PED(clone, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 16)
			PED.SET_PED_COMBAT_ATTRIBUTES(clone, 46, 1)
			PED.SET_PED_CONFIG_FLAG(clone, 208, true)
			relationship:hostile(clone)

			if attacker.stationary then	
				PED.SET_PED_COMBAT_MOVEMENT(clone, 0) 
			end
			wait(100)
		end
	end)


	local ped_weapon_list = menu.list(attacker_options, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '')	
	menu.divider(ped_weapon_list, HUD._GET_LABEL_TEXT("PM_WEAPONS"))
	
--local ped_melee_list = menu.list(ped_weapon_list, HUD._GET_LABEL_TEXT("VAULT_WMENUI_8"), {}, '')
--menu.divider(ped_melee_list, HUD._GET_LABEL_TEXT("VAULT_WMENUI_8"))
local ped_melee_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'melee_list'), {}, "")
local ped_shotguns_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'shotguns_list'), {}, "")
local ped_heavy_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'heavy_list'), {}, "")
local ped_throwables_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'throwables_list'), {}, "")
local ped_handguns_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'handguns_list'), {}, "")
local ped_submachine_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'submachine_list'), {}, "")
local ped_rifles_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'rifles_list'), {}, "")
local ped_sniper_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'sniper_list'), {}, "")
local ped_misc_list = menu.list(ped_weapon_list, menuname('Sky_KoT', 'misc_list'), {}, "")
	
	-- creates the attacker melee weapon list
	for label, weapon in pairs_by_keys(melee_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_melee_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end	

for label, weapon in pairs_by_keys(shotguns_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_shotguns_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(heavy_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_heavy_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(throwables_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_throwables_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(handguns_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_handguns_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(submachine_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_submachine_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(rifles_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_rifles_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(sniper_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_sniper_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end

	for label, weapon in pairs_by_keys(misc_weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_misc_list,  strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg, {}, '')	
			menu.focus(ped_weapon_list)
		end)
	end
--[[
--]]
	menu.action(ped_weapon_list, HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '', function()
		attacker.weapon = nil
		menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '')	
		menu.focus(ped_weapon_list)
	end)

	-- creates the attacker weapon list
	for label, weapon in pairs_by_keys(weapons) do
		local strg = HUD._GET_LABEL_TEXT(label)
		menu.action(ped_weapon_list, strg, {}, '', function()
			attacker.weapon = weapon
			menu.set_menu_name(ped_weapon_list, menuname('Trolling - Attacker Options', 'Set Weapon') .. ': ' .. strg)
			menu.focus(ped_weapon_list)
		end)
	end


	menu.toggle(attacker_options, menuname('Trolling - Attacker Options', 'Stationary'), {}, '', function(toggle)
		attacker.stationary = toggle
	end)

	-------------------------------------
	-- ENEMY CHOP
	-------------------------------------

	menu.action(attacker_options, menuname('Trolling - Attacker Options', 'Enemy Chop'), {'sendchop'}, '', function()
		local ped_hash = joaat("a_c_chop")
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		pos.x = pos.x + math.random(-3,3)
		pos.y = pos.y + math.random(-3,3)
		pos.z = pos.z - 1.0
		
		REQUEST_MODELS(ped_hash)
		local ped = entities.create_ped(28, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		insert_once(attacker.spawned, "a_c_chop")
		ENTITY.SET_ENTITY_INVINCIBLE(ped, attacker.godmode)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
		TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, 1)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		relationship:hostile(ped)
	end)
	
-----------Jesus lance----
--создание модели
function request_model_load(hash)
    request_time = os.time()
    if not STREAMING.IS_MODEL_VALID(hash) then
--util.toast("Запрошенная модель была недопустимой и не могла быть загружена.")
        return
    end
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
-- util.toast("Модель неудачно загружена в течении 10 секунд 10 seconds.")
            break
        end
--util.toast("Загружаю хеш модели " .. hash)
        util.yield()
    end
end

function dispatch_griefer_jesus(target)
--log("Послать Иисуса.")
    griefer_jesus = util.create_thread(function(thr)
        request_model_load(0xEA177CDD )
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
        coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
local jesus = entities.create_ped(1, 0xEA177CDD , coords, 30.0)
        ENTITY.SET_ENTITY_INVINCIBLE(jesus, true)
        PED.SET_PED_HEARING_RANGE(jesus, 9999)
	    PED.SET_PED_CONFIG_FLAG(jesus, 281, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(jesus, 5, true)
	    PED.SET_PED_COMBAT_ATTRIBUTES(jesus, 46, true)
        PED.SET_PED_CAN_RAGDOLL(jesus, false)
        WEAPON.GIVE_WEAPON_TO_PED(jesus, util.joaat("weapon_combatmg_mk2"), 9999, true, true)
        TASK.TASK_GO_TO_ENTITY(jesus, target_ped, -1, -1, 100.0, 0.0, 0)
    	TASK.TASK_COMBAT_PED(jesus, target_ped, 0, 16)
        PED.SET_PED_ACCURACY(jesus, 100.0)
        PED.SET_PED_COMBAT_ABILITY(jesus, 2)
	ADD_BLIP_FOR_ENTITY(jesus, 609, 13)
		

--проверка возрождения
 while true do
local player_coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
local jesus_coords = ENTITY.GET_ENTITY_COORDS(jesus, false)
local dist =  MISC.GET_DISTANCE_BETWEEN_COORDS(player_coords['x'], player_coords['y'], 
player_coords['z'], jesus_coords['x'], jesus_coords['y'], jesus_coords['z'], false)
 if dist > 100 then
 local behind = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(target_ped, -3.0, 0.0, 0.0)
ENTITY.SET_ENTITY_COORDS(jesus, behind['x'], behind['y'], behind['z'], false, false, false, false)
end
-- Скрипт Иисуса если Иисус исчезнет, мы можем просто сделать еще одного
if not ENTITY.DOES_ENTITY_EXIST(jesus) then
util.toast("Враг перестал существовать.")
util.stop_thread()
end
local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
if not players.exists(target) then
util.toast("Цель на игрока была потеряна.")
util.stop_thread()
else
TASK.TASK_COMBAT_PED(jesus, target_ped, 0, 16)
end
util.yield()
end
end)
end
menu.action(attacker_options, menuname('Sky_KoT', 'DreAttack'), {"sendgrieferjesus"}, "", function(on_click)
dispatch_griefer_jesus(pid)
end)

	-------------------------------------
	-- SEND POLICE CAR
	-------------------------------------

	menu.action(attacker_options, menuname('Trolling - Attacker Options', 'Send Police Car'), {'sendpolicecar'}, '', function()
		local veh_hash = joaat("police3")
		local ped_hash = joaat("s_m_y_cop_01")
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		
		REQUEST_MODELS(veh_hash, ped_hash)
		local coords_ptr = alloc()
		local nodeId = alloc()
		local weapons = {"weapon_pistol", "weapon_pumpshotgun"}
		
		if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
			pos.x = pos.x + math.random(-20,20)
			pos.y = pos.y + math.random(-20,20)
			PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
		end
		
		local coords = memory.read_vector3(coords_ptr); memory.free(coords_ptr); memory.free(nodeId)
		local vehicle = entities.create_vehicle(veh_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		SET_ENT_FACE_ENT(vehicle, player_ped)
		VEHICLE.SET_VEHICLE_SIREN(vehicle, true)
		AUDIO.BLIP_SIREN(vehicle)
		VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
		ENTITY.SET_ENTITY_INVINCIBLE(vehicle, attacker.godmode)
		
		for seat = -1, 0 do
			local cop = entities.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			local weapon = random(weapons)
			PED.SET_PED_RANDOM_COMPONENT_VARIATION(cop, 0)
			WEAPON.GIVE_WEAPON_TO_PED(cop, joaat(weapon) , -1, false, true)
			PED.SET_PED_NEVER_LEAVES_GROUP(cop, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(cop, 1, true)
			PED.SET_PED_AS_COP(cop, true)
			PED.SET_PED_INTO_VEHICLE(cop, vehicle, seat)
			ENTITY.SET_ENTITY_INVINCIBLE(cop, attacker.godmode)
			TASK.TASK_COMBAT_PED(cop, player_ped, 0, 16)
			PED.SET_PED_KEEP_TASK(cop, true)
			create_tick_handler(function()
				if TASK.GET_SCRIPT_TASK_STATUS(cop, 0x2E85A751) == 7 then
					TASK.CLEAR_PED_TASKS(cop)
					TASK.TASK_SMART_FLEE_PED(cop, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 1000.0, -1, false, false)
					PED.SET_PED_KEEP_TASK(cop, true)
					return false
				end
				return true
			end)
		end
		
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_hash)
		AUDIO.PLAY_POLICE_REPORT("SCRIPTED_SCANNER_REPORT_FRANLIN_0_KIDNAP", 0.0)
	end)
--[[
-------------------------------------
	-- CUSTOM KDJ BY AXHOV
	-------------------------------------
	
	menu.action(attacker_options, 'Send KDJ Car', {'sendkdj'}, '', function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local veh_hash = joaat('krieger')
		local ped_hash = joaat('csb_isldj_04')
		STREAMING.REQUEST_MODEL(veh_hash); STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(veh_hash) or not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			wait()
		end
		local coords_ptr = alloc()
		local nodeId = alloc()
		local coords
		local weapons = {'weapon_machinepistol', 'weapon_machinepistol'}
		if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
			pos.x = pos.x + math.random(-20,20)
			pos.y = pos.y + math.random(-20,20)
			PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
		end
		coords = memory.read_vector3(coords_ptr); memory.free(coords_ptr); memory.free(nodeId)
		local veh = entities.create_vehicle(veh_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		SET_ENT_FACE_ENT(veh, player_ped)
		VEHICLE.SET_VEHICLE_SIREN(veh, true)
		AUDIO.BLIP_SIREN(veh)
		VEHICLE.SET_VEHICLE_ENGINE_ON(veh, true, true, true)
		ENTITY.SET_ENTITY_INVINCIBLE(veh, gm)

		local function create_ped_into_vehicle(seat)
			local cop = entities.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			PED.SET_PED_RANDOM_COMPONENT_VARIATION(cop, 0)
			WEAPON.GIVE_WEAPON_TO_PED(cop, joaat(random(weapons)) , -1, false, true)
			PED.SET_PED_NEVER_LEAVES_GROUP(cop, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(cop, 1, true)
			PED.SET_PED_AS_COP(cop, true)
			PED.SET_PED_INTO_VEHICLE(cop, veh, seat)
			TASK.TASK_COMBAT_PED(cop, player_ped, 0, 16)
			ENTITY.SET_ENTITY_INVINCIBLE(cop, godmode)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(cop, true)
			PED.SET_PED_KEEP_TASK(cop, true)
			return cop
		end

		for seat = -1, 0 do
			local cop = create_ped_into_vehicle(seat)
			util.create_thread(function()
				while ENTITY.GET_ENTITY_HEALTH(cop) > 0 do
					local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
					if PLAYER.IS_PLAYER_DEAD(pid) then
						while PLAYER.IS_PLAYER_DEAD(pid) do
							wait()
						end
						TASK.TASK_COMBAT_PED(cop, player_ped, 0, 16)
					end
					wait()
				end
			end)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash); STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_hash)
		AUDIO.PLAY_POLICE_REPORT('SCRIPTED_SCANNER_REPORT_FRANLIN_0_KIDNAP', 0.0)
	end)

menu.action(attacker_options, 'Удалить KDJ', {}, '', function()
DELETE_ALL_VEHICLES_GIVEN_MODEL('krieger')
DELETE_ALL_PEDS_GIVEN_MODEL('csb_isldj_04')
end)

	menu.toggle(attacker_options, menuname('Trolling - Attacker Options', 'Invincible Attackers'), {}, '', function(toggle)
		attacker.godmode = toggle
	end)

	menu.action(attacker_options, menuname('Trolling - Attacker Options', 'Delete Attackers'), {}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(p, false)
		for _, model in ipairs(attacker.spawned) do
			DELETE_PEDS(model)
		end
		attacker.spawned = {}
	end)
--]]	
menu.action(attacker_options, menuname('Sky_KoT', 'Delete'), {}, '', function()
DELETE_ALL_VEHICLES_GIVEN_MODEL('police3')
DELETE_ALL_PEDS_GIVEN_MODEL('s_m_y_cop_01')
end)

menu.toggle(attacker_options, menuname('Trolling - Attacker Options', 'Invincible KDJ Krieger'), {}, 'Forces ONLY the KDJ Kreiger to be god mode, and NOT the occupants, to prevent victims from just blowing up the vehicle.', function(toggle)
gm = toggle
end)
	-------------------------------------
	-- EXPLOSIONS
	-------------------------------------
local explo_settings = menu.list(trolling_list, menuname('Trolling', 'Custom Explosion'), {}, '')	
local explode = menu.list(explo_settings, menuname('Trolling', 'Custom Explosion'), {}, '')
	local explosions = {
		audible = true,
		speed = 300,
		owned = false,
		type = 0,
		invisible = false
	}
	function explosions:explode_player(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		pos.z = pos.z - 1.0
		if not self.owned then
			FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, self.type, 1.0, self.audible, self.invisible, 0, false)
		else
			FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(), pos.x, pos.y, pos.z, self.type, 1.0, self.audible, self.invisible, 0, true)
		end
	end
	
	menu.divider(explode, menuname('Trolling', 'Custom Explosion'))

	menu.slider(explode, menuname('Trolling - Custom Explosion', 'Explosion Type'), {'explosion'},'', 0, 72, 0, 1, function(value)
		explosions.type = value
	end)
	
	menu.toggle(explode, menuname('Trolling - Custom Explosion', 'Invisible'), {}, '', function(toggle)
		explosions.invisible = toggle
	end)

	menu. toggle(explode, menuname('Trolling - Custom Explosion', 'Audible'), {}, '', function(toggle)
		explosions.audible = toggle
	end, true)
	
	menu.toggle(explode, menuname('Trolling - Custom Explosion', 'Owned Explosions'), {}, '', function(toggle)
		explosions.owned = toggle
	end)
	
	menu.action(explode, menuname('Trolling - Custom Explosion', 'Explode'), {'customexplode'}, '', function()
		explosions:explode_player(pid)
	end)

	menu.slider(explode, menuname('Trolling - Custom Explosion', 'Loop Speed'), {'speed'}, '', 50, 1000, 300, 10, function(value) --changes the speed of loop
		explosions.speed = value
	end)
	
	menu.toggle_loop(explode, menuname('Trolling - Custom Explosion', 'Explosion Loop'), {'customloop'}, '', function()
		explosions:explode_player(pid)
		wait(explosions.speed)
	end)

--KILL AS THE ORBITAL CANNON
--Убить с орбиталочки
----------------------------------------
	menu.action(explo_settings, menuname('Sky_KoT', 'Fast orbital'), {"orbital"}, "", function()
		menu.trigger_commands("becomeorbitalcannon on") 
		util.yield(200)
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), pos.x, pos.y, pos.z, 59, 1.0, true, false, 1.0)
		local effect = 
		{
			['asset'] = "scr_xm_orbital",
			['name'] = "scr_xm_orbital_blast"
		}
		
		STREAMING.REQUEST_NAMED_PTFX_ASSET(effect.asset)
		
		while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(effect.asset) do
			util.yield()
		end

		GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
			effect.name, 
			pos.x, 
			pos.y, 
			pos.z, 
			0.0, 
			0.0, 
			0.0, 
			1.0, 
			false, false, false, true
		)

		AUDIO.PLAY_SOUND_FROM_COORD(
			-1, 
			"DLC_XM_Explosions_Orbital_Cannon", 
			pos.x, 
			pos.y, 
			pos.z, 
			0, 
			true, 
			0, 
			false
		)
		util.yield(1000)
		menu.trigger_commands("becomeorbitalcannon off")
	end)
	
	-------------------------------------
	-- KILL AS THE ORBITAL CANNON
	-------------------------------------
menu.action(explo_settings, menuname('Trolling', 'Kill as Orbital Cannon'), {'orbital'}, '', function()
		local countdown = 3
		if players.is_in_interior(pid) then
			return notification.normal('The player is in interior', NOTIFICATION_RED)
		end
		local cam = CAM.CREATE_CAM("DEFAULT_SCRIPTED_CAMERA", false)
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local height = pos.z + 200
		menu.trigger_commands('becomeorbitalcannon on')
		CAM.DO_SCREEN_FADE_OUT(500)
		wait(1000)
		CAM.SET_CAM_ROT(cam, -90, 0.0, 0.0, 2)
		CAM.SET_CAM_FOV(cam, 80)
		CAM.SET_CAM_COORD(cam, pos.x, pos.y, height)
		CAM.SET_CAM_ACTIVE(cam, true)
		STREAMING.LOAD_SCENE(pos.x, pos.y, pos.z)
		CAM.RENDER_SCRIPT_CAMS(true, false, 3000, true, false, 0)
		STREAMING.SET_FOCUS_POS_AND_VEL(pos.x, pos.y, pos.z, 5.0, 0.0, 0.0)
		GRAPHICS.SET_SCRIPT_GFX_DRAW_ORDER(1)
		GRAPHICS.SET_DRAW_ORIGIN(pos.x, pos.y, pos.z, 0)
		GRAPHICS.ANIMPOSTFX_PLAY("MP_OrbitalCannon", 0, true)
		wait(1000)
		CAM.DO_SCREEN_FADE_IN(0)

		local scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE("ORBITAL_CANNON_CAM")
		while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(scaleform) do
			wait()
		end
		
		local startTime = os.time()
		while true do
			wait()
			local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
			DRAW_LOCKON_SPRITE_ON_PLAYER(pid)

			CAM.SET_CAM_COORD(cam, pos.x, pos.y, height)
			HUD.DISPLAY_RADAR(false)

			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SET_STATE")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(3)
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SET_ZOOM_LEVEL")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(1.0)
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SET_CHARGING_LEVEL")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(1.0)
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
			
			if countdown > 0 then
				if os.difftime(os.time(), startTime) == 1 then
					countdown = countdown - 1
					startTime = os.time()
				end
				GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SET_COUNTDOWN")
				GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(countdown)
				GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
			else
				GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SET_CHARGING_LEVEL")
				GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.0)
				GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

				local effect = {asset = "scr_xm_orbital", name = "scr_xm_orbital_blast"}
		
				STREAMING.REQUEST_NAMED_PTFX_ASSET(effect.asset)
				while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(effect.asset) do
					wait()
				end

				FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(), pos.x, pos.y, pos.z, 59, 1.0, true, false, 1.0)
				GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
				GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
					effect.name, 
					pos.x,
					pos.y,
					pos.z, 
					0.0, 
					0.0, 
					0.0,
					1.0, 
					false, false, false, true
				)
				AUDIO.PLAY_SOUND_FROM_COORD(-1, "DLC_XM_Explosions_Orbital_Cannon", pos.x, pos.y, pos.z, 0, true, 0, false)
				CAM.SHAKE_CAM(cam, "GAMEPLAY_EXPLOSION_SHAKE", 1.5)
				break
			end
			GRAPHICS.SET_SCRIPT_GFX_DRAW_ORDER(0)
			GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)
			GRAPHICS.RESET_SCRIPT_GFX_ALIGN()
		end
		CAM.DO_SCREEN_FADE_OUT(500)
		wait(600)
		GRAPHICS.ANIMPOSTFX_STOP("MP_OrbitalCannon")
		CAM.RENDER_SCRIPT_CAMS(false, false, 3000, true, false, 0)
		CAM.SET_CAM_ACTIVE(cam, false)
		CAM.DESTROY_CAM(cam, false)
		HUD.DISPLAY_RADAR(true)
		STREAMING.CLEAR_FOCUS()
		GRAPHICS.CLEAR_DRAW_ORIGIN()
		wait(600)
		CAM.DO_SCREEN_FADE_IN(0)
		menu.trigger_commands('becomeorbitalcannon off')
	end)
	
		-------------------------------------
	-- RAIN ROCKETS
	-------------------------------------

	local function rain_rockets(pid, owned)
		local user_ped = PLAYER.PLAYER_PED_ID()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local owner
		local hash = joaat("weapon_airstrike_rocket")
		if not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) then
			WEAPON.REQUEST_WEAPON_ASSET(hash, 31, 0)
		end
		pos.x = pos.x + math.random(-6,6)
		pos.y = pos.y + math.random(-6,6)
		local ground_ptr = alloc(32); MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false); pos.z = memory.read_float(ground_ptr); memory.free(ground_ptr)
		if owned then owner = user_ped else owner = 0 end
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+50, pos.x, pos.y, pos.z, 200, true, hash, owner, true, false, 2500.0)
	end

	menu.toggle_loop(explo_settings, menuname('Trolling', 'Rain Rockets (owned)'), {'ownedrockets'}, '', function()
		rain_rockets(pid, true)
		wait(500)
	end)

	menu.toggle_loop(explo_settings, menuname('Trolling', 'Rain Rockets'), {'rockets'}, '', function()
		rain_rockets(pid, false)
		wait(500)
	end)

	menu.toggle_loop(explo_settings, menuname('Trolling', 'Water Loop'), {'waterloop'}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		pos.z = pos.z - 1.0
		FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 13, 1.0, true, false, 0, false)
	end)

	menu.toggle_loop(explo_settings, menuname('Trolling', 'Flame Loop'), {'flameloop'}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		pos.z = pos.z - 1.0
		FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 12, 1.0, true, false, 0, false)
	end)	
	-------------------------------------
	-- SHAKE CAMERA
	-------------------------------------

	menu.toggle_loop(explode, menuname('Trolling', 'Shake Camera'), {'shake'}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(), pos.x, pos.y, pos.z, 0, 0, false, true, 80)
		wait(150)
	end)
	
	-------------------------------------
	-- NET FORCEFIELD
	-------------------------------------

	local items = {'Disable', 'Push Out', 'Destroy'}
	local current_forcefield
	local forcefield = menu.list(trolling_list, menuname('Forcefield', 'Forcefield') .. ': ' .. menuname('Forcefield', items[ 1 ]) ) 

	for i, item in ipairs(items) do
		menu.action(forcefield, menuname('Forcefield', item), {}, '', function()
			current_forcefield = i
			menu.set_menu_name(forcefield, menuname('Forcefield', 'Forcefield') .. ': ' .. menuname('Forcefield', item) )
			menu.focus(forcefield)
		end)
	end

	create_tick_handler(function()
		if current_forcefield == 1 then
			return true
		elseif current_forcefield == 2 then
			local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local pos1 = ENTITY.GET_ENTITY_COORDS(player_ped)
			local entities = GET_NEARBY_ENTITIES(pid, 10)
			
			for _, entity in ipairs(entities) do
				local pos2 = ENTITY.GET_ENTITY_COORDS(entity)
				local force = vect.norm(vect.subtract(pos2, pos1))
				if ENTITY.IS_ENTITY_A_PED(entity)  then
					if not PED.IS_PED_A_PLAYER(entity) and not PED.IS_PED_IN_ANY_VEHICLE(entity, true) then
						REQUEST_CONTROL(entity)
						PED.SET_PED_TO_RAGDOLL(entity, 1000, 1000, 0, 0, 0, 0)
						ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
					end
				else
					REQUEST_CONTROL(entity)
					ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
				end
			end
		elseif current_forcefield == 3 then
			local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
			FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 29, 5.0, false, true, 0.0, true)
		end
		return true
	end)

	-------------------------------------
	-- CREEPER CLOWN
	-------------------------------------

	menu.action(trolling_list, menuname('Trolling', 'Creeper Clown'), {}, '', function()
		local hash = joaat("s_m_y_clown_01")
		local explosion = {
			asset 	= "scr_rcbarry2",
			name 	= "scr_exp_clown"
		}
		local appears = {
			asset 	= "scr_rcbarry2",
			name 	= "scr_clown_appears"
		}

		AUDIO.REQUEST_SCRIPT_AUDIO_BANK("BARRY_02_CLOWN_A", false, -1)
		AUDIO.REQUEST_SCRIPT_AUDIO_BANK("BARRY_02_CLOWN_B", false, -1)
		AUDIO.REQUEST_SCRIPT_AUDIO_BANK("BARRY_02_CLOWN_C", false, -1)

		REQUEST_MODELS(hash)
		local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player)
		local theta = ( math.random() + math.random(0, 1) ) * math.pi
		local coord = vect.new(
			pos.x + 7.0 * math.cos(theta),
			pos.y + 7.0 * math.sin(theta),
			pos.z - 1.0
		)
		local ped = entities.create_ped(0, hash, coord, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	
		REQUEST_PTFX_ASSET(appears.asset)
		GRAPHICS.USE_PARTICLE_FX_ASSET(appears.asset)
		GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(appears.name, ped, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.5, false, false, false, false)
		SET_ENT_FACE_ENT(ped, player)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true) 
		
		TASK.TASK_GO_TO_COORD_ANY_MEANS(ped, pos.x, pos.y, pos.z, 5.0, 0, 0, 0, 0)
		local dest = pos
		PED.SET_PED_KEEP_TASK(ped, true)
		AUDIO.STOP_PED_SPEAKING(ped, true)
		AUDIO.SET_AMBIENT_VOICE_NAME(ped, "CLOWNS")
		
		create_tick_handler(function()
			local pos = ENTITY.GET_ENTITY_COORDS(ped)
			local ppos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))

			if vect.dist(pos, ppos) < 3.0 then
				REQUEST_PTFX_ASSET(explosion.asset)
				GRAPHICS.USE_PARTICLE_FX_ASSET(explosion.asset)
				GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
					explosion.name, 
					pos.x, 
					pos.y, 
					pos.z, 
					0.0, 
					0.0, 
					0.0, 
					1.0, 
					false, false, false, false
				)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 0, 1.0, true, true, 1.0)
				ENTITY.SET_ENTITY_VISIBLE(ped, false, 0)

				return false
			elseif vect.dist(ppos, dest) > 3 then
				dest = ppos
				TASK.TASK_GO_TO_COORD_ANY_MEANS(ped, ppos.x, ppos.y, ppos.z, 5.0, 0, 0, 0, 0)
			end
			return true
		end)

		AUDIO.RELEASE_NAMED_SCRIPT_AUDIO_BANK("BARRY_02_CLOWN_A")
		AUDIO.RELEASE_NAMED_SCRIPT_AUDIO_BANK("BARRY_02_CLOWN_B")
		AUDIO.RELEASE_NAMED_SCRIPT_AUDIO_BANK("BARRY_02_CLOWN_C")
	end)
	-------------------------------------
	-- CAGE OPTIONS
	-------------------------------------

	local cage_options = menu.list(trolling_list, menuname('Trolling', 'Cage'), {}, '')
	
	menu.divider(cage_options, menuname('Trolling', 'Cage'))

	menu.action(cage_options, menuname('Trolling - Cage', 'Small'), {'smallcage'}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
		if PED.IS_PED_IN_ANY_VEHICLE(p) then return end
		trapcage(pid)
	end) 
	
	menu.action(cage_options, menuname('Trolling - Cage', 'Tall'), {'tallcage'}, '', function()
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
		if PED.IS_PED_IN_ANY_VEHICLE(p) then return end
		trapcage_2(pid)
	end)
	-------------------------------------
	-- AUTOMATIC
	-------------------------------------

	-- 1) traps the player in cage
	-- 2) gets the position of the cage
	-- 3) if the current player position is 4 m far from the cage, another one is created.
	menu.toggle(cage_options, menuname('Trolling - Cage', 'Automatic'), {'autocage'}, '', function(toggle)
		cage_loop = toggle
		local a
		while cage_loop do
			wait(1000)
			local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local b = ENTITY.GET_ENTITY_COORDS(p)
			if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then break end
			if a == nil or vect.dist(a, b) >= 4 then
				TASK.CLEAR_PED_TASKS_IMMEDIATELY(p)
				if PED.IS_PED_IN_ANY_VEHICLE(p, false) then return end
				a = b
				trapcage(pid)
				notification.normal('<C>' .. PLAYER.GET_PLAYER_NAME(pid) .. '</C> ' .. 'was out of the cage')
			end
		end
	end)

	-------------------------------------
	-- FENCE
	-------------------------------------

	menu.action(cage_options, menuname('Trolling - Cage', 'Fence'), {'fence'}, '', function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local object_hash = joaat("prop_fnclink_03e")
		pos.z = pos.z - 1.0
		REQUEST_MODELS(object_hash)
		local object = {}
		object[1] = OBJECT.CREATE_OBJECT(object_hash, pos.x - 1.5, pos.y + 1.5, pos.z, true, true, true) 																			
		object[2] = OBJECT.CREATE_OBJECT(object_hash, pos.x - 1.5, pos.y - 1.5, pos.z, true, true, true)
		
		object[3] = OBJECT.CREATE_OBJECT(object_hash, pos.x + 1.5, pos.y + 1.5, pos.z, true, true, true) 	
		local rot_3  = ENTITY.GET_ENTITY_ROTATION(object[3])
		rot_3.z = -90
		ENTITY.SET_ENTITY_ROTATION(object[3], rot_3.x, rot_3.y, rot_3.z, 1, true)
		
		object[4] = OBJECT.CREATE_OBJECT(object_hash, pos.x - 1.5, pos.y + 1.5, pos.z, true, true, true) 	
		local rot_4  = ENTITY.GET_ENTITY_ROTATION(object[4])
		rot_4.z = -90
		ENTITY.SET_ENTITY_ROTATION(object[4], rot_4.x, rot_4.y, rot_4.z, 1, true)
		
		for key, obj in pairs(object) do
			ENTITY.FREEZE_ENTITY_POSITION(obj, true)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(object_hash)
	end)

	-------------------------------------
	-- STUNT TUBE
	-------------------------------------

	menu.action(cage_options, menuname('Trolling - Cage', 'Stunt Tube'), {'stunttube'}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat("stt_prop_stunt_tube_s")
		REQUEST_MODELS(hash)
		local obj = OBJECT.CREATE_OBJECT(hash, pos.x, pos.y, pos.z, true, true, false)
		local rot = ENTITY.GET_ENTITY_ROTATION(obj)
		ENTITY.SET_ENTITY_ROTATION(obj, rot.x, 90.0, rot.z, 1, true)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
	end)

	-------------------------------------
	-- RAPE
	-------------------------------------

	busted(menu.toggle, cage_options, menuname('Trolling', 'Rape'), {}, menuname('Help', 'Busted feature'), function(toggle)
		rape = toggle
		if pid == PLAYER.PLAYER_ID() then return end		
		if rape then
			piggyback = false
			local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local pos = ENTITY.GET_ENTITY_COORDS(p, false)
			STREAMING.REQUEST_ANIM_DICT("rcmpaparazzo_2")
			while not STREAMING.HAS_ANIM_DICT_LOADED("rcmpaparazzo_2") do
				wait()
			end
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "rcmpaparazzo_2", "shag_loop_a", 8, -8, -1, 1, 0, false, false, false)
			ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), p, 0, 0, -0.3, 0, 0, 0, 0, false, true, false, false, 0, true)
			while rape do
				wait()
				if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then
					rape = false
				end
			end
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
			ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), true, false)
		end
	end)

	-------------------------------------
	-- HOSTILE PEDS
	-------------------------------------

	menu.action(trolling_list, menuname('Trolling', 'Hostile Peds'), {'hostilepeds'}, menuname('Help', 'All on foot peds will combat player.'), function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		for _, ped in ipairs(GET_NEARBY_PEDS(pid, 90)) do
			if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_A_PLAYER(ped) then
				local weapon = random(weapons)
				REQUEST_CONTROL_LOOP(ped)
				TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
				PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
				PED.SET_PED_MAX_HEALTH(ped, 300)
				ENTITY.SET_ENTITY_HEALTH(ped, 300)
				WEAPON.GIVE_WEAPON_TO_PED(ped, joaat(weapon), -1, false, true)
				TASK.TASK_COMBAT_PED(ped, player_ped, 0, 0)
				WEAPON.SET_PED_DROPS_WEAPONS_WHEN_DEAD(ped, false)
				relationship:hostile(ped)
			end
		end
	end)

	-------------------------------------
	-- RAM PLAYER
	-------------------------------------

	menu.click_slider(trolly_vehicles, menuname('Trolling', 'Ram Player'), {'ram'}, '', 1, 3, 1, 1, function(value)
		local vehicles = {"insurgent2", "phantom2", "adder"}
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local theta = (math.random() + math.random(0, 1)) * math.pi --returns a random angle between 0 and 2pi (exclusive)
		local coord = vect.new(
			pos.x + 12 * math.cos(theta),
			pos.y + 12 * math.sin(theta),
			pos.z
		)
		local veh_hash = joaat(vehicles[value])
		REQUEST_MODELS(veh_hash)
		local vehicle = entities.create_vehicle(veh_hash, coord, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		SET_ENT_FACE_ENT(vehicle, player_ped)
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 2)
		ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(vehicle, true)
		VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 100)
	end)
	-------------------------------------
	-- HOSTILE TRAFFIC--Враждебный траффик--
	-------------------------------------
--menu.action(trolly_vehicles, "Враждебный траффик", {"hostiletraffic"}, "Все автомобили наезжают на игрока", function()
menu.action(trolly_vehicles, menuname('Trolling', 'Hostile Traffic'), {'hostiletraffic'}, '', function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		for _, vehicle in ipairs(GET_NEARBY_VEHICLES(pid, 250)) do	
			if not VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1) then
				local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
				if not PED.IS_PED_A_PLAYER(driver) then 
					REQUEST_CONTROL_LOOP(driver)
					PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
					PED.SET_PED_MAX_HEALTH(driver, 300)
					ENTITY.SET_ENTITY_HEALTH(driver, 300)
					TASK.CLEAR_PED_TASKS_IMMEDIATELY(driver)
					PED.SET_PED_INTO_VEHICLE(driver, vehicle, -1)
					PED.SET_PED_COMBAT_ATTRIBUTES(driver, 46, true)
					TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
					TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, player_ped, 6, 100, 0, 0, 0, true)
				end
			end
		end
	end)

	-------------------------------------
	-- KAMIKASE
	-------------------------------------

menu.click_slider(trolly_vehicles, menuname('Trolling', 'Kamikaze'), {'kamikaze'}, '', 1, 3, 1, 1, function(value)
local planes = 
{
"lazer",
"mammatus",
"cuban800"
}
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local theta = (math.random() + math.random(0, 1)) * math.pi --returns a random angle between 0 and 2pi (exclusive)
		local coord = vect.new(
			pos.x + 20 * math.cos(theta),
			pos.y + 20 * math.sin(theta),
			pos.z + 30
		)
		local hash = joaat(planes[ value ])
		REQUEST_MODELS(hash)
		local plane = entities.create_vehicle(hash, coord, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		SET_ENT_FACE_ENT_3D(plane, player_ped)
		ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(plane, true)
		VEHICLE.SET_VEHICLE_FORWARD_SPEED(plane, 150)
		VEHICLE.CONTROL_LANDING_GEAR(plane, 3)
	end)
	-------------------------------------
	-- PIGGY BACK
	-------------------------------------

	busted(menu.toggle, trolling_list, menuname('Trolling', 'Piggy Back'), {}, menuname('Help', 'Busted feature'), function(toggle)
		if pid == players.user() then return end
		piggyback = toggle
		if piggyback then
			rape = false
			local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local tick = 0
			STREAMING.REQUEST_ANIM_DICT("rcmjosh2")
			while not STREAMING.HAS_ANIM_DICT_LOADED("rcmjosh2") do
				wait()
			end
			ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), p, PED.GET_PED_BONE_INDEX(p, 0xDD1C), 0, -0.2, 0.65, 0, 0, 180, false, true, false, false, 0, true)
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "rcmjosh2", "josh_sitting_loop", 8, -8, -1, 1, 0, false, false, false)
			while piggyback do
				wait()
				if not NETWORK.NETWORK_IS_PLAYER_CONNECTED(pid) then
					piggyback = false
				end
			end
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
			ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), true, false)
		end
	end)
	-------------------------------------
	-- DAMAGE--Выстрел в игрока
	-------------------------------------

--local damage = menu.list(trolling_list, menuname('Trolling', 'Damage'), {}, 'Choose the weapon and shoot \'em no matter where you are.')
local damage = menu.list(menu.player_root(pid), menuname('Trolling', 'Damage'), {}, '')
menu.toggle(damage, menuname('Sky_KoT', 'spectate'), {}, menuname('Help', 'Choose the weapon and shoot em no matter where you are.'), function(on)
spectate = on
if spectate then
menu.trigger_commands('spectate '..PLAYER.GET_PLAYER_NAME(pid)..' on')
else
menu.trigger_commands('spectate '..PLAYER.GET_PLAYER_NAME(pid)..' off')
end
end)

menu.divider(damage, menuname('Trolling', 'Damage'))

menu.action(damage, menuname('Trolling - Damage', 'Heavy Sniper'), {}, '', function()
		local hash = joaat("weapon_heavysniper")
		local a = CAM.GET_GAMEPLAY_CAM_COORD()
		local b = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(a.x, a.y, a.z, b.x , b.y, b.z, 200, 0, hash, PLAYER.PLAYER_PED_ID(), true, false, 2500.0)
end)
menu.action(damage, 'weapon_heavysniper_mk2', {}, '', function()
local hash = joaat("weapon_heavysniper_mk2")
local a = CAM.GET_GAMEPLAY_CAM_COORD()
local b = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), false)
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(a.x, a.y, a.z, b.x , b.y, b.z, 200, 0, hash, PLAYER.PLAYER_PED_ID(), true, false, 2500.0)
end)
menu.action(damage, menuname('Trolling - Damage', 'Firework'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat("weapon_firework")
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+3, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, menuname('Trolling - Damage', 'Up-n-Atomizer'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat("weapon_raypistol")
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+3, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, menuname('Trolling - Damage', 'Molotov'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat("weapon_molotov")
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, menuname('Trolling - Damage', 'EMP Launcher'), {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_emplauncher")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, "weapon_pumpshotgun", {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_pumpshotgun")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'weapon_heavysniper_mk2', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_heavysniper_mk2")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'weapon_rpg', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_rpg")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'weapon_grenadelauncher', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_grenadelauncher")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'weapon_railgun', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_railgun")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'weapon_hominglauncher', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_hominglauncher")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'weapon_compactlauncher', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_compactlauncher")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'weapon_rayminigun', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_rayminigun")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_PLAYER_LAZER', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_PLAYER_LAZER")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_APC_CANNON', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_APC_CANNON")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_APC_CANNON', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_APC_CANNON")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_APC_MISSILE', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_APC_MISSILE")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'DIR_FLAME', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("DIR_FLAME")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'DIR_FLAME_EXPLODE', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("DIR_FLAME_EXPLODE")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_OPPRESSOR_MISSILE', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_OPPRESSOR_MISSILE")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_KHANJALI_CANNON_HEAVY', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_KHANJALI_CANNON_HEAVY")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_CHERNO_MISSILE', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_CHERNO_MISSILE")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_ENEMY_LASER', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_ENEMY_LASER")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'VEHICLE_WEAPON_APC_MG', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("VEHICLE_WEAPON_APC_MG")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'WT_REVOLVER', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_revolver")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'WT_REVOLVER2', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_revolver_mk2")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'WT_REV_DA', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_doubleaction")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage,'WT_REV_NV', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat("weapon_navyrevolver")
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)
------------------------------------
menu.divider(damage, menuname('Sky_KoT', 'Anonimsnipe (New Ren)'), '')
--DAMAGE--Выстрел в игрока (New Ren)---------

local function REQUEST_WEAPON_ASSET(hash)
if WEAPON.HAS_WEAPON_ASSET_LOADED(hash) then
return
end
WEAPON.REQUEST_WEAPON_ASSET(hash, 31, 0)
while not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) do
wait()
end
end

menu.action(damage, menuname('Trolling - Damage', 'Firework'), {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat('weapon_firework')
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+3, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, menuname('Trolling - Damage', 'Up-n-Atomizer'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_raypistol')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+3, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, menuname('Trolling - Damage', 'Molotov'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_molotov')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, menuname('Trolling - Damage', 'EMP Launcher'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_emplauncher')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)



menu.action(damage, 'weapon_heavysnipe', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_heavysniper')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'weapon_rpg', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_rpg')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'VEHICLE_WEAPON_PLAYER_LAZER', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('VEHICLE_WEAPON_PLAYER_LAZER')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'VEHICLE_WEAPON_ENEMY_LASER', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('VEHICLE_WEAPON_ENEMY_LASER')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'weapon_heavysnipe', {}, '', function()
local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
local hash = joaat('weapon_heavysniper')
REQUEST_WEAPON_ASSET(hash)
MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'WT_REVOLVER', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_revolver')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'WT_REV_DA', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_doubleaction')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)

menu.action(damage, 'WT_REV_NV', {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = joaat('weapon_navyrevolver')
		REQUEST_WEAPON_ASSET(hash)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z, pos.x , pos.y, pos.z-2, 200, 0, hash, 0, true, false, 2500.0)
end)


    menu.action(damage, "Снайпер от меня", {"snipe"}, "Убивает игрока с вами в качестве атакующего [Не сработает, если у вас нет потерь с целью]", function(on_click)
        local owner = PLAYER.PLAYER_PED_ID()
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local target = ENTITY.GET_ENTITY_COORDS(target_ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, 300.0, true, 100416529, owner, true, false, 100.0)
    end)

    menu.action(damage, "Анонимный снайпер", {"selfsnipe"}, "Стреляет в игрока анонимно, как будто это сделал случайный прохожий", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local target = ENTITY.GET_ENTITY_COORDS(target_ped)
        local random_ped = get_random_ped()
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, 300.0, true, 100416529, random_ped, true, false, 100.0)
    end)


--[[
WT_REVOLVER = "weapon_revolver",
WT_REVOLVER2 = "weapon_revolver_mk2",
WT_REV_DA = "weapon_doubleaction",
WT_REV_NV= "weapon_navyrevolver",
--]]
-------------------------------------------------
	
	---------------------
	---------------------
	-- NET VEHICLE OPT
	---------------------
	---------------------

	local vehicleOpt = menu.list(menu.player_root(pid), menuname('Player - Vehicle', 'Vehicle'), {}, '')

	menu.divider(vehicleOpt, menuname('Player - Vehicle', 'Vehicle'))
	
	-------------------------------------
	-- TELEPORT
	-------------------------------------

	local tpvehicle = menu.list(vehicleOpt, menuname('Player - Vehicle', 'Teleport'))

	menu.divider(tpvehicle, menuname('Player - Vehicle', 'Teleport'))

	menu.action(tpvehicle, menuname('Vehicle - Teleport', 'TP to Me'), {}, '', function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), false)
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		ENTITY.SET_ENTITY_COORDS(vehicle, pos.x, pos.y, pos.z, false, false, false)
	end)

	menu.action(tpvehicle, menuname('Vehicle - Teleport', 'TP to Ocean'), {}, '', function()
		local pos = {x = -4809.93, y = -2521.67, z = 250}
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		ENTITY.SET_ENTITY_COORDS(vehicle, pos.x, pos.y, pos.z, false, false, false)
	end)

	menu.action(tpvehicle, menuname('Vehicle - Teleport', 'TP to Prision'), {}, '', function()
		local pos = {x = 1680.11, y = 2512.89, z = 45.56}
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		ENTITY.SET_ENTITY_COORDS(vehicle, pos.x, pos.y, pos.z, false, false, false)
	end)

	menu.action(tpvehicle, menuname('Vehicle - Teleport', 'TP to Fort Zancudo'), {}, '', function()
		local pos = {x = -2219.0583, y = 3213.0232, z = 32.8102}
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		ENTITY.SET_ENTITY_COORDS(vehicle, pos.x, pos.y, pos.z, false, false, false)
	end)

	menu.action(tpvehicle, menuname('Vehicle - Teleport', 'TP to Waypoint'), {}, '', function()
		local pos = GET_WAYPOINT_COORDS()
		if pos then
			local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
			if vehicle == NULL then return end
			REQUEST_CONTROL_LOOP(vehicle)
			ENTITY.SET_ENTITY_COORDS(vehicle, pos.x, pos.y, pos.z, false, false, false)
		else notification.normal('No waypoint found', NOTIFICATION_RED) end
	end)

	-------------------------------------
	-- ACROBATICS
	-------------------------------------

	local acrobatics = menu.list(vehicleOpt, menuname('Player - Vehicle', 'Acrobatics'), {}, '')

	menu.divider(acrobatics, menuname('Player - Vehicle', 'Acrobatics'))


	menu.action(acrobatics, menuname('Vehicle - Acrobatics', 'Ollie'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle ~= NULL and VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(vehicle) then
			REQUEST_CONTROL_LOOP(vehicle)
			ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, 0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
		end
	end)
	
	menu.action(acrobatics, menuname('Vehicle - Acrobatics', 'Kick Flip'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(vehicle) then
			REQUEST_CONTROL_LOOP(vehicle)
			ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, 0.0, 0.0, 10.71, 5.0, 0.0, 0.0, 1, false, true, true, true, true)
		end
	end)

	menu.action(acrobatics, menuname('Vehicle - Acrobatics', 'Double Kick Flip'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle ~= NULL and VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(vehicle) then
			REQUEST_CONTROL_LOOP(vehicle)
			ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, 0.0, 0.0, 21.43, 20.0, 0.0, 0.0, 1, false, true, true, true, true)
		end
	end)

	menu.action(acrobatics, menuname('Vehicle - Acrobatics', 'Heel Flip'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle ~= NULL and VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(vehicle) then
			REQUEST_CONTROL_LOOP(vehicle)
			ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, 0.0, 0.0, 10.71, -5.0, 0.0, 0.0, 1, false, true, true, true, true)
		end
	end)

	-------------------------------------
	-- KILL ENGINE
	-------------------------------------
	
	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Kill Engine'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, -4000)
	end)

	-------------------------------------
	-- CLEAN
	-------------------------------------
	
	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Clean'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
	end)

	-------------------------------------
	-- REPAIR
	-------------------------------------

	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Repair'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		VEHICLE.SET_VEHICLE_FIXED(vehicle)
		VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
		VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
	end)

	-------------------------------------
	-- KICK
	-------------------------------------

	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Kick'), {}, '', function()
		local param = {578856274, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
		util.trigger_script_event(1 << pid, param)
	end)
	
	-------------------------------------
	-- UPGRADE
	-------------------------------------

	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Upgrade'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		VEHICLE.SET_VEHICLE_MOD_KIT(vehicle, 0)
		for i = 0, 50 do
			VEHICLE.SET_VEHICLE_MOD(vehicle, i, VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, i) - 1, false)
		end
	end)
	
	-------------------------------------
	-- CUSTOM PAINT
	-------------------------------------

	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Apply Radom Paint'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		local primary, secundary = Colour.Random(), Colour.Random()
		VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, unpack(primary))
		VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, unpack(secundary))
	end)
	
	-------------------------------------
	-- BURST TIRES
	-------------------------------------
	
	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Burst Tires'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, true)
		for wheelId = 0, 7 do
			VEHICLE.SET_VEHICLE_TYRE_BURST(vehicle, wheelId, true, 1000.0)
		end
	end)

	-------------------------------------
	-- CATAPULT
	-------------------------------------
	
	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Catapult'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle ~= NULL and VEHICLE.IS_VEHICLE_ON_ALL_WHEELS(vehicle) then
			REQUEST_CONTROL_LOOP(vehicle)
			ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, 0.0, 0.0, 9999, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
		end	
	end)

	-------------------------------------
	-- BOOST FORWARD
	-------------------------------------
	
	menu.action(vehicleOpt, menuname('Player - Vehicle', 'Boost Forward'), {}, '', function()
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		local unitv = ENTITY.GET_ENTITY_FORWARD_VECTOR(vehicle)
		local force = vect.mult(unitv, 40)
		AUDIO.SET_VEHICLE_BOOST_ACTIVE(vehicle, true)
		ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0.0, 0.0, 0.0, 1, false, true, true, true, true)
		AUDIO.SET_VEHICLE_BOOST_ACTIVE(vehicle, false)
	end)

	-------------------------------------
	-- LICENSE PLATE
	-------------------------------------

	menu.text_input(vehicleOpt, menuname('Player - Vehicle', 'Set License Plate'), {'setplatetxt'}, 'MAX 8 characters', function(strg)
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL or strg == '' then return end
		REQUEST_CONTROL_LOOP(vehicle)
		while #strg > 8 do -- reduces the length of string till it's 8 characters long
			wait()
			strg = string.gsub(strg, '.$', '')
		end
		VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(vehicle, strg)
	end)

	-------------------------------------
	-- GOD MODE
	-------------------------------------
	
	menu.toggle(vehicleOpt, menuname('Player - Vehicle', 'God Mode'), {}, '', function(toggle)
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		if toggle then
			VEHICLE.SET_VEHICLE_ENVEFF_SCALE(vehicle, 0.0)
			VEHICLE.SET_VEHICLE_BODY_HEALTH(vehicle, 1000.0)
			VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, 1000.0)
			VEHICLE.SET_VEHICLE_FIXED(vehicle)
			VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
			VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(vehicle, 1000.0)
			VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
			if VEHICLE._IS_VEHICLE_DAMAGED(vehicle) then
				for i = 0, 10 do
					VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle, i)
				end
			end
		end
		ENTITY.SET_ENTITY_INVINCIBLE(vehicle, toggle)
		ENTITY.SET_ENTITY_PROOFS(vehicle, toggle, toggle, toggle, toggle, toggle, toggle, 1, toggle)
		VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_DAMAGE(vehicle, toggle)
		VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_FIRES(vehicle, toggle)
		VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(vehicle, not toggle)
		VEHICLE.SET_VEHICLE_CAN_BREAK(vehicle, not toggle)
		VEHICLE.SET_VEHICLE_ENGINE_CAN_DEGRADE(vehicle, not toggle)
		VEHICLE.SET_VEHICLE_EXPLODES_ON_HIGH_EXPLOSION_DAMAGE(vehicle, not toggle)
		VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, not toggle)
		VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK(vehicle, not toggle)
	end)

	-------------------------------------
	-- INVISIBLE
	-------------------------------------

	menu.toggle(vehicleOpt, menuname('Player - Vehicle', 'Invisible'), {}, '', function(toggle)
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		ENTITY.SET_ENTITY_VISIBLE(vehicle, not toggle, false)
	end)

	-------------------------------------
	-- FREEZE
	-------------------------------------

	menu.toggle(vehicleOpt, menuname('Player - Vehicle', 'Freeze'), {}, '', function(toggle)
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		ENTITY.FREEZE_ENTITY_POSITION(vehicle, toggle)
	end)

	-------------------------------------
	-- LOCK DOORS
	-------------------------------------

	menu.toggle(vehicleOpt, menuname('Player - Vehicle', 'Child Lock'), {}, '', function(toggle)
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(pid)
		if vehicle == NULL then return end
		REQUEST_CONTROL_LOOP(vehicle)
		if toggle then
			VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 4)
		else
			VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 1)
		end
	end)

	---------------------
	---------------------
	-- FRIENDLY
	---------------------
	---------------------

	local friendly_list = menu.list(menu.player_root(pid), menuname('Player', 'Friendly Options'), {}, '')
	
	menu.divider(friendly_list, menuname('Player', 'Friendly Options'))

	-------------------------------------
	-- KILL KILLERS
	-------------------------------------

	menu.toggle_loop(friendly_list, menuname('Friendly Options', 'Kill Killers'), {'explokillers'}, menuname('Help', 'Explodes the players murderer.'), function(toggle)
		local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local killer = PED.GET_PED_SOURCE_OF_DEATH(p)
		if ENTITY.DOES_ENTITY_EXIST(killer) and not ENTITY.IS_ENTITY_DEAD(killer) and killer ~= p then
			local pos = ENTITY.GET_ENTITY_COORDS(killer, false)
			FIRE.ADD_OWNED_EXPLOSION(p, pos.x, pos.y, pos.z, 1, 1.0, true, false, 1)
			while not ENTITY.IS_ENTITY_DEAD(p) do
				wait()
			end
		end
	end)

menu.action(friendly_list, "Lock GR Mission", {}, ".", function()
write_global.int(2549745 + 884, 1)
--memory.write_int(memory.script_global(2549745),glvalgr)
end)

local lock_gl = false
menu.toggle(friendly_list, "Lock Global 1", {"lockgl1"}, "",
    function(state)
        lock_gl = state
        while lock_gl do
            memory.write_int(memory.script_global(Glintf1),glvalint1)
            util.yield()
        end
    end
)
--memory.write_int(memory.script_global(Glintf1),glvalint1)
--memory.write_int(memory.script_global(Glintf1),glvalint1)
--memory.write_int(memory.script_global(2549745),glvalgr)
-- util.yield()

menu.action(friendly_list, "Request Ballistic Loadout", {}, ".", function()
--menu.action(self_options, menuname('Self', 'Instant Bullshark'), {}, 'For those who prefer a non toggle based option.', function()
	write_global.int(2544210 + 884, 1)
end)
--menu.action(friendly_list, "Radout", {}, ".", function()
--write_global.int(("[[[[[[[WorldPTR]+8]+30]+10]+20]+70]+0]+2C")
--end)

local planes = {
        'besra',
        'dodo',
        'avenger',
        'microlight',
        'molotov',
        'starling',
        'bombishka',
        'howard',
        'duster',
        'luxor2',
        'lazer',
        'nimbus',
        'shamal',
        'stunt',
        'titan',
        'velum2',
        'milijet',
        'mamatus',
        'besra',
        'cuban800',
        'saebreeze'
    }
menu.toggle(friendly_list, menuname('World', 'Angry Planes'), {}, '', function(toggle)
--menu.toggle(friendly_list, "Angry Planes", {"angryplanes"}, "", function(on)
--menu.toggle(trolling_list, menuname('World', 'Angry Planes'), {}, '', function(toggle)
        angryplanes = toggle
        local spawned = {}
    
	create_tick_handler(function()
                for k, plane in pairs(spawned) do
                    if ENTITY.IS_ENTITY_DEAD(plane.plane) then
                        spawned[ k ] = nil
                    end
                end
		return angryplanes
        end)
    
        while angryplanes do
            wait(1000)
            if #spawned < 40 then
                local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
                local theta = (math.random() + math.random(0, 1)) * math.pi --returns a random angle between 0 and 2pi (exclusive)
                local radius = math.random(50, 150)
                pos = vect.new(
                    pos.x + radius * math.cos(theta),
                    pos.y + radius * math.sin(theta),
                    pos.z + 200
                )
                local jet_hash = joaat(random(planes))
                local ped_hash = joaat('s_m_y_blackops_01')
    
                STREAMING.REQUEST_MODEL(jet_hash); STREAMING.REQUEST_MODEL(ped_hash)
                while not STREAMING.HAS_MODEL_LOADED(jet_hash) and not STREAMING.HAS_MODEL_LOADED(ped_hash) do
                    wait()
                end
                local jet = entities.create_vehicle(jet_hash, pos, math.deg(theta))
                if jet ~= 0 then
                    local pilot = entities.create_ped(5, ped_hash, pos, math.deg(theta))
                    table.insert(spawned, {['plane'] = jet, ['pilot'] = pilot})
                    PED.SET_PED_INTO_VEHICLE(pilot, jet, -1)
                    VEHICLE._SET_VEHICLE_JET_ENGINE_ON(jet, true)
                    VEHICLE.SET_VEHICLE_FORWARD_SPEED(jet, 60)
                    VEHICLE.SET_HELI_BLADES_FULL_SPEED(jet)
                    VEHICLE.CONTROL_LANDING_GEAR(jet, 3)
                    VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(jet, true)
                    TASK.TASK_PLANE_MISSION(pilot, jet, 0, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0, 0, 6, 100, 0, 0, 80, 50)
                    PED.SET_PED_COMBAT_ATTRIBUTES(pilot, 1, true)
                end
            end
        end
    
	for k, plane in pairs(spawned) do
		entities.delete_by_handle(plane.plane)
		entities.delete_by_handle(plane.pilot)
	end
end)

--Сетевые события---
local event = menu.list(menu.player_root(pid), "Сетевые события", {}, "")
--script event -621279188

menu.action(event, 'Отправить репорт Эксплоиты', {}, '', function()
local param = {-1619412469, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'Отправить на остров', {}, '', function()
local param = {-621279188, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

--menu.toggle(event, "Отправить на остров цикл", {}, "", function(on)
--local param = {-621279188, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
--util.trigger_script_event(1 << pid, param)
--end)

menu.action(event, 'Ошибка транзакции', {}, '', function()
local param = {-1704141512, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'Видеосцена Лестер ', {}, 'Начало ограбы в казино, встреча в парке', function()
local param = {1068259786, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'Спам звуками ', {}, '', function()
local param = {1132878564, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.toggle(event, "Спам звуками цикл", {}, "", function(on_toggle)
if on_toggle then
local param = {1132878564, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
else
local param = {1132878564, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
        end
    end)

menu.action(event, 'Bounty', {}, '', function()
local param = {1294995624, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'CeoBan', {}, '', function()
local param = {-764524031, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'CeoKick', {}, '', function()
local param = {248967238, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'CeoMoney', {}, '', function()
local param = {1890277845, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'ClearWantedLevel', {}, '', function()
local param = {-91354030, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'FakeDeposit', {}, 'Начало ограбы в казино, встреча в парке', function()
local param = {677240627, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'ForceMission', {}, '', function()
local param = {2020588206, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'GtaBanner', {}, '', function()
local param = {1572255940, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'PersonalVehicleDestroyed', {}, '', function()
local param = {802133775, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'RemoteOffradar', {}, '', function()
local param = {-391633760, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'RotateCam', {}, 'RotateCam', function()
local param = {801199324, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'Spectate', {}, '   ', function()
local param = {-1113591308, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'Teleport', {}, '', function()
local param = {603406648, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'TransactionError', {}, '   ', function()
local param = {-1704141512, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)

menu.action(event, 'VehicleKick', {}, '', function()
local param = {578856274, PLAYER.PLAYER_ID(), 0, 0, 0, 0, 1, PLAYER.PLAYER_ID(), MISC.GET_FRAME_COUNT()}
util.trigger_script_event(1 << pid, param)
end)


-- end of generate_features
end

local defaulthealth = ENTITY.GET_ENTITY_MAX_HEALTH(PLAYER.PLAYER_PED_ID())
local modded_health = defaulthealth

---------------------
---------------------
-- SELF
---------------------
---------------------

local self_options = menu.list(menu.my_root(), menuname('Self', 'Self'), {'selfoptions'}, '')
local health = menu.list(self_options, menuname('Sky_KoT', 'Health'))
-------------------------------------
-- HEALTH OPTIONS
-------------------------------------

menu.toggle(health, menuname('Self', 'Mod Max Health'), {'modhealth'}, menuname('Help', 'Changes your ped\'s max health. Some menus will tag you as modder. It returns to default max health when it\'s disabled.'), function(toggle)
	modhealth  = toggle
	if modhealth then
		local user = PLAYER.PLAYER_PED_ID()
		PED.SET_PED_MAX_HEALTH(user,  modded_health)
		ENTITY.SET_ENTITY_HEALTH(user, modded_health)
	else
		local user = PLAYER.PLAYER_PED_ID()
		PED.SET_PED_MAX_HEALTH(user, defaulthealth)
		menu.trigger_commands('moddedhealth ' .. defaulthealth) -- just if you want the slider to go to default value when mod health is off
		if ENTITY.GET_ENTITY_HEALTH(user) > defaulthealth then 
			ENTITY.SET_ENTITY_HEALTH(user, defaulthealth)
		end
	end
	create_tick_handler(function()
		if PED.GET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID()) ~= modded_health  then
			PED.SET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID(), modded_health)
			ENTITY.SET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID(), modded_health)	
		end
		if config.general.displayhealth then
			local strg = '~b~' .. 'HEALTH ' .. '~w~' .. tostring(ENTITY.GET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID()))
			DRAW_STRING(strg, config.healthtxtpos.x, config.healthtxtpos.y, 0.6, 4)	
		end
		return modhealth
	end)
end)

menu.slider(health, menuname('Self', 'Set Max Health'), {'moddedhealth'}, menuname('Help', 'Health will be modded with the given value.'), 100, 9000,defaulthealth,50, function(value)
	modded_health = value
end)

menu.action(health, menuname('Self', 'Refill Health'), {'maxhealth'}, '', function()
	ENTITY.SET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID(), PED.GET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID()))
end)

menu.action(health, menuname('Self', 'Refill Armour'), {'maxarmour'}, '', function()
	if util.is_session_started() then
		PED.SET_PED_ARMOUR(PLAYER.PLAYER_PED_ID(), 50)
	else
		PED.SET_PED_ARMOUR(PLAYER.PLAYER_PED_ID(), 100)
	end
end)

menu.toggle(health, menuname('Self', 'Refill Health in Cover'), {'healincover'}, '', function(toggle)
	refillincover = toggle
	while refillincover do
		if PED.IS_PED_IN_COVER(PLAYER.PLAYER_PED_ID()) then
			PLAYER._SET_PLAYER_HEALTH_RECHARGE_LIMIT(players.user(), 1)
			PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 15)
		else
			PLAYER._SET_PLAYER_HEALTH_RECHARGE_LIMIT(players.user(), 0.5)
			PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 1)
		end
		wait()
	end
	if not refillincover then
		PLAYER._SET_PLAYER_HEALTH_RECHARGE_LIMIT(players.user(), 0.25)
		PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 1)
	end
end)

menu.action(health, menuname('Self', 'Instant Bullshark'), {}, menuname('Help', 'For those who prefer a non toggle based option.'), function()
	write_global.int(2703656 + 3590, 1)
end)

-------------------------------------
-- FORCEFIELD
-------------------------------------
local superhero = menu.list(self_options, menuname('Sky_KoT', 'Superhero'))

local items = {'Disable', 'Push Out', 'Destroy'}
local current_forcefield
local forcefield = menu.list(superhero, menuname('Forcefield', 'Forcefield') .. ': ' .. menuname('Forcefield', items[ 1 ]) ) 

for i, item in ipairs(items) do
	menu.action(forcefield, menuname('Forcefield', item), {}, '', function()
		current_forcefield = i
		menu.set_menu_name(forcefield, menuname('Forcefield', 'Forcefield') .. ': ' .. menuname('Forcefield', item) )
		menu.focus(forcefield)
	end)
end

create_tick_handler(function()
	if current_forcefield == 1 then
		return true
	elseif current_forcefield == 2 then
		local pos1 = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
		local entities = GET_NEARBY_ENTITIES(PLAYER.PLAYER_ID(), 10)
		for k, entity in pairs(entities) do
			local pos2 = ENTITY.GET_ENTITY_COORDS(entity)
			local force = vect.norm(vect.subtract(pos2, pos1))
			if ENTITY.IS_ENTITY_A_PED(entity)  then
				if not PED.IS_PED_A_PLAYER(entity) and not PED.IS_PED_IN_ANY_VEHICLE(entity, true) then
					REQUEST_CONTROL(entity)
					PED.SET_PED_TO_RAGDOLL(entity, 1000, 1000, 0, 0, 0, 0)
					ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
				end
			else
				REQUEST_CONTROL(entity)
				ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
			end
		end
	elseif current_forcefield == 3 then
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
		proofs.explosion = true
		FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 29, 5.0, false, true, 0.0, true)
	end
	return true
end)

-------------------------------------
-- FORCE
-------------------------------------

menu.toggle(superhero, menuname('Self', 'Force'), {'jedimode'}, menuname('Help', 'Use Force in nearby vehicles.'), function(toggle)
	force = toggle	
	if force then
		notification.help(		
menuname('Notification', 'Press ') .. "~INPUT_VEH_FLY_SELECT_TARGET_RIGHT~ " .. menuname('Notification', 'and ') ..
"~INPUT_VEH_FLY_ROLL_RIGHT_ONLY~ " .. menuname('Notification', 'to use Force.')
)
		local user_ped = PLAYER.PLAYER_PED_ID()
		local pos = ENTITY.GET_ENTITY_COORDS(user_ped)
		util.create_thread(function()
			local effect = {asset	= "scr_ie_tw", name	= "scr_impexp_tw_take_zone"}
			local colour = Colour.New(0.5, 0, 0.5)
			
			REQUEST_PTFX_ASSET(effect.asset)
			GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
			GRAPHICS.SET_PARTICLE_FX_NON_LOOPED_COLOUR(colour.r, colour.g, colour.b)
			GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(
				effect.name, 
				user_ped, 
				0.0, 
				0.0, 
				-0.9, 
				0.0, 
				0.0, 
				0.0, 
				1.0, 
				false, false, false
			)
		end)
	end
	while force do
		wait()
		local entities = GET_NEARBY_VEHICLES(players.user(), 50)
		if PAD.IS_CONTROL_PRESSED(0, 118) then
			for k, entity in pairs(entities) do
				REQUEST_CONTROL(entity)
				ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, 0, 0, 0.5, 0, 0, 0, 0, false, false, true)
			end
		end
		if PAD.IS_CONTROL_PRESSED(0, 109) then
			for k, entity in pairs(entities) do
				REQUEST_CONTROL(entity)
				ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, 0, 0, -70, 0, 0, 0, 0, false, false, true)
			end
		end
	end
end)

-------------------------------------
-- CARPET RIDE
-------------------------------------

local object
menu.toggle(superhero, menuname('Self', 'Carpet Ride'), {'carpetride'}, '', function(toggle)
	carpetride = toggle
	local hspeed = 0.2
	local vspeed = 0.2
	local user_ped = PLAYER.PLAYER_PED_ID()
	local pos = ENTITY.GET_ENTITY_COORDS(user_ped)
	local object_hash = joaat("p_cs_beachtowel_01_s")
	
	if carpetride then
		STREAMING.REQUEST_ANIM_DICT("rcmcollect_paperleadinout@")
		REQUEST_MODELS(object_hash)
		TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
		object = OBJECT.CREATE_OBJECT(object_hash, pos.x, pos.y, pos.z, true, true, true)
		ENTITY.ATTACH_ENTITY_TO_ENTITY(user_ped, object, 0, 0, -0.2, 1.0, 0, 0, 0, false, true, false, false, 0, true)
		ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(object, false, false)

		TASK.TASK_PLAY_ANIM(user_ped, "rcmcollect_paperleadinout@", "meditiate_idle", 8, -8, -1, 1, 0, false, false, false)
notification.help
(
--[[
--]]
menuname('Notification', 'Press ') .. "~INPUT_MOVE_UP_ONLY~ " .. "~INPUT_MOVE_DOWN_ONLY~ " .. "~INPUT_VEH_JUMP~ " .. "~INPUT_DUCK~ " .. menuname('Notification', 'to use Carpet Ride.') ..
menuname('Notification', 'Press ')  .. "~INPUT_VEH_MOVE_UP_ONLY~ " .. menuname('Notification', 'to move faster')

)
		local height = ENTITY.GET_ENTITY_COORDS(object, false).z
		
		while carpetride do
			wait()
			HUD.DISPLAY_SNIPER_SCOPE_THIS_FRAME()
			local obj_pos = ENTITY.GET_ENTITY_COORDS(object)
			local camrot = CAM.GET_GAMEPLAY_CAM_ROT(0)
			ENTITY.SET_ENTITY_ROTATION(object, 0, 0, camrot.z, 0, true)
			local forward = ENTITY.GET_ENTITY_FORWARD_VECTOR(user_ped)
			if PAD.IS_CONTROL_PRESSED(0, 32) then
				if PAD.IS_CONTROL_PRESSED(0, 102) then 
					height = height + vspeed 
				end
				if PAD.IS_CONTROL_PRESSED(0, 36) then 
					height = height - vspeed 
				end
				ENTITY.SET_ENTITY_COORDS(object, obj_pos.x + forward.x * hspeed, obj_pos.y + forward.y * hspeed, height, false, false, false, false)
			elseif PAD.IS_CONTROL_PRESSED(0, 130) then
				  ENTITY.SET_ENTITY_COORDS(object, obj_pos.x - forward.x * hspeed, obj_pos.y - forward.y * hspeed, height, false, false, false, false)
			else
				 if PAD.IS_CONTROL_PRESSED(0, 102) then
					ENTITY.SET_ENTITY_COORDS(object, obj_pos.x, obj_pos.y, height, false, false, false, false)
					height = height + vspeed
				elseif PAD.IS_CONTROL_PRESSED(0, 36) then
					ENTITY.SET_ENTITY_COORDS(object, obj_pos.x, obj_pos.y, height, false, false, false, false)
					height = height - vspeed
				end
			end
			   if PAD.IS_CONTROL_PRESSED(0, 61) then
				hspeed, vspeed = 1.5, 1.5
			else
				hspeed, vspeed = 0.2, 0.2
			end
		end
	else
		TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
		ENTITY.DETACH_ENTITY(user_ped, true, false)
		ENTITY.SET_ENTITY_VISIBLE(object, false)
		entities.delete_by_handle(object)
	end
end)

menu.toggle_loop(superhero, menuname('Sky_KoT', 'Godfinger'), {'Godfinger'}, menuname('Sky_KoT', 'Use Godfinger entities away from you while you point at them. Press B to start pointing.'),function()
    if read_global.int(4516656 + 930) == 3 then
        local hit, pos, nsurface, entity = RAYCAST(nil --[[camera]], 100 --[[distance]], 26--[[flags]])
        write_global.int(4516656 + 935, NETWORK.GET_NETWORK_TIME()) -- could be here
        if hit == 1 and entity and entity ~= NULL then
            draw_box_esp(entity, Colour.New(255, 0, 0))
            ENTITY.SET_ENTITY_PROOFS(PLAYER.PLAYER_PED_ID(), false, false, true --[[explosion proof]], false, false, false, 1, false)
            FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 29, 25.0, false, true, 0.0, true)
        end
    end
end)

-------------------------------------
-- KILL KILLERS
-------------------------------------

menu.toggle_loop(self_options, menuname('Friendly Options', 'Kill Killers'), {'explokillers'}, menuname('Help', 'Explodes the player\'s murderer.'), function(toggle)
	local p = PLAYER.PLAYER_PED_ID()
	local killer = PED.GET_PED_SOURCE_OF_DEATH(p)
	if ENTITY.DOES_ENTITY_EXIST(killer) and not ENTITY.IS_ENTITY_DEAD(killer) and killer ~= p then
		local pos = ENTITY.GET_ENTITY_COORDS(killer, false)
		FIRE.ADD_OWNED_EXPLOSION(p, pos.x, pos.y, pos.z, 1, 1.0, true, false, 1)
		while not ENTITY.IS_ENTITY_DEAD(p) do
			wait()
		end
	end
end)

-------------------------------------
-- UNDEAD OFFRADAR
-------------------------------------

menu.toggle(self_options, menuname('Self', 'Undead Offradar'), {'undeadoffradar'}, '', function(toggle)
	undead = toggle
	local user = PLAYER.PLAYER_PED_ID()
	local defaulthealth = ENTITY.GET_ENTITY_MAX_HEALTH(user)
	if undead then ENTITY.SET_ENTITY_MAX_HEALTH(user, 0) end
	while undead do
		wait()
		if ENTITY.GET_ENTITY_MAX_HEALTH(user) ~= 0 then
			ENTITY.SET_ENTITY_MAX_HEALTH(user, 0)
		end
	end
	ENTITY.SET_ENTITY_MAX_HEALTH(user, defaulthealth)
end)

-------------------------------------
-- TRAILS
-------------------------------------

local bones = {
	0x49D9,	-- left hand
	0xDEAD,	-- right hand
	0x3779,	-- left foot
	0xCC4D	-- right foot
}
local trails_colour = Colour.New(1.0, 0, 1.0)
local trails_options = menu.list(self_options, menuname('Self', 'Trails'))

menu.toggle(trails_options, menuname('Self - Trails', 'Trails'), {'toggletrails'}, '', function(toggle)
	trails = toggle
	local lastvehicle
	local minimum, maximum
	local effect = {asset = "scr_rcpaparazzo1", name = "scr_mich4_firework_sparkle_spawn"}
	local effects = {}
	REQUEST_PTFX_ASSET(effect.asset)
	create_tick_handler(function()	
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
		if vehicle == NULL then
			for _, boneId in ipairs(bones) do
				GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
				local fx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE(
					effect.name, 
					PLAYER.PLAYER_PED_ID(), 
					0.0, 
					0.0, 
					0.0, 
					0.0, 
					0.0, 
					0.0, 
					PED.GET_PED_BONE_INDEX(PLAYER.PLAYER_PED_ID(), boneId),
					0.7, --scale
					false, false, false
				)
				GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(
					fx, 
					trails_colour.r, 
					trails_colour.g, 
					trails_colour.b, 
					0
				)
				table.insert(effects, fx)
			end
		else
			if lastvehicle ~= vehicle then
				local minimum_ptr = alloc()
				local maximum_ptr = alloc()
				MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), minimum_ptr, maximum_ptr)
				minimum = memory.read_vector3(minimum_ptr); memory.free(minimum_ptr)
				maximum = memory.read_vector3(maximum_ptr); memory.free(maximum_ptr)
				lastvehicle = vehicle
			end

			local offsets = {
				left = vect.new(minimum.x, minimum.y), -- BACK & LEFT
				right = vect.new(maximum.x, minimum.y) -- BACK & RIGHT
			}
			for k, offset in pairs(offsets) do
				GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
				local fx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY(
					effect.name,
				 	vehicle, 
					offset.x, 
					offset.y, 
					0.0, 
					0.0, 0.0, 0.0, 
					1.0, -- scale
					false, false, false
				)
				GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(
					fx, 
					trails_colour.r, 
					trails_colour.g, 
					trails_colour.b, 
					0
				)
				table.insert(effects, fx)
			end
		end
		return trails
	end)
	
	local sTime = os.time()
	while trails do
		if os.time() - sTime == 1 then
			for i = 1, #effects do
				GRAPHICS.STOP_PARTICLE_FX_LOOPED(effects[i], 0)
				GRAPHICS.REMOVE_PARTICLE_FX(effects[i], 0)
				effects[i] = nil
			end
			sTime = os.time()
		end
		wait()
	end
	
	for k, effect in pairs(effects) do
		GRAPHICS.STOP_PARTICLE_FX_LOOPED(effect, 0)
		GRAPHICS.REMOVE_PARTICLE_FX(effect, 0)
	end
end)

menu.rainbow(menu.colour(trails_options, menuname('Self - Trails', 'Colour'), {'trailcolour'}, '', Colour.New(1.0, 0, 1.0), false, function(colour)
	trails_colour = colour
end))

-------------------------------------
-- COMBUSTION MAN
-------------------------------------

menu.toggle(superhero, menuname('Self', 'Combustion Man'), {'combustionman'}, menuname('Help', 'Shoot explosive ammo without aiming a weapon. If you think Oppressor MK2 is annoying, you haven\'t use it with this.'),function(toggle)
	shootlazer = toggle
	if shootlazer then
--notification.help("Нажмите " .. "~INPUT_ATTACK~ " .. "для выстрела.")
notification.help(menuname('Notification', 'Press ')  .. "~INPUT_ATTACK~ " .. menuname('Notification', 'to use Combustion Man.'))
		create_tick_handler(function()
			PAD.DISABLE_CONTROL_ACTION(2, 106, true) -- INPUT_VEH_MOUSE_CONTROL_OVERRIDE
			PAD.DISABLE_CONTROL_ACTION(2, 122, true) -- INPUT_VEH_FLY_MOUSE_CONTROL_OVERRIDE
			PAD.DISABLE_CONTROL_ACTION(2, 135, true) -- INPUT_VEH_SUB_MOUSE_CONTROL_OVERRIDE

			local a = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
			local b = GET_OFFSET_FROM_CAM(80)
			local hash = joaat("VEHICLE_WEAPON_PLAYER_LAZER")
			HUD.DISPLAY_SNIPER_SCOPE_THIS_FRAME()
			if not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) then
				WEAPON.REQUEST_WEAPON_ASSET(hash, 31, 26)
				while not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) do
					wait()
				end
			end
			if PAD.IS_DISABLED_CONTROL_PRESSED(2, 24) then
				MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					200,
					true,
					hash,
					PLAYER.PLAYER_PED_ID(),
					true, true, -1.0
				)
			end
			if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), true) then
				PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), true)
			end
			return shootlazer
		end)
	end
end)

-------------------------------------
-- UFO
-------------------------------------

menu.action(superhero, menuname('Vehicle', 'UFO'), {'ufo'}, menuname('UFO', 'Drive an UFO, use its tractor beam and cannon.'), function(toggle)
	if guided_missile.get_state() == -1 then
		ufo.set_state(true)
	end
end)

-------------------------------------
-- PROOFS
-------------------------------------

local menu_self_proofs = menu.list(self_options, menuname('Self', 'Player Proofs'), {}, '')

menu.divider(menu_self_proofs, menuname('Self', 'Player Proofs'))


for proof, bool in pairs_by_keys(proofs) do
	menu.toggle(menu_self_proofs, menuname('Self - Proofs', first_upper(proof)), {proof .. 'proof'}, '', function(toggle)
		proofs[ proof ] = toggle
		ENTITY.SET_ENTITY_PROOFS(PLAYER.PLAYER_PED_ID(), proofs.bullet, proofs.fire, proofs.explosion, proofs.collision, proofs.melee, proofs.steam, 1, proofs.drown)
	end)
end

create_tick_handler(function()
	if includes(proofs, true) then
		ENTITY.SET_ENTITY_PROOFS(PLAYER.PLAYER_PED_ID(), proofs.bullet, proofs.fire, proofs.explosion, proofs.collision, proofs.melee, proofs.steam, 1, proofs.drown)
	end
	return true
end)

---------------------
---------------------
-- WEAPON
---------------------
---------------------

local weapon_options = menu.list(menu.my_root(), menuname('Weapon', 'Weapon'), {'weaponoptions'}, '')

menu.divider(weapon_options, menuname('Weapon', 'Weapon'))

-------------------------------------
-- VEHICLE PAINT GUN
-------------------------------------

menu.toggle_loop(weapon_options, menuname('Weapon', 'Vehicle Paint Gun'), {'paintgun'}, menuname('Help', 'Applies a random colour combination to the damaged vehicle.'),function(toggle)
	if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
		local ptr = alloc(32); PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), ptr)
		local entity = memory.read_int(ptr); memory.free(ptr)
		
		if entity == NULL then 
			return 
		end
		
		if ENTITY.IS_ENTITY_A_PED(entity) then
			entity = PED.GET_VEHICLE_PED_IS_IN(entity, false)
		end
		if ENTITY.IS_ENTITY_A_VEHICLE(entity) then
			REQUEST_CONTROL_LOOP(entity)
			local primary, secundary = Colour.Random(), Colour.Random()
			VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(entity, unpack(primary))
			VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(entity, unpack(secundary))
		end
	end
end)

-------------------------------------
-- SHOOTING EFFECT
-------------------------------------

local effects = 
{
	-- Clown Flowers
	{
		asset 	= "scr_rcbarry2",
		name 	= "scr_clown_bul",
		scale	= 0.3, 
		rot		= vect.new(0, 0, 180)
	},
	-- Clown Muz
	{
		asset 	= "scr_rcbarry2",
		name	= "muz_clown",
		scale 	= 0.8,
		rot		= vect.new(0, 0, 0)
	}
}
local items = {'Disable', 'Clown Flowers', 'Clown Muz'}
local current_effect
local shooting_effect = menu.list(weapon_options, menuname('Shooting Effect', 'Shooting Effect') .. ': ' .. menuname('Shooting Effect', items[1]) )

for i, item in ipairs(items) do
	menu.action(shooting_effect, menuname('Shooting Effect', item), {}, '', function()
		current_effect = i
		menu.set_menu_name(shooting_effect, menuname('Shooting Effect', 'Shooting Effect') .. ': ' .. menuname('Shooting Effect', item) )
		menu.focus(shooting_effect)
	end)
end

create_tick_handler(function()
	if current_effect == 1 then
		return true
	elseif current_effect ~= nil then
		local user_ped = PLAYER.PLAYER_PED_ID()
		if PED.IS_PED_SHOOTING(user_ped) then
			local effect = effects[ current_effect - 1 ]
			local weapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(user_ped, false)
			local bone_pos = ENTITY._GET_ENTITY_BONE_POSITION_2(weapon, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(weapon, "gun_muzzle"))
			local offset = ENTITY.GET_OFFSET_FROM_ENTITY_GIVEN_WORLD_COORDS(weapon, bone_pos.x, bone_pos.y, bone_pos.z)
			REQUEST_PTFX_ASSET(effect.asset)
			GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
			GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(
				effect.name,
				weapon, 
				offset.x + 0.10,
				offset.y,
				offset.z,
				effect.rot.x,
				effect.rot.y,
				effect.rot.z,
				effect.scale,
				false, false, false
			)
		end	
	end
	return true
end)

-------------------------------------
-- MAGNET GUN
-------------------------------------

local items = {'Disable', 'Smooth', 'Caos Mode'}
local current_magnetgun
local sphere_colour = Colour.New(0, 255, 255)
local magnetgun = menu.list(weapon_options, menuname('Weapon', 'Magnet Gun') .. ': ' .. menuname('Weapon - Magnet Gun', items[ 1 ]))

for i, item in ipairs(items) do
	menu.action(magnetgun, menuname('Weapon - Magnet Gun', item), {}, '', function()
		current_magnetgun = i
		menu.set_menu_name(magnetgun, menuname('Weapon', 'Magnet Gun') .. ': ' .. menuname('Weapon - Magnet Gun', item) )
		menu.focus(magnetgun)
	end)
end

create_tick_handler(function()
	if current_magnetgun == 1 then
		return true
	elseif current_magnetgun == 2 and PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_ID()) then
		local v = {}
		local offset = GET_OFFSET_FROM_CAM(30)
		for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
			if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) then
				local vpos = ENTITY.GET_ENTITY_COORDS(vehicle)
				if vect.dist(offset, vpos) < 70 and REQUEST_CONTROL(vehicle) and #v < 20 then
					insert_once(v, vehicle)
					local unitv = vect.norm(vect.subtract(offset, vpos))
					local dist = vect.dist(offset, vpos)
					local vel = vect.mult(unitv, dist)
					ENTITY.SET_ENTITY_VELOCITY(vehicle, vel.x, vel.y, vel.z)
				end
			end
		end
		GRAPHICS._DRAW_SPHERE(offset.x, offset.y, offset.z, 0.5, sphere_colour.r, sphere_colour.g, sphere_colour.b, 0.5)
		sphere_colour = Colour.Rainbow(sphere_colour)
	elseif current_magnetgun == 3 and PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_ID()) then
		local v = {}
		local offset = GET_OFFSET_FROM_CAM(30)
		for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
			if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) then
				local vpos = ENTITY.GET_ENTITY_COORDS(vehicle)
				if vect.dist(offset, vpos) < 70 and REQUEST_CONTROL(vehicle) and #v < 20 then
					insert_once(v, vehicle)
					local unitv = vect.norm(vect.subtract(offset, vpos))
					local dist = vect.dist(offset, vpos)
					local mult = 15 * (1 - 2^(-dist))
					local force = vect.mult(unitv, mult)
					ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
				end
			end
		end
		GRAPHICS._DRAW_SPHERE(offset.x, offset.y, offset.z, 0.5, sphere_colour.r, sphere_colour.g, sphere_colour.b, 0.5)
		sphere_colour = Colour.Rainbow(sphere_colour)
	end
	return true
end)

-------------------------------------
-- AIRSTRIKE GUN
-------------------------------------

menu.toggle_loop(weapon_options, menuname('Weapon', 'Airstrike Gun'), {}, '', function(toggle)
	local hash = joaat("weapon_airstrike_rocket")
	if not WEAPON.HAS_WEAPON_ASSET_LOADED(hash) then
		WEAPON.REQUEST_WEAPON_ASSET(hash, 31, 0)
	end
	local hit, coords, normal_surface, entity = RAYCAST(nil, 1000.0)
	if hit == 1 then
		if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
			MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coords.x, coords.y, coords.z + 35, coords.x, coords.y, coords.z, 200, true, hash, PLAYER.PLAYER_PED_ID(), true, false, 2500.0)
		end
	end
end)

-------------------------------------
-- BULLET CHANGER
-------------------------------------


local ammo_ptrs = --belongs to ammo type 4
{
	WT_FLAREGUN		= {hash = 0x47757124},
	WT_GL			= {hash = 0xA284510B},
	WT_GNADE 		= {hash = 0x93E220BD},
	WT_MOLOTOV		= {hash = 0x24B17070},
	WT_GNADE_SMK	= {hash = 0xFDBC8A50},
	WT_SNWBALL		= {hash = 0x0787F0BB}
}
local rockets_list = {
	WT_A_RPG		= "weapon_rpg",
	WT_FWRKLNCHR	= "weapon_firework",
	WT_RAYPISTOL	= "weapon_raypistol"
}
local bullet 			= 0xB1CA77B1
local from_memory 		= false
local default_bullet 	= {}

function GET_CURRENT_WEAPON_AMMO_TYPE() --returns 4 if OBJECT (rocket, grenade, etc.), and 2 if INSTANT HIT
	local offsets = {0x08, 0x10D8, 0x20, 0x54}
	local addr = address_from_pointer_chain(worldptr, offsets)
	if addr ~= NULL then
		return memory.read_byte(addr), addr
	else
		error('current ammo type not found')
	end
end

function GET_CURRENT_WEAPON_AMMO_PTR()
	local offsets = {0x08, 0x10D8, 0x20, 0x60}
	local addr = address_from_pointer_chain(worldptr, offsets)
	local value
	if addr ~= NULL then
		return memory.read_long(addr), addr
	else
		error('current ammo pointer not found.')
	end
end

function SET_BULLET_TO_DEFAULT()
	for weapon, data in pairs(default_bullet) do
		local atype, aptr = data.ammotype, data.ammoptr
		memory.write_byte(atype.addr, atype.value)
		memory.write_long(aptr.addr, aptr.value)
	end
end


local toggle_bullet_type = menu.toggle(weapon_options, menuname('Weapon', 'Bullet Changer') .. ': ' .. HUD._GET_LABEL_TEXT("WT_A_RPG"), {'bulletchanger'}, '', function(toggle)
	bulletchanger = toggle
	while bulletchanger do
		wait()
		if not from_memory then
			SET_BULLET_TO_DEFAULT()
			local user_ped = PLAYER.PLAYER_PED_ID()
			local pos2 = GET_OFFSET_FROM_CAM(30)
			if PED.IS_PED_SHOOTING(user_ped) and GET_CURRENT_WEAPON_AMMO_TYPE() ~= 4 then
				local current_weapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(user_ped, false)
				local pos1 = ENTITY._GET_ENTITY_BONE_POSITION_2(
					current_weapon, 
					ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(current_weapon, "gun_muzzle")
				)
				MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, 200, true, bullet, user_ped, true, false, 2000.0)
			end
		else
			local weapon_ptr = alloc(12)
			WEAPON.GET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), weapon_ptr, true)
			local weapon = memory.read_int(weapon_ptr); memory.free(weapon_ptr)
			local ammotype, ammotype_addr = GET_CURRENT_WEAPON_AMMO_TYPE()
			local ammoptr, ammoptr_addr = GET_CURRENT_WEAPON_AMMO_PTR()
	
			if not does_key_exists(default_bullet, weapon) then
				default_bullet[weapon] = {
					['ammotype'] = {['addr'] = ammotype_addr, ['value'] = ammotype},
					['ammoptr'] = {['addr'] = ammoptr_addr, ['value'] = ammoptr}
				}
				memory.write_byte(ammotype_addr, 4)
				memory.write_long(ammoptr_addr, bullet)
			else
				if ammotype ~= 4 then
					memory.write_byte(ammotype_addr, 4)
				end
				if ammoptr ~= bullet then
					memory.write_long(ammoptr_addr, bullet)
				end
			end
		end
	end
	SET_BULLET_TO_DEFAULT()
end)

local bullet_type = menu.list(weapon_options, menuname('Weapon', 'Set Weapon Bullet'))
menu.divider(bullet_type, menuname('Weapon', 'Set Weapon Bullet'))

local type_throwables = menu.list(bullet_type, HUD._GET_LABEL_TEXT("AT_THROW"), {}, menuname('Help', 'Not networked. Other players can only see explosions'))
menu.divider(type_throwables, HUD._GET_LABEL_TEXT("AT_THROW"))

for label, v in pairs_by_keys(rockets_list) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bullet_type, strg, {}, '', function()
		bullet = joaat(v)
		menu.set_menu_name(toggle_bullet_type, menuname('Weapon', 'Bullet Changer') .. ': ' .. strg)
		if not bulletchanger then menu.trigger_command(toggle_bullet_type, 'on') end
		menu.focus(bullet_type)
		from_memory = false
	end)
end

for label, data in pairs_by_keys(ammo_ptrs) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(type_throwables, strg, {}, '', function()
		local current_ptr = alloc(12)
		WEAPON.GET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), current_ptr)
		local current = memory.read_int(current_ptr); memory.free(current_ptr)
		if data.ammoptr == nil then 
			WEAPON.GIVE_WEAPON_TO_PED(PLAYER.PLAYER_PED_ID(), data.hash, -1, false, false)
			WEAPON.SET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), data.hash, false)
			data.ammoptr = GET_CURRENT_WEAPON_AMMO_PTR()
			WEAPON.SET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), current, false)
		end
		bullet = data.ammoptr
    	menu.set_menu_name(toggle_bullet_type, menuname('Weapon', 'Bullet Changer') .. ': ' .. strg)
		if not bulletchanger then menu.trigger_command(toggle_bullet_type, 'on') end
		menu.focus(bullet_type)
		from_memory = true
  	end)
end

-------------------------------------
-- PTFX GUN
-------------------------------------

local effects = {
	['Clown Explosion'] = {
		asset 	= "scr_rcbarry2",
		name	= "scr_exp_clown",
		colour 	= false
	},
	['Clown Appears'] = {
		asset	= "scr_rcbarry2",
		name 	= "scr_clown_appears",
		colour 	= false
	},
	['FW Trailburst'] = {
		asset 	= "scr_rcpaparazzo1",
		name 	= "scr_mich4_firework_trailburst_spawn",
		colour 	= true
	},
	['FW Starburst'] = {
		asset	= "scr_indep_fireworks",
		name	= "scr_indep_firework_starburst",
		colour 	= true
	},
	['FW Fountain'] = {
		asset 	= "scr_indep_fireworks",
		name	= "scr_indep_firework_fountain",
		colour 	= true
	},
	['Alien Disintegration'] = {
		asset	= "scr_rcbarry1",
		name 	= "scr_alien_disintegrate",
		colour 	= false
	},
	['Clown Flowers'] = {
		asset	= "scr_rcbarry2",
		name	= "scr_clown_bul",
		colour 	= false
	},
	['FW Ground Burst'] = {
		asset 	= "proj_indep_firework",
		name	= "scr_indep_firework_grd_burst",
		colour 	= false
	}
}
local impact_effect = effects ['Clown Explosion']
local impact_colour = Colour.New(0.5, 0, 0.5)

local fx_weapon_root = menu.list(weapon_options, menuname('Hit Effect', 'Hit Effect'))

menu.divider(fx_weapon_root, menuname('Hit Effect', 'Hit Effect'))

local fx_weapon_toggle = menu.toggle(fx_weapon_root,  menuname('Hit Effect', 'Hit Effect') .. ': ' .. menuname('Hit Effect', 'Clown Explosion'), {}, '', function(toggle)
	fx_weapon = toggle 
	while fx_weapon do
		REQUEST_PTFX_ASSET(impact_effect.asset)
		local hit, coords, normal_surface, entity = RAYCAST(nil, 1000.0)
		if hit == 1 then
			if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
				local rot = GET_ROTATION_FROM_DIRECTION(normal_surface)
				GRAPHICS.USE_PARTICLE_FX_ASSET(impact_effect.asset)
				if impact_effect.colour then
					local colour = impact_colour
					GRAPHICS.SET_PARTICLE_FX_NON_LOOPED_COLOUR(colour.r, colour.g, colour.b)
				end
				GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(
					impact_effect.name, 
					coords.x, 
					coords.y, 
					coords.z, 
					rot.x - 90, 
					rot.y, 
					rot.z, 
					1.0, 
					false, false, false, false
				)
			end
		end
		wait()
	end	
end)

local fx_list = menu.list(fx_weapon_root,  menuname('Hit Effect', 'Set Effect') )

for k, table in pairs_by_keys(effects) do
	local helptext
	if effects[k].colour then
		helptext = menuname('Help', 'Colour can be changed.')
	else helptext = "" end
	menu.action(fx_list, menuname('Hit Effect', k), {}, helptext, function()
		impact_effect = effects[k]
		menu.set_menu_name(fx_weapon_toggle, menuname('Hit Effect', 'Hit Effect') .. ': ' .. menuname('Hit Effect', k) )
		if not fx_weapon then menu.trigger_command(fx_weapon_toggle, 'on') end
		menu.focus(fx_list)
	end)
end


menu.rainbow(menu.colour(fx_weapon_root, menuname('Hit Effect', 'Colour'), {'effectcolour'}, menuname('Help', 'Only works on some fx'),  Colour.New(0.5, 0, 0.5), false, function(colour)
	impact_colour = colour
end))

-------------------------------------
-- VEHICLE GUN
-------------------------------------

local vehicle_gun_list = {
	['Lazer'] 			= "lazer",
	['Insurgent'] 		= "insurgent2",
	['Phantom Wedge'] 	= "phantom2",	
	['Adder'] 			= "adder",
['Косатка'] 	= "kosatka"
}
local vehicle_for_gun = vehicle_gun_list.Adder
local into_vehicle
local vehicle_gun = menu.list(weapon_options, menuname('Weapon', 'Vehicle Gun'), {'vehiclegun'}, '')

menu.divider(vehicle_gun, menuname('Weapon', 'Vehicle Gun'))

local toggle_vehicle_gun = menu.toggle(vehicle_gun, menuname('Weapon', 'Vehicle Gun') .. ': Adder', {'togglevehiclegun'}, '', function(toggle)
--local toggle_vehicle_gun = menu.toggle(vehicle_gun, menuname('Weapon', 'Vehicle Gun') .. ': Adder', {'togglevehiclegun'}, '', function(toggle)
	vehiclegun = toggle
	local preview
	local offset = 25
	local maxoffset = 100
	local minoffset = 15
	local mult = 0.0

	create_tick_handler(function()
		local hash = joaat(vehicle_for_gun)
		REQUEST_MODELS(hash)
		local hit, coords, nsurface, entity = RAYCAST(nil, offset + 5.0, 1)
		
		if not config.general.disablepreview then 
			local offset_limit = minoffset + mult * (maxoffset - minoffset)
			offset = incr(offset, 0.5, offset_limit)
			if PAD.IS_CONTROL_JUST_PRESSED(2, 241) and PAD.IS_CONTROL_PRESSED(2, 241) then
				if mult < 1.0 then mult = mult + 0.25 end
			end		
			if PAD.IS_CONTROL_JUST_PRESSED(2, 242) and PAD.IS_CONTROL_PRESSED(2, 242) then
				if mult > 0.0 then mult = mult - 0.25 end
			end
		end
		
		if hit ~= 1 then 
			coords = GET_OFFSET_FROM_CAM(offset) 
		end
		
		if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_ID()) then
			local rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
			if not config.general.disablepreview then
				if not ENTITY.DOES_ENTITY_EXIST(preview) then
					preview = VEHICLE.CREATE_VEHICLE(hash, coords.x, coords.y, coords.z, rot.z, false, false)
					ENTITY.SET_ENTITY_ALPHA(preview, 153, true)
					ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(preview, false, false)
				end
				
				ENTITY.SET_ENTITY_COORDS_NO_OFFSET(preview, coords.x, coords.y, coords.z, false, false, false)
				
				if hit == 1 then
					VEHICLE.SET_VEHICLE_ON_GROUND_PROPERLY(preview, 1.0)
				end
				
				ENTITY.SET_ENTITY_ROTATION(preview, rot.x, rot.y, rot.z, 0, true)
				
				if instructional:begin() then
					add_control_group_instructional_button(29, "FM_AE_SORT_2")
					instructional:set_background_colour(0, 0, 0, 80)
					instructional:draw()
				end

			end
			if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
				if ENTITY.DOES_ENTITY_EXIST(preview) then
					entities.delete_by_handle(preview)
				end
				
				local vehicle = entities.create_vehicle(hash, coords, rot.z)
				ENTITY.SET_ENTITY_ROTATION(vehicle, rot.x, rot.y, rot.z, 0, true) 
				
				if into_vehicle then
					VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
					PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, -1)
				else VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 2) end
				
				ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(vehicle, true)
				VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 200)
				ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(vehicle, true)
			end
		elseif ENTITY.DOES_ENTITY_EXIST(preview) then
			entities.delete_by_handle(preview)
		end
		return vehiclegun
	end)
end)

local set_vehicle = menu.list(vehicle_gun, menuname('Weapon - Vehicle Gun', 'Set Vehicle'))

for k, vehicle in pairs_by_keys(vehicle_gun_list) do
	menu.action(set_vehicle, k, {}, '', function()
		vehicle_for_gun = vehicle_gun_list[k]
		menu.set_menu_name(toggle_vehicle_gun, 'Vehicle Gun: ' .. k)
		if not vehiclegun then menu.trigger_command(toggle_vehicle_gun, 'on') end
		menu.focus(set_vehicle)
	end)
end

menu.text_input(vehicle_gun, menuname('Weapon - Vehicle Gun', 'Custom Vehicle'), {'customvehgun'}, '', function(vehicle)
	local modelHash = joaat(vehicle)
	local name = HUD._GET_LABEL_TEXT(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(modelHash))
	if STREAMING.IS_MODEL_A_VEHICLE(modelHash) then
		vehicle_for_gun = vehicle
		menu.set_menu_name(toggle_vehicle_gun, 'Vehicle Gun: ' .. name)
	else 
		return notification.normal('The model is not a vehicle', NOTIFICATION_RED) 
	end
	if not vehiclegun then menu.trigger_command(toggle_vehicle_gun, 'on') end
end)

menu.toggle(vehicle_gun, menuname('Weapon - Vehicle Gun', 'Set Into Vehicle'), {}, '', function(toggle)
	into_vehicle = toggle
end)

-------------------------------------
-- TELEPORT GUN
-------------------------------------

menu.toggle(weapon_options, menuname('Weapon', 'Teleport Gun'), {'tpgun'}, '', function(toggle)
	telegun = toggle
	while telegun do
		wait()
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
		local hit, coords, normal_surface, entity = RAYCAST(nil, 1000.0)
		
		if hit == 1 and PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then	
			if vehicle == NULL then
				coords.z = coords.z + 1.0
				SET_ENTITY_COORDS_2(PLAYER.PLAYER_PED_ID(), coords)
			else
				local speed = ENTITY.GET_ENTITY_SPEED(vehicle)
				ENTITY.SET_ENTITY_COORDS(vehicle, coords.x, coords.y, coords.z, false, false, false, false)
				ENTITY.SET_ENTITY_HEADING(vehicle, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, speed)
			end
		end
	end
end)

-------------------------------------
-- BULLET SPEED MULT
-------------------------------------

local default_speed = {}
local speed_mult = 1

function SET_AMMO_SPEED_MULT(mult)
	local offsets = {0x08, 0x10D8, 0x20, 0x60, 0x58}
	local addr = address_from_pointer_chain(worldptr, offsets)
	if addr ~= NULL then
		local value = memory.read_float(addr)
		if not does_key_exists(default_speed, addr) and value ~= nil then
			default_speed[addr] = value
			memory.write_float(addr, mult * value)
		elseif value ~= mult * default_speed[addr] then
			memory.write_float(addr, mult * default_speed[addr])
		end
	end
end

menu.click_slider(weapon_options, menuname('Weapon', 'Bullet Speed Mult'), {'ammospeedmult'},  menuname('Help', 'Allows you to change the speed of non-instant hit bullets rockets, fireworks, grenades, etc.'), 100, 2500, 100, 50, function(mult)
	speed_mult = mult / 100
	if speed_mult == 1 then
		for addr,  value in pairs(default_speed) do
			memory.write_float(addr, value)
			default_speed[addr] = nil
		end
	end
end)

-------------------------------------
-- MAGNET ENTITIES
-------------------------------------

menu.toggle(weapon_options, menuname('Weapon', 'Magnet Entities'), {}, '', function(toggle)
	magnetent = toggle
	if not magnetent then return end
	local applyforce = false
	local entities = {}
	local entity = 0
	notification.help(
		menuname('Notification', 'Magnet Entities applies an attractive force on two specific entities. ') ..
		menuname('Notification', 'Shoot the chosen entities (vehicle, object or ped) to attract them to each other')
	)
	while magnetent do
		wait()
		if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_ID()) then
			local ptr = alloc(32)
			
            if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), ptr) then
				entity = memory.read_int(ptr)
			end
			memory.free(ptr)
			
            if entity and entity ~= NULL then
				if ENTITY.IS_ENTITY_A_PED(entity) and PED.IS_PED_IN_ANY_VEHICLE(entity) then
					local vehicle = PED.GET_VEHICLE_PED_IS_IN(entity, false)
					entity = vehicle
				end
				draw_box_esp(entity, Colour.New(255,0,0))
			end
				
			if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) and entity and entity ~= NULL then
				local mypos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
				local entpos = ENTITY.GET_ENTITY_COORDS(entity)
				local dist = vect.dist(mypos, entpos)
				
				if entities[1] ~= entity and dist < 500 then 
					table.insert(entities, entity)
				end
				
				if #entities == 2 then
					local ent1, ent2 = entities[1], entities[2]
					create_tick_handler(function()
						if not ENTITY.DOES_ENTITY_EXIST(ent1) or not ENTITY.DOES_ENTITY_EXIST(ent2) then
							return false
						end

						local pos1 = ENTITY.GET_ENTITY_COORDS(ent1)
						local pos2 = ENTITY.GET_ENTITY_COORDS(ent2)
						local dist = vect.dist(pos1, pos2)
						local force1 = vect.mult(vect.norm(vect.subtract(pos2, pos1)), dist / 20)
						local force2 = vect.mult(force1, -1)

						
						if ENTITY.IS_ENTITY_A_PED(ent1) then
                            if not PED.IS_PED_A_PLAYER(ent1) then
                                REQUEST_CONTROL(ent1)
                                PED.SET_PED_TO_RAGDOLL(ent1, 1000, 1000, 0, 0, 0, 0)
                                ENTITY.APPLY_FORCE_TO_ENTITY(ent1, 1, force1.x, force1.y, force1.z, 0, 0, 0, 0, false, false, true)
                            end
                        else
                            REQUEST_CONTROL(ent1)
                            ENTITY.APPLY_FORCE_TO_ENTITY(ent1, 1, force1.x, force1.y, force1.z, 0, 0, 0, 0, false, false, true)
						end
						
						if ENTITY.IS_ENTITY_A_PED(ent2) then
                            if not PED.IS_PED_A_PLAYER(ent2) then
                                REQUEST_CONTROL(ent2)
                                PED.SET_PED_TO_RAGDOLL(ent2, 1000, 1000, 0, 0, 0, 0)
                                ENTITY.APPLY_FORCE_TO_ENTITY(ent2, 1, force2.x, force2.y, force2.z, 0, 0, 0, 0, false, false, true)
                            end
                        else
                            REQUEST_CONTROL(ent2)
                            ENTITY.APPLY_FORCE_TO_ENTITY(ent2, 1, force2.x, force2.y, force2.z, 0, 0, 0, 0, false, false, true)
						end

						return magnetent
					end)
					entities = {}
				end
			end
		end
	end
end)

-------------------------------------
-- VALKYIRE ROCKET
-------------------------------------

menu.toggle(weapon_options, menuname('Weapon', 'Valkyire Rocket'), {}, '', function(toggle)
	valkyire_rocket = toggle
	if valkyire_rocket then
		local rocket
		local cam
		local blip
		local init
		local draw_rect = function(x, y, z, w)
			GRAPHICS.DRAW_RECT(x, y, z, w, 255, 255, 255, 255)
		end

		while valkyire_rocket do
			if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) and not init then
				init = true 
				sTime = cTime()
			elseif init then
				if not ENTITY.DOES_ENTITY_EXIST(rocket) then
					local weapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER.PLAYER_PED_ID())
					local offset = GET_OFFSET_FROM_CAM(10)
			
					rocket = OBJECT.CREATE_OBJECT_NO_OFFSET(joaat('w_lr_rpg_rocket'), offset.x, offset.y, offset.z, true, false, true)
					ENTITY.SET_ENTITY_INVINCIBLE(rocket, true)
					ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(rocket, true)
					NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.OBJ_TO_NET(rocket), PLAYER.PLAYER_ID(), true)
					ENTITY.SET_ENTITY_LOAD_COLLISION_FLAG(rocket, true, 1)
					NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.OBJ_TO_NET(rocket), true);
					NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.OBJ_TO_NET(rocket), false)
					ENTITY.SET_ENTITY_RECORDS_COLLISIONS(rocket, true)
					ENTITY.SET_ENTITY_HAS_GRAVITY(rocket, false)
				
					CAM.DESTROY_ALL_CAMS(true)
					cam = CAM.CREATE_CAM("DEFAULT_SCRIPTED_CAMERA", true)
					CAM.SET_CAM_NEAR_CLIP(cam, 0.01)
					CAM.SET_CAM_NEAR_DOF(cam, 0.01)
					GRAPHICS.CLEAR_TIMECYCLE_MODIFIER()
					GRAPHICS.SET_TIMECYCLE_MODIFIER("CAMERA_secuirity")
					ATTACH_CAM_TO_ENTITY_WITH_FIXED_DIRECTION(cam, rocket, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1)
					CAM.SET_CAM_ACTIVE(cam, true)
					CAM.RENDER_SCRIPT_CAMS(true, false, 0, true, true, 0)

					PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), true)
					ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(), true)
				else
					local rot = CAM.GET_GAMEPLAY_CAM_ROT(0)
					local direction = ROTATION_TO_DIRECTION(CAM.GET_GAMEPLAY_CAM_ROT(0))
					local coords = ENTITY.GET_ENTITY_COORDS(rocket)
					local groundZ = GET_GROUND_Z_FOR_3D_COORD(coords)
					local altitude = math.abs(coords.z - groundZ)
					local force = vect.mult(direction, 40)
					ENTITY.SET_ENTITY_ROTATION(rocket, rot.x, rot.y, rot.z, 0, 1)
					STREAMING.SET_FOCUS_POS_AND_VEL(coords.x, coords.y, coords.z, rot.z, rot.y, rot.z)
					
					ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(rocket, 1, force.x, force.y, force.z, false, false, false, false)

					HUD.HIDE_HUD_AND_RADAR_THIS_FRAME()
					PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), true)
					ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(), true)
					HUD._HUD_WEAPON_WHEEL_IGNORE_SELECTION()
					
					draw_rect(0.5, 0.5 - 0.025, 0.050, 0.002)
					draw_rect(0.5, 0.5 + 0.025, 0.050, 0.002)
					draw_rect(0.5 - 0.025, 0.5, 0.002, 0.052)
					draw_rect(0.5 + 0.025, 0.5, 0.002, 0.052)
					draw_rect(0.5 + 0.05, 0.5, 0.050, 0.002)
					draw_rect(0.5 - 0.05, 0.5, 0.050, 0.002)
					draw_rect(0.5, 0.5 + 0.05, 0.002, 0.050)
					draw_rect(0.5, 0.5 - 0.05, 0.002, 0.050)
					
					local length = 0.5 - 0.5 * (cTime()-sTime) / 7000 -- timer length
					local perc = length / 0.5
					local color = get_blended_color(perc) -- timer color

					GRAPHICS.DRAW_RECT(0.25, 0.5, 0.03, 0.5, 255, 255, 255, 120)
					GRAPHICS.DRAW_RECT(0.25, 0.75 - length / 2, 0.03, length, color.r, color.g, color.b, color.a)

					if ENTITY.HAS_ENTITY_COLLIDED_WITH_ANYTHING(rocket) or length <= 0 then
						local impact_coord = ENTITY.GET_ENTITY_COORDS(rocket)
						FIRE.ADD_EXPLOSION(impact_coord.x, impact_coord.y, impact_coord.z, 32, 1.0, true, false, 0.4)
						entities.delete_by_handle(rocket)
						PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), false)
						CAM.RENDER_SCRIPT_CAMS(false, false, 3000, true, false, 0)
						GRAPHICS.SET_TIMECYCLE_MODIFIER("DEFAULT")
						STREAMING.CLEAR_FOCUS()
						CAM.DESTROY_CAM(cam, 1)
						PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), false)
						ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(), false)
					
						rocket = 0
						init = false
					end	
				end
			end
			wait()
		end
		
		if rocket and ENTITY.DOES_ENTITY_EXIST(rocket) then
			local impact_coord = ENTITY.GET_ENTITY_COORDS(rocket)
			FIRE.ADD_EXPLOSION(impact_coord.x, impact_coord.y, impact_coord.z, 32, 1.0, true, false, 0.4)
			entities.delete_by_handle(rocket)
			STREAMING.CLEAR_FOCUS()
			CAM.RENDER_SCRIPT_CAMS(false, false, 3000, true, false, 0)
			CAM.DESTROY_CAM(cam, 1)
			GRAPHICS.SET_TIMECYCLE_MODIFIER("DEFAULT")
			ENTITY.FREEZE_ENTITY_POSITION(PLAYER.PLAYER_PED_ID(), false)
			PLAYER.DISABLE_PLAYER_FIRING(PLAYER.PLAYER_PED_ID(), false)
			if HUD.DOES_BLIP_EXIST(blip) then
				util.remove_blip(blip)
			end
			HUD.UNLOCK_MINIMAP_ANGLE()
			HUD.UNLOCK_MINIMAP_POSITION()
		end
	end
end)

-------------------------------------
-- GUIDED MISSILE
-------------------------------------

menu.action(weapon_options, menuname('Weapon', 'Launch Guided Missile'), {}, '', function()
	if ufo.get_state() == -1 then 
		guided_missile.set_state(true)
	end
end)

-------------------------------------
-- SUPERPUNCH
-------------------------------------

menu.toggle_loop(weapon_options, menuname('Weapon', 'Superpunch'), {}, menuname('Help', 'Push nearby entities away when performing melee animation'), function ()
	local is_performing_action = PED.IS_PED_PERFORMING_MELEE_ACTION(PLAYER.PLAYER_PED_ID())
	if is_performing_action then
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
		FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 29, 25.0, false, true, 0.0, true)
		AUDIO.PLAY_SOUND_FRONTEND(-1, "EMP_Blast", "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", false)
	end
end)

---------------------
---------------------
-- VEHICLE
---------------------
---------------------

local vehicle_options = menu.list(menu.my_root(), menuname('Vehicle', 'Vehicle'), {}, '')

menu.divider(vehicle_options, menuname('Vehicle', 'Vehicle'))

-------------------------------------
-- AIRSTRIKE AIRCRAFT
-------------------------------------

local vehicle_weapon = menu.list(vehicle_options, menuname('Vehicle', 'Vehicle Weapons'), {'vehicleweapons'}, 'Allows you to add weapons to any vehicle.')

menu.divider(vehicle_weapon, menuname('Vehicle', 'Vehicle Weapons'))


local airstrikeplanes =  menu.toggle(vehicle_options, menuname('Vehicle', 'Airstrike Aircraft'), {'airstrikeplanes'}, menuname('Notification', 'Use any plane or helicopter to make airstrikes.'), function(toggle)
	airstrike_plane = toggle
	if not airstrike_plane then return end
	for name, control in pairs(imputs) do
		if control[2] == config.controls.airstrikeaircraft then
util.show_corner_help(menuname('Notification', 'Press ') .. ('~%s~'):format(name) .. menuname('Notification', ' to use Airstrike Aircraft'))
			notification.help(menuname('Notification', 'Airstrike Aircraft can be used in planes or helicopters.'))
			break
		end
	end
	while airstrike_plane do
		local control = config.controls.airstrikeaircraft
		if IS_PED_IN_ANY_AIRCRAFT(PLAYER.PLAYER_PED_ID()) and PAD.IS_CONTROL_PRESSED(2, control) then
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID())
			local pos = ENTITY.GET_ENTITY_COORDS(vehicle)
			local startTime = os.time() 
			create_tick_handler(function()
				wait(500)
				local groundz = GET_GROUND_Z_FOR_3D_COORD(pos)
				pos.x = pos.x + math.random(-3,3)
				pos.y = pos.y + math.random(-3,3)
				if ( pos.z - groundz > 10 ) then
					MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z - 3, pos.x, pos.y, groundz, 200, true, joaat("weapon_airstrike_rocket"), PLAYER.PLAYER_PED_ID(), true, false, 2500.0)
				end
				return ( os.time() - startTime <= 5 )
			end)
		end
		wait(200)
	end
end)

-------------------------------------
-- VEHICLE WEAPONS
-------------------------------------

function draw_line_from_vehicle(vehicle, startpoint)
	local minimum_ptr, maximum_ptr = alloc(), alloc()
	MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), minimum_ptr, maximum_ptr)
	local minimum = memory.read_vector3(minimum_ptr); memory.free(minimum_ptr)
	local maximum = memory.read_vector3(maximum_ptr); memory.free(maximum_ptr)
	local startcoords = 
	{
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y, 0), --FRONT & LEFT
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y, 0)  --FRONT & RIGHT
	}	
	local endcoords = 
	{
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y + 25, 0),
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y + 25, 0)
	}
	local coord1 = startcoords[ startpoint ]
	local coord2 = endcoords[ startpoint ]
	GRAPHICS.DRAW_LINE(coord1.x, coord1.y, coord1.z, coord2.x, coord2.y, coord2.z, 255, 0, 0, 150)
end


function shoot_bullet_from_vehicle(vehicle, weaponName, startpoint)
	local weaponHash = joaat(weaponName)
	local minimum_ptr, maximum_ptr = alloc(), alloc()
	if not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) then
		WEAPON.REQUEST_WEAPON_ASSET(weaponHash, 31, 26)
		while not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) do
			wait()
		end
	end
	MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), minimum_ptr, maximum_ptr)
	local minimum = memory.read_vector3(minimum_ptr); memory.free(minimum_ptr)
	local maximum = memory.read_vector3(maximum_ptr); memory.free(maximum_ptr)

	local startcoords = 
	{
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y + 0.25, 0.3), 	--FRONT & LEFT
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y + 0.25, 0.3), 	--FRONT & RIGHT
		bl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, minimum.y, 0.3), 		--BACK & LEFT
		br = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, minimum.y, 0.3) 			--BACK & RIGHT
	}	
	local endcoords = 
	{
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y + 50, 0.0),
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y + 50, 0.0),
		bl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, minimum.y - 50, 0.0),
		br = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, minimum.y - 50, 0.0)
	}
	local coord1 = startcoords[ startpoint ]
	local coord2 = endcoords[ startpoint ]
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coord1.x, coord1.y, coord1.z, coord2.x, coord2.y, coord2.z, 200, true, weaponHash, PLAYER.PLAYER_PED_ID(), true, false, 2000.0)
end

-------------------------------------
-- VEHICLE LASER
-------------------------------------

menu.toggle(vehicle_weapon, menuname('Vehicle - Vehicle Weapons', 'Vehicle Lasers'), {'vehiclelasers'},'', function(toggle)
	vehicle_laser = toggle
	if vehicle_laser and airstrike_plane then
		menu.trigger_command(airstrikeplanes, 'off')
	end
	while vehicle_laser do
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(PLAYER.PLAYER_ID())
		if vehicle ~= NULL then
			draw_line_from_vehicle(vehicle, 'fl')
			draw_line_from_vehicle(vehicle, 'fr')
		end
		wait()
	end
end)

-------------------------------------
-- VEHICLE WEAPONS
-------------------------------------

local selected = 1

local toggle_veh_weapons = menu.toggle(vehicle_weapon, menuname('Vehicle - Vehicle Weapons', 'Vehicle Weapons') .. ': ' .. HUD._GET_LABEL_TEXT("WT_V_SPACERKT"), {}, '', function(toggle)
	veh_rockets = toggle
	if not veh_rockets then return end
	for name, control in pairs(imputs) do
		if control[2] == config.controls.vehicleweapons then
			util.show_corner_help(menuname('Notification', 'Press ') .. ('~%s~'):format(name) .. menuname('Notification', ' to use Vehicle Weapons'))
			break
		end
	end
	while veh_rockets do
		local control = config.controls.vehicleweapons
		local vehicle = GET_VEHICLE_PLAYER_IS_IN(PLAYER.PLAYER_ID())
		if vehicle ~= NULL and veh_weapons[ selected ][ 3 ](2, control) then
			if not PAD.IS_CONTROL_PRESSED(0, 79) then
				shoot_bullet_from_vehicle(vehicle, veh_weapons[ selected ][ 1 ], 'fl')
				shoot_bullet_from_vehicle(vehicle, veh_weapons[ selected ][ 1 ], 'fr')
			else
				shoot_bullet_from_vehicle(vehicle, veh_weapons[ selected ][ 1 ], 'bl')
				shoot_bullet_from_vehicle(vehicle, veh_weapons[ selected ][ 1 ], 'br')
			end
		end
		wait()
	end
end)

local vehicle_weapon_list = menu.list(vehicle_weapon, menuname('Vehicle - Vehicle Weapons', 'Set Vehicle Weapon'))
menu.divider(vehicle_weapon_list, HUD._GET_LABEL_TEXT("PM_WEAPONS"))

for i, table in pairs_by_keys(veh_weapons) do
	local strg = HUD._GET_LABEL_TEXT( table[2] )
	menu.action(vehicle_weapon_list, strg, {strg}, '', function()
		selected = i
		menu.set_menu_name(toggle_veh_weapons, menuname('Vehicle - Vehicle Weapons', 'Set Vehicle Weapon') .. ': ' .. strg)
		if not veh_rocket then menu.trigger_command(toggle_veh_weapons, 'on') end
		menu.focus(vehicle_weapon_list)
	end)
end

-------------------------------------
-- VEHICLE EDITOR
-------------------------------------

local handling_editor = menu.list(vehicle_options, menuname('Vehicle', 'Handling Editor'), {}, '', function()
	handling.display_handling = true
end, function()
	handling.display_handling = false
	if handling.cursor_mode then
		handling.cursor_mode = false
		UI.toggle_cursor_mode(false)
	end
end)


handling = {
	cursor_mode = false,
	window_x = 0.02,
	window_y = 0.08,
	inviewport = {},
	display_handling = false,
	flying = {},
	boat = {},
	offsets = 
	{
		-- handling
		{    
			{menuname('Handling', 'Mass'), 0xC},
			{menuname('Handling', 'Initial Drag Coefficient'), 0x10},
			{menuname('Handling', 'Down Force Modifier'), 0x14},
			{menuname('Handling', 'Centre Of Mass Offset X'), 0x20},
			{menuname('Handling', 'Centre Of Mass Offset Y'), 0x24},
			{menuname('Handling', 'Centre Of Mass Offset Z'), 0x28},
			{menuname('Handling', 'Inercia Multiplier X'), 0x30},
			{menuname('Handling', 'Inercia Multiplier Y'), 0x34},
			{menuname('Handling', 'Inercia Multiplier Z'), 0x38},
			{menuname('Handling', 'Percent Submerged'), 0x40},
			{menuname('Handling', 'Submerged Ratio'), 0x44},
			{menuname('Handling', 'Drive Bias Front'), 0x48},
			{menuname('Handling', 'Acceleration'), 0x4C},
			{menuname('Handling', 'Drive Inertia'), 0x54},
			{menuname('Handling', 'Up Shift'), 0x58},
			{menuname('Handling', 'Down Shift'), 0x5C},
			{menuname('Handling', 'Initial Drive Force'), 0x60},
			{menuname('Handling', 'Drive Max Flat Velocity'), 0x64},
			{menuname('Handling', 'Initial Drive Max Flat Velocity'), 0x68},
			{menuname('Handling', 'Brake Force'), 0x6C},
			{menuname('Handling', 'Brake Bias Front'), 0x74},
			{menuname('Handling', 'Brake Bias Rear'), 0x78},
			{menuname('Handling', 'Hand Brake Force'), 0x7C},
			{menuname('Handling', 'Steering Lock'), 0x80},
			{menuname('Handling', 'Steering Lock Ratio'), 0x84},
			{menuname('Handling', 'Traction Curve Max'), 0x88},
			{menuname('Handling', 'Traction Curve Max Ratio'), 0x8C},
			{menuname('Handling', 'Traction Curve Min'), 0x90},
			{menuname('Handling', 'Traction Curve Min Ratio'), 0x94},
			{menuname('Handling', 'Traction Curve Lateral'), 0x98},
			{menuname('Handling', 'Traction Curve Lateral Ratio'), 0x9C},
			{menuname('Handling', 'Traction Spring Delta Max'), 0xA0},
			{menuname('Handling', 'Traction Spring Delta Max Ratio'), 0xA4},
			{menuname('Handling', 'Low Speed Traction Multiplier'), 0xA8},
			{menuname('Handling', 'Camber Stiffness'), 0xAC},
			{menuname('Handling', 'Traction Bias Front'), 0xB0},
			{menuname('Handling', 'Traction Bias Rear'), 0xB4},
			{menuname('Handling', 'Traction Loss Multiplier'), 0xB8},
			{menuname('Handling', 'Suspension Force'), 0xBC},
			{menuname('Handling', 'Suspension Comp Damp'), 0xC0},
			{menuname('Handling', 'Suspension Rebound Damp'), 0xC4},
			{menuname('Handling', 'Suspension Lower Limit'), 0xC8},
			{menuname('Handling', 'Suspension Upper Limit'), 0xCC},
			{menuname('Handling', 'Suspension Raise'), 0xD0},
			{menuname('Handling', 'Suspension Bias Front'), 0xD4},
			{menuname('Handling', 'Suspension Bias Rear'), 0xD8},
			{menuname('Handling', 'Anti-Roll Bar Force'), 0xDC},
			{menuname('Handling', 'Anti-Roll Bar Bias Front'), 0xE0},
			{menuname('Handling', 'Anti-Roll Bar Bias Rear'), 0xE4},
			{menuname('Handling', 'Roll Centre Height Front'), 0xE8},
			--{'Roll Centre Height Front'), 0xEC},
			{menuname('Handling', 'Collision Damage Multiplier'), 0xF0},
			{menuname('Handling', 'Weapon Damage Multiplier'), 0xF4},
			--{'Weapon Damage Multiplier'), 0xF8},
			{menuname('Handling', 'Engine Damage Multiplier'), 0xFC},
			{menuname('Handling', 'Petrol Tank Volume'), 0x100},
			{menuname('Handling', 'Oil Volume'), 0x104},
			{menuname('Handling', 'Seat Offset Distance X'), 0x10C},
			{menuname('Handling', 'Seat Offset Distance Y'), 0x110},
			{menuname('Handling', 'Seat Offset Distance Z'), 0x114},
			{menuname('Handling', 'Increase Speed'), 0x120}
		},
		-- flying
		{
			{menuname('Handling', 'Thrust'), 0x338},
			{menuname('Handling', 'Thrust Fall Off'), 0x33C},
			{menuname('Handling', 'Thrust Vectoring'), 0x340},
			{menuname('Handling', 'Yaw Mult'), 0x34C},
			{menuname('Handling', 'Yaw Stabilise'), 0x350},
			{menuname('Handling', 'Side Slip Mult'), 0x354},
			{menuname('Handling', 'Roll Mult'), 0x35C},
			{menuname('Handling', 'Roll Stabilise'), 0x360},
			{menuname('Handling', 'Pitch Mult'), 0x368},
			{menuname('Handling', 'Pitch Stabilise'), 0x36C},
			{menuname('Handling', 'Form Lift Mult'), 0x374},
			{menuname('Handling', 'Attack Lift Mult'), 0x378},
			{menuname('Handling', 'Attack Dive Mult'), 0x37C},
			{menuname('Handling', 'Gear Down Drag V'), 0x380},
			{menuname('Handling', 'Gear Down Lift Mult'), 0x384},
			{menuname('Handling', 'Wind Mult'), 0x388},
			{menuname('Handling', 'Move Res'), 0x38C},
			{menuname('Handling', 'Turn Res X'), 0x390},
			{menuname('Handling', 'Turn Res Y'), 0x394},
			{menuname('Handling', 'Turn Res Z'), 0x398},
			{menuname('Handling', 'Speed Res X'), 0x3A0},
			{menuname('Handling', 'Speed Res Y'), 0x3A4},
			{menuname('Handling', 'Speed Res Z'), 0x3A8},
			{menuname('Handling', 'Gear Door Front Open'), 0x3B0},
			{menuname('Handling', 'Gear Door Rear Open'), 0x3B4},
			{menuname('Handling', 'Gear Door Rear Open 2'), 0x3B8},
			{menuname('Handling', 'Gear Door Rear M Open'), 0x3BC},
			{menuname('Handling', 'Turbulence Magnitude Max'), 0x3C0},
			{menuname('Handling', 'Turbulence Force Mult'), 0x3C4},
			{menuname('Handling', 'Turbulence Roll Torque Mult'), 0x3C8},
			{menuname('Handling', 'Turbulence Pitch Torque Mult'), 0x3CC},
			{menuname('Handling', 'Body Damage Control Effect'), 0x3D0},
			{menuname('Handling', 'Input Sensitivity For Difficulty'), 0x3D4},
			{menuname('Handling', 'On Ground Yaw Boost Speed Peak'), 0x3D8},
			{menuname('Handling', 'On Ground Yaw Boost Speed Cap'), 0x3DC},
			{menuname('Handling', 'Engine Off Glide Mult'), 0x3E0},
			{menuname('Handling', 'Afterburner Effect Radius'), 0x3E4},
			{menuname('Handling', 'Afterburner Effect Distance'), 0x3E8},
			{menuname('Handling', 'Afterburner Effect Force Mult'), 0x3EC},
			{menuname('Handling', 'Submerge Level To Pull Heli Underwater'), 0x3F0},
			{menuname('Handling', 'Extra Lift With Roll'), 0x3F4},
		},
		-- boat
		{
			{menuname('Handling', 'Box Front Mult'), 0x338},
			{menuname('Handling', 'Box Rear Mult'), 0x33C},
			{menuname('Handling', 'Box Side Mult'), 0x340},
			{menuname('Handling', 'Sample Top'), 0x344},
			{menuname('Handling', 'Sample Bottom'), 0x348},
			{menuname('Handling', 'Sample Bottom Test Correction'), 0x34C},
			{menuname('Handling', 'Aquaplane Force'), 0x350},
			{menuname('Handling', 'Aquaplane Push Water Mult'), 0x354},
			{menuname('Handling', 'Aquaplane Push Water Cap'), 0x358},
			{menuname('Handling', 'Aquaplane Push Water Apply'), 0x35C},
			{menuname('Handling', 'Rudder Force'), 0x360},
			{menuname('Handling', 'Rudder Offset Submerge'), 0x364},
			{menuname('Handling', 'Rudder Offset Force'), 0x368},
			{menuname('Handling', 'Rudder Offset Force Z Mult'), 0x36C},
			{menuname('Handling', 'Wave Audio Mult'), 0x370},
			{menuname('Handling', 'Look L R Cam Height'), 0x3A0},
			{menuname('Handling', 'Drag Coefficient'), 0x3A4},
			{menuname('Handling', 'Keel Sphere Size'), 0x3A8},
			{menuname('Handling', 'Prop Radius'), 0x3AC},
			{menuname('Handling', 'Low Lod Ang Offset'), 0x3B0},
			{menuname('Handling', 'Low Lod Draught Offset'), 0x3B4},
			{menuname('Handling', 'Impeller Offset'), 0x3B8},
			{menuname('Handling', 'Impeller Force Mult'), 0x3BC},
			{menuname('Handling', 'Dinghy Sphere Buoy Const'), 0x3C0},
			{menuname('Handling', 'Prow Raise Mult'), 0x3C4},
			{menuname('Handling', 'Deep Water Sample Buotancy Mult'), 0x3C8},
			{menuname('Handling', 'Transmission Multiplier'), 0x3CC},
			{menuname('Handling', 'Traction Multiplier'), 0x3D0}
		}
	}
}


function handling:load()
	local file = wiridir ..'\\handling\\' .. self.vehicle_name .. '.json'
	if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then 
		return
	end
	if not filesystem.exists(file) then 
		return notification.normal('File not found', NOTIFICATION_RED)
	end
	
	file = io.open(file, 'r')
	local content = file:read('a')
	file:close()
	if string.len(content) > 0 then
		local parsed = json.parse(content, false)
		local sethandling = function(offsets, s)
			for _, a in ipairs(offsets) do
				local addr = address_from_pointer_chain(worldptr, {0x08, 0xD30, 0x938, a[2]})
				if addr ~= NULL then
					memory.write_float(addr, parsed[s][a[1]])
				else notification.normal('Got a null address while trying to write ' .. a[2], NOTIFICATION_RED) end
			end
		end
		sethandling(self.offsets[1], 'handling')
		if parsed.flying ~= nil then sethandling(self.offsets[2], 'flying') end
		if parsed.boat ~= nil then sethandling(self.offsets[3], 'boat') end
		notification.normal(first_upper(self.vehicle_name) .. ' handling data loaded')
	end
end


function handling:save()
	if not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then 
		return
	end
	local table = {}
	local model = GET_USER_VEHICLE_MODEL(true)
	local file = wiridir ..'\\handling\\' .. self.vehicle_name .. '.json'
	local gethandling = function(offsets)
		local s = {}
		for _, a in ipairs(offsets) do
			local addr = address_from_pointer_chain(worldptr, {0x08, 0xD30, 0x938, a[2]})
			if addr ~= NULL then
				local value = memory.read_float(addr)
				s[ a[1] ] = value
			else notification.normal('Got a null address while trying to write ' .. a[2], NOTIFICATION_RED) end
		end
		return s
	end
	table.handling = gethandling(self.offsets[1])
	if IS_THIS_MODEL_AN_AIRCRAFT(model) then
		table.flying = gethandling(self.offsets[2])
	end
	if VEHICLE.IS_THIS_MODEL_A_BOAT(model) then
		table.boat = gethandling(self.offsets[3])
	end
	file = io.open(file, 'w')
	file:write(json.stringify(table, nil, 4))
	file:close()
	notification.normal(first_upper(self.vehicle_name) .. ' handling data saved')
end


function handling:create_actions(offsets, s)
	local t = {}
	table.insert(t, menu.divider(handling_editor, first_upper(s)))
	table.sort(offsets, function(a, b) return a[2] < b[2] end)
	
	for _, a in ipairs(offsets) do
		local action = menu.action(handling_editor, a[1], {}, '', function()
			local addr = address_from_pointer_chain(worldptr, {0x08, 0xD30, 0x938, a[2]})
			if addr == NULL then return end
			local value = round(memory.read_float(addr), 4)
			local nvalue = DISPLAY_ONSCREEN_KEYBOARD("BS_WB_VAL", 7, value)
			if nvalue == '' then return end
			if tonumber(nvalue) == nil then
				return notification.normal('Invalid input', NOTIFICATION_RED)
			elseif tonumber(nvalue) ~= value then
				memory.write_float(addr, tonumber(nvalue))
			end 
		end)
		menu.on_tick_in_viewport(action, function()
			self.inviewport[s] = self.inviewport[s] or {}
			if not includes(self.inviewport[s], a[1]) then
			   table.insert(self.inviewport[s], a)
			end
		end)
		  
		menu.on_focus(action, function()
			self.onfocus = a[1]
		end)
		
		table.insert(t, action)
	end
	return t
end

handling:create_actions(handling.offsets[1], 'handling')

-------------------------------------
-- VEHICLE DOORS
-------------------------------------

local doors_list = menu.list(vehicle_options, menuname('Vehicle', 'Vehicle Doors'), {}, '')

local doors = {
	'Driver Door',
	'Passenger Door',
	'Rear Left',
	'Rear Right',
	'Hood',
	'Trunk'
}

menu.divider(doors_list, menuname('Vehicle', 'Vehicle Doors'))

for i, door in ipairs(doors) do
	menu.toggle(doors_list, menuname('Vehicle - Vehicle Doors', door), {}, '', function(toggle)
		local vehicle = entities.get_user_vehicle_as_handle()
		if toggle then
			VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, (i-1), false, false)
		else
			VEHICLE.SET_VEHICLE_DOOR_SHUT(vehicle, (i-1), false)
		end
	end)
end

menu.toggle(doors_list, menuname('Vehicle - Vehicle Doors', 'All'), {}, '', function(toggle)
	local vehicle = entities.get_user_vehicle_as_handle()
	for i, door in ipairs(doors) do
		if toggle then
			VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, (i-1), false, false)
		else
			VEHICLE.SET_VEHICLE_DOOR_SHUT(vehicle, (i-1), false)
		end
	end
end)


-------------------------------------
-- VEHICLE INSTANT LOCK ON
-------------------------------------

menu.toggle(vehicle_options, menuname('Vehicle', 'Vehicle Instant Lock-On'), {}, '', function(toggle)
	vehlock = toggle
	local default = {}
	local offsets = {0x08, 0x10D8, 0x70, 0x60, 0x178}

	while vehlock do
		wait()
		local ptr = alloc()
		local addr = address_from_pointer_chain(worldptr, offsets)
		if addr ~= NULL then
			local value = memory.read_float(addr)
			if value ~= 0.0 then
				table.insert(default, {addr, value})
				memory.write_float(addr, 0.0)
			end
		end
	end

	if #default > 0 then
		for _, data in ipairs(default) do
			memory.write_float(table.unpack(data))
		end
	end
end)

-------------------------------------
-- VEHICLE EFFECTS
-------------------------------------

local effects = {
	-- Clown Appears
	{
		name 	= "scr_clown_appears",
		asset	= "scr_rcbarry2",
		scale	= 0.3,
		speed	= 500
	},
	-- Alien Impact
	{
		name 	= "scr_alien_impact_bul",
		asset	= "scr_rcbarry1",
		scale	= 1.0,
		speed	= 50
	},
	-- Electic Fire
	{
		name 	= "ent_dst_elec_fire_sp",
		asset 	= "core",
		scale 	= 0.8,
		speed	= 25
	}
}
local wheel_bones = {"wheel_lf", "wheel_lr", "wheel_rf", "wheel_rr"}
local items = {'Disable', 'Clown Appears', 'Alien Impact', 'Electic Fire'}
local current_effect
local vehicle_effect = menu.list(vehicle_options, menuname('Vehicle Effects', 'Vehicle Effects') .. ': ' .. menuname('Vehicle Effects', items[1]) )

for i, item in ipairs(items) do
	menu.action(vehicle_effect, menuname('Vehicle Effects', item), {}, '', function()
		current_effect = i
		menu.set_menu_name(vehicle_effect, menuname('Vehicle Effects', 'Vehicle Effects') .. ': ' .. menuname('Vehicle Effects', item) )
		menu.focus(vehicle_effect)
	end)
end

create_tick_handler(function()
	if current_effect == 1 then
		return true
	elseif current_effect ~= nil then
		local effect = effects[ current_effect - 1 ]
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), true)
		if vehicle == NULL then return true end
		REQUEST_PTFX_ASSET(effect.asset)
		for k, bone in pairs(wheel_bones) do
			GRAPHICS.USE_PARTICLE_FX_ASSET(effect.asset)
			GRAPHICS._START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY_BONE(
				effect.name,
				vehicle,
				0.0, 			--offsetX
				0.0, 			--offsetY
				0.0, 			--offsetZ
				0.0, 			--rotX
				0.0, 			--rotY
				0.0, 			--rotZ
				ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(vehicle, bone),
				effect.scale, 	--scale
				false, false, false
			)
		end
		wait(effect.speed)
	end
	return true
end)

-------------------------------------
-- AUTOPILOT
-------------------------------------

local driving_style_flag = {
	['Stop Before Vehicles'] 	= 1,
	['Stop Before Peds'] 		= 2,
	['Avoid Vehicles'] 			= 4,
	['Avoid Empty Vehicles'] 	= 8,
	['Avoid Peds'] 				= 16,
	['Avoid Objects']			= 32,
	['Stop At Traffic Lights'] 	= 128,
	['Reverse Only'] 			= 1024,
	['Take Shortest Path'] 		= 262144,
	['Ignore Roads'] 			= 4194304,
	['Ignore All Pathing'] 		= 16777216
}

local drivingstyle = 786988
local presets = {
	{
		'Normal', 
		'Stop before vehicles & peds, avoid empty vehicles & objects and stop at traffic lights.',
		786603
	},
	{
	  	'Ignore Lights',
	  	'Stop before vehicles, avoid vehicles & objects.', 
	  	2883621
	},
	{
	  	'Avoid Traffic',
	  	'Avoid vehicles & objects.', 
	  	786468
	},
	{
	  	'Rushed',
	  	'Stop before vehicles, avoid vehicles, avoid objects', 
	  	1074528293
	},
	{
	  	'Default',
	  	'Avoid vehicles, empty vehicles & objects, allow going wrong way and take shortest path', 
	  	786988
	}
}
local selected_flags = {}
local list_autopilot = menu.list(vehicle_options, menuname('Vehicle - Autopilot', 'Autopilot') )

menu.divider(list_autopilot, menuname('Vehicle - Autopilot', 'Autopilot') )


menu.toggle(list_autopilot, menuname('Vehicle - Autopilot', 'Autopilot'), {'autopilot'}, '', function(toggle)
	autopilot = toggle
	if autopilot then
		local lastblip
		local lastdrivstyle
		local lastspeed
		local drive_to_waypoint =  function()
			local vehicle = entities.get_user_vehicle_as_handle()
			if vehicle == NULL then return end
			local ptr = alloc()
			local coord = GET_WAYPOINT_COORDS()
			if not coord then
				notification.normal('Set a waypoint to start driving')
			else
				PED.SET_DRIVER_ABILITY(PLAYER.PLAYER_PED_ID(), 0.5);
				TASK.OPEN_SEQUENCE_TASK(ptr)
				TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(0, vehicle, coord.x, coord.y, coord.z, autopilot_speed or 25.0, drivingstyle, 45.0);
				TASK.TASK_VEHICLE_PARK(0, vehicle, coord.x, coord.y, coord.z, ENTITY.GET_ENTITY_HEADING(vehicle), 7, 60.0, true);
				TASK.CLOSE_SEQUENCE_TASK(memory.read_int(ptr));
				TASK.TASK_PERFORM_SEQUENCE(PLAYER.PLAYER_PED_ID(), memory.read_int(ptr))
				TASK.CLEAR_SEQUENCE_TASK(ptr)

				lastspeed = autopilot_speed or 25.0
				lastblip = HUD.GET_FIRST_BLIP_INFO_ID(8)
				lastdrivstyle = drivingstyle
				return coord
			end
		end
		local lastcoord = drive_to_waypoint()
		while autopilot do
			wait()
			local blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
			if drivingstyle ~= lastdrivstyle  then
				lastcoord = drive_to_waypoint()
				lastdrivstyle = drivingstyle
			end
			if blip ~= lastblip then
				lastcoord = drive_to_waypoint()
				lastblip = blip
			end
			if lastspeed ~= autopilot_speed then
				lastcoord = drive_to_waypoint()
				lastspeed = autopilot_speed
			end
		end
	else
		TASK.CLEAR_PED_TASKS(PLAYER.PLAYER_PED_ID())
	end
end)

local menu_driving_style = menu.list(list_autopilot, menuname('Vehicle - Autopilot', 'Driving Style'), {}, '')

menu.divider(menu_driving_style, menuname('Vehicle - Autopilot', 'Driving Style'))
menu.divider(menu_driving_style, menuname('Autopilot - Driving Style', 'Presets'))

for k, style in pairs(presets) do
	menu.action(menu_driving_style, menuname('Autopilot - Driving Style', style[ 1 ]), {}, style[ 2 ], function()
		drivingstyle = style[ 3 ]
	end)
end

menu.divider(menu_driving_style, menuname('Autopilot - Driving Style', 'Custom'))

for name, flag in pairs(driving_style_flag) do
	menu.toggle(menu_driving_style, menuname('Autopilot - Driving Style', name), {}, '', function(toggle) 
		local toggle = toggle
		if toggle then
			table.insert(selected_flags, flag)
		else selected_flags[ name ] = nil end
	end)
end

menu.action(menu_driving_style, menuname('Autopilot - Driving Style', 'Set Custom Driving Style'), {}, '', function()
	local style = 0
	for k, v in pairs(selected_flags) do
		style = style + v
	end
	drivingstyle = style
end)

menu.slider(list_autopilot, menuname('Vehicle - Autopilot', 'Speed'), {'autopilotspeed'}, '', 10, 200, 25, 1, function(speed)
	autopilot_speed = speed
end)

-------------------------------------
-- ENGINE ALWAYS ON
-------------------------------------

menu.toggle_loop(vehicle_options, menuname('Vehicle', 'Engine Always On'), {'alwayson'}, '', function()
	local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
	if ENTITY.DOES_ENTITY_EXIST(vehicle) then
		VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
		VEHICLE.SET_VEHICLE_LIGHTS(vehicle, 0)
		VEHICLE._SET_VEHICLE_LIGHTS_MODE(vehicle, 2)
	end
end)

---------------------
---------------------
-- BODYGUARD
---------------------
---------------------

local bodyguards_options = menu.list(menu.my_root(), menuname('Bodyguard Menu', 'Bodyguard Menu'), {'bodyguardmenu'}, '')

menu.divider(bodyguards_options, menuname('Bodyguard Menu', 'Bodyguard Menu'))

local bodyguard = {
	godmode 		= false,
	ignoreplayers 	= false,
	spawned 		= {},
	backup_godmode 	= false,
	formation 		= 0
}

menu.action(bodyguards_options, menuname('Bodyguard Menu', 'Spawn Bodyguard (7 Max)'), {'spawnbodyguard'}, '', function()
	local user_ped = PLAYER.PLAYER_PED_ID()
	local pos = ENTITY.GET_ENTITY_COORDS(user_ped)
	local ptr1 = alloc(32)
	local ptr2 = alloc(32)
	local groupId = PED.GET_PED_GROUP_INDEX(user_ped); PED.GET_GROUP_SIZE(groupId, ptr2, ptr1)
	local groupSize = memory.read_int(ptr1); memory.free(ptr1); memory.free(ptr2)
	if groupSize == 30 then
		return notification.normal('You reached the max number of bodyguards', NOTIFICATION_RED)
	end
	pos.x = pos.x + math.random(-3, 3)
	pos.y = pos.y + math.random(-3, 3)
	pos.z = pos.z - 1.0
	local model = bodyguard.model or random(peds)
	local weapon = bodyguard.weapon or random(weapons)
	local m_ped_hash = joaat(model)
	
	REQUEST_MODELS(m_ped_hash)
	local ped = entities.create_ped(29, m_ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	insert_once(bodyguard.spawned, model)
	NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(NETWORK.PED_TO_NET(ped), PLAYER.PLAYER_ID(), true)
	NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.PED_TO_NET(ped), true)
	WEAPON.GIVE_WEAPON_TO_PED(ped, joaat(weapon), -1, false, true)
	WEAPON.SET_CURRENT_PED_WEAPON(ped, joaat(weapon), false)
	PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
	PED.SET_PED_COMBAT_RANGE(ped, 2)
	PED.SET_PED_CONFIG_FLAG(ped, 208, true)
	PED.SET_PED_SEEING_RANGE(ped, 100.0)
	ENTITY.SET_ENTITY_INVINCIBLE(ped, bodyguard.godmode)
	PED.SET_PED_AS_GROUP_MEMBER(ped, groupId)
	PED.SET_PED_NEVER_LEAVES_GROUP(ped, true)
	PED.SET_GROUP_FORMATION(groupId, bodyguard.formation)
	PED.SET_GROUP_FORMATION_SPACING(groupId, 1.0, 0.9, 3.0)
	SET_ENT_FACE_ENT(ped, user_ped)
	
	if bodyguard.ignoreplayers then
		local relHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(PLAYER.PLAYER_PED_ID())
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, relHash)
	else 
		relationship:friendly(ped) 
	end
end)

local bodyguards_model_list = menu.list(bodyguards_options, menuname('Bodyguard Menu', 'Set Model') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '')

menu.divider(bodyguards_model_list, 'Bodyguard Model List')

menu.action(bodyguards_model_list, HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '', function()
	bodyguard.model = nil
	menu.set_menu_name(bodyguards_model_list, menuname('Bodyguard Menu', 'Set Model') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"))
	menu.focus(bodyguards_model_list)
end)

for k, model in pairs_by_keys(peds) do
	menu.action(bodyguards_model_list, menuname('Ped Models', k), {}, '', function()
		bodyguard.model = model
		menu.set_menu_name(bodyguards_model_list, menuname('Bodyguard Menu', 'Set Model') .. ': ' .. k)
		menu.focus(bodyguards_model_list)
	end)
end

menu.action(bodyguards_options, menuname('Bodyguard Menu', 'Clone Player (Bodyguard)'), {'clonebodyguard'}, '', function()
	local user_ped = PLAYER.PLAYER_PED_ID()
	local ptr1 = alloc(32)
	local ptr2 = alloc(32)
	local pos = ENTITY.GET_ENTITY_COORDS(user_ped)
	local groupId = PLAYER.GET_PLAYER_GROUP(players.user()); PED.GET_GROUP_SIZE(groupId, ptr2, ptr1)
	local groupSize = memory.read_int(ptr1); memory.free(ptr1); memory.free(ptr2)
	if groupSize >= 7 then
		return notification.normal('You reached the max number of bodyguards', NOTIFICATION_RED)
	end
	pos.x = pos.x + math.random(-3,3)
	pos.y = pos.y + math.random(-3,3)
	pos.z = pos.z - 1.0
	local weapon = bodyguard.weapon or random(weapons)
	
	local clone = PED.CLONE_PED(user_ped, 1, 1, 1)
	insert_once(bodyguard.spawned, "mp_f_freemode_01")
	insert_once(bodyguard.spawned, "mp_m_freemode_01")
	WEAPON.GIVE_WEAPON_TO_PED(clone, joaat(weapon), -1, false, true)
	WEAPON.SET_CURRENT_PED_WEAPON(clone, joaat(weapon), false)
	PED.SET_PED_HIGHLY_PERCEPTIVE(clone, true)
	PED.SET_PED_COMBAT_RANGE(clone, 2)
	PED.SET_PED_CONFIG_FLAG(clone, 208, true)
	PED.SET_PED_SEEING_RANGE(clone, 100.0)
	ENTITY.SET_ENTITY_COORDS(clone, pos.x, pos.y, pos.z)
	ENTITY.SET_ENTITY_INVINCIBLE(clone, bodyguard.godmode)
	PED.SET_PED_AS_GROUP_MEMBER(clone, groupId)
	PED.SET_PED_NEVER_LEAVES_GROUP(clone, true)
	PED.SET_GROUP_FORMATION(groupId, 0)
	PED.SET_GROUP_FORMATION_SPACING(groupId, 1.0, 0.9, 3.0)
	SET_ENT_FACE_ENT(clone, user_ped)
	ADD_BLIP_FOR_ENTITY(clone, 788, 53)
	if bodyguard.ignoreplayers then
		local relHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(PLAYER.PLAYER_PED_ID())
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(clone, relHash)
	else
		relationship:friendly(clone) 
	end
end)

-- bodyguards weapons
local bodyguards_weapon_list = menu.list(bodyguards_options, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"))
menu.divider(bodyguards_weapon_list, HUD._GET_LABEL_TEXT("PM_WEAPONS"))

local bodyguards_melee_list = menu.list(bodyguards_weapon_list, HUD._GET_LABEL_TEXT("VAULT_WMENUI_8"))

menu.divider(bodyguards_melee_list, HUD._GET_LABEL_TEXT("VAULT_WMENUI_8"))
local bodyguards_melee_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'melee_list'), {}, "")
local bodyguards_shotguns_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'shotguns_list'), {}, "")
local bodyguards_heavy_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'heavy_list'), {}, "")
local bodyguards_throwables_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'throwables_list'), {}, "")
local bodyguards_handguns_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'handguns_list'), {}, "")
local bodyguards_submachine_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'submachine_list'), {}, "")
local bodyguards_rifles_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'rifles_list'), {}, "")
local bodyguards_sniper_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'sniper_list'), {}, "")
local bodyguards_misc_list = menu.list(bodyguards_weapon_list, menuname('Sky_KoT', 'misc_list'), {}, "")


for label, weapon in pairs_by_keys(melee_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_melee_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(shotguns_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_shotguns_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(heavy_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_heavy_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(throwables_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_throwables_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(handguns_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_handguns_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(submachine_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_submachine_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(rifles_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_rifles_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(sniper_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_sniper_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

for label, weapon in pairs_by_keys(misc_weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_misc_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end
--[[
--]]
menu.action(bodyguards_weapon_list, HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"), {}, '', function()
	bodyguard.weapon = nil
	menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. HUD._GET_LABEL_TEXT("SR_GUN_RANDOM"))
	menu.focus(bodyguards_weapon_list)
end)

for label, weapon in pairs_by_keys(weapons) do
	local strg = HUD._GET_LABEL_TEXT(label)
	menu.action(bodyguards_weapon_list, strg, {}, '', function()
		bodyguard.weapon = weapon
		menu.set_menu_name(bodyguards_weapon_list, menuname('Bodyguard Menu', 'Set Weapon') .. ': ' .. strg)
		menu.focus(bodyguards_weapon_list)
	end)
end

menu.toggle(bodyguards_options, menuname('Bodyguard Menu', 'Invincible Bodyguard'), {'bodyguardsgodmode'}, '', function(toggle)
	bodyguard.godmode = toggle
end)

menu.toggle(bodyguards_options, menuname('Bodyguard Menu', 'Ignore Players'), {}, '', function(toggle)
	bodyguard.ignoreplayers = toggle
end)

local formation = menu.list(bodyguards_options, menuname('Bodyguard Menu', 'Group Formation') .. ': ' .. menuname('Bodyguard Menu - Group Formation', formations[1][1] ), {}, '')

for _, value in ipairs(formations) do
	menu.action(formation, menuname('Bodyguard Menu - Group Formation', value[1]) , {}, '', function()
		bodyguard.formation = value[2]
		local group = PED.GET_PED_GROUP_INDEX(PLAYER.PLAYER_PED_ID())
		PED.SET_GROUP_FORMATION(group, bodyguard.formation)
		menu.set_menu_name(formation, menuname('Bodyguard Menu', 'Group Formation') .. ': ' .. menuname('Bodyguard Menu - Group Formation', value[1]) )
		menu.focus(formation)
	end)
end

menu.action(bodyguards_options, menuname('Bodyguard Menu', 'Delete Bodyguards'), {}, '', function()
	local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(p, false)
	for _, model in ipairs(bodyguard.spawned) do
		DELETE_PEDS(model)
	end
	bodyguard.spawned = {}
end)
-------------------------------------
-- BACKUP HELICOPTER
-------------------------------------

local backup_heli_option = menu.list(bodyguards_options,  menuname('Bodyguard Menu', 'Backup Helicopter'))
menu.divider(backup_heli_option, menuname('Bodyguard Menu', 'Backup Helicopter'))


menu.action(backup_heli_option, menuname('Bodyguard Menu - Backup Helicopter', 'Spawn Backup Helicopter'), {'backupheli'}, '', function()
	local heli_hash = joaat("buzzard2")
	local ped_hash = joaat("s_m_y_blackops_01")
	local user_ped = PLAYER.PLAYER_PED_ID()
	local pos = ENTITY.GET_ENTITY_COORDS(user_ped)
	pos.x = pos.x + math.random(-20, 20)
	pos.y = pos.y + math.random(-20, 20)
	pos.z = pos.z + 30
	
	REQUEST_MODELS(ped_hash, heli_hash)
	relationship:friendly(user_ped)
	local heli = entities.create_vehicle(heli_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	
	if not ENTITY.DOES_ENTITY_EXIST(heli) then 
		notification.normal(menuname('Notification', 'Failed to create vehicle. Please try again'), NOTIFICATION_RED)
		return
	else
		local heliNetId = NETWORK.VEH_TO_NET(heli)
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(NETWORK.NET_TO_PED(heliNetId)) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(heliNetId, true)
		end
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(heliNetId, players.user(), true)
		ENTITY.SET_ENTITY_INVINCIBLE(heli, godmode)
		VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
		VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
		VEHICLE.SET_VEHICLE_SEARCHLIGHT(heli, true, true)
		ENTITY.SET_ENTITY_INVINCIBLE(heli, bodyguard.backup_godmode)
		ADD_BLIP_FOR_ENTITY(heli, 422, 46)
	end

	local pilot = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)
	PED.SET_PED_MAX_HEALTH(pilot, 500)
	ENTITY.SET_ENTITY_HEALTH(pilot, 500)
	ENTITY.SET_ENTITY_INVINCIBLE(pilot, bodyguard.backup_godmode)
	PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
	TASK.TASK_HELI_MISSION(pilot, heli, 0, user_ped, 0.0, 0.0, 0.0, 23, 40.0, 40.0, -1.0, 0, 10, -1.0, 0)
	PED.SET_PED_KEEP_TASK(pilot, true)
	
	for seat = 1, 2 do
		local ped = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		local pedNetId = NETWORK.PED_TO_NET(ped)
		
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ped) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(pedNetId, true)
		end
		
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(pedNetId, players.user(), true)
		PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
		WEAPON.GIVE_WEAPON_TO_PED(ped, joaat("weapon_mg"), -1, false, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 3, false)
		PED.SET_PED_COMBAT_MOVEMENT(ped, 2)
		PED.SET_PED_COMBAT_ABILITY(ped, 2)
		PED.SET_PED_COMBAT_RANGE(ped, 2)
		PED.SET_PED_SEEING_RANGE(ped, 100.0)
		PED.SET_PED_TARGET_LOSS_RESPONSE(ped, 1)
		PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
		PED.SET_PED_VISUAL_FIELD_PERIPHERAL_RANGE(ped, 400.0)
		PED.SET_COMBAT_FLOAT(ped, 10, 400.0)
		PED.SET_PED_MAX_HEALTH(ped, 500)
		ENTITY.SET_ENTITY_HEALTH(ped, 500)
		ENTITY.SET_ENTITY_INVINCIBLE(ped, bodyguard.backup_godmode)
		
		if bodyguard.ignoreplayers then
			local relHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(PLAYER.PLAYER_PED_ID())
			PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, relHash)
		else
			relationship:friendly(ped)
		end
	end	
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
end)

menu.action(backup_heli_option, menuname('Bodyguard Menu - Backup Helicopter', 'ANNIHILATOR'), {'backupheli'}, '', function()
	local heli_hash = joaat("ANNIHILATOR")
	local ped_hash = joaat("s_m_y_blackops_01")
	local user_ped = PLAYER.PLAYER_PED_ID()
	local pos = ENTITY.GET_ENTITY_COORDS(user_ped)
	pos.x = pos.x + math.random(-20, 20)
	pos.y = pos.y + math.random(-20, 20)
	pos.z = pos.z + 30
	
	REQUEST_MODELS(ped_hash, heli_hash)
	relationship:friendly(user_ped)
	local heli = entities.create_vehicle(heli_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	
	if not ENTITY.DOES_ENTITY_EXIST(heli) then 
		notification.normal(menuname('Notification', 'Failed to create vehicle. Please try again'), NOTIFICATION_RED)
		return
	else
		local heliNetId = NETWORK.VEH_TO_NET(heli)
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(NETWORK.NET_TO_PED(heliNetId)) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(heliNetId, true)
		end
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(heliNetId, players.user(), true)
		ENTITY.SET_ENTITY_INVINCIBLE(heli, godmode)
		VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
		VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
		VEHICLE.SET_VEHICLE_SEARCHLIGHT(heli, true, true)
		ENTITY.SET_ENTITY_INVINCIBLE(heli, bodyguard.backup_godmode)
		ADD_BLIP_FOR_ENTITY(heli, 422, 46)
	end

	local pilot = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)
	PED.SET_PED_MAX_HEALTH(pilot, 500)
	ENTITY.SET_ENTITY_HEALTH(pilot, 500)
	ENTITY.SET_ENTITY_INVINCIBLE(pilot, bodyguard.backup_godmode)
	PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
	TASK.TASK_HELI_MISSION(pilot, heli, 0, user_ped, 0.0, 0.0, 0.0, 23, 40.0, 40.0, -1.0, 0, 10, -1.0, 0)
	PED.SET_PED_KEEP_TASK(pilot, true)
	
	for seat = 1, 2 do
		local ped = entities.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		local pedNetId = NETWORK.PED_TO_NET(ped)
		
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ped) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(pedNetId, true)
		end
		
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(pedNetId, players.user(), true)
		PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
		WEAPON.GIVE_WEAPON_TO_PED(ped, joaat("weapon_mg"), -1, false, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 3, false)
		PED.SET_PED_COMBAT_MOVEMENT(ped, 2)
		PED.SET_PED_COMBAT_ABILITY(ped, 2)
		PED.SET_PED_COMBAT_RANGE(ped, 2)
		PED.SET_PED_SEEING_RANGE(ped, 100.0)
		PED.SET_PED_TARGET_LOSS_RESPONSE(ped, 1)
		PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
		PED.SET_PED_VISUAL_FIELD_PERIPHERAL_RANGE(ped, 400.0)
		PED.SET_COMBAT_FLOAT(ped, 10, 400.0)
		PED.SET_PED_MAX_HEALTH(ped, 500)
		ENTITY.SET_ENTITY_HEALTH(ped, 500)
		ENTITY.SET_ENTITY_INVINCIBLE(ped, bodyguard.backup_godmode)
		
		if bodyguard.ignoreplayers then
			local relHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(PLAYER.PLAYER_PED_ID())
			PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, relHash)
		else
			relationship:friendly(ped)
		end
	end	
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
end)

menu.toggle(backup_heli_option, menuname('Bodyguard Menu - Backup Helicopter', 'Invincible Backup'), {'backupgodmode'}, '', function(toggle)
bodyguard.backup_godmode = toggle
end)

menu.action(backup_heli_option, menuname('Sky_KoT', 'Delete Backup Helicopter'), {'backupgodmode'}, '', function()
local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
local pos = ENTITY.GET_ENTITY_COORDS(p, false)
--DELETE_NEARBY_VEHICLES(pos, 50000.0)
DELETE_NEARBY_VEHICLES(pos, "buzzard2", 50000.0)
--DELETE_NEARBY_PEDS(pos, "s_m_y_blackops_01", 50000.0)
end)

---------------------
---------------------
-- WORLD
---------------------
---------------------

local world_options = menu.list(menu.my_root(), menuname('World', 'World'), {}, '')

menu.divider(world_options, menuname('World', 'World'))

-------------------------------------
-- JUMPING CARS
-------------------------------------

menu.toggle_loop(world_options, menuname('World', 'Jumping Cars'), {}, '', function(toggle)
	local entities = GET_NEARBY_VEHICLES(PLAYER.PLAYER_ID(), 150)
	for _, vehicle in ipairs(entities) do
		REQUEST_CONTROL(vehicle)
		ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, 0, 0, 6.5, 0, 0, 0, 0, false, false, true)
	end
	wait(1500)
end)

-------------------------------------
-- KILL ENEMIES
-------------------------------------

menu.action(world_options, menuname('World', 'Kill Enemies'), {'killenemies'}, '', function()
	local peds = GET_NEARBY_PEDS(PLAYER.PLAYER_ID(), 500)
	for _, ped in ipairs(peds) do
		local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(PLAYER.PLAYER_PED_ID(), ped)
		if not ENTITY.IS_ENTITY_DEAD(ped) and ( (rel == 4 or rel == 5) or PED.IS_PED_IN_COMBAT(ped, PLAYER.PLAYER_PED_ID()) ) then
			local pos = ENTITY.GET_ENTITY_COORDS(ped)
			FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(), pos.x, pos.y, pos.z, 1, 1.0, true, false, 0.0)
		end
	end
end)

menu.toggle_loop(world_options, menuname('World', 'Auto Kill Enemies'), {'autokillenemies'}, '', function()
	local peds = GET_NEARBY_PEDS(players.user(), 500)
	for _, ped in ipairs(peds) do
		local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(PLAYER.PLAYER_PED_ID(), ped)
		if not ENTITY.IS_ENTITY_DEAD(ped) and ( (rel == 4 or rel == 5) or PED.IS_PED_IN_COMBAT(ped, PLAYER.PLAYER_PED_ID()) ) then
			local pos = ENTITY.GET_ENTITY_COORDS(ped)
			FIRE.ADD_OWNED_EXPLOSION(PLAYER.PLAYER_PED_ID(), pos.x, pos.y, pos.z, 1, 1.0, true, false, 0.0)
		end
	end
end)


-------------------------------------
--ANGRY PLANES
-------------------------------------

local planes = {
	'besra',
	'dodo',
	'avenger',
	'microlight',
	'molotok',
	'bombushka',
	'howard',
	'duster',
	'luxor2',
	'lazer',
	'nimbus',
	'shamal',
	'stunt',
	'titan',
	'velum2',
	'miljet',
	'mammatus',
	'besra',
	'cuban800',
	'seabreeze',
	'alphaz1',
	'mogul',
	'nokota',
	'strikeforce',
	'vestra',
	'tula',
	'rogue'
}
local spawned = {}

menu.toggle(world_options, menuname('World', 'Angry Planes'), {}, '', function(toggle)
	angryplanes = toggle
	
	if not angryplanes then
		for index, value in ipairs(spawned) do
			entities.delete_by_handle(value [1])
			entities.delete_by_handle(value [2])
			spawned [index] = nil
		end
		return 
	end

	local ped_hash = joaat("s_m_y_blackops_01")
	REQUEST_MODELS(ped_hash)

	while angryplanes do
		if #spawned < 50 then
			local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
			local theta = (math.random() + math.random(0, 1)) * math.pi
			local radius = math.random(50, 150)
			local plane_hash = joaat(random(planes))
			
			REQUEST_MODELS(plane_hash)
			local plane = VEHICLE.CREATE_VEHICLE(plane_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, false)
			if ENTITY.DOES_ENTITY_EXIST(plane) then
				NETWORK.SET_NETWORK_ID_CAN_MIGRATE(NETWORK.VEH_TO_NET(plane), false)
				ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(plane, true)

				local pilot = PED.CREATE_PED(26, ped_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z, true, true)
				spawned [1 + #spawned] = {plane, pilot}
				PED.SET_PED_INTO_VEHICLE(pilot, plane, -1)

				pos = vect.new(
					pos.x + radius * math.cos(theta),
					pos.y + radius * math.sin(theta),
					pos.z + 200
				)

				VEHICLE._SET_VEHICLE_JET_ENGINE_ON(plane, true)
				ENTITY.SET_ENTITY_COORDS(plane, pos.x, pos.y, pos.z)
				ENTITY.SET_ENTITY_HEADING(plane, math.deg(theta))
				VEHICLE.SET_VEHICLE_FORWARD_SPEED(plane, 60)
				VEHICLE.SET_HELI_BLADES_FULL_SPEED(plane)
				VEHICLE.CONTROL_LANDING_GEAR(plane, 3)
				VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(plane, true)
				TASK.TASK_PLANE_MISSION(pilot, plane, 0, PLAYER.PLAYER_PED_ID(), 0, 0, 0, 6, 100, 0, 0, 80, 50)
			end
		end
		wait(500)
	end
end)

-------------------------------------
-- HEALTH BAR
-------------------------------------

local items = {'Disable', 'Players', 'Peds', 'Players & Peds', 'Aimed Ped'}
local current_health_bar
local health_bars = menu.list(world_options, menuname('World', 'Draw Health Bar') .. ': ' .. menuname('World - Draw Health Bar', items[1]))

for i, name in ipairs(items) do
	menu.action(health_bars, menuname('World - Draw Health Bar', name), {}, '', function()
		current_health_bar = i
		menu.set_menu_name(health_bars, menuname('World', 'Draw Health Bar') .. ': ' .. menuname('World - Draw Health Bar', name))
		menu.focus(health_bars)	
	end)
end

create_tick_handler(function()
	if current_health_bar == 1 then -- disable
		return true
	elseif current_health_bar == 2 then -- players
		for _, player in ipairs(players.list(false)) do
			local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player)
			draw_health_on_ped(ped, 250)
		end
	elseif current_health_bar == 3 then -- peds
		local peds = GET_NEARBY_PEDS(PLAYER.PLAYER_ID(), 300)
		for _, ped in ipairs(peds) do
			if not PED.IS_PED_A_PLAYER(ped) and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(PLAYER.PLAYER_PED_ID(), ped, 1) then
				draw_health_on_ped(ped, 250)
			end
		end
	elseif current_health_bar == 4 then -- players & peds
		local peds = GET_NEARBY_PEDS(PLAYER.PLAYER_ID(), 300)
		for _, ped in ipairs(peds) do
			if ped ~= PLAYER.PLAYER_PED_ID() and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(PLAYER.PLAYER_PED_ID(), ped, 1) then
				draw_health_on_ped(ped, 250)
			end
		end
	elseif current_health_bar == 5 then -- aimed ped
		if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_ID()) then
			local entity = NULL
			local ptr = alloc(32)
			if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), ptr) then
				entity = memory.read_int(ptr)
			end
			memory.free(ptr)
			if entity ~= NULL and ENTITY.IS_ENTITY_A_PED(entity) then
				draw_health_on_ped(entity, 500)
			end
		end
	end
	return true
end)

---------------------
---------------------
-- SETTINGS--Настройки
---------------------
---------------------

local settings = menu.list(menu.my_root(),menuname('Settings', 'Settings'), {''}, '')

menu.divider(settings, menuname('Settings', 'Settings'))


menu.action(settings, menuname('Settings', 'Save Settings'), {}, '', function()
	ini.save(config_file, config)
	notification.normal('Конфигурация сохранена')
end)

-------------------------------------
-- LANGUAGE
-------------------------------------

local language_settings = menu.list(settings, menuname('Settings', 'language'))

menu.divider(language_settings, menuname('Settings', 'language'))


menu.action(language_settings, menuname('Settings', 'Create New Translation'), {}, menuname('Settings', 'Creates a file you can use to make a new WiriScript translation'), function()
	local file = wiridir .. '\\new translation.json'
	local content = json.stringify(features, nil, 4)
	file = io.open(file,'w')
	file:write(content)
	file:close()
	notification.normal('File: new translation.json was created')
end)

if config.general.language ~= 'english' then
	menu.action(language_settings, menuname('Settings', 'Update Translation'), {}, menuname('Settings', 'Creates an updated translation file that has all the missing features'), function()
		local t = swap_values(features, menunames)
		local file = wiridir .. config.general.language .. ' (update).json'
		local content = json.stringify(t, nil, 4)
		file = io.open(file, 'w')
		file:write(content)
		file:close()
		notification.normal('File: ' .. config.general.language .. ' (update).json, was created')
	end)
end

menu.divider(language_settings, '°°°')


if config.general.language ~= 'english' then
	local actionId
	actionId = menu.action(language_settings, 'English', {}, '', function()
		config.general.language = 'english'
		ini.save(config_file, config)
		menu.show_warning(actionId, CLICK_MENU, menuname('Help', 'Would you like to restart the script now to apply the language setting?'), function()
			util.stop_script()
		end)
	end)
end

for _, path in ipairs(filesystem.list_files(languagedir)) do
	local filename, ext = string.match(path, '^.+\\(.+)%.(.+)$')
	if ext == 'json' and config.general.language ~= filename then
		local actionId
		actionId = menu.action(language_settings, first_upper(filename), {}, '', function()
			config.general.language = filename
			ini.save(config_file, config)
            menu.show_warning(actionId, CLICK_MENU, 'Would you like to restart the script now to apply the language setting?', function()
                util.stop_script()	
            end)
		end)
	end
end

-------------------------------------

menu.toggle(settings, menuname('Settings', 'Display Health Text'), {'displayhealth'}, menuname('Help', 'If health is going to be displayed while using Mod Health'), function(toggle)
	config.general.displayhealth = toggle
end, config.general.displayhealth)


local healthtxt = menu.list(settings, menuname('Settings', 'Health Text Position'), {}, '')
local _x, _y =  directx.get_client_size()

menu.slider(healthtxt, 'X', {'healthx'}, '', 0, _x, round(_x * config.healthtxtpos.x) , 1, function(x)
	config.healthtxtpos.x = round(x /_x, 4)
end)

menu.slider(healthtxt, 'Y', {'healthy'}, '', 0, _y, round(_y * config.healthtxtpos.y), 1, function(y)
	config.healthtxtpos.y = round(y /_y, 4)
end)


menu.toggle(settings, menuname('Settings', 'Stand Notifications'), {'standnotifications'}, menuname('Help', 'Turns to Stand\'s notification appearance'), function(toggle)
	config.general.standnotifications = toggle
end, config.general.standnotifications)


-------------------------------------
-- CONTROLS
-------------------------------------

local control_settings = menu.list(settings, menuname('Settings', 'Controls') , {}, '')

menu.divider(control_settings, menuname('Settings', 'Controls'))


local airstrike_plane_control = menu.list(control_settings, menuname('Settings - Controls', 'Airstrike Aircraft'), {}, '')

for name, control in pairs(imputs) do
	local keyboard, controller = control[1]:match('^(.+)%s?;%s?(.+)$')
	local strg = "Keyboard: ".. keyboard .. ", Controller: " .. controller
	menu.action(airstrike_plane_control, strg, {}, "", function()
		config.controls.airstrikeaircraft = control[2]
		util.show_corner_help(menuname('Notification', 'Press ') .. ('~%s~ '):format(name) .. menuname('Notification', ' to use Airstrike Aircraft'))
	end)
end

local vehicle_weapons_control = menu.list(control_settings, menuname('Settings - Controls', 'Vehicle Weapons'), {}, '')

for name, control in pairs(imputs) do
	local keyboard, controller = control[1]:match('^(.+)%s?;%s?(.+)$')
	local strg = "Keyboard: ".. keyboard .. ", Controller: " .. controller
	menu.action(vehicle_weapons_control, strg, {}, "", function()
		config.controls.vehicleweapons = control[2]
		util.show_corner_help('Press ' .. ('~%s~ '):format(name) .. ' to use Vehicle Weapons')
	end)
end

menu.toggle(settings, menuname('Settings', 'Disable Lock-On Sprites'), {}, menuname('UFO', 'Disables the boxes that UFO draws on players.'), function(toggle)
	config.general.disablelockon = toggle
end, config.general.disablelockon)


menu.toggle(settings, menuname('Settings', 'Disable Vehicle Gun Preview'), {}, '', function(toggle)
	config.general.disablepreview = toggle
end, config.general.disablepreview)


-------------------------------------
-- HANDLING EDITOR CONFIG
-------------------------------------

local handling_editor_settings = menu.list(settings, menuname('Settings', 'Handling Editor'), {}, '')

menu.divider(handling_editor_settings, menuname('Settings', 'Handling Editor'))


local onfocuscolour = Colour.Normalize(config.onfocuscolour)

menu.colour(handling_editor_settings, menuname('Settings - Handling Editor', 'Focused Text Colour'), {'onfocuscolour'}, '', onfocuscolour, false, function(new)
	onfocuscolour = new
	config.onfocuscolour = Colour.Integer(new)
end)


local highlightcolour = Colour.Normalize(config.highlightcolour)

menu.colour(handling_editor_settings, menuname('Settings - Handling Editor', 'Highlight Colour'), {'highlightcolour'}, '', highlightcolour, false, function(new)
	highlightcolour = new
	config.highlightcolour = Colour.Integer(new)
end)


local buttonscolour = Colour.Normalize(config.buttonscolour)

menu.colour(handling_editor_settings, menuname('Settings - Handling Editor', 'Buttons Colour'), {'buttonscolour'}, '', buttonscolour, false, function(new)
	buttonscolour = new
	config.buttonscolour = Colour.Integer(new)
end)

-------------------------------------

menu.toggle(settings, menuname('Settings', 'Busted Features'), {}, menuname('Help', 'Allows you to use some previously removed features. Requires to save save settings and restart.'), function(toggle)
	config.general.bustedfeatures = toggle
	if config.general.bustedfeatures then
		notification.help(menuname('Notification', 'Please save settings and restart the script'))
	end
end, config.general.bustedfeatures)
---------------------
---------------------
-- WIRISCRIPT
---------------------
---------------------

--local script = menu.list(menu.my_root(), 'WiriScript', {}, '')

menu.divider(settings, 'WiriScript')

menu.action(settings, menuname('WiriScript', 'Show Credits'), {}, '', function()
	if showing_intro then return end
	
	local state = 0
	local stime = cTime()
	local i = 1
	local delay = 0
	local ty = {
		'DeF3c',
		'Hollywood Collins',
		'Murten',
		'QuickNET',
		'komt',
		'Ren',
		'ICYPhoenix',
		'Koda',
		'jayphen',
		'Fwishky',
		'Polygon',
		'Sainan',
		'NONECKED',
		{'wiriscript', "HUD_COLOUR_BLUE"}
	}

	AUDIO.SET_MOBILE_RADIO_ENABLED_DURING_GAMEPLAY(true)
	AUDIO.SET_MOBILE_PHONE_RADIO_STATE(true)
	AUDIO.SET_RADIO_TO_STATION_NAME("RADIO_16_SILVERLAKE")
	AUDIO.SET_CUSTOM_RADIO_TRACK_LIST("RADIO_16_SILVERLAKE", "SEA_RACE_RADIO_PLAYLIST", true)

	create_tick_handler(function()
		local scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE("OPENING_CREDITS")
		
		while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(scaleform) do
			wait()
		end
	
		if cTime() - stime >= delay and state == 0 then
			SETUP_SINGLE_LINE(scaleform)
			ADD_TEXT_TO_SINGLE_LINE(scaleform, ty[i][1] or ty[i], "$font2", ty[i][2] or "HUD_COLOUR_WHITE")
			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_SINGLE_LINE")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
		
			GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_CREDIT_BLOCK")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
			GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
			GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
		
			state = 1
			i = i + 1
			delay = 4000
			stime = cTime()
		end
	
		if cTime() - stime >= 4000 and state == 1 then
			HIDE(scaleform)
			state = 0
			stime = cTime()
		end
	
		if state == 1 and i == #ty + 1 then
			state = 2
			stime = cTime()
		end

		if cTime() - stime >= 3000 and state == 2 then
			AUDIO.START_AUDIO_SCENE("CAR_MOD_RADIO_MUTE_SCENE")
			wait(5000)
			AUDIO.SET_MOBILE_RADIO_ENABLED_DURING_GAMEPLAY(false)
			AUDIO.SET_MOBILE_PHONE_RADIO_STATE(false)
			AUDIO.CLEAR_CUSTOM_RADIO_TRACK_LIST("RADIO_01_CLASS_ROCK")
			AUDIO.SKIP_RADIO_FORWARD()
			AUDIO.STOP_AUDIO_SCENE("CAR_MOD_RADIO_MUTE_SCENE")
			return false
		end

		if PAD.IS_CONTROL_JUST_PRESSED(2, 194)  then
			state = 2
			stime = cTime()
		elseif state ~= 2 then
		
			if instructional:begin() then
				add_control_instructional_button(194, "REPLAY_SKIP_S")
				instructional:set_background_colour(0, 0, 0, 80)
				instructional:draw()
			end
		end

		HUD.HIDE_HUD_AND_RADAR_THIS_FRAME()
		HUD._HUD_WEAPON_WHEEL_IGNORE_SELECTION()
		GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)
		return true
	end)
end)


developer(menu.toggle_loop, menu.my_root(), 'Address Picker', {}, 'Developer', function()
	if PLAYER.IS_PLAYER_FREE_AIMING(PLAYER.PLAYER_ID()) then
		local ptr = alloc(32)
		if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), ptr) then
			entity = memory.read_int(ptr)
		end
		memory.free(ptr)
		if entity and entity ~= NULL then
			if ENTITY.IS_ENTITY_A_PED(entity) and PED.IS_PED_IN_ANY_VEHICLE(entity, false) then
				local vehicle  = PED.GET_VEHICLE_PED_IS_IN(entity, false)
				entity = vehicle
			end
			
			local strg
			local ptrX = alloc()
			local ptrY = alloc()
			draw_box_esp(entity, Colour.New(255, 0, 0))
			local pos = ENTITY.GET_ENTITY_COORDS(entity)
			GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(pos.x, pos.y, pos.z, ptrX, ptrY)
			local posX = memory.read_float(ptrX); memory.free(ptrX)
			local posY = memory.read_float(ptrY); memory.free(ptrY)
			local addr = entities.handle_to_pointer(entity)
			
			if addr ~= NULL then
				local addr_hex = string.format("%x", addr)
				strg = string.upper(addr_hex)
			else 
				strg = 'NULL' 
			end

			local lenX, lenY = directx.get_text_size(strg, 0.5)
			GRAPHICS.DRAW_RECT(posX, posY, lenX, lenY, 0, 0, 0, 120)
			directx.draw_text(posX, posY, strg, ALIGN_CENTRE, 0.5, Colour.New(1.0, 1.0, 1.0))
			if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) and addr ~= NULL then
				util.copy_to_clipboard(strg)
			end
		end
	end
end)


developer(menu.action, menu.my_root(), 'CPedFactory', {}, '', function()
	local hex = string.format("%x", worldptr)
	util.copy_to_clipboard(string.upper( hex ))
end)


menu.hyperlink(settings, menuname('WiriScript', 'Join WiriScript FanClub'), 'https://cutt.ly/wiriscript-fanclub', menuname('WiriScript', 'Join us in our fan club, created by komt.'))

menu.hyperlink(settings, menuname('WiriScript', 'Discord'), 'https://discord.gg/Bm3P5w5fB9', menuname('WiriScript', 'Join us in our fan club, created by komt.'))

menu.hyperlink(settings, menuname('WiriScript', 'GitHub'), 'https://github.com/nowiry/WiriScript', menuname('WiriScript', 'Join us in our fan club, created by komt.'))

for _, pId in ipairs(players.list()) do
	generate_features(pId)
end
players.on_join(generate_features)

-------------------------------------
--ON STOP
-------------------------------------

util.on_stop(function()
	if handling.cursor_mode then
		UI.toggle_cursor_mode(false)
	end
	if bulletchanger then
		SET_BULLET_TO_DEFAULT()
	end
	if speed_mult ~= 1.0 then
		SET_AMMO_SPEED_MULT(1.0)
	end

	ufo.on_stop()
	guided_missile.on_stop()

	if usingprofile then
		if spoofname then 
			menu.trigger_commands('spoofname off') 
		end

		if spoofrid then 
			menu.trigger_commands('spoofrid off') 
		end
		
		if spoofcrew then 
			menu.trigger_commands('crew off') 
		end
	end

	if carpetride then
		local m_object_hash = joaat("p_cs_beachtowel_01_s")
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
		local obj = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(pos.x, pos.y, pos.z, 10.0, m_object_hash, false, 0, 0)
		if ENTITY.DOES_ENTITY_EXIST(obj) and ENTITY.IS_ENTITY_ATTACHED_TO_ENTITY(PLAYER.PLAYER_PED_ID(), obj) then
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
			ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), true, false)
			ENTITY.SET_ENTITY_VISIBLE(obj, false)
			entities.delete_by_handle(obj)
		end
	end

	if autopilot then
		TASK.CLEAR_PED_TASKS(PLAYER.PLAYER_PED_ID())
	end

end)


while true do
	wait()

	guided_missile.main_loop()
	ufo.main_loop()

	if speed_mult ~= 1.0 then
		SET_AMMO_SPEED_MULT(speed_mult)
	end

	local vehicle = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), true)
	
	if vehicle ~= 0 then
		local vehicleHash = ENTITY.GET_ENTITY_MODEL(vehicle)
		vehicleName = HUD._GET_LABEL_TEXT(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(vehicleHash))
		if vehicleHash ~= lastVehicle then
			lastVehicle = vehicleHash
		end
	else
		vehicleName = '???'
	end
-------------------------------------
--HANDLING DISPLAY
-------------------------------------

	if handling.display_handling then
		handling.vehicle_name = GET_USER_VEHICLE_NAME()
		handling.vehicle_model = GET_USER_VEHICLE_MODEL(true)

		if PAD.IS_CONTROL_JUST_PRESSED(2, 323) or PAD.IS_DISABLED_CONTROL_JUST_PRESSED(2, 323) then
			UI.toggle_cursor_mode()
			handling.cursor_mode = not handling.cursor_mode
		end

		UI.set_highlight_colour(highlightcolour.r, highlightcolour.g, highlightcolour.b)
		UI.begin(menuname('Handling', 'Vehicle Handling'), handling.window_x, handling.window_y)
		
		UI.label(menuname('Handling', 'Current Vehicle'), handling.vehicle_name)

		for s, l in pairs(handling.inviewport) do
			if #s > 0 then
				local subhead = first_upper(s)
				UI.subhead(subhead)
				for _, a in ipairs(l) do
					local addr = address_from_pointer_chain(worldptr, {0x08, 0xD30, 0x938, a[2]})
					local value
					
					if addr == NULL then
						value = '???'
					else
						value = round(memory.read_float(addr), 3)
					end
					
					if a[1] == handling.onfocus then
						UI.label(a[1] .. ':\t', value, onfocuscolour, onfocuscolour)
					else
						UI.label(a[1] .. ':\t', value)
					end
				end
			end
		end

		if menu.is_open() then 
			handling.inviewport = {}
			if IS_THIS_MODEL_AN_AIRCRAFT(handling.vehicle_model) and #handling.flying == 0 then
				handling.flying = handling:create_actions(handling.offsets[2], 'flying')
			end
			
			if not IS_THIS_MODEL_AN_AIRCRAFT(handling.vehicle_model) and #handling.flying > 0 then
				for i, Id in ipairs(handling.flying) do
					menu.delete(Id)
				end
				handling.flying = {}
			end
			
			if VEHICLE.IS_THIS_MODEL_A_BOAT(handling.vehicle_model) and #handling.boat == 0 then
				handling.boat = handling:create_actions(handling.offsets[3], 'boat')
			end
			
			if not VEHICLE.IS_THIS_MODEL_A_BOAT(handling.vehicle_model) and #handling.boat > 0 then
				for i, Id in ipairs(handling.boat) do
					menu.delete(Id)		
				end
				handling.boat = {}
			end
		end

		UI.divider()
		UI.start_horizontal()
		   
		if UI.button(menuname('Handling', 'Save Handling'), buttonscolour, Colour.Mult(buttonscolour, 0.6)) then
			handling:save()
		end

		if UI.button(menuname('Handling', 'Load Handling'), buttonscolour, Colour.Mult(buttonscolour, 0.6)) then
			handling:load()
		end
		
		UI.end_horizontal()
		handling.window_x, handling.window_y = UI.finish()

		if instructional:begin() then
			add_control_instructional_button(323, menuname('Handling', 'Cursor mode'))
			instructional:set_background_colour(0, 0, 0, 80)
			instructional:draw()
		end

	end
end
