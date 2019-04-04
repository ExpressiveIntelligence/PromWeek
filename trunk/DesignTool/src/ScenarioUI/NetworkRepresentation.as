package ScenarioUI
{
	import CiF.*;
	import spark.components.Group;
	import flash.events.MouseEvent;
	
	/**
	 * 
	 */
	public class NetworkRepresentation extends Group
	{
		public var networkLines:Vector.<NetworkLine>;
		
		private var cif:CiFSingleton;
		
		public var selectedChar:Character;
		
		public var characterRepresentations:Vector.<CharacterRepresentation>;
		
		public var typeToDisplay:int = SocialNetwork.BUDDY;
		
		public function NetworkRepresentation(){
			super();
			
			cif = CiFSingleton.getInstance();
			
			networkLines = new Vector.<NetworkLine>();
			characterRepresentations = new Vector.<CharacterRepresentation>;
		}
		
		
		
		/**
		 * Updates the position and scale of each network line coming from the gameEngine's currentSelection
		 */
		public function update():void {
			//Debug.debug(this, "update()");
			//if there is an avatar selection, make sure all the right lines are visible and not visible
			for each (var line:NetworkLine in networkLines){	
				if ("selected" == line.fromChar.currentState){
					//Debug.debug(this, "update() updating line from currently selected character: " + line.fromChar.character.characterName);
					line.type = this.typeToDisplay;
					line.update();
					line.visible = true;
				}else{
					line.visible = false;
				}
			}
		}
		
		/**
		 * For every avatar, create a NetworkLine between them. These will be redrawn/colored/sized by each line's update according to the CharInfoUI.
		 */
		public function createNetworkLines():void {
			//Debug.debug(this, "createNetworkLines() number of character representations: " + this.characterRepresentations.length);
			//remove old representations
			for each (var nl:ScenarioUI.NetworkLine in this.networkLines) {
				this.removeElement(nl);
			}
			this.networkLines = new Vector.<NetworkLine>();
			for each (var char1:CharacterRepresentation in this.characterRepresentations) {
				for each (var char2:CharacterRepresentation in this.characterRepresentations) {	
					if (char1.character.characterName != char2.character.characterName) {
						//Debug.debug(this, "createNetworkLines() creating a network line between: " + char1.character.characterName + " and " + char2.character.characterName);
						var line:NetworkLine = new NetworkLine();
						line.fromChar = char1;
						line.toChar = char2;
						line.type = this.typeToDisplay;
						networkLines.push(line);
						this.addElement(line);
					}
				}
			}
		}
	}

}