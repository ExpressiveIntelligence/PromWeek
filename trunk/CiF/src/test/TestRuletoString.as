package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * ...
	 * @author Travis
	 */
	public class TestRuletoString {
		public var rule:Rule;		
		
		public var influenceRule:InfluenceRule;
		public var influenceRule2:InfluenceRule;
		
		public var traitPred:Predicate;
		public var traitPred2:Predicate;
		public var relationshipPred:Predicate;
		public var relationshipPred2:Predicate;
		public var statusPred:Predicate;
		public var statusPred2:Predicate;
		public var ckbPred:Predicate;
		public var networkPred:Predicate;
		public var networkPred2:Predicate;
		public var networkPred3:Predicate;
		public var networkPred4:Predicate;
		public var sfdbPred:Predicate;
		public var cif:CiFSingleton;
		
		
		[Before]
		public function setUp():void {
			cif = CiFSingleton.getInstance();
			cif.clear();
			cif.defaultState();
			rule = new Rule();
			influenceRule = new InfluenceRule();
			
			influenceRule2 = new InfluenceRule();
			
			traitPred = new Predicate();
			traitPred2 = new Predicate();
			relationshipPred = new Predicate();
			relationshipPred2 = new Predicate();
			statusPred = new Predicate();
			statusPred2 = new Predicate();
			ckbPred = new Predicate();
			networkPred = new Predicate();
			networkPred2 = new Predicate();
			networkPred3 = new Predicate();
			networkPred4 = new Predicate();
			sfdbPred = new Predicate();
			
			influenceRule.id = -1;
			relationshipPred.setRelationshipPredicate("initiator", "responder", RelationshipNetwork.DATING, true);
			networkPred4.setNetworkPredicate("initiator", "responder", "greaterthan", 66, SocialNetwork.COOL, true);
			relationshipPred2.setRelationshipPredicate("initiator", "responder", RelationshipNetwork.FRIENDS, true);
			networkPred.setNetworkPredicate("initiator", "responder", "greaterthan", 33, SocialNetwork.BUDDY, false);
			networkPred2.setNetworkPredicate("initiator", "responder", "lessthan", 67, SocialNetwork.BUDDY, false);		
			networkPred3.setNetworkPredicate("initiator", "responder", "greaterthan", 66, SocialNetwork.ROMANCE, true);
			statusPred2.setStatusPredicate("initiator", "responder", Status.BULLY, false);
			statusPred.setStatusPredicate("initiator", "responder", Status.HAS_A_CRUSH_ON, true);
			traitPred.setTraitPredicate("other", Trait.CONFIDENT, true);
			traitPred2.setTraitPredicate("responder", Trait.BRAINY, true);
			sfdbPred.setSFDBLabelPredicate("initiator", "responder", SocialFactsDB.CAT_POSITIVE, false, 5);
			ckbPred.setCKBPredicate("initiator", "likes", "likes", "dislikes", "cool");
			
			rule.predicates.push(traitPred);
			rule.predicates.push(networkPred);
			rule.predicates.push(networkPred3);
			rule.predicates.push(networkPred2);
			
			rule.predicates.push(statusPred);
			rule.predicates.push(ckbPred);
			rule.predicates.push(relationshipPred);
			rule.predicates.push(relationshipPred2);
			rule.predicates.push(networkPred4);
			rule.predicates.push(sfdbPred);

			influenceRule.predicates.push(traitPred);
			influenceRule.predicates.push(traitPred2);
			influenceRule.predicates.push(networkPred3);
			influenceRule.predicates.push(networkPred2);
			influenceRule.predicates.push(networkPred);
			influenceRule.predicates.push(relationshipPred2);
			
			influenceRule.predicates.push(sfdbPred);
			influenceRule.predicates.push(statusPred);
			influenceRule.predicates.push(ckbPred);
			influenceRule.predicates.push(networkPred4);
			influenceRule.predicates.push(relationshipPred);
			influenceRule.predicates.push(statusPred2);
			
			influenceRule.predicates[9].intent = true;
			//influenceRule.predicates[1].operator = "+";
			//influenceRule.predicates.push(sfdbPred);
			
			influenceRule2.predicates.push(relationshipPred);
			influenceRule2.predicates[0].intent = true;
			
			
		}
		//toString testing
		
		[Test]
		public function testRule():void {
			//trace(rule.toString());
			var baseline:String = "trait(initiator, confident)^buddyNetwork(initiator, responder) greaterthan 33^buddyNetwork(initiator, responder) lessthan 67^status(initiator, responder, has a crush on)^ckb(initiator, likes, responder, dislikes, cool)^{~relationship(initiator, responder, dating)}^relationship(initiator, responder, friends)";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "testRule:\n" + rule.toString());
			Assert.assertTrue(baseline == rule.toString());
		}
		
		[Test]
		public function testRuleXML():void {
			//trace(rule.toXMLString());
			var baseline:String = "<Rule name=\"Anonymous Rule\" id=\"-1\">\n  <Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n"; 
			baseline += "  <Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"greaterthan\" value=\"33\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "  <Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"lessthan\" value=\"67\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "  <Predicate type=\"status\" status=\"has a crush on\" first=\"initiator\" second=\"responder\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "  <Predicate type=\"CKBEntry\" first=\"initiator\" second=\"responder\" firstSubjective=\"likes\" secondSubjective=\"dislikes\" label=\"cool\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n"; 
			baseline += "  <Predicate type=\"relationship\" first=\"initiator\" second=\"responder\" relationship=\"dating\" negated=\"true\" intent=\"true\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "  <Predicate type=\"relationship\" first=\"initiator\" second=\"responder\" relationship=\"friends\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "</Rule>";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "testRuleXML:\n" + rule.toXMLString());
			Assert.assertTrue(baseline == rule.toXMLString());
		}
		
		//toXMLString testing
		
		[Test]
		public function testInfluenceRule():void {
			//trace(this.influenceRule.predicates.length);
			//trace(influenceRule.toString());
			var baseline:String = "0: trait(initiator, confident)^buddyNetwork(initiator, responder) lessthan 67^buddyNetwork(initiator, responder) greaterthan 33^relationship(initiator, responder, friends)^status(initiator, responder, has a crush on)^ckb(initiator, likes, responder, dislikes, cool)^{~relationship(initiator, responder, dating)}";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "testInfluenceRule.toString():\n" + influenceRule.toString());
			Assert.assertTrue(baseline == influenceRule.toString());
		}
		
		[Test]
		public function testInfluenceRuleXML():void {
			//trace(influenceRule.toXMLString());
			var baseline:String = "<InfluenceRule weight=\"0\" name=\"Anonymous Rule\" id=\"-1\">\n";
			baseline += "<Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n"; 
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"lessthan\" value=\"67\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"greaterthan\" value=\"33\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";			baseline += "<Predicate type=\"relationship\" first=\"initiator\" second=\"responder\" relationship=\"friends\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"relationship\" first=\"initiator\" second=\"responder\" relationship=\"friends\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "<Predicate type=\"status\" status=\"has a crush on\" first=\"initiator\" second=\"responder\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "<Predicate type=\"CKBEntry\" first=\"initiator\" second=\"responder\" firstSubjective=\"likes\" secondSubjective=\"dislikes\" label=\"cool\" negated=\"false\" intent=\"false\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n"; 
			baseline += "<Predicate type=\"relationship\" first=\"initiator\" second=\"responder\" relationship=\"dating\" negated=\"true\" intent=\"true\" isSFDB=\"false\" window=\"0\" numTimesUniquelyTrueFlag=\"false\" numTimesUniquelyTrue=\"0\" numTimesRoleSlot=\"\"/>\n";
			baseline += "</InfluenceRule>\n";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "influenceRule.toXMLString():\n" + influenceRule.toXMLString());
			Assert.assertTrue(baseline == influenceRule.toXMLString());

		}
		
		[Test]
		public function testGeneratedRuleName():void {
			var baseline:String = "Intent(~Dating) Friends | ButNetMed | has a crush on | confident | CKB";
			//Debug.debug(this, "\nbaseline:\n" + baseline);
			//Debug.debug(this, "influenceRule.generatedString():\n" + influenceRule.generateRuleName());
			Assert.assertTrue(baseline == influenceRule.generateRuleName());
		}
		
		[Test]
		public function testisGeneratedRuleEqualToName():void {
			influenceRule2.generateRuleName();
			influenceRule2.name = "Intent(~Dating)";
			//Assert.assertTrue(influenceRule2.isGeneratedRuleEqualToName());
		}


	}

}