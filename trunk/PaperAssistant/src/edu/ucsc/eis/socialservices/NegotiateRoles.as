package edu.ucsc.eis.socialservices 
{
	import edu.ucsc.eis.*;
	import edu.ucsc.eis.socialgame.*;
	
	/**
	 * The role negotiation process.
	 * 
	 * @author Josh McCoy
	 * @param	socials
	 * @param	game
	 * @param 	sglib
	 * @param	endsToConsider
	 * @return
	 */
	public function NegotiateRoles(socials:Vector.<SocialEntity>, game:SocialGame, sglib:SocialGameLibrary, endsToConsider:int = 1):SocialGame {
		//for each open role,
		//get top volition scores for non-assigned characters
		//assign a high volition character to the empty role
		var roles:Vector.<Role> = game.getAllRoles();
		
		
		for (var curRoleIndex:int = 0; curRoleIndex < roles.length; ++curRoleIndex) {
			if( !roles[curRoleIndex].hasCharacterAssigned() ) {	
			
				var ends:Vector.<VolitionValue> = new Vector.<VolitionValue>();
				var chosenVolition:VolitionValue = new VolitionValue();
				
				
				for each (var socent:SocialEntity in socials) {
					//if the character is not in the game, add his volitions to the list
					//trace("NegotiateRoles: socent name - " + socent.getName());
					if ( !game.isCharacterInGame(socent.getName())) {
						ends = ends.concat(socent.getTopEndsByGameAndRole(sglib.getGameIndexByName(game.getName()), curRoleIndex));
						//trace(ends);
					}else {
						//trace("NegotiateRoles(): " + socent.getName() + " is already assigned to a role in " + game.getName());
					}
				}
				ends = ends.sort(chosenVolition.compare)//.splice(0, endsToConsider);
				//trace(ends);
				//place character in the role
				var randomIndex:int = Math.min(Math.floor(Math.random() * endsToConsider), ends.length - 1);
				chosenVolition = ends[randomIndex];
				//trace("NegotiateRoles():  Adding " + chosenVolition.characterName + " to fill role " + roles[curRoleIndex].getTitle() + " in game " + game.getName() + ". VolitionValue: " + chosenVolition);
				game.assignCharacterToRoleByName(chosenVolition.characterName, roles[curRoleIndex].getTitle());
			}else {
				//trace("NegotiateRoles(): " + roles[curRoleIndex].getTitle() + " is already assigned to " + roles[curRoleIndex].getCharacterName());
				
			}
		}
		//trace(game);
		
		//fill out game branches here for lack of a better place in the paper prototype
		
		game.start();
		while (!game.isDone()) {
			var chosenEventId:int;
			for each (socent in socials) {
				if (socent.getName() == game.getCharacterInRole(game.getDecisionMaker())) {
					chosenEventId = socent.chooseEvent(game.getNextEvents(), game);
					//trace(game.getCharacterInRole(game.getDecisionMaker()) + " " + socent.getName() + " chose " + chosenEventId + " in game " + game.getName());
				}
			}
			if(!game.isDone()) game.advance(chosenEventId);
		}
		return game;
		
	}

}