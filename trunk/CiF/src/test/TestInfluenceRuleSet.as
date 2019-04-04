package test 
{
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.InfluenceRule;
	import CiF.InfluenceRuleSet;
	import CiF.Predicate;
	import CiF.Status;
	//import CiF.StatusNetwork;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestInfluenceRuleSet
	{
		
		public var influenceRS:InfluenceRuleSet;
		public var influenceRS2:InfluenceRuleSet;
		public var influenceRule:InfluenceRule;
		public var predicate:Predicate;
		public var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			cif = CiFSingleton.getInstance();
			cif.clear();
			influenceRule = new InfluenceRule();
			influenceRS = new InfluenceRuleSet();
			influenceRS2 = new InfluenceRuleSet();
			influenceRule.name = "test!";
			influenceRule.weight = 20;
			influenceRule.id = 1;
			
			predicate = new Predicate();
			predicate.negated = false;
			predicate.type = Predicate.STATUS;
			predicate.status = Status.HAS_A_CRUSH_ON;
			predicate.first = "initiator";
			predicate.second = "responder";
			
			influenceRule.predicates.push(predicate);
			influenceRS.influenceRules.push(influenceRule);
			
			
		}
		
		[Test]
		public function testXMLString():void {
			var baseline:String = "<InfluenceRule weight=\"20\" name=\"test!\" id=\"1\">\n<Predicate type=\"status\" status=\"has a crush on\" first=\"initiator\" second=\"responder\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\"/>\n</InfluenceRule>\n";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "toXMLString():\n" + influenceRS.toXMLString());
			Assert.assertTrue(baseline == influenceRS.toXMLString());
		}
		
		[Test]
		public function testEquals():void {
			//Debug.debug(this, "InfluenceRuleSet Equals");
			Assert.assertTrue(InfluenceRuleSet.equals(influenceRS, influenceRS));
			Assert.assertFalse(InfluenceRuleSet.equals(influenceRS, influenceRS2));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(InfluenceRuleSet.equals(influenceRS, influenceRS.clone()));
		}
	}

}