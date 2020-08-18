//TODO: Add thanks / originally written by .Twi

class N4IDClient extends Actor config(N4IDList);

var bool bSentInfo;
var config Array<string> UserID;
var config Array<string> UserKey;

replication
{
	reliable if ( Role == ROLE_Authority )
		GetIDAndPass;
	reliable if ( Role < ROLE_Authority )
		ReturnIDAndPass;
}

//runs on the client
//checks for a ubi ID and password
//can add later - randomly generate unique id
simulated function GetIDAndPass()
{
	local R6PlayerController PC;
	local string MD5PassHash;
    
	if ( Level.NetMode == NM_DedicatedServer )
		return;
	if ( !bSentInfo )
	{
		PC = R6PlayerController(class'Actor'.static.GetCanvas().Viewport.Actor);
		if ( ( PC != none ) && ( PC.m_GameService != none ) )
		{
			if ( PC.m_GameService.m_szUserID == "" )
				PC.m_GameService.m_szUserID = PC.PlayerReplicationInfo.PlayerName;
			if ( R6GSServers(PC.m_GameService).m_szPassword == "" )
                //TODO: Make the password Random
                R6GSServers(PC.m_GameService).m_szPassword = "1234ABC";
                R6GSServers(PC.m_GameService).m_szSavedPwd = R6GSServers(PC.m_GameService).m_szPassword;
                
            //TODO: Add salt? Configurable per server maybe?
            PC.PlayerReplicationInfo.m_szUbiUserID = PC.m_GameService.m_szUserID;   
			MD5PassHash = class'MD5'.static.MD5String(R6GSServers(PC.m_GameService).m_szPassword);                
            R6GSServers(PC.m_GameService).SaveConfig();
			ReturnIDAndPass(PC.PlayerReplicationInfo.PlayerName,PC.m_GameService.m_szUserID,MD5PassHash, PC);
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
}



defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysTick=true
	bHidden=true
	bAlwaysRelevant=true
}