//TODO: Add thanks / originally written by .Twi

class N4IDClient extends Actor config(N4IDList);

var config Array<string> UserID;
var config Array<string> UserKey;
var config string UserSalt;
var bool bSentInfo;

replication
{
	reliable if ( Role == ROLE_Authority )
		GetIDAndPass;
	reliable if ( Role < ROLE_Authority )
		ReturnIDAndPass;
}

//runs on the client
//checks for a ubi ID and password
//can add later  randomly generate unique id
simulated function GetIDAndPass()
{
	local R6PlayerController PC;
	local string SHAPassHash;
    
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
            if (UserSalt == "" || Len(UserSalt) < 20)
            {
                UserSalt = GenerateSalt(20);
            }
            PC.PlayerReplicationInfo.m_szUbiUserID = PC.m_GameService.m_szUserID;
            R6GSServers(PC.m_GameService).SaveConfig();
            SaveConfig();       
			SHAPassHash = class'SHA1Hash'.static.GetStringHashString(R6GSServers(PC.m_GameService).m_szPassword $ UserSalt);
			ReturnIDAndPass(PC.PlayerReplicationInfo.PlayerName,PC.m_GameService.m_szUserID,SHAPassHash, PC);
            bSentInfo = true;//when server gets info, set this var so that the check for info doesn't keep running
		}
	}
}

//server receives this info from the client
function ReturnIDAndPass(string sName,string sID,string sPass, R6PlayerController PC)
{   
    //TODO: Verify PlayerID against INI. If ID exists, verify it against password. If password good, change userID to report to N4, if not, notify user and change ID to Anonymous.
    //TODO: Only update INI with new users
    PC.PlayerReplicationInfo.m_szUbiUserID = sID;
    UserID[UserID.Length] = Caps(sID);
    UserKey[UserKey.Length] = Caps(sPass);
    SaveConfig();
	log("Received info from"@sName@"with ID:"@sID@"pass:"@sPass);
    //log(class'DiceWords'.static.GetPassPhrase(8,true));
}

simulated function string GenerateSalt(int iLength)
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