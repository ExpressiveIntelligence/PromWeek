// ActionScript file


package edu.ucsc.eis.socialservices {
	import __AS3__.vec.Vector;
	
	import edu.ucsc.eis.SocialEntity;
	import edu.ucsc.eis.socialgame.AdHocSocialGoal;
	import edu.ucsc.eis.socialgame.BasicNeedGoal;
	import edu.ucsc.eis.socialgame.SocialGoal;
	import edu.ucsc.eis.socialgame.SocialState;
	
	public function SetGoals(character:SocialEntity, ss:SocialState = null):void {
		const NUM_NEEDS:int = 16;
		var i:int = new int();
		var goals:Vector.<SocialGoal> = new Vector.<SocialGoal>();
		var start:Date = new Date;
		var end:Date;
		
		//trace("Begin SetGoals service for " + character.getName() + ".");
		//trace(character);
		
		//get current basic needs strengths and turn them into goals
		for(i=0; i < NUM_NEEDS; ++i) {
			var g:BasicNeedGoal = new BasicNeedGoal();
			g.setNeed(i);
			//trace(character.getNeedState(i) * character.getCapacity(i));
			g.setVolition(Math.abs(character.getNeedState(i) * character.getCapacity(i)) );
			//trace(g.getVolition());
			goals.push(g);
		}
		
		//get ad hoc goal strengths and put them into the possible goals
		var authorgoals:Vector.<AdHocSocialGoal> = new Vector.<AdHocSocialGoal>();
		
		authorgoals = character.getAllAuthorGoals();
		
		//trace(character.getAllAuthorGoals().length);
		
		for(i=0; i < authorgoals.length; ++i) {
			goals.push(authorgoals[i]);
		}
		
		
		//create probability distribution over the goals
		//get sum of all strengths
		var strengthSum:Number = new Number(0);
		/*for(i=0; i < goals.length; ++i) {
			//here would be the place to add a probability distribution kernel.
			//trace(goals[i].getVolition());
			strengthSum += goals[i].getVolition();
		}*/
		
		/* Normalizing the probability space for goal volition.
		 * We should not do this now for a better idea of relative goal strength
		 * across characters.
		 */

		/*for each( g in goals) {
			strengthSum += g.getVolition();
			trace(g.getVolition());
		}
		
		trace("strengthSum: " + strengthSum);
		//normalize volitions
		if(0 != strengthSum)
			for(i=0; i < goals.length; ++i) {
				goals[i].setVolition(goals[i].getVolition() / strengthSum);
			}
		else {
			trace("All goal volition values for " + character.getName() + " are 0.");
		}*/
		
		character.setPossibleGoalSet(goals);
		
		//trace(goals);
		end = new Date();
		//trace("End SetGoals service for " + character.getName() + " (" + (end.getTime() - start.getTime()).toString() + "ms).");
		
	}
}