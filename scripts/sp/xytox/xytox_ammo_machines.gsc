#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;


xytox_ammo_machine_init()
{
	level thread xytox_vars();
	level thread init_XytoxAmmomatic();
	level thread thread_restarter(); //Important for servers!
}

XytoxAmmomatic( origin, angles ) //Orginal code from ZeiiKeN. Edited to make cool ammomatic machine.
{
	collision = spawn("script_model", ( (origin[0]), (origin[1]), (origin[2] + 50)) ); //adding 50 units on Z cord to prevent people from jumping on top of this using some exploit
    collision setModel("collision_geo_32x32x128");
    collision rotateTo(angles, .1);
	collision hide();

	vender_ammo = spawn( "script_model", origin );
	vender_ammo setModel( "zombie_vending_doubletap_on" );
	vender_ammo rotateTo(angles, .1);
	vender_ammo thread maps\_zombiemode_perks::perk_fx( "revive_light" ); //put it blue because some idiot might think it's the actual doubletap machine

	trig = spawn("trigger_radius", origin, 1, 25, 25);
	trig SetCursorHint( "HINT_NOICON" );
	
	if(level.script == "zombie_cod5_prototype" || level.script == "zombie_cod5_sumpf" )
	{
		trig setHintString("Press ^3&&1^7 to Buy Ammo [Cost: " + level.xytox_ammo + "]");
	}
	else if( level.script == "zombie_moon" )
	{
		trig SetHintString( &"ZOMBIE_NEED_POWER" );
		level waittill("doubletap_on");
	}
	else
	{
		trig SetHintString( &"ZOMBIE_NEED_POWER" );
		level waittill("juggernog_on");
	}
	
	trig setHintString("Press ^3&&1^7 to Buy Ammo [Cost: " + level.xytox_ammo + "]");
	for(;;)
	{
		level waittill("notifier_1");

		trig thread dispense_ammo();
	}
}

dispense_ammo()
{
	level endon("notifier_2"); 
	
	for(;;)
	{
		self waittill( "trigger", who );

		weapon = who GetCurrentWeapon();
      	ammocount = who getammocount(weapon);
      	clipcount = who getweaponammoclip(weapon);
      	maxammo = weaponmaxammo(weapon);
		
		if( who UseButtonPressed() && (maxammo <= ammocount - clipcount) )
		{
            while( who UseButtonPressed() )
			{
				wait 0.05;
			}
			who playsound("evt_perk_deny");
            continue;
		}
		else if( who UseButtonPressed() && (who.score >= level.xytox_ammo) && !(maxammo <= ammocount - clipcount))
		{
			while( who UseButtonPressed() )
			{
				wait 0.05;
			}
			//Blacklisted weapons
			if( who GetCurrentWeapon() == "ray_gun_zm" || 
				who GetCurrentWeapon() == "ray_gun_upgraded_zm" ||
				who GetCurrentWeapon() == "thundergun_zm" ||
				who GetCurrentWeapon() == "thundergun_upgraded_zm" ||
				who GetCurrentWeapon() == "freezegun_upgraded_zm" || 
				who GetCurrentWeapon() == "freezegun_zm" ||
				who GetCurrentWeapon() == "tesla_gun_zm" ||
				who GetCurrentWeapon() == "tesla_gun_upgraded_zm" ||
				who GetCurrentWeapon() == "m1911_upgraded_zm" ||
				who GetCurrentWeapon() == "humangun_zm" ||
				who GetCurrentWeapon() == "humangun_upgraded_zm" ||
				who GetCurrentWeapon() == "sniper_explosive_zm" ||
				who GetCurrentWeapon() == "sniper_explosive_upgraded_zm" ||
				who GetCurrentWeapon() == "shrink_ray_zm" ||
				who GetCurrentWeapon() == "shrink_ray_upgraded_zm" ||
				who GetCurrentWeapon() == "microwavegun_zm" ||
				who GetCurrentWeapon() == "microwavegun_upgraded_zm" ||
				who GetCurrentWeapon() == "microwavegundw_zm" ||
				who GetCurrentWeapon() == "microwavegundw_upgraded_zm"
				)
			{
				while( who UseButtonPressed() )
				{
					wait 0.05;
				}

				who iPrintLn("You cannot buy ammo for a ^0blacklisted^7 weapon!"); //Comment this if you want to print a message for players
				who playSound("zmb_no_cha_ching");
				continue;
			}
			else
			{
				while( who UseButtonPressed() )
				{
					wait 0.05;
				}

				who givemaxammo( who GetCurrentWeapon() );
				who maps\_zombiemode_score::minus_to_player_score( level.xytox_ammo );
				who playSound("zmb_cha_ching");
			}
		}
		else if( who UseButtonPressed() && !(who.score >= level.xytox_ammo) )
		{
			who playSound("zmb_no_cha_ching");
			who maps\_zombiemode_audio::create_and_play_dialog( "general", "door_deny", undefined, 1 );
			while( who UseButtonPressed() )
			{
				wait 0.05;
			}
		}
	}
}


init_XytoxAmmomatic() //Thanks for Soliderror for helping pick the spots in the waw maps
{
	if( level.enable_xytox_ammo == 1 )
	{
		//BO1 Maps
		if(level.script == "zombie_theater") //Kino Der Toten
		{
			level thread XytoxAmmomatic(  (-818, -1049, 80), (0, -90, 0) ); //In fire trap room, behind trap switch
		}
		else if(level.script == "zombie_pentagon") //"Five"
		{
			level thread XytoxAmmomatic(  (-1478, 1700, -512), (0, 180, 0) ); //Next to jugg
		}
		else if(level.script == "zombie_cosmodrome") //Ascension
		{
			level thread XytoxAmmomatic( (-1833.255, 2201.54, -83.875), (0, -90, 0) ); //Against the wall near PHD
		}
		else if(level.script == "zombie_coast") //Call of The Dead
		{
			level thread XytoxAmmomatic(  (-493, 955, 255), (0, 360, 0) ); //Below the floor at PHD
		}
		else if(level.script == "zombie_temple") //Shangri La
		{
			level thread XytoxAmmomatic(  (905, -2020, -173), (0, -180, 0) ); //The area where jugg is, between 2 barriers
		}
		else if(level.script == "zombie_moon") //Moon
		{
			level thread XytoxAmmomatic(  (-1438.5, 1135, -250.875), (0, 90, 0) ); //In the room heading towards tunnel 11
		}
		else if(level.script == "zombie_cod5_prototype") //Nacht Der Untoten
		{
			level thread XytoxAmmomatic( (56, 563, 2), (0, 360, 0) );//In spawn
		}
		else if(level.script == "zombie_cod5_asylum") //Verruckt
		{
			level thread XytoxAmmomatic(  (-568, 968, 226), (0, 0, 0) );//In the room near speed cola 
		}
		else if(level.script == "zombie_cod5_sumpf") //Shi No Numa
		{
			level thread XytoxAmmomatic(  (10118.6, 982.349, -528.375), (0, 90, 0) ); //next to spawn room
		}
		else if(level.script == "zombie_cod5_factory") //Der Riese
		{
			level thread XytoxAmmomatic(  (-444, -1047, 67), (0, 0, 0) ); //In the furnace room
		}
	}
}

xytox_vars()
{
	vars_check(); //Checks the vars value, defaults them if not changed.

	//Value of the Ammomattic machine cost for all maps. Default: 2500
	level.xytox_ammo = getDvarint( "xytox_ammo_cost");
	
	//Enabled Ammomatic machines. Default: 1
	level.enable_xytox_ammo = getDvarint("xytox_enable_ammo");
}

vars_check()
{
	if( getDvar("xytox_ammo_cost") == "" )
	{
		SetDvar("xytox_ammo_cost", 2500);
	}

	if( getDvar("xytox_enable_ammo") == "" )
	{
		setDvar("xytox_enable_ammo", 1);
	}
}

thread_restarter() //In dedi servers, the trigger thread breaks in random reasons. This ensures every 10 seconds the thread restarts automatically
{
	wait 5;
	for(;;)
	{
		level notify("notifier_1");
		wait 10;
		level notify("notifier_2");
	}
}
