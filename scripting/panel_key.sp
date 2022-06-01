#pragma semicolon 1
#pragma newdecls required

KeyValues
	hKV;

public Plugin myinfo =
{
	name = "Menu Half-Life 2/ Меню из Хайлф-Лайф 2",
	author = "by Nek.'a 2x2 | ggwp.site ",
	description = "Меню из Хайлф-Лайф, спасибо Kruzya",
	version = "1.0.2",
	url = "http://hlmod.ru and https://ggwp.site/"
};

public void OnPluginStart()
{
	char sPath[PLATFORM_MAX_PATH]; Handle hFile;
	BuildPath(Path_SM, sPath, sizeof(sPath), "configs/panel.ini");
	
	hKV = new KeyValues("ListPanel");		//
	hKV.SetNum("level", 0);
	if(!hKV.ImportFromFile(sPath))
		PrintToChatAll("Файл не был загружен [%s]", sPath);
		
	if(!FileExists(sPath))
	{
		hFile = OpenFile(sPath, "w");
		CloseHandle(hFile);
	}

	CheckSettings();
	
	CreateTimer(3.0, Timer_Panel, _, TIMER_REPEAT);
	for(int i = 1; i <= MaxClients; i++) if(IsClientInGame(i)) OnClientPutInServer(i);
}

stock void CheckSettings()
{
	hKV.Rewind();
	hKV.JumpToKey("ListPanel", false);

	char sKey[256], sValue[256];
	int iValue[2];

	if(hKV.GotoFirstSubKey(false))		//
	{
		do
		{	//
			if(hKV.GetSectionName(sKey, sizeof(sKey)))		//
			{
				hKV.GetString(NULL_STRING, sValue, sizeof(sValue));

				if(hKV.GotoFirstSubKey(false))		//
				{
					do 
					{
						if(hKV.GetSectionName(sKey, sizeof(sKey)))		//
						{
							if(!strcmp(sKey, "time") || !strcmp(sKey, "level"))
								hKV.GetString(NULL_STRING, sValue, sizeof(sValue));
							else if(strcmp(sKey, "time") || !strcmp(sKey, "level"))
								hKV.GetUInt64(sKey, iValue);
						}
						
					} while(hKV.GotoNextKey(false));
					hKV.GoBack();
				}
			}
		} while( hKV.GotoNextKey(false) );
	}
}

public void OnClientPutInServer(int client)
{
	Show_Panel(client);
}

public Action Timer_Panel(Handle hTimerLocal)
{
	for(int i = 1; i <= MaxClients; i++) if(IsClientInGame(i) && !IsFakeClient(i))
		Show_Panel(i);
}

public void Show_Panel(int client)
{
	if (!client || !IsClientInGame(client) || IsFakeClient(client))
		return;

	CreateDialog(client, hKV, DialogType_Menu);
}
