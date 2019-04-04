/******************************************************************************
 * edu.ucsc.eis.socialgame.AdHocSocialGoal
 * 
 * implements SocialGoal interface
 * 
 * The ad hoc social goal is a generic catch-all for goals not encompassed
 * by basic needs goals. When not actively persued by an agent, these goals
 * consist of a volition value and a string tag that describes the goal.
 * 
 *****************************************************************************/
package edu.ucsc.eis.socialgame
{
	import edu.ucsc.eis.socialgame.SocialGoal;

	public class AdHocSocialGoal implements SocialGoal
	{
		private var volition:Number;
		private var topic:String;
		private var persistence:Number;
		private var active:Boolean;
		private var subject:String;
		private var object:String;
		
		public function AdHocGoal():void {
			this.volition = new Number();
			this.topic = new String()
			this.persistence = new Number();
			this.active = new Boolean(false);
			this.subject = new String();
			this.object = new String(); 			
		}

		public function isBasicNeeds():Boolean {return false;}
		
		public function isAdHoc():Boolean{return true;}
		
		public function getVolition():Number {return this.volition;}
		public function getPersistence():Number {return this.persistence;}
		public function getTopic():String {return this.topic;}
		public function getSubject():String {return this.subject;}
		public function getObject():String {return this.object;}
		
		public function setVolition(v:Number):void {
			this.volition = v;
		}
		
		public function setPersistence(p:Number):void {
			this.persistence = p;
		}
		
		public function setTopic(t:String):void {
			this.topic = t;
		}
		
		public function setSubject(s:String):void{this.subject = s;}
		public function setObject(o:String):void{this.object = o;}
		
		public function isActive():Boolean{
			return this.active;
		}
		
		public function setActive(a:Boolean):void {
			this.active = a;
		}
		
		public function createClone():AdHocSocialGoal {
			var clone:AdHocSocialGoal = new AdHocSocialGoal();
			clone.setVolition(this.volition);
			clone.setTopic(this.topic);
			clone.setPersistence(this.persistence);
			clone.setSubject(this.subject);
			clone.setObject(this.object);
			clone.setActive(this.active);
			return clone;
		}
		
		
		public function toString():String {
			var returnStr:String = new String;
			returnStr = returnStr.concat("AdHocGoal:",this.active,",");
			if(this.active) {
				returnStr=returnStr.concat(this.subject," ",this.topic," ",this.object,",",this.volition,",",this.persistence);
			}else{
				returnStr=returnStr.concat(this.subject," ",this.topic," ",this.object,",",this.volition);
			}
			return returnStr;
		}
	}
}