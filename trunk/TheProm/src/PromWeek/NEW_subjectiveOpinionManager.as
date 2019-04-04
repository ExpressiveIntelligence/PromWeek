package PromWeek 
{
	
	import CiF.Character;
	import CiF.Debug;
	import CiF.LineOfDialogue;
	import CiF.RelationshipNetwork;
	import CiF.Trait;
	import com.greensock.easing.Strong;
	import flash.utils.Dictionary;
	import CiF.SocialGameContext;
	import CiF.Predicate;
	import CiF.CiFSingleton;
	

	public class NEW_subjectiveOpinionManager
	{
		
		private static var _instance:NEW_subjectiveOpinionManager = new NEW_subjectiveOpinionManager();
		private var gameEngine:GameEngine;
		private var cif:CiFSingleton;
		private var dm:DifficultyManager;
		

		/**
		 * These store all subjective opinions that we have computed. It is cleared out every turn.
		 * Index: init-resp
		 */
		public var buddySubjectiveOpinions:Dictionary;
		public var romanceSubjectiveOpinions:Dictionary;
		public var coolSubjectiveOpinions:Dictionary;
		 
		public function NEW_subjectiveOpinionManager() 
		{
			gameEngine = GameEngine.getInstance();
			cif = CiFSingleton.getInstance();
			dm = DifficultyManager.getInstance();
		}
		
		public static function getInstance():NEW_subjectiveOpinionManager {
			return _instance;
		}
		

		public function clearStoredSubjectiveOpinions():void
		{
			this.buddySubjectiveOpinions = new Dictionary();
			this.romanceSubjectiveOpinions = new Dictionary();
			this.coolSubjectiveOpinions = new Dictionary();
		}
		
		
		
		
		public function getBuddyText(primary:Character, secondary:Character):Dictionary
		{
			//Return if we have cached a word for this turn;
			var indexString:String = primary.characterName.toLowerCase() + "-" + secondary.characterName.toLowerCase();
			if (this.buddySubjectiveOpinions[indexString] != null)
			{
				return this.buddySubjectiveOpinions[indexString];
			}
			
			var buddyDictionary:Dictionary = new Dictionary();
			
			//value = cif.coolNetwork.getWeight(char.networkID, selectedCharacter.networkID) / 100;
			var primaryGreenValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveGreenOpinions[secondary.networkID];
			//var secondaryGreenValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveGreenOpinions[primary.networkID];

			var primaryRedValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveRedOpinions[secondary.networkID];
			//var secondaryRedValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveRedOpinions[primary.networkID];
						
			var primaryBlueValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveBlueOpinions[secondary.networkID];
			//var secondaryBlueValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveBlueOpinions[primary.networkID];
			
			
			//do all the interesting ones
			var potentialWords:Vector.<String> = new Vector.<String>();
			var potentialIntensity:Vector.<Number> = new Vector.<Number>();

			//TOP tier!
			if (potentialWords.length == 0)
			{
				if (isFriend(primary, secondary) && isEnemy(primary, secondary))
				{
					potentialWords.push("rival");
					potentialIntensity.push(2);
				}
				else if (isWorstEnemy(primary, secondary))
				{
					potentialWords.push("arch-nemesis!");
					potentialIntensity.push(1);
				}
				else if (isBestFriend(primary, secondary))
				{
					potentialWords.push("besties!");
					potentialIntensity.push(5);
				}
			}
			
			//MIDDLE tier
			if (potentialWords.length == 0)
			{
				if (isFriend(primary, secondary))
				{
					potentialWords.push("my friend!");
					potentialIntensity.push(5);
				}
				else if (isEnemy(primary, secondary))
				{
					potentialWords.push("my enemy!");
					potentialIntensity.push(5);
				}
			}
			
			//BOTTOM tier
			if (potentialWords.length == 0)
			{
				if (primaryGreenValue < 0.20)
				{
					potentialWords.push("jerk!");
					potentialIntensity.push(1);
				}
				else if (primaryGreenValue < 0.40)
				{
					potentialWords.push("dislike");
					potentialIntensity.push(2);
				}
				else if (primaryGreenValue < 0.60)
				{
					potentialWords.push("ok");
					potentialIntensity.push(3);
				}
				else if (primaryGreenValue < 0.80)
				{
					potentialWords.push("great");
					potentialIntensity.push(4);
				}
				else
				{
					potentialWords.push("awesome!");
					potentialIntensity.push(5);
				}
			}
			
			//choose ONE of the potential words that will be the word for that whole turn
			var randIndex:int = Utility.randRange(0, (potentialWords.length - 1));
			buddyDictionary["text"] = LineOfDialogue.preprocessLine(potentialWords[randIndex]);
			buddyDictionary["intensity"] = potentialIntensity[randIndex];
			
			this.buddySubjectiveOpinions[indexString] = buddyDictionary;
			return buddyDictionary;
			
		}

		public function getRomanceText(primary:Character, secondary:Character):Dictionary
		{
			//Return if we have cached a word for this turn;
			var indexString:String = primary.characterName.toLowerCase() + "-" + secondary.characterName.toLowerCase();
			if (this.romanceSubjectiveOpinions[indexString] != null)
			{
				return this.romanceSubjectiveOpinions[indexString];
			}
			
			var romanceDictionary:Dictionary = new Dictionary();
			
			//value = cif.coolNetwork.getWeight(char.networkID, selectedCharacter.networkID) / 100;
			var primaryGreenValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveGreenOpinions[secondary.networkID];
			//var secondaryGreenValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveGreenOpinions[primary.networkID];

			var primaryRedValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveRedOpinions[secondary.networkID];
			//var secondaryRedValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveRedOpinions[primary.networkID];
						
			var primaryBlueValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveBlueOpinions[secondary.networkID];
			//var secondaryBlueValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveBlueOpinions[primary.networkID];
			
			
			//do all the interesting ones
			var potentialWords:Vector.<String> = new Vector.<String>();
			var potentialIntensity:Vector.<Number> = new Vector.<Number>();

			//TOP tier!
			if (potentialWords.length == 0)
			{
				if (isTrueLove(primary, secondary))
				{
					if (isDating(primary, secondary))
					{
						potentialWords.push("true love!");
						potentialIntensity.push(5);
					}
					else
					{
						potentialWords.push("If only...");
						potentialIntensity.push(5);
					}
				}
			}
			//MIDDLE tier
			if (potentialWords.length == 0)
			{
				if (isDating(primary, secondary))
				{
					if (primaryRedValue < 0.40)
					{
						potentialWords.push("ball and chain");
						potentialIntensity.push(3);
					}
					else if (secondary.hasTrait(Trait.MALE))
					{
						potentialWords.push("boyfriend!");
						potentialIntensity.push(5);
					}
					else
					{
						potentialWords.push("girlfriend!");
						potentialIntensity.push(5);
					}
				} 
				else if (primaryRedValue < 0.25 && primaryGreenValue < 0.33)
				{
					potentialWords.push("gross!");
					potentialIntensity.push(1);
				}
				else if (primaryRedValue < 0.25 && primaryGreenValue > 0.66)
				{
					potentialWords.push("weird...");
					potentialIntensity.push(3);
				}
			}
			//BOTTOM tier
			if (potentialWords.length == 0)
			{
				if (primaryRedValue < 0.20)
				{
					potentialWords.push("not interested");
					potentialIntensity.push(1);
				}
				else if (primaryRedValue < 0.40)
				{
					potentialWords.push("no thank you");
					potentialIntensity.push(2);
				}
				else if (primaryRedValue < 0.60)
				{
					potentialWords.push("whatever");
					potentialIntensity.push(3);
				}
				else if (primaryRedValue < 0.80)
				{
					potentialWords.push("intriguing");
					potentialIntensity.push(4);
				}
				else
				{
					potentialWords.push("gorgeous!");
					potentialIntensity.push(5);
				}
			}
			
			//choose ONE of the potential words that will be the word for that whole turn
			var randIndex:int = Utility.randRange(0, (potentialWords.length - 1));
			romanceDictionary["text"] = LineOfDialogue.preprocessLine(potentialWords[randIndex]);
			romanceDictionary["intensity"] = potentialIntensity[randIndex];
			
			//var extraWords:String = "";
			//var buddyIntensity:Number = this.getBuddyText(primary, secondary)["intensity"];
			//if (Math.abs((buddyIntensity - romanceDictionary["intensity"])) >= 2)
			//{
				//extraWords = "but";
				//if (Math.random() > 0.5)
				//{
					//extraWords += "...";
				//}
				//extraWords += " ";
			//}
			//romanceDictionary["text"] = extraWords + romanceDictionary["text"];
			
			this.romanceSubjectiveOpinions[indexString] = romanceDictionary;
			return romanceDictionary;
		}
		public function getCoolText(primary:Character, secondary:Character):Dictionary
		{
			//Return if we have cached a word for this turn;
			var indexString:String = primary.characterName.toLowerCase() + "-" + secondary.characterName.toLowerCase();
			if (this.coolSubjectiveOpinions[indexString] != null)
			{
				return this.coolSubjectiveOpinions[indexString];
			}
			
			var coolDictionary:Dictionary = new Dictionary();
			
			//value = cif.coolNetwork.getWeight(char.networkID, selectedCharacter.networkID) / 100;
			var primaryGreenValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveGreenOpinions[secondary.networkID];
			//var secondaryGreenValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveGreenOpinions[primary.networkID];

			var primaryRedValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveRedOpinions[secondary.networkID];
			//var secondaryRedValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveRedOpinions[primary.networkID];
						
			var primaryBlueValue:Number = gameEngine.worldGroup.avatars[primary.characterName.toLowerCase()].subjectiveBlueOpinions[secondary.networkID];
			//var secondaryBlueValue:Number = gameEngine.worldGroup.avatars[secondary.characterName.toLowerCase()].subjectiveBlueOpinions[primary.networkID];
			
			
			//do all the interesting ones
			var potentialWords:Vector.<String> = new Vector.<String>();
			var potentialIntensity:Vector.<Number> = new Vector.<Number>();
			//TOP tier!
			if (potentialWords.length == 0)
			{
				if (isIdol(primary, secondary))
				{
					potentialWords.push("my idol!");
					potentialIntensity.push(5);
				}
				else if (isBiggestLoser(primary, secondary))
				{
					potentialWords.push("pathetic!");
					potentialIntensity.push(1);
				}
			}
			
			
			//MIDDLE tier
			if (potentialWords.length == 0) 
			{
				
			}
			
			//BOTTOM tier
			if (potentialWords.length == 0)
			{
				if (primaryBlueValue < 0.20)
				{
					potentialWords.push("total loser!");
					potentialIntensity.push(1);
				}
				else if (primaryBlueValue < 0.40)
				{
					potentialWords.push("lame");
					potentialIntensity.push(2);
				}
				else if (primaryBlueValue < 0.60)
				{
					potentialWords.push("meh");
					potentialIntensity.push(3);
				}
				else if (primaryBlueValue < 0.80)
				{
					potentialWords.push("cool");
					potentialIntensity.push(4);
				}
				else 
				{
					potentialWords.push("super cool!");
					potentialIntensity.push(5);
				}
			}
			
			//choose ONE of the potential words that will be the word for that whole turn
			var randIndex:int = Utility.randRange(0, (potentialWords.length - 1));
			coolDictionary["text"] = LineOfDialogue.preprocessLine(potentialWords[randIndex]);
			coolDictionary["intensity"] = potentialIntensity[randIndex];
			
			
			//var extraWords:String = "";
			//var romanceIntensity:Number = this.getRomanceText(primary, secondary)["intensity"];
			//if (Math.abs((romanceIntensity - coolDictionary["intensity"])) >= 2)
			//{
				//extraWords = "but";
				//if (Math.random() > 0.5)
				//{
					//extraWords += "...";
				//}
				//extraWords += " ";
			//}
			//coolDictionary["text"] = extraWords + coolDictionary["text"];
			//
			
			this.coolSubjectiveOpinions[indexString] = coolDictionary;
			return coolDictionary;
		}
		
		
		public function isBestFriend(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (primary.getBestFriend().toLowerCase() == secondary.characterName.toLowerCase())
				returnBool = true;
			return returnBool;
		}
		public function isIdol(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (primary.getIdol().toLowerCase() == secondary.characterName.toLowerCase())
				returnBool = true;
			return returnBool;
		}
		public function isTrueLove(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (primary.getTrueLove().toLowerCase() == secondary.characterName.toLowerCase())
				returnBool = true;
			return returnBool;
		}
		public function isBiggestLoser(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (primary.getBiggestLoser().toLowerCase() == secondary.characterName.toLowerCase())
				returnBool = true;
			return returnBool;
		}
		public function isWorstEnemy(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (primary.getWorstEnemy().toLowerCase() == secondary.characterName.toLowerCase())
				returnBool = true;
			return returnBool;
		}		
		
		public function isDating(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.DATING, primary, secondary))
			{
				returnBool = true;
			}
			return returnBool;
		}
		public function isFriend(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.FRIENDS, primary, secondary))
			{
				returnBool = true;
			}
			return returnBool;
		}
		public function isEnemy(primary:Character, secondary:Character):Boolean
		{
			var returnBool:Boolean = false; 
			if (cif.relationshipNetwork.getRelationship(RelationshipNetwork.ENEMIES, primary, secondary))
			{
				returnBool = true;
			}
			return returnBool;
		}
	}

}