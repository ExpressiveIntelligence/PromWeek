
package edu.ucsc.eis.socialservices {
	import __AS3__.vec.Vector;
	
	import edu.ucsc.eis.SocialEntity;
	import edu.ucsc.eis.socialgame.SocialGame;
	import edu.ucsc.eis.socialgame.SocialGameLibrary;
	
/******************************************************************************
 * The PlaneIntent function is the implementation as service of the intent
 * planning process of the social AI framework. The high level responsibilities
 * of this service are to take a set of goals (usually with an attached
 * probability distribution) with volitions and return a social game that 
 * opportunistically choses a game to play based on how many goals it fulfills.
 * The probability a game is chosen is increased if the game fulfills any
 * traits specified in the character's personality description.
 *****************************************************************************/

	public function PlanIntent(character:SocialEntity, sglib:SocialGameLibrary):void {
		//var scores:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
		//var scores:Vector.<Vector.<Vector.<Number>>> = new Vector.<Vector.<Vector.<Number>>>();
		var curGameIndex:int = new int();
		var curRoleIndex:int = new int();
		var curNeedIndex:int = new int();
		var curEndIndex:int = new int();
		var start:Date = new Date();
		var end:Date;
		const NUM_NEEDS:int = 16;
		
		//trace("PlanIntent(): " + character.getName() + "'s volition modifier: " + character.volitionModifier);
		/*
		 * Need to respect the social entity's active needs, not all needs.
		 * 
		 */
		
		//trace("Begin PlanIntent service for " + character.getName() + ".");
		
		
		//Version that respects social game endings (stored as a 3D vector).
		//scores[game][ending][role]
		for (curGameIndex = 0; curGameIndex < sglib.getLength(); ++curGameIndex) {
			
			var numRoles:int = new int(0);
			var game:SocialGame = new SocialGame();
			var antiEnds:Vector.<int>;
			game = sglib.getSocialGame(curGameIndex);
			numRoles = game.getNumRoles();
			
			
			//scores.push(new Vector.<Vector.<Number>>());
			
			//get the antithetical ends vector for the the game
			antiEnds = game.getAntiEnds().slice();
			//trace("antiends: [" + antiEnds + "]");
			
			//process antithetical endings (index offset by 1 to account for traditional ending)
			for (curEndIndex = 0; curEndIndex < game.getAntiEndCount()+1; ++curEndIndex) {
				
				//trace(game);
					
				//scores[curGameIndex].push(new Vector.<Number>(numRoles));
				
				for(curRoleIndex=0; curRoleIndex < numRoles; ++curRoleIndex) {
					var score:Number = new Number(0.0);
					var endId:int;
					(curEndIndex == 0) ? endId = game.getTraditionalEndId() : endId = antiEnds[curEndIndex - 1];
					//scores[curGameIndex][curEndIndex][curRoleIndex] = 0.0;
					character.volition[curGameIndex][curEndIndex][curRoleIndex] = 0.0;
					for (curNeedIndex = 0; curNeedIndex < NUM_NEEDS; ++curNeedIndex) {
						//score += game.getNeedChangeByRole(curNeedIndex, curRoleIndex);
						score = game.getNeedChangeByRoleAndEnd(curNeedIndex, curRoleIndex, endId);
						//trace(score);
						//scores[curGameIndex][curEndIndex][curRoleIndex] += character.getNeedValence(curNeedIndex) * score * character.getNeedVolition(curNeedIndex);
						character.volition[curGameIndex][curEndIndex][curRoleIndex] += character.volitionModifier * character.getNeedValence(curNeedIndex) * score * character.getNeedVolition(curNeedIndex);
						/* Needs an "add to existing value" function.
						 * character.setVolitionMatrixValue(curGameIndex, curEndIndex, curRoleIndex, character.getNeedValence(curNeedIndex) * score * character.getNeedVolition(curNeedIndex));
						 */
						//trace(curGameIndex.toString() + curEndIndex.toString() + curRoleIndex.toString() + "-" + curNeedIndex);trace("Score for " + game.getName() + ", ending: " + endId + ", rolei: " + curRoleIndex + ", needi: " + curNeedIndex + ",  score: " + score + " total score: " + scores[curGameIndex][curEndIndex][curRoleIndex]);

					}
					
				}
			}
		}
		/* Save the volition matrix (aka scores[][][]) to the character:SocialEntity for later use (role negotiation). */
		
		/* Intent forming is next! */
		
		
		//initialize the score keeping array
		
		//The total game (no respect to endings) version.
		//trace(sglib.getLibraryXML());
		//character.
		//"score" each role in each social game.
		//The score for each game/role needs to be relative to the capacity of the character.
		//Use the dot product of the vector of basic need goal volitions with the vector of
		//basic need changes with each socialgame/role/ending combination.
		/*for(curGameIndex=0; curGameIndex< sglib.getLength(); ++curGameIndex) {
			var numRoles:int = new int(0);
			var game:SocialGame = new SocialGame();
			game = sglib.getSocialGame(curGameIndex);
			//trace(game);
			numRoles = game.getNumRoles();	
			scores.push(new Vector.<Number>(2));
			for(curRoleIndex=0; curRoleIndex < numRoles; ++curRoleIndex) {
				var score:Number = new Number(0.0);
				for(curNeedIndex=0; curNeedIndex<NUM_NEEDS; ++curNeedIndex) {
					score += game.getNeedChangeByRole(curNeedIndex,curRoleIndex);
					//trace(score);
					//trace("Score for " + game.getName() + ", " + curRoleIndex + ", " + curNeedIndex + ": " + score);
					scores[curGameIndex][curRoleIndex] += character.getNeedValence(curNeedIndex)*score * character.getNeedVolition(curNeedIndex);
				}
			}
		}*/ 
		
		
		//trait score
		
		//keep the score for each role of each game
		
		end = new Date();
		
		//trace(character.volition);
		//trace("End PlanIntent service for " + character.getName() + " (" + (end.getTime() - start.getTime()).toString() + "ms).");
		//trace("   Time taken: " + (end.getTime() - start.getTime()).toString() + "ms.");
		
		
		
	}

}