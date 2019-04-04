package edu.ucsc.eis.socialgame	
{
	public class BasicNeedGoal implements SocialGoal
	{
		private var volition:Number;
		private var need:int;
		private var persistence:Number;
		private var active:Boolean;
		
		public function BasicNeedGoal() {
			this.volition = new Number();
			this.need = new int();
			this.persistence = new Number();
			this.active = new Boolean(false); 			
		}

		
		public function isBasicNeeds():Boolean {return true;}
		public function isAdHoc():Boolean {return false;}
		
		public function getVolition():Number {return this.volition;}
		public function getPersistence():Number {return this.persistence;}
		public function getBasicNeed():int {return this.need;}
		
		public function setVolition(v:Number):void {
			this.volition = v;
		}
		
		public function setPersistence(p:Number):void {
			this.persistence = p;
		}
		
		public function setNeed(n:int):void {
			this.need = n;
		}
		
		/* To tell if the goal is value object or if it is representing
		 * an active goal.
		 */
		public function isActive():Boolean {return this.active;}

		public function setActive(a:Boolean):void {this.active = a;}

		public function toString():String {
			var returnStr:String = new String;
			returnStr = returnStr.concat("BasicNeedGoal:",this.active,",");
			//if(this.active) {
				returnStr=returnStr.concat(this.need,",",this.volition,",",this.persistence);
			//}else{
			//	returnStr=returnStr.concat(this.need);
			//}
			return returnStr;
		}

	}
}