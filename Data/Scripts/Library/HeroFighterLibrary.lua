--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            HeroFighterLibrary.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2021-05-25T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
function Get_Hero_Entries(upgrade_object)
	--Index is name of build option to open popup. For ground units tied to an orbiting unit, it is the rebuild option if one exists, or a dummy value that should not match the name of any buildable unit if it does not
	--Hero_Squadron = name of spawned squadron. Can be a table to define multiple options
	--PopupHeader = name of header object for popup
	--Options = first item in sublist is popup option suffix. Locations is a list of all heroes who are associated with this option. Optionally, GroundPerception is the perception to detect these heroes for ground forms.
	--NoInit = optional parameter to prevent fighter from being automatically assigned to the first found hero on startup
	--Faction = Primary owner who is the only valid init. Optional, and Factions[1] will serve the same purpose if not defined
	--Factions = specifies faction list for ground reinforcement perceptions. If a primary faction exists it should be specified first for efficiency
	--NoPlayerInit  = NoInit if Faction is Human. Requires Faction/Factions
	--GroundCompany = name of company to add to reinforcements when squadron/ship is in orbit. Requires GroundPerception and Factions. Can be a table to define multiple options
	--NoSpawnFlag = name of global variable that will prevent spawn. If used the squadron will not be cleared even if Enabler is set
	--Enabler = name of object used to reenable ground forms of fighter squadrons when killed. If not set the hero will not be unassigned and disabled
	--DeathMessage = The string to display when a GroundCompany is killed. Optional field
	--Hero_Squadron and GroundCompany multiple values default to the first listed. Others are accessed through Set_Fighter_Hero_Index and Set_Fighter_Hero_Ground_Index, with arguements of the index and name of the new value
	
	--When piggybacking reinforcement system to check for orbital object instead of squadron, set a dummy index that does not match any buildable object and set NoInit to prevent all the missing fields from causing errors. 
	--GroundReinforcementPerception = the perception to detect when a unit is in orbit. Requires Faction and GroundCompany
	--NoSpawnFlag = name of global variable that will prevent spawn

	--WARNING: using indexes with too long of names can prevent them from working in grount tactical. It makes no sense, but watch that
	local heroes = {
		-- Sith
		["NIHILUS_RECOVER"] = {
			NoInit = true,
			GroundReinforcementPerception = "Nihilus_In_Orbit",
			GroundCompany = "NIHILUS_MASTER_TEAM",
			Factions = {"Rebel"},
			NoSpawnFlag = "GROUND_NIHILUS_DEAD",
			DeathMessage = "Darth Nihilus requires sustenance to fight further.",
		},
		["WELEX_KOROFU_SITH_LOCATION_SET"] = {
			Hero_Squadron = "WELEX_KOROFU_AUREK_SQUADRON",
			PopupHeader = "WELEX_KOROFU_SELECTOR_HEADER",
			Options = {
				{"SCHERP", Locations = {"SCHERP_AVARICE"}},
				{"KARATH_SITH", Locations = {"KARATH_LEVIATHAN"}},
				{"ROOKS", Locations = {"ROOKS_SUPREMACY"}},
				{"VARKO", Locations = {"VARKO_TRIUMPH_OF_TARIS", "VARKO_TEARS_OF_TARIS"}},
				{"MON_HALAN", Locations = {"MON_HALAN_SWIFTSURE"}},
			}
		},
		-- Republic
		["CARTH_ONASI_LANCE_LOCATION_SET"] = {
			Hero_Squadron = "CARTH_ONASI_LANCE_SQUADRON",
			Factions = {"Empire"},
			PopupHeader = "CARTH_ONASI_LANCE_SELECTOR_HEADER",
			Options = {
				{"KARATH_REP", Locations = {"KARATH_RECIPROCITY","KARATH_SWIFTSURE","KARATH_COURAGEOUS","KARATH_LEVIATHAN_REPUBLIC"}, GroundPerception = "Karath_In_Orbit"},
				{"SOMMOS", Locations = {"SOMMOS_SWIFTSURE","SOMMOS_TREMENDOUS"}, GroundPerception = "Sommos_In_Orbit"},
				{"DODONNA", Locations = {"DODONNA_HAMMERHEAD"}, GroundPerception = "Dodonna_In_Orbit"},
				{"OPELLE", Locations = {"OPELLE_CENTURION"}, GroundPerception = "Opelle_In_Orbit"},
			},
			GroundCompany = "CARTH_MW_TEAM",
			NoSpawnFlag = "GROUND_CARTH_DEAD",
			DeathMessage = "Carth Onasi has been severely injured and removed from ground duty.",
		},
		["JERRIT_LOCATION_SET"] = {
			Hero_Squadron = "JERRIT_AUREK_SQUADRON",
			Factions = {"Empire"},
			PopupHeader = "JERRIT_SELECTOR_HEADER",
			Options = {
				{"TELETTOH", Locations = {"TELETTOH_TESTAMENT"}, GroundPerception = "Telettoh_In_Orbit"},
				{"KARATH_REP", Locations = {"KARATH_RECIPROCITY","KARATH_SWIFTSURE","KARATH_COURAGEOUS","KARATH_LEVIATHAN_REPUBLIC"}, GroundPerception = "Karath_In_Orbit"},
				{"MODL", Locations = {"BASK_MODL_SWIFTSURE"}, GroundPerception = "Modl_In_Orbit"},
				{"MORVIS", Locations = {"MORVIS_RECIPROCITY", "MORVIS_VELTRAA", "MORVIS_DILIGENCE"}, GroundPerception = "Morvis_In_Orbit"},
			},
			GroundCompany = "JERRIT_TEAM",
			NoSpawnFlag = "GROUND_JERRIT_DEAD",
			DeathMessage = "Lt. Jerrit has been severely injured and removed from ground duty.",
		},
		["JHAKA_BAKARN_LOCATION_SET"] = {
			Hero_Squadron = "JHAKA_BAKARN_CHELA_SQUADRON",
			PopupHeader = "JHAKA_BAKARN_SELECTOR_HEADER",
			Options = {
				{"BAKVALEN", Locations = {"TREDE_BAKVALEN_CENTURION"}},
				{"MORVIS", Locations = {"MORVIS_RECIPROCITY", "MORVIS_VELTRAA", "MORVIS_DILIGENCE"}},
				{"DODONNA", Locations = {"DODONNA_HAMMERHEAD"}},
				{"ROKON", Locations = {"ROKON_HAMMERHEAD"}},
			}
		},
		["ODIS_LOCATION_SET"] = {
			Hero_Squadron = "ODIS_DYNAMIC_FREIGHTER_SQUADRON",
			PopupHeader = "ODIS_SELECTOR_HEADER",
			Options = {
				{"CEDE", Locations = {"CEDE_INTERDICTOR"}},
				{"OPELLE", Locations = {"OPELLE_CENTURION"}},
				{"SOMMOS", Locations = {"SOMMOS_SWIFTSURE","SOMMOS_TREMENDOUS"}},
				{"VANG", Locations = {"TEELO_VANG_STALWART", "TEELO_VANG_INTERDICTOR"}},
			}
		},
		["RUTU_LOCATION_SET"] = {
			Hero_Squadron = "RUTU_REPUBLIC_HEAVY_BOMBER_SQUADRON",
			Factions = {"Empire"},
			PopupHeader = "RUTU_SELECTOR_HEADER",
			Options = {
				{"DELSTAR", Locations = {"OWEN_DELSTAR_SWIFTSURE"}, GroundPerception = "Delstar_In_Orbit"},
				{"ATHACORR", Locations = {"ATHACORR_AXEHEAD", "ATHACORR_STALWART"}, GroundPerception = "Athacorr_In_Orbit"},
				{"MODL", Locations = {"BASK_MODL_SWIFTSURE"}, GroundPerception = "Modl_In_Orbit"},
				{"SOMMOS", Locations = {"SOMMOS_SWIFTSURE","SOMMOS_TREMENDOUS"}, GroundPerception = "Sommos_In_Orbit"},
			},
			GroundCompany = "RUTU_TEAM",
			NoSpawnFlag = "GROUND_RUTU_DEAD",
			DeathMessage = "Lt. Rutu has been severely injured and removed from ground duty.",
		},
		["WELEX_KOROFU_REP_LOCATION_SET"] = {
			Hero_Squadron = "WELEX_KOROFU_AUREK_SQUADRON",
			PopupHeader = "WELEX_KOROFU_SELECTOR_HEADER",
			Options = {
				{"ROKON", Locations = {"ROKON_HAMMERHEAD"}},
				{"CEDE", Locations = {"CEDE_INTERDICTOR"}},
				{"VANG", Locations = {"TEELO_VANG_STALWART", "TEELO_VANG_INTERDICTOR"}},
				{"TELETTOH", Locations = {"TELETTOH_TESTAMENT"}},
			}
		},
		["REBUILD_SCROPE"] = {
			NoInit = true,
			GroundReinforcementPerception = "Morvis_In_Orbit",
			GroundCompany = "SCROPE_TEAM",
			Factions = {"Empire"},
			NoSpawnFlag = "SCROPE_COMMAND_SKIFF_DEAD",
			DeathMessage = "Scrope's Command Skiff has been damaged and requires repairs to be deployed again.",
		},
		["REVAN_JEDI_RECOVER"] = {
			NoInit = true,
			GroundReinforcementPerception = "Revan_In_Orbit",
			GroundCompany = "REVAN_JEDI_MW_TEAM",
			Factions = {"Empire"},
			NoSpawnFlag = "GROUND_REVAN_JEDI_DEAD",
			DeathMessage = "Supreme Commander Revan needs to recuperate.",
			EnablementFlag = "REVAN_INTERDICTOR_FORM",
		},
		-- Mandalorians
		["RECOVER_MANDALORE_ULTIMATE"] = {
			NoInit = true,
			GroundReinforcementPerception = "Mandalore_In_Orbit",
			GroundCompany = "MANDALORE_ULTIMATE_VIBROSWORD_TEAM",
			Factions = {"Underworld"},
			NoSpawnFlag = "MANDALORE_ULTIMATE_VIBROSWORD_DEAD",
			DeathMessage = "Our Mandalore needs to recuperate.",
		},
		["REBUILD_VEELA_ORDO_BASILISK"] = {
			NoInit = true,
			GroundReinforcementPerception = "Veela_Ordo_In_Orbit",
			GroundCompany = "VEELA_ORDO_TEAM",
			Factions = {"Underworld"},
			NoSpawnFlag = "VEELA_ORDO_BASILISK_DEAD",
			DeathMessage = "Veela Ordo's Basilisk has been damaged and requires repairs to be deployed again.",
		},
		["JAGI_SKULL_LOCATION_SET"] = {
			Hero_Squadron = "JAGI_SKULL_SQUADRON",
			Factions = {"Underworld"},
			PopupHeader = "JAGI_SKULL_SELECTOR_HEADER",
			Options = {
				{"CASSUS", Locations = {"FETT_JAIGALAAR","FETT_GRATUA"}, GroundPerception = "Cassus_In_Orbit"},
				{"BENDAK", Locations = {"GORSE_BENDAK_EXPLORER"}, GroundPerception = "Bendak_In_Orbit"},
				{"BORM", Locations = {"BORM_PARJAI"}, GroundPerception = "Borm_Parjai_In_Orbit"},
				{"TEGRIS", Locations = {"TEGRIS_ORDO_CLANSHIP"}, GroundPerception = "Tegris_Ordo_In_Orbit"},
				{"XARGA", Locations = {"XARGA_SHAADLAR_MANDALORIAN"}, GroundPerception = "Xarga_In_Orbit"},
			},
			GroundCompany = "JAGI_TEAM",
			NoSpawnFlag = "GROUND_JAGI_DEAD",
			DeathMessage = "Jagi has been severely injured and removed from ground duty.",
		},
		["VIPER_ALPHA_SQUADRON_LOCATION_SET"] = {
			Hero_Squadron = "VIPER_ALPHA_SQUADRON",
			PopupHeader = "VIPER_ALPHA_SELECTOR_HEADER",
			Options = {
				{"BORM", Locations = {"BORM_PARJAI"}},
				{"BENDAK", Locations = {"GORSE_BENDAK_EXPLORER"}},
				{"CASSUS", Locations = {"FETT_JAIGALAAR","FETT_GRATUA"}},
				{"KRAAKE", Locations = {"KRAAKE_AXEHEAD"}},
				{"VIPSANIS", Locations = {"VIPSANIS_VICTUS"}},
			}
		},
		["GRIZZER_GETAL_SQUADRON_LOCATION_SET"] = {
			Hero_Squadron = "GRIZZER_GETAL_SQUADRON",
			PopupHeader = "GRIZZER_GETAL_SELECTOR_HEADER",
			Options = {
				{"TEGRIS", Locations = {"TEGRIS_ORDO_CLANSHIP"}},
				{"VEELA", Locations = {"VEELA_ORDO_CLANSHIP"}},
				{"VIPSANIS", Locations = {"VIPSANIS_VICTUS"}},
				{"XARGA", Locations = {"XARGA_SHAADLAR_MANDALORIAN"}},
			}
		},
		-- RR_Enhanced
		["RECOVER_CASSUS_FETT"] = {
			NoInit = true,
			GroundReinforcementPerception = "Cassus_In_Orbit",
			GroundCompany = "CASSUS_FETT_TEAM",
			Factions = {"Underworld"},
			NoSpawnFlag = "CASSUS_FETT_GROUND_DEAD",
			DeathMessage = "Cassus Fett has suffered critical injuries and must heal before returning.",
		},
	}

	if upgrade_object ~= nil then
		return heroes[upgrade_object]
	end
	return heroes
end

function Get_Hero_Upgrade(upgrade_object)
	--Define Setter and NewObject of an entry with the index being the name of a dummy object that triggers the change
	local upgrades = {
	}
	return upgrades[upgrade_object]
end