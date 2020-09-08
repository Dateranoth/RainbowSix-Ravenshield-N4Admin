/*  N4IDMod is a modification that provides unique username for N4Admin server to use.
    This allows compatibility with OpenRVS which allows multiplayer games again.
    Copyright (C) 2020 Dateranoth, .Twi

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

class N4IDMod extends Actor config(N4IDMod);

var config string StatServerURL;
var string sWelcomeMessage;


event BeginPlay()
{
    StartupMessage();
    LoadConfig();
    if (StatServerURL == "mywebsite.com" || StatServerURL == "")
    {
        StatServerURL = "mywebsite.com";
        SaveConfig();
        log("[N4IDMod] Stat URL still set to default. Please update N4IDMod.ini StatServerURL with your stat server website.");
        sWelcomeMessage = "[N4IDMod] Please contact the server admin to access your stats.";
    }
    else
    {
        sWelcomeMessage = "[N4IDMod] See your stats from this server at"@StatServerURL;
    }
	SetTimer(1.0,true);
}

//checks for new players entering the server
//creates a client on them, which handles retrieving the variables
simulated function Timer()
{
	local R6PlayerController PC;
	local Controller C;
	local N4IDClient Client;
	
	for ( C = Level.ControllerList; C != none; C = C.NextController )
	{
		PC = R6PlayerController(C);
		if ( ( PC != none ) && ( PC.m_TeamSelection != PTS_UnSelected ) )
		{
			foreach PC.ChildActors(class'N4IDClient',Client)
			{
				if ( Client != none )
				{
					Client.GetIDAndPass(sWelcomeMessage);
					break;
				}
			}
			if ( Client == none )
				Client = spawn(class'N4IDClient',PC);
		}
	}
}

// Prints the N4IDMod startup message
static function StartupMessage()
{
    log("");
	log("********************************** N4IDMod V1.0 ********************************************");
    log("*    N4IDMod is a modification that provides unique username for N4Admin server to use.    *");
    log("*    This allows compatibility with OpenRVS which allows multiplayer games again.          *");
    log("*    Copyright (C) 2020 Dateranoth, .Twi                                                   *");
    log("*                                                                                          *");
    log("*    This program is free software: you can redistribute it and/or modify                  *");
    log("*    it under the terms of the GNU General Public License as published by                  *");
    log("*    the Free Software Foundation, either version 3 of the License, or                     *");
    log("*    (at your option) any later version.                                                   *");
    log("*                                                                                          *");
    log("*    This program is distributed in the hope that it will be useful,                       *");
    log("*    but WITHOUT ANY WARRANTY; without even the implied warranty of                        *");
    log("*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                         *");
    log("*    GNU General Public License for more details.                                          *");
    log("*                                                                                          *");
    log("*    You should have received a copy of the GNU General Public License                     *");
    log("*    along with this program.  If not, see <https://www.gnu.org/licenses/>.                *");
	log("********************************** N4IDMod V1.0 ********************************************");
    log("");
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bHidden=true
	bAlwaysRelevant=true
    StatServerURL=""
}