package PromWeek 
{
	import CiF.Character;
	import CiF.Predicate;
	import CiF.Rule;
	import CiF.SFDBContext;
	
	/**
	 * ...
	 * @author Mike
	 */
	public class JuiceContext implements SFDBContext 
	{
		public static const TYPE_SWITCH_OUTCOME:Number = 0;
		public static const TYPE_BUY_GAME:Number = 1;
		public static const TYPE_BUY_RESULTS:Number = 2;
		public static const TYPE_BUY_MOTIVES:Number = 3;
		
		public var type:int = -1;
		public var cost:Number;
		public var gameName:String;
		public var initiator:String;
		public var responder:String;
		public var time:int;
		
		public static var order:int = 0;
		private var order:int;
		
		/**
		 * This is what the switch outcome set the response to (after the switch outcome has done its switching)
		 */
		public var newResponse:String;
		
		
		public function JuiceContext() 
		{
			this.order = JuiceContext.order++;
		}
		
		public function getChange():Rule { return null; }
		
		public function getTime():int { return this.time; }
		
		public function isSocialGame():Boolean { return false; }
		
		public function isJuice():Boolean { return true; }
		
		public function isTrigger():Boolean { return false; }
		
		public function isStatus():Boolean { return false; }
		
		public function isPredicateInChange(p:Predicate, x:Character, y:Character, z:Character):Boolean
		{
			return false;
		}
		
		public function toXML():XML 
		{
			var outXML:XML;
			outXML= <JuiceContext type={this.type} cost={this.cost} order={this.order} time={this.time} gameName={this.gameName} initiator={this.initiator} responder={this.responder}/> ;
			if (this.type == JuiceContext.TYPE_SWITCH_OUTCOME)
			{
				outXML.@newResponse = this.newResponse;				
			}
			
			return outXML;
		}

		public function toXMLString():String 
		{
			return this.toXML().toXMLString();
		}
		
		
		public function loadFromXML(juiceContextXML:XML):SFDBContext
		{
			var juiceContext:JuiceContext = new JuiceContext();
			juiceContext.type = (juiceContextXML.@type.toString())?juiceContextXML.@type: -1;
			juiceContext.cost = (juiceContextXML.@cost.toString())?juiceContextXML.@cost: -1;
			juiceContext.time = (juiceContextXML.@time.toString())?juiceContextXML.@time: -1;
			juiceContext.gameName = (juiceContextXML.@gameName.toString())?juiceContextXML.@gameName: "";
			juiceContext.gameName = (juiceContextXML.@initiator.toString())?juiceContextXML.@initiator: "";
			juiceContext.gameName = (juiceContextXML.@responder.toString())?juiceContextXML.@responder: "";
			juiceContext.newResponse = (juiceContextXML.@newResponse.toString())?juiceContextXML.@newResponse: "";
			juiceContext.order = (juiceContextXML.@order.toString())?juiceContextXML.@order: -1;

			return juiceContext;
		}
		
		
	}

}