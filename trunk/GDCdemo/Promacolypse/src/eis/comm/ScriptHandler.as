package eis.comm 
{
	import merapi.handlers.mxml.MessageHandler;
	import merapi.messages.IMessage;
	import eis.comm.ScriptMessage;
	import merapi.Bridge;
	
	/**
	 * Merapi handler for the scriptReceved message type.
	 * @author Josh
	 */
	public class ScriptHandler extends MessageHandler
	{
		/* Message type to handle; needs to be the same as was sent from
		 * the java side.
		*/
		public static const SCRIPT:String = "script";
		
		
		public function ScriptHandler() 
		{
			super( ScriptHandler.SCRIPT );
			//connectMerapi();
			Bridge.connect();
		}
		
		/**
		 * The function that constitutes the handler for the script message
		 * types received.
		 * 
		 */
		override public function handleMessage( message:IMessage):void {
			if (message is ScriptMessage) {
				var scriptMessage:ScriptMessage = message as ScriptMessage;
				trace("ScriptHandler.handleMessage(): Received a script message. Handle it!");
			}
		}
		
	}

}