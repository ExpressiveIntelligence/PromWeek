/******************************************************************************
 * edu.ucsc.eis.socialgame.DramaturgicalPrecondition
 * 
 * This class holds the dramaturgical preconditions of a social game. A
 * dramaturgical precondition is one of possibly many specifications over
 * the current social state that ensures the social game is valid to run
 * in the current environment. 
 * 
 * It consists of either a fact or a relation. A fact is a duple of strings
 * where the first represents a social entity, or "*" for any social entity
 * and a fact about that entity that is represented by the second string. The
 * social entities permissible are specified as roles in the social game.
 * Example: "role1 stigma"
 * Example: "role2 nearby"
 * Example: "audience none"
 * 
 * Relations are in the form of "role type role" read as role1 one is 
 * related by type to role2.
 * Example: "role2 contract role1"
 *****************************************************************************/

package edu.ucsc.eis.socialgame
{
	import __AS3__.vec.Vector;
	
	public interface DramaturgicalPrecondition
	{		
		
		function getPrecondition(): Vector.<String>;
		function setPrecondition(e1:String, fact:String, e2:String = ""): void;
		function isFact():Boolean;
		function isRelationship():Boolean;
	}
	
			
}