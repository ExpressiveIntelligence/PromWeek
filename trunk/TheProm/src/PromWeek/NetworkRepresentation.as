package PromWeek
{
	import spark.components.Group;
	import flash.events.MouseEvent;
	
	/**
	 * Draws the selection circle for selected character representation to the user.
	 * 
	 */
	public class NetworkRepresentation extends Group
	{
		public var networkLines:Vector.<NetworkLine>;
		
		private var gameEngine:GameEngine;
		
		public function NetworkRepresentation()
		{
			super();
			
			gameEngine = GameEngine.getInstance();
			
			networkLines = new Vector.<NetworkLine>();
		}
		

		
		/**
		 * Updates the position and scale of each network line coming from the gameEngine's currentSelection
		 */
		public function update():void
		{
			//if there is an avatar selection, make sure all the right lines are visible and not visible
			if (gameEngine.primaryAvatarSelection != null)
			{
				for each (var line:NetworkLine in networkLines)
				{	
					if (line.fromChar == gameEngine.primaryAvatarSelection)
					{
						line.update();
						line.visible = true;
						
					}
					else
					{
						line.visible = false;
					}
				}
			}
		}
		
		/**
		 * For every avatar, create a NetworkLine between them. These will be redrawn/colored/sized by each line's update according to the CharInfoUI.
		 */
		public function createNetworkLines():void
		{
			for each (var char1:Avatar in gameEngine.worldGroup.avatars)
			{
				for each (var char2:Avatar in gameEngine.worldGroup.avatars)
				{	
					if (char1.characterName != char2.characterName)
					{
						var line:NetworkLine = new NetworkLine();
						line.fromChar = char1.characterName;
						line.toChar = char2.characterName;
						networkLines.push(line);
						this.addElement(line);
					}
				}
			}
		}
	}

}