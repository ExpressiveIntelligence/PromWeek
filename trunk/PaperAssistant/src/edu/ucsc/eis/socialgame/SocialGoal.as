/******************************************************************************
 * edu.ucsc.eis.socialgame.SocialGoal
 * 
 * Interface for SocialGoals. Likely to be implemented by basic needs goals
 * and ad hoc goals.
 * 
 * 
 *****************************************************************************/

package edu.ucsc.eis.socialgame
{
	public interface SocialGoal
	{
		function isBasicNeeds():Boolean;
		function isAdHoc():Boolean;
		function getVolition():Number;
		function setVolition(n:Number):void;
		function getPersistence():Number;
		
		
		/* To tell if the goal is value object or if it is representing
		 * an active goal.
		 */
		function isActive():Boolean;
		function setActive(b:Boolean):void;
	}
}