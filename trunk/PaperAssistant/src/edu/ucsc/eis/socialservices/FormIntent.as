package edu.ucsc.eis.socialservices 
{
	import edu.ucsc.eis.SocialEntity;
	import edu.ucsc.eis.socialgame.SocialGame;
	import edu.ucsc.eis.socialgame.SocialGameLibrary;
	import edu.ucsc.eis.socialgame.VolitionValue;
	import mx.collections.errors.ItemPendingError;
	//import Math.random;
	
	/**
	 * Picks a social game to play based on the volition values of the social
	 * entites.
	 * 
	 * @author Josh McCoy
	 * 
	 * @param socials A vector of the social entities to participate in the 
	 * intent forming process.
	 * @param sglib Social game library.
	 * @param whiteOnly Only initiate a game as the White role.
	 * @param endsToConsider The number of traditional endings to consider when
	 * choosing a social game.
	 * 
	 * @return A social game with one role assignment.
	 */	
	public function FormIntent(socials:Vector.<SocialEntity>, sglib:SocialGameLibrary, whiteOnly:Boolean = true, endsToConsider:int = 1):SocialGame {
		var tradEnds:Vector.<VolitionValue> = new Vector.<VolitionValue>();
		var topTradEnds:Vector.<VolitionValue>;
		var sg:SocialGame;
		var randomIndex:int;
		var chosenVolition:VolitionValue;
		
			//store highest n volition values
		
		for each (var socent:SocialEntity in socials) {
			if (whiteOnly) {
				tradEnds = tradEnds.concat(socent.getTopTradEndsForWhite());
			} else {
				tradEnds = tradEnds.concat(socent.getTopTradEnds());
			}
		}
		trace("FormIntent(): tradEnds - "+tradEnds);
		topTradEnds = tradEnds.sort(new VolitionValue().compare).splice(0, endsToConsider);
		
		trace("FormIntent(): topTradEnds - "+topTradEnds);
		
		//take highest traditional end volitions and choose one.
		randomIndex = Math.min(topTradEnds.length, Math.floor(Math.random() * endsToConsider));
		chosenVolition = topTradEnds[randomIndex];
		sg = sglib.getSocialGame(chosenVolition.game);
		
		//trace("chosen volition: " + chosenVolition);
		//assign the character that has the chosen volition value to their desired role in the social game
		//trace("sg.getRoleTitleString(chosenVolition.role) - " + sg.getRoleTitleString(chosenVolition.role));
	
		sg.assignCharacterToRoleByName(chosenVolition.characterName, sg.getRoleTitleString(chosenVolition.role));
		//trace("FormIntent(): first assigned role is " + sg.getRoleTitleString(chosenVolition.role) + " to " + chosenVolition.characterName+". Volition - " +chosenVolition + ". SocialGame - " + sg);
		//trace("is " + chosenVolition.characterName + " in a game role? " + sg.isCharacterInGame(chosenVolition.characterName).toString());
	
		return sg;
	}
}