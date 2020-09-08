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

class N4IDClient extends Actor config(N4IDList);

var config Array<string> UserID;
var config Array<string> UserKey;
var config Array<string> UserSalt;
var bool bSentInfo;

replication
{
    reliable if ( Role == ROLE_Authority )
        GetIDAndPass;
    reliable if ( Role < ROLE_Authority )
        VerifyN4IDAndPass;
}

//Runs on the client
//Checks for a ubi ID and password
//If no ubi ID, it will use Nickname.
//If no ubi password, it will generate a random one.
//Passes username and password to server for verification.
simulated function GetIDAndPass(string sMOTD)
{
    local R6PlayerController PC;
    local string SHAPassHash;
    local int counter;
    
    if ( Level.NetMode == NM_DedicatedServer )
        return;
    if ( !bSentInfo )
    {
        PC = R6PlayerController(class'Actor'.static.GetCanvas().Viewport.Actor);
        if ( ( PC != none ) && ( PC.m_GameService != none ) )
        {
            ReplaceText(PC.m_GameService.m_szUserID, "?", "");
            ReplaceText(PC.m_GameService.m_szUserID, ",", "");
            ReplaceText(PC.m_GameService.m_szUserID, "#", "");
            ReplaceText(PC.m_GameService.m_szUserID, "/", "");
            ReplaceText(PC.m_GameService.m_szUserID, " ", "");            
            if ( PC.m_GameService.m_szUserID == "" )
            {
                PC.m_GameService.m_szUserID = PC.PlayerReplicationInfo.PlayerName; //No ID exists. Set ID to current Player Name
            }
            ReplaceText(R6GSServers(PC.m_GameService).m_szPassword, "?", "");
            ReplaceText(R6GSServers(PC.m_GameService).m_szPassword, ",", "");
            ReplaceText(R6GSServers(PC.m_GameService).m_szPassword, "#", "");
            ReplaceText(R6GSServers(PC.m_GameService).m_szPassword, "/", "");
            ReplaceText(R6GSServers(PC.m_GameService).m_szPassword, " ", ""); 
            if ( R6GSServers(PC.m_GameService).m_szPassword == "" )         
            {
                R6GSServers(PC.m_GameService).m_szPassword = class'DiceWords'.static.GetPassPhrase(8,true); //Generate Random Password
                R6GSServers(PC.m_GameService).m_szSavedPwd = R6GSServers(PC.m_GameService).m_szPassword; //Place Random Password in Saved Password Field so it is remembered.
            }   
            PC.PlayerReplicationInfo.m_szUbiUserID = PC.m_GameService.m_szUserID;
            R6GSServers(PC.m_GameService).SaveConfig();
            SaveConfig();

            SHAPassHash = class'SHA1Hash'.static.GetStringHashString(R6GSServers(PC.m_GameService).m_szPassword);
            VerifyN4IDAndPass(PC.m_GameService.m_szUserID,SHAPassHash, PC);
            PC.ClientMessage(sMOTD);            
            bSentInfo = true;//when server gets info, set this var so that the check for info doesn't keep running
        }
    }
}

//Server receives this info from the client
//Check UserID and Password.
//If UserID does not exists, creates a new user and saves to N4IDList.ini.
//If UserID does exists, verifies password.
//If password matches, UserID is updated on server to be used as UbiID on N4Admin.
//If password does not match, random string is added to end of UserID for use on N4Admin.
//Notifies player of login status.
function VerifyN4IDAndPass(string sID,string sPass, R6PlayerController PC)
{   
    //Check UserID and Password.
    local int i;
    local string sTSalt;
    local bool bUserExists;
    LoadConfig();
    if (UserID.Length != UserKey.Length || UserID.Length != UserSalt.Length)
    {
        log("[N4IDMod] ERROR - UserID parameters("@UserID.Length@")and User Key parameters("@UserKey.Length@")and User Salt parameters("@Usersalt.Length@")are not the same length. Please reset N4IDList.ini or remove mismatching ID||Key||Salt.");
        PC.PlayerReplicationInfo.m_szUbiUserID = sID$"_"$GenerateSalt(8);
        
        PC.ClientMessage("[N4IDMod] Login Failed for User:"@sID@"due to N4IDMod setup problem");
        PC.ClientMessage("[N4IDMod] Stats will be logged with the following UserID:"@PC.PlayerReplicationInfo.m_szUbiUserID);
        PC.ClientMessage("[N4IDMod] Please Notify Server Owner");
    }
    else
    {
        bUserExists = false;
        for (i=0; i<UserID.Length; i++)
        {
            if (UserID[i] == sID)
            {
                if (UserKey[i] == class'SHA1Hash'.static.GetStringHashString(sPass $ UserSalt[i]))
                {
                    PC.PlayerReplicationInfo.m_szUbiUserID = sID;
                    log("[N4IDMod] Login Accepted for User:"@sID);
                    PC.ClientMessage("[N4IDMod] Successfully Joined Server as User:"@sID);
                }
                else
                {
                    PC.PlayerReplicationInfo.m_szUbiUserID =  sID$"_"$GenerateSalt(8);
                    log("[N4IDMod] Login Failed for User"@sID@"Generated Temp Name"@PC.PlayerReplicationInfo.m_szUbiUserID);
                    
                    PC.ClientMessage("[N4IDMod] Login Failed (incorrect password or name already taken) for User:"@sID);
                    PC.ClientMessage("[N4IDMod] Stats will be logged with the following name:"@PC.PlayerReplicationInfo.m_szUbiUserID);
                    PC.ClientMessage("[N4IDMod] To correct, open RavenShield.ini and change the username in m_szUserID or correct the password in m_szSavedPwd");
                    PC.ClientMessage("[N4IDMod] Otherwise, on next login another random identifier will be assigned");
                }
                bUserExists = true;
                break;
            }
        }
        if (!bUserExists)
        {
            sTSalt = GenerateSalt(20);
            UserID[UserID.Length] = sID;
            UserSalt[UserSalt.Length] = sTSalt;
            UserKey[UserKey.Length] = class'SHA1Hash'.static.GetStringHashString(sPass$sTSalt);
            PC.PlayerReplicationInfo.m_szUbiUserID = sID;
            log("[N4IDMod] Created New User:"@sID);
            
            PC.ClientMessage("[N4IDMod] Successfully Joined Server as new User:"@sID);
            PC.ClientMessage("[N4IDMod] It is recommended you backup your password in RavenShield.ini under m_szSavedPwd");
        }
    }
    SaveConfig();
}

//Return Letter Number string based on input.
function string GenerateSalt(int iLength)
{
    local int x,i;
    local Array<string> aLetterNumber;
    local string sSalt, sLetterNumber;
    
    sSalt = "";
    sLetterNumber = "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ0123456789";
    for(x=0; x<Len(sLetterNumber); x++)
    {
        aLetterNumber[x] = Mid(sLetterNumber,x,1);
    }
    for(i=0; i<iLength; i++)
    {
        sSalt = sSalt $ aLetterNumber[Rand(aLetterNumber.Length)];
    }
    return sSalt;
    
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysTick=true
    bHidden=true
    bAlwaysRelevant=true
}