//TODO: Add thanks / originally written by .Twi

class N4IDClient extends Actor config(N4IDList);

var config Array<string> UserID;
var config Array<string> UserKey;
var config Array<string> UserSalt;
var bool bSentInfo;

replication
{
    reliable if ( Role == ROLE_Authority )
        GetIDAndPass;
    reliable if ( Role == ROLE_Authority )
        NotifyPlayer;
    reliable if ( Role < ROLE_Authority )
        VerifyN4IDAndPass;
}

//runs on the client
//checks for a ubi ID and password
//can add later  randomly generate unique id
simulated function GetIDAndPass()
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
            VerifyN4IDAndPass(PC.PlayerReplicationInfo.PlayerName,PC.m_GameService.m_szUserID,SHAPassHash, PC);        
            bSentInfo = true;//when server gets info, set this var so that the check for info doesn't keep running
        }
    }
}

//Notify Player if they logged in successfully or not.
//If not, tell player the unique string appended to their name.
simulated function NotifyPlayer(string sFromClient, string sFromServer)
{
    if ( sFromClient == sFromServer )
    {
        log("Successfully Logged in to server as"@sFromServer);
        AddMessageToConsole("Successfully Logged in to server as"@sFromServer,class'Canvas'.static.MakeColor(0,255,0)); 
    }
    else
    {
        log("Login Failed. Using Temporary Name"@sFromServer);
        AddMessageToConsole("Login Failed. Using Temporary Name"@sFromServer,class'Canvas'.static.MakeColor(0,255,0));
    }  
}

//server receives this info from the client
//Check UserID and Password. Update UbiID based on this information.
function VerifyN4IDAndPass(string sName,string sID,string sPass, R6PlayerController PC)
{   
    //Check UserID and Password.
    local int i;
    local string sTSalt;
    local bool bUserExists;
    LoadConfig();
    if (UserID.Length != UserKey.Length || UserID.Length != UserSalt.Length)
    {
        log("ERROR - N4IDMod - UserID parameters("@UserID.Length@")and User Key parameters("@UserKey.Length@")and User Salt parameters("@Usersalt.Length@")are not the same length. Please reset N4IDList.ini or remove mismatching ID||Key||Salt.");
        PC.PlayerReplicationInfo.m_szUbiUserID = sName$"_"$GenerateSalt(8);
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
                    log("Login Accepted for User:"@sID);                    
                }
                else
                {
                    PC.PlayerReplicationInfo.m_szUbiUserID =  sName$"_"$GenerateSalt(8);
                    log("Login Failed for User"@sID@"Generated Temp Name"@PC.PlayerReplicationInfo.m_szUbiUserID);
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
            log("Created New User:"@sID);
        }
    }
    NotifyPlayer(sID,PC.PlayerReplicationInfo.m_szUbiUserID); 
    SaveConfig();
}

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