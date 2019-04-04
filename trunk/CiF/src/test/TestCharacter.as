package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 *
	 */
	public class TestCharacter
	{
		
		public var edward:Character;
		public var karen:Character;
		
		[Before]
		public function setUp():void {
			this.edward = new Character();
			this.edward.characterName = "Edward";
			this.edward.networkID = 0;
			this.edward.setTrait(Trait.HUMBLE);
			
			
			this.karen = new Character();
			this.karen.characterName = "Karen";
			this.karen.networkID = 1;
			this.karen.setTrait(Trait.AFRAID_OF_COMMITMENT);
			
			//statuses
			this.edward.addStatus(Status.ANGRY_AT, karen);
			this.karen.addStatus(Status.SHAKEN);
		}

		[Test]
		public function testHasStatus():void {
			Assert.assertTrue(this.edward.hasStatus(Status.ANGRY_AT, this.karen));
		}

		[Test]
		public function testRemoveStatus():void {
			this.edward.removeStatus(Status.ANGRY_AT);
			Assert.assertFalse(this.edward.hasStatus(Status.ANGRY_AT, this.karen));
		}
		
		[Test]
		public function testUpdateStatusDuration():void {
			var status:Status = this.edward.statuses[Status.ANGRY_AT];
			this.edward.updateStatusDurations();
			//Debug.debug(this, "testUpdateStatusDuration():  edward's emnity duration remaining: " + status.remainingDuration);
			Assert.assertTrue(2 == status.remainingDuration);
		}
		
		[Test]
		public function testXMLString():void {
			var baseLine:String = "<Character name=\"Edward\" networkID=\"0\">\n  <Trait type=\"humble\"/>\n  <Status type=\"angry at\" from=\"Edward\" to=\"Karen\"/>\n</Character>";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "toXML:\n" + this.edward.toXMLString());
			Assert.assertTrue(baseLine == this.edward.toXMLString());
		}
		
		[Test]
		public function testSetTrait():void {
			this.edward.setTrait(Trait.COLD);
			Assert.assertTrue(this.edward.hasTrait(Trait.COLD));
		}
		
		[Test]
		public function testEquals():void {
			Assert.assertTrue(Character.equals(edward, edward));
			Assert.assertFalse(Character.equals(edward, karen));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(Character.equals(edward, edward.clone()));
		}
		
		
		
	}

}