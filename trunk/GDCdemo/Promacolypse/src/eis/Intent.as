package eis 
{
	//import air.net.SocketMonitor;
	/**
	* Demo's version of the intent formation process. As it stands now, it
	* determines the lists of the highest scored social games from character
	* volition, game change type, and what games are available to play.
	* */
	/*	Social games defined in GameEngine.as.			
	* this.romanceUpSG = new Vector.<SocialGame>();
			this.relationshipUpSG = new Vector.<SocialGame>();
			this.relationshipDownSG = new Vector.<SocialGame>();
			this.datingSG = new Vector.<SocialGame>();
			this.notFriendsSG = new Vector.<SocialGame>();*/
	public class Intent
	{
		public var possibleGames:Vector.<FilledGame>;
		public var possibleGameScores:Vector.<Number>;
		public var topGames:Vector.<SocialGame>;
		public var perCharacterGames:Vector.<Vector.<SocialGame>>;
		public var sortedGames:Vector.<FilledGame>;
		
		public function Intent() {
			this.possibleGames = new Vector.<FilledGame>();
			this.possibleGameScores = new Vector.<Number>();
			this.topGames = new Vector.<SocialGame>();
			this.perCharacterGames = new Vector.<Vector.<SocialGame>>();
			this.sortedGames = new Vector.<FilledGame>();
		}
		
		public function formIntent(char:Character, characters:Object, prosMem:ProspectiveMemory,
			hierarchies:Vector.<Hierarchy>, romUp:Vector.<SocialGame>, relUp:Vector.<SocialGame>,
			relDown:Vector.<SocialGame>, dating:Vector.<SocialGame>, notFriends:Vector.<SocialGame>,
			rel:SocialNetwork, rom:SocialNetwork, auth:SocialNetwork, status:StatusNetwork):void {
			//trace(prosMem);
				
			for each (var otherChar:Character in characters) {
				if(char.characterName != otherChar.characterName) {
					//Assign truth values to these based on a run of their associated hierarchy.
					var i:int;
					var romUpAccept:Boolean; 
					var relDownAccept:Boolean;
					var relUpAccept:Boolean;
					var datingAccept:Boolean;
					var notFriendsAccept:Boolean;

					for (i = 0; i < hierarchies.length; ++i) {
						if (hierarchies[i].type == SocialGame.ROMANCE_UP) {
							romUpAccept = hierarchies[i].execute(char, otherChar, characters, rel, rom, auth, status);
						}else if (hierarchies[i].type == SocialGame.RELATIONSHIP_UP) {
							relUpAccept = hierarchies[i].execute(char, otherChar, characters, rel, rom, auth, status);
						}else if (hierarchies[i].type == SocialGame.RELATIONSHIP_DOWN) {
							relDownAccept = hierarchies[i].execute(char, otherChar, characters, rel, rom, auth, status);
						}else if (hierarchies[i].type == SocialGame.DATING) {
							datingAccept = hierarchies[i].execute(char, otherChar, characters, rel, rom, auth, status);
						}else if (hierarchies[i].type == SocialGame.NOT_FRIENDS) {
							notFriendsAccept = hierarchies[i].execute(char, otherChar, characters, rel, rom, auth, status);
						}
					}				
					
					trace("Hierarchy: " + char.characterName + " " + otherChar.characterName+ " " + romUpAccept + " " + relUpAccept + " " + relDownAccept + " "+ datingAccept + " " + notFriendsAccept);
					
					
					//look at romUp social games and add those that correspond to romUpAccept value.
					//Do the same for the rest of the social game categories.
					//trace("character.charactername: " + prosMem.getValue(otherChar, SocialGame.RELATIONSHIP_UP));
					for (i = 0; i < romUp.length; ++i) {
						if (romUp[i].isSuccess == romUpAccept) {
							this.possibleGames.push(
								new FilledGame(romUp[i], 
								prosMem.getValue(otherChar, SocialGame.ROMANCE_UP),
								char.characterName,
								otherChar.characterName));
							//this.possibleGameScores.push(prosMem.getValue(char, SocialGame.ROMANCE_UP));
						}
					}
					for (i = 0; i < relUp.length; ++i) {
						if (relUp[i].isSuccess == relUpAccept) {
							this.possibleGames.push(
								new FilledGame(relUp[i],
								prosMem.getValue(otherChar, SocialGame.RELATIONSHIP_UP),
								new String(char.characterName),
								otherChar.characterName));
							//this.possibleGameScores.push(prosMem.getValue(otherChar, SocialGame.RELATIONSHIP_UP));
						}
					}
					for (i = 0; i < relDown.length; ++i) {
						if (relDown[i].isSuccess == relDownAccept) {
							this.possibleGames.push(
								new FilledGame(relDown[i], 
								prosMem.getValue(otherChar, SocialGame.RELATIONSHIP_DOWN),
								char.characterName,
								otherChar.characterName));
							//this.possibleGameScores.push(prosMem.getValue(otherChar, SocialGame.RELATIONSHIP_DOWN));
						}
					}
					for (i = 0; i < dating.length; ++i) {
						if (dating[i].isSuccess == datingAccept) {
							this.possibleGames.push(
								new FilledGame(dating[i], 
								prosMem.getValue(otherChar, SocialGame.DATING),
								char.characterName,
								otherChar.characterName));
							//this.possibleGameScores.push(prosMem.getValue(otherChar, SocialGame.DATING));
						}
					}
					for (i = 0; i < notFriends.length; ++i) {
						if (notFriends[i].isSuccess == notFriendsAccept) {
							this.possibleGames.push(
								new FilledGame(notFriends[i], 
									prosMem.getValue(otherChar, SocialGame.NOT_FRIENDS),
								char.characterName,
								otherChar.characterName));
							//this.possibleGameScores.push(prosMem.getValue(otherChar, SocialGame.NOT_FRIENDS));
						}
					}
				}
				//trace("Number of possible games: " + this.possibleGames.length);
				//creat the view on the possible social games
				
				//top social games
				this.sortedGames = this.possibleGames.sort(FilledGame.compare);
				//trace(this.possibleGames);
				
				
				//top social games per other character
			}
			
			
		}
		public function getFilledGamesFor(targetName:String):Vector.<FilledGame> {
				var charGames:Vector.<FilledGame> = new Vector.<FilledGame>();
				var i:int; 
				for (i = 0; i < this.sortedGames.length; ++i) {
					if (this.sortedGames[i].target == targetName) {
						charGames.push(this.sortedGames[i]);
					}
				}
				//trace(charGames);
				return charGames;
			}
	}

}