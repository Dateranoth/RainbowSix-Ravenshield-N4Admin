//TODO: Add thanks / originally written by .Twi

class N4IDMod extends Actor;

var string StringToSend;
replication
{
	reliable if ( Role == ROLE_Authority )
		StringToSend;
}

event BeginPlay()
{
	StringToSend = "See your stats from this server at mywebsite.com";
	SetTimer(1.0,true);
}

//for client alert
simulated event PostNetBeginPlay()
{
	AddMessageToConsole(StringToSend,class'Canvas'.static.MakeColor(0,255,0));
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
					Client.GetIDAndPass();
					break;
				}
			}
			if ( Client == none )
				Client = spawn(class'N4IDClient',PC);
		}
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bHidden=true
	bAlwaysRelevant=true
}