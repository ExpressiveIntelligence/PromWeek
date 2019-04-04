package eis.comm 
{
	import merapi.messages.Message;
	/**
	 * Class that reconstitutes the script message type when a message
	 * of that type is received from the java side of the bridge.
	 * 
	 * @author Josh
	 */
	public class ScriptMessage extends Message
	{
		public static const SCRIPT:String = "script";
		
		public function ScriptMessage() 
		{
			super(SCRIPT);
		}
		
	}

}