package test 
{
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.Predicate;
	import CiF.Rule;
	import CiF.Trait;
	import CiF.TriggerContext;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestTriggerContext
	{
		
		public var cif:CiFSingleton;
		public var testTC:TriggerContext;
		public var rule:Rule;
		public var predicate:Predicate;

		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.testTC = new TriggerContext();
			this.rule = new Rule();
			this.predicate = new Predicate();
			
			testTC.time = 20;
			rule.name = "friendly";
			predicate.type = Predicate.TRAIT;
			predicate.trait = Trait.CONFIDENT;
			predicate.first = "initiator";
			rule.predicates.push(predicate);
			testTC.change = rule;

		}
		
		[Test]
		public function testXMLString():void {
			var baseLine:String = "<TriggerContext time=\"20\">\n  <Rule name=\"friendly\">\n    <Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n  </Rule>\n</TriggerContext>";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "testXML:\n" + testTC.toXMLString());
			Assert.assertTrue(baseLine == testTC.toXMLString());
		}
		
	}

}