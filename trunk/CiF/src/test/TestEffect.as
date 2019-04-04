package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * ...
	 * @author Travis
	 */
	public class TestEffect {
		public var effect:Effect;
		public var effect2:Effect;
		
		
		public var traitPred:Predicate;
		public var relationshipPred:Predicate;
		public var statusPred:Predicate;
		public var ckbPred:Predicate;
		public var networkPred:Predicate;
		public var sfdbPred:Predicate;
		
		
		[Before]
		public function setUp():void {
			effect = new Effect();
			effect2 = new Effect();
			
			effect.id = 2;
			effect2.id = 4;
			
			traitPred = new Predicate();
			relationshipPred = new Predicate();
			statusPred = new Predicate();
			ckbPred = new Predicate();
			networkPred = new Predicate();
			sfdbPred = new Predicate();
			
			traitPred.setTraitPredicate("initiator", Trait.CONFIDENT, false);
			networkPred.setNetworkPredicate("initiator", "responder", "+", 40, SocialNetwork.BUDDY);
			statusPred.setStatusPredicate("initiator", "responder", Status.HAS_A_CRUSH_ON);
			statusPred.isSFDB = true;
			ckbPred.setCKBPredicate("initiator", "responder", "likes", "dislikes", "cool");
			relationshipPred.setRelationshipPredicate("initiator", "responder", RelationshipNetwork.DATING, true);
		
			
			effect.condition.predicates.push(traitPred);
			effect.condition.predicates.push(ckbPred);
			effect.condition.predicates.push(statusPred);
			effect.change.predicates.push(traitPred);
			effect.change.predicates.push(relationshipPred);
			effect.change.predicates.push(networkPred);
			
			effect2.condition.predicates.push(traitPred);
			effect2.condition.predicates.push(statusPred);
			effect2.change.predicates.push(relationshipPred);
			effect2.change.predicates.push(networkPred);
			
		}
		//toString testing
		
		[Test]
		public function testEffectToString():void {
			var baseline:String = "Accept: trait(initiator, confident)^ckb(initiator, likes, responder, dislikes, cool)^[status(initiator, responder, has a crush on) window(0)] | trait(initiator, confident)^~relationship(initiator, responder, dating)^buddyNetwork(initiator, responder) + 40";
			//trace(effect.toString());
			//Debug.debug(this, "toString:\n" + effect.toString());
			//Debug.debug(this, "baseline:\n" + baseline);			
			Assert.assertTrue(baseline == effect.toString());
		}
		
		[Test]
		public function testXMLEffect():void {
			var baseline:String = "<Effect id=\"2\" accept=\"true\" instantiationID=\"-1\">\n<PerformanceRealization>null</PerformanceRealization>\n<ConditionRule>\n ";
			baseline += "<Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"CKBEntry\" first=\"initiator\" second=\"responder\" firstSubjective=\"likes\" secondSubjective=\"dislikes\" label=\"cool\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"status\" status=\"has a crush on\" first=\"initiator\" second=\"responder\" negated=\"false\" isSFDB=\"true\" window=\"0\"/>\n";
			baseline += "</ConditionRule>\n<ChangeRule>\n";
			baseline += "<Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"relationship\" first=\"initiator\" second=\"responder\" relationship=\"dating\" negated=\"true\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"+\" value=\"40\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ChangeRule>\n</Effect>\n";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "toXMLString:\n" + effect.toXMLString());
			Assert.assertTrue( baseline == effect.toXMLString());
		}
		
		[Test]
		public function testEquals():void {
			//Debug.debug(this, "Effect Equals");
			Assert.assertTrue(Effect.equals(effect, effect));
			Assert.assertFalse(Effect.equals(effect, effect2));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(Effect.equals(effect, effect.clone()));
		}
	}

}