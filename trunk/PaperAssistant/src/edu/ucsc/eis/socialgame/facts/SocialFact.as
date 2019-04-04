/******************************************************************************
 * edu.ucsc.eis.socialgame.facts.SocialFact
 * 
 * This interface is used to help aggregate social facts. Its functionality
 * revolves around keeping track of the type of social fact that implements
 * this interface. It also 
 * 
 *****************************************************************************/

package edu.ucsc.eis.socialgame.facts
{
	public interface SocialFact
	{
		//public const BASIC_NEED:int 	= 0;
		//public const STATUS:int 		= 1;
		//public const RELATIONSHIP:int 	= 2;
		
		function factType():int;
		function factAbout():String;
		
	}
}