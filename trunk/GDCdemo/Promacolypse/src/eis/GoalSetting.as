package eis 
{
	/**
	 * Performs the goal setting social service on a single character.
	 * Returns the character's prospective memory.
	 **/
	public function GoalSetting(charName:String, characters:Object, rel:SocialNetwork, rom:SocialNetwork, auth:SocialNetwork, status:StatusNetwork):ProspectiveMemory
	{
		trace("GoalSetting(): for " + charName);
		var charNetworkID:int = (characters[charName] as Character).networkID;
		var char:Character = characters[charName] as Character;
		
		var prosMem:ProspectiveMemory = new ProspectiveMemory(3, SocialGame.CHANGE_TYPE_COUNT);
				
		for each (var otherChar:Character in characters) {
			var possible:Boolean;
			var actual:Boolean;
			var otherNetworkID:int = otherChar.networkID;
			if (otherChar.characterName != charName) {
				var vol:Number = 0.0;
				
				/*
				 * Friends :- rel(x,y)>70 ^ rel(y,x)>70
				 * 
				 * x is char; y is otherchar
				 */
				
				//actual
				if(0.0 != status.getStatus(StatusNetwork.FRIEND, char, otherChar))
					actual = true;
				else
					actual = false;
				//possible
				if (rel.getWeight(charNetworkID, otherNetworkID) > 70.0 && rel.getWeight(otherNetworkID, charNetworkID) > 70.0) {
					possible = true;
				}else
					possible = false;
				 
				// cases of actual and possible truth values
				
				//T&T is ignored
				//T&F is ~ of actual
				if (actual && !possible) {
					
					//score rel(x,y)>70
					vol = 70.0 - rel.getWeight(charNetworkID, otherNetworkID);
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_DOWN, vol);
					//score rel(y,x)>70
					vol = 70.0 - rel.getWeight(otherNetworkID, charNetworkID);
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_DOWN, vol);
					
				}else if (!actual && possible) {
					vol = 0.0;
					//score friends: how much over we above the friends rel threshold
					vol = rel.getWeight(charNetworkID, otherNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.FRIENDS, vol);
					
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_UP, vol);
					vol = rel.getWeight(otherNetworkID, charNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.FRIENDS, vol);
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_UP, vol);
					//score relUps
					
				}else if (!actual && !possible) {
					vol = 0.0;
					//score half of the body of the Friends rule
					vol = rel.getWeight(charNetworkID, otherNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_UP, vol/2.0);
					vol = rel.getWeight(otherNetworkID, charNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_UP, vol/2.0);
				}
				
				 /*
				  * ~Friends :- rel(x,y)<40
				  */
				if(0.0 == status.getStatus(StatusNetwork.FRIEND, char, otherChar))
					actual = true;
				else
					actual = false;
				//possible
				if (rel.getWeight(charNetworkID, otherNetworkID) < 40.0) {
					possible = true;
				}else
					possible = false;
				 
				// cases of actual and possible truth values
				
				//T&T is ignored
				//T&F is ~ of actual
				if (actual && !possible) {
					
					//score rel(x,y)<70
					vol = rel.getWeight(charNetworkID, otherNetworkID) - 40.0;
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_UP, vol);
					
				}else if (!actual && possible) {
					vol = 0.0;
					//score ~friends: how much lower is rel(x,y) than 40?
					vol = 40.0 - rel.getWeight(charNetworkID, otherNetworkID);
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_DOWN, vol);
					//XXX this should be scored when we have some ~friends games
					//to show.
					//prosMem.setValue(otherChar, SocialGame.NOT_FRIENDS, vol);
					
				}else if (!actual && !possible) {
					vol = 0.0;
					//score ~friends: how much lower is rel(x,y) than 40?
					vol = 40.0 - rel.getWeight(charNetworkID, otherNetworkID);
					prosMem.setValue(otherChar, SocialGame.RELATIONSHIP_DOWN, vol/2);
				}
				  
				  
				 /*
				  * Dating :- rom(x,y)>70 & rom(y,x)>70
				  */
				if(0.0 == status.getStatus(StatusNetwork.DATING, char, otherChar))
					actual = true;
				else
					actual = false;
				//possible
				if (rom.getWeight(charNetworkID, otherNetworkID) > 70.0 && rom.getWeight(charNetworkID, otherNetworkID) > 70.0) {
					possible = true;
				}else
					possible = false;
				
				//T&T is ignored
				//T&F is ~ of actual
				if (actual && !possible) {
					//trace("Dating: actual && !possible");
					//score rom(x,y)>70
					vol = 70.0 - rom.getWeight(charNetworkID, otherNetworkID);
					prosMem.setValue(otherChar, SocialGame.ROMANCE_DOWN, vol);
					//score rom(y,x)>70
					vol = 70.0 - rom.getWeight(otherNetworkID, charNetworkID);
					prosMem.setValue(otherChar, SocialGame.ROMANCE_DOWN, vol);
					
				}else if (!actual && possible) {
					//trace("Dating: !actual && possible");
					vol = 0.0;
					//score dating: how much over we above the dating rom threshold
					vol = rom.getWeight(charNetworkID, otherNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.DATING, vol);
					prosMem.setValue(otherChar, SocialGame.ROMANCE_UP, vol);
					vol = rom.getWeight(otherNetworkID, charNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.DATING, vol);
					prosMem.setValue(otherChar, SocialGame.ROMANCE_UP, vol);
					//score relUps
					
				}else if (!actual && !possible) {
					//trace("Dating: !actual && !possible");
					vol = 0.0;
					//score half of the body of the dating rule
					vol = rom.getWeight(charNetworkID, otherNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.ROMANCE_UP, vol/2.0);
					vol = rel.getWeight(otherNetworkID, charNetworkID) - 70.0;
					prosMem.setValue(otherChar, SocialGame.ROMANCE_UP, vol/2.0);
				}
			}
		}
		
		 
		
		return prosMem;
	}
}