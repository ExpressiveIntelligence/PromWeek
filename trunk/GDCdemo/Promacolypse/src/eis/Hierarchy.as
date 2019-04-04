package eis 
{
	import eis.skins.SocialNetworkButtonSkin;
	
	/**
	 * var map:Object = [];
	 * map["romanceUp"] = new Hierarchy(influences);
	 * 
	 * ...
	 * @author Ben*
	 */
	public class Hierarchy
	{
		//------------ DATA MEMBERS -------------
		public var influences:Vector.<Influence>; 
		public var type:int; // DATING, RELATIONSHIP_UP, etc.
			
		//----------- CONSTRUCTOR ---------------
		public function Hierarchy(influences:Vector.<Influence>, type:int) 
		{
			this.influences = influences;
			this.type = type;
		}
			
		//----------- METHODS ------------------

		//ARGUMENTS
		//A:char -- the initiator.
		//B:char -- the target
		//theState:State -- the entire game state (consists of 
		
		public function execute(A:Character, B:Character, characters:Object, rel:SocialNetwork, rom:SocialNetwork, auth:SocialNetwork, status:StatusNetwork):Boolean {
			var highestWeightPos:Number, posNumeral:int;
			var highestWeightNeg:Number, negNumeral:int;
			var runningTotal:Number = 0.0;
			var i:int = 0;
			var c:int = 0;
			
			for (i = 0; i < influences.length; ++i) {
				/*
				 * We assume the influence's conditions are true until determined
				 * otherwise.
				 */
				var isTrue:Boolean = true;
				var conds:Vector.<Condition> = influences[i].conditions;
				for (c = 0; c < conds.length; ++c) {
					//conditional truth statements based on condition type
					if (conds[c].type == Condition.TRAIT) {
						if (conds[c].primary == "A") {
							//match up trait class with trait in a character
							if (!A.hasTrait(conds[c].trait))
								isTrue = false;
						} else if (conds[c].primary == "B") {
							if (!B.hasTrait(conds[c].trait))
								isTrue = false;
						}
						//return true; // if we got to this point, then there is no issue!
					}
					//NOTTRAIT case
					if (conds[c].type == Condition.NOTTRAIT) {
						if (conds[c].primary == "A") {
							//match up trait class with trait in a character
							if (A.hasTrait(conds[c].trait))
								isTrue = false;
						} else if (conds[c].primary == "B") {
							if (B.hasTrait(conds[c].trait))
								isTrue = false;
						}
						//return true; // if we got to this point, then there is no issue!
					}
					//network condition case
					if (conds[c].type == Condition.NETWORK) {
						var from:int;
						var to:int;
						var net:SocialNetwork;
						
						//get the network type
						if (conds[c].networkType == SocialNetwork.RELATIONSHIP) 
							net = rel;
						if (conds[c].networkType == SocialNetwork.ROMANCE) 
							net = rom;
						if(conds[c].networkType == SocialNetwork.AUTHENTICITY)
							net = auth;
						
						//get the social network id of primary
						if (conds[c].primary == "A")
							from = A.networkID;
						else if (conds[c].primary == "B")
							from = B.networkID;
						
						//get the social network id of the secondary
							if (conds[c].secondary == "A")
							to = A.networkID;
						else if (conds[c].secondary == "B")
							to = B.networkID;
						
						
						if (conds[c].comparisonOperator == "<") {
							//need social network as class
							if (!(net.getWeight(from, to) < conds[c].networkValue))
								isTrue = false;
						}else if (conds[c].comparisonOperator == ">") {
							//need social network as class
							if (!(net.getWeight(from, to) > conds[c].networkValue))
								isTrue = false;
						}else if (conds[c].comparisonOperator == "AverageOpinion") {
							//if (A.characterName == "Karen")
							//	trace("AverageFriends with Karen." + net.getAverageOpinion(from) + " " + net.getWeight(to, from)); ;
							if (!(net.getAverageOpinion(from) > conds[c].networkValue)) {
								isTrue = false;
							}
						}else if (conds[c].comparisonOperator == "FriendsOpinion") {
							//know the person who is the obj of opinion
							//know the person's friends
							//get the id's of A's friends
							var sum:Number = 0.0;
							var friendCount:Number = 0.0;
							for each(var char:Character in characters) {
								//are they A's friend?
								//A is karen
								//B is edward
								if (char.characterName != A.characterName) {
									if (status.getStatus(SocialGame.FRIENDS, char, B)) {
										trace("opinion used: " + rel.getWeight(char.networkID, A.networkID));
										sum += rel.getWeight(char.networkID, A.networkID);
										friendCount++;
									}
									//if A's friend is the target, they don't count
								}
							}
							trace("FriendsOpinion " + sum + " " + friendCount);
							if(friendCount > 0.0) {
								if ( !((sum / friendCount) < conds[c].networkValue)) {
									isTrue = false;
								}
							}else {
								isTrue = false;
							}
						}
						//return true; // if we got to this point, then there is no issue!
					}
					
					//status condition case
					if (conds[c].type == Condition.STATUS) {
						
						if (conds[c].primary == "A") {
							if (!status.getStatus(conds[c].status, A, B)){
								isTrue = false;
							}
						}else if(conds[c].primary == "B") {
							if (!status.getStatus(conds[c].status, B, A)){
								isTrue = false;
							}
						}
						//return true; // if we got to this point, then there is no issue!
					}
					
					//NOTstatus condition case
					if (conds[c].type == Condition.NOTSTATUS) {
						
						if (conds[c].primary == "A") {
							if (status.getStatus(conds[c].status, A, B)){
								isTrue = false;
							}
						}else if(conds[c].primary == "B") {
							if (status.getStatus(conds[c].status, B, A)){
								isTrue = false;
							}
						}
						//return true; // if we got to this point, then there is no issue!
					}
					//trace(isTrue);
					
				}
				//we got here -- if it's true, add the weight. if false, ignore.
				if (isTrue) {
					//trace("adding to running total: " + influences[i].weight);
					runningTotal += influences[i].weight;
				}
				if (influences[i].weight > highestWeightPos && influences[i].romanNumeral > 0) {
					highestWeightPos = influences[i].weight;
					posNumeral = influences[i].romanNumeral;
				}else if (influences[i].weight < highestWeightNeg && influences[i].romanNumeral < 0) {
					highestWeightNeg = influences[i].weight;
					negNumeral = influences[i].romanNumeral;
				}
				
			}
			//trace("running total: " + runningTotal);
			if (this.type == SocialGame.ROMANCE_UP) {
				trace("SocialGame.ROMANCE_UP -- running total: " + runningTotal);
			}
			if (runningTotal > 0.0) return true;
			return false
		}
		
	}

}