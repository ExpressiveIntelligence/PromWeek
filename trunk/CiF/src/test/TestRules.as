package test {
	
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * ...
	 * @author Josh McCoy
	 */
	public class TestRules{
		
		private var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
		}
		
		
		//[Test]
		public function testARule():void {
			
			//var cif:CiFSingleton = CiFSingleton.getInstance();
			var sg:SocialGame = cif.socialGamesLib.getByName("Brag");
			var e:Effect = sg.getEffectByID(11);
			//Debug.debug(this, "testARule() testing: " + e.toXMLString());
			//Debug.debug(this, "testARule() salience: " + e.scoreSalience());
			//Debug.debug(this, "testARule() evaluation: " + e.evaluateCondition(cif.cast.getCharByName("Zack"), cif.cast.getCharByName("Naomi"), cif.cast.getCharByName("Cassie")));
			//Debug.debug(this, "testARule() evaluation of first pred: " +  e.condition.predicates[0].evaluate(cif.cast.getCharByName("Zack"), cif.cast.getCharByName("Naomi"), cif.cast.getCharByName("Cassie")));
			//Debug.debug(this, "testARule() first pred: " + e.condition.predicates[0].toXMLString());
			
		}
		
		[Test]
		public function testEvaluateOrderedRule():void {
			//0 zack and cassie were dating
			//1 zack cassie budup
			//2 zack cassie friends
			
			var rule:Rule = new Rule();
			var pred:Predicate;
			var result:Boolean;
			
			pred = new Predicate();
			pred.setRelationshipPredicate("initiator", "responder", RelationshipNetwork.DATING);
			Debug.debug(this, "testEvaluateOrderedRule() pred1 time found: " + cif.sfdb.timeOfPredicateInHistory(pred, this.cif.cast.getCharByName("Zack"), this.cif.cast.getCharByName("Cassie")));
			Debug.debug(this, "testEvaluateOrderedRule() pred1 eval: " + pred.evaluate(this.cif.cast.getCharByName("Zack"), this.cif.cast.getCharByName("Cassie")));
			rule.predicates.push(pred);
			
			pred = new Predicate();
			pred.setNetworkPredicate("responder", "initiator", "+" , 20, SocialNetwork.ROMANCE);
			//pred.operator = Predicate.getOperatorByNumber(Predicate.ADD);
			pred.sfdbOrder = 4;
			pred.isSFDB = true;
			pred.window = 0;
			rule.predicates.push(pred);
			
			Debug.debug(this, "testEvaluateOrderedRule() pred2 time found: " + cif.sfdb.timeOfPredicateInHistory(pred, this.cif.cast.getCharByName("Zack"), this.cif.cast.getCharByName("Cassie")));
			Debug.debug(this, "testEvaluateOrderedRule() pred2 eval: " + pred.evaluate(this.cif.cast.getCharByName("Zack"), this.cif.cast.getCharByName("Cassie")));
			
			pred = new Predicate();
			pred.setSFDBLabelPredicate("initiator", "other", SocialFactsDB.CAT_NEGATIVE);
			pred.sfdbOrder = 2;
			rule.predicates.push(pred);
			Debug.debug(this, "testEvaluateOrderedRule() pred3 time found: " + cif.sfdb.timeOfPredicateInHistory(pred, this.cif.cast.getCharByName("Zack"), null, this.cif.cast.getCharByName("Buzz")));
			Debug.debug(this, "testEvaluateOrderedRule() pred3 eval: " + pred.evaluate(this.cif.cast.getCharByName("Zack"), this.cif.cast.getCharByName("Buzz")));
			
			result = rule.evaluate(this.cif.cast.getCharByName("Zack"), this.cif.cast.getCharByName("Cassie"), this.cif.cast.getCharByName("Buzz"));
			
			Debug.debug(this, "testEvaluateOrderedRule() result: " + result);
			Assert.assertTrue(result);
			
		}
		
	}

}