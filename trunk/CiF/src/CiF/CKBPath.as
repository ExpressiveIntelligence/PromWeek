package CiF 
{
	/**
	 * The CKBPath class represents a full path through the CKB that consists
	 * of a character, connection type, item, and truth label. All four of 
	 * these aspects 
	 */
	public class CKBPath
	{
		/**
		 * The name of the character in the CKB path.
		 */
		public var characterName:String;
		/**
		 * The name of the connection type in the CKB path.
		 */
		public var connectionType:String;
		/**
		 * The name of the item in the CKB path.
		 */
		public var itemName:String;
		/**
		 * The truth label in the CKB path.
		 */
		public var truthLabel:String;
		
		public function CKBPath() {
			
		}
		
		/**********************************************************************
		 * Utility functions.
		 *********************************************************************/
		
		public function toString():String {
			return this.characterName + " " + this.connectionType + " " + this.itemName + " - " + this.truthLabel;
		}
		
	}

}