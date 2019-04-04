package eis 
{
	/**
	 * ...
	 * @author Ben*
	 */
	public class ParseXML
	{
		
		public function ParseXML() 
		{
			
		}
		
		//Ultimately this will be some cool thing that reads in well-formatted XML from Java/Scala town.  For now,
		//it is just a hard coded string.
		public static function getScript():String {
			//This will in reality be talking with the Scala AI side of things to get a well-formated XML string of all
			//of the dialogue of a social game.  However, for now, it is just hard coded.
			return "<SCRIPT><DIALOGUE lineNum='0' name='Karen' line='Hey Edward.' Animation='talk' time='2' /><DIALOGUE lineNum='1' name='Edward' line='Yeah Karen?' Animation='talk' time='2' /><DIALOGUE lineNum='2' name='Karen' line='If I could be reborn into anything in the world, it would be a tear drop... so I could be born in your eyes, live life on your cheek, and die on your lips.' Animation='happytalk' time='8' />" +
			"<DIALOGUE lineNum='3' name='Edward' line='Ohhh, that`s so sweet!' Animation='blush' time='4' /><DIALOGUE lineNum='4' name='Karen' line='Edward, will you be my main squeeze?' Animation='tickle' time='5' /><DIALOGUE lineNum='5' name='Edward' line='Oh Karen! Yes, yes, a thousand times yes!' Animation='blush' time='5' /></SCRIPT>";
		}
		
		public static function getState():String {
			//This will in reality be talking with the Scala AI side of things to get a well-formated XML string of all
			//of the dialogue of a social game.  However, for now, it is just hard coded.
			
			return "<GAME_UPDATE><CHARACTER name='Edward'><GAME rank='1' name='SC_Dating' target='Lily' change='RomanceUp' value='40' /><GAME rank='2' name='SC_Dating' target='Bruce' change='RomanceUp' value='100' /></CHARACTER><CHARACTER name='Karen'><GAME rank='3' name='SC_Friend' target='Lily' change='RelationshipUp' value='80' />" +
			"</CHARACTER><NETWORK name='Romance'><NODE from='Edward' to='Lily' value='70' /></NETWORK><SOCIAL_STATUS name='Dating'><NODE from='Edward' to='Lily' value='true' /></SOCIAL_STATUS></GAME_UPDATE>";
			//WORKS GREAT
			
			//return "<GAME_UPDATE><CHARACTER name='Edward'><GAME rank='1' name='SC_Dating' target='Lily' change='RomanceUp' value='40' /></CHARACTER><NETWORK name='Romance'><NODE from='Edward' to='Lily' value='70' /></NETWORK><SOCIAL_STATUS name='Dating'><NODE from='Edward' to='Lily' value='true' /></SOCIAL_STATUS></GAME_UPDATE>";
		}
		
		//Given a string (probably received from getScript() ) of XML, break it up into it's component parts
		//so that we can have our way with it.
		public static function parseScript(inputString:String):void {
			var mainXML:XML;
			try {
				mainXML = new XML(inputString);
			} catch (e:Error)
			{
				trace("Error: " + e.message)
				return;
			}

			var lineNums:XMLList = mainXML.DIALOGUE.@lineNum;
			var names:XMLList = mainXML.DIALOGUE.@name;
			var lines:XMLList = mainXML.DIALOGUE.@line;
			var animations:XMLList = mainXML.DIALOGUE.@Animation;
			var times:XMLList = mainXML.DIALOGUE.@time;
			var length:int = lineNums.length();
			for (var i:int = 0; i < length; i++) {
				trace(lineNums[i] + " " + names[i] + " says: " + lines[i] + " while doing: " + animations[i] + " for " + times[i] + " seconds");
			}
		}
		
		//Given a string (probably received from getState() ) of XML, break it up into it's component parts
		//so that we can have our way with it.
		public static function parseState(inputString:String):void {
			var mainXML:XML;
			try {
				mainXML = new XML(inputString);
			} catch (e:Error)
			{
				trace("Error: " + e.message)
				return;
			}
			trace(mainXML);

			var characters:XMLList = mainXML.CHARACTER.@name;
			var networks:XMLList = mainXML.NETWORK.@name;
			var socialStatus:XMLList = mainXML.SOCIAL_STATUS.@name;
			
			var socialGameRanks:XMLList = mainXML.CHARACTER.GAME.@rank;
			trace("what is social games rank?" + socialGameRanks);
			

			var numChars:int = characters.length();
			var numNetworks:int = networks.length();
			var numSocialStatus:int = socialStatus.length();
			trace("number of characters is: " + numChars);
			for (var i:int = 0; i < numChars; i++) {
				//trace(lineNums[i] + " " + names[i] + " says: " + lines[i] + " while doing: " + animations[i] + " for " + times[i] + " seconds");
				
				var tempList:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@rank;
				var tempList2:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@name;
				var tempList3:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@target;
				var tempList4:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@change;
				var tempList5:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@value;
				trace(characters[i] + " Feels this way about games: ");
				for (var j:int = 0; j < tempList.length(); j++) {
					trace("rank:" + tempList[j] + " name:" + tempList2[j] + " target:" + tempList3[j] + " change:" + tempList4[j] + " value:" + tempList5[j]);
				}				
			}
			trace("number of networks is: " + numNetworks);
			for (i = 0; i < numNetworks; i++) {
				var tempList6:XMLList = mainXML.NETWORK.(@name == networks[i]).NODE.@from;
				var tempList7:XMLList = mainXML.NETWORK.(@name == networks[i]).NODE.@to;
				var tempList8:XMLList = mainXML.NETWORK.(@name == networks[i]).NODE.@value;
				trace(networks[i] + " looks like this: ");
				for (j = 0; j < tempList.length(); j++) {
					trace("from " + tempList6[j] + " to " + tempList7[j] + " value " + tempList8[j]);
				}
			}
			
			trace("number of social status is: " + numSocialStatus);
			for (i = 0; i < numSocialStatus; i++) {
				var tempList9:XMLList = mainXML.SOCIAL_STATUS.(@name == socialStatus[i]).NODE.@from;
				var tempList10:XMLList = mainXML.SOCIAL_STATUS.(@name == socialStatus[i]).NODE.@to;
				var tempList11:XMLList = mainXML.SOCIAL_STATUS.(@name == socialStatus[i]).NODE.@value;
				trace(socialStatus[i] + " looks like this: ");
				for (j = 0; j < tempList.length(); j++) {
					trace("from " + tempList9[j] + " to " + tempList10[j] + " value " + tempList11[j]);
				}
			}
		}
	}

}