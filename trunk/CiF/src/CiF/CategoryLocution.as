package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class CategoryLocution implements Locution
	{
		public var realizedString:String;
		
		public var candidates:Vector.<Number>;
		
		public var type:String;
		public var who:String;
		
		public var towardWho:String;
		
		
		public function CategoryLocution() 
		{
			candidates = new Vector.<Number>();
			
			towardWho = "";
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			realizedString = "";
			
			var char:Character;
			if (this.who == "i")
			{
				char = initiator;
			}
			else if (this.who == "r")
			{
				char = responder;
			}
			else if (this.who == "o")
			{
				char = other;
			}
			
			
			//if a status it is directed, get the char it is directed to
			var towardChar:Character;
			if (this.towardWho == "i")
			{
				towardChar = initiator;
			}
			else if (this.towardWho == "r")
			{
				towardChar = responder;
			}
			else if (this.towardWho == "o")
			{
				towardChar = other;
			}
			
			
			//make it the format of the toString
			if (type.substr(0, 5) != "cat: ")
			{
				this.type = "cat: " + this.type;
			}
			
			if (Trait.getNumberByName(type) != -1)
			{
				for each (var trait:Number in Trait.CATEGORIES[Trait.getNumberByName(type)])
				{
					if (char.hasTrait(trait))
					{
						candidates.push(trait);
					}
				}
				
				//now return a random one from the candidates
				if (candidates.length > 0)
				{
					return Trait.getNameByNumber(candidates[Util.randRange(0, candidates.length - 1)]);
				}
			}
			else if (Status.getStatusNumberByName(type) != -1)
			{
				for each (var status:Number in Status.CATEGORIES[Status.getStatusNumberByName(type)])
				{
					if (towardWho != "")
					{
						if (char.hasStatus(status, towardChar))
						{
							candidates.push(status);
						}
					}
					else
					{
						if (char.hasStatus(status))
						{
							candidates.push(status);
						}
					}
				}
				
				//now return a random one from the candidates
				if (candidates.length > 0)
				{
					if (towardWho != "")
					{
						return Status.getStatusNameByNumber(candidates[Util.randRange(0, candidates.length - 1)]) + " " + towardChar.characterName;
					}
					else
					{
						return Status.getStatusNameByNumber(candidates[Util.randRange(0, candidates.length - 1)]);
					}
				}
			}
			
			//if we get here, we havewn't found any reason to have been in this category, which means it is an error
			//but let's just return the name of the category then sans "cat: "
			return type.replace("cat: ", "");
		}
		
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "CategoryLocution";
		}
	}
}