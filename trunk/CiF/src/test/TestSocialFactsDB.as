package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	import org.flexunit.async.Async;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestSocialFactsDB
	{
		public var cif:CiFSingleton;
		
		
		/*[Beforeclass]
		public static function classSetUp():void {
			this.cif = CiFSingleton.getInstance();
			
		}*/
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
		}
		
		[Test]
		public function testFindLabelFromValues():void {
			this.cif = CiFSingleton.getInstance();
			var matchingContexts:Vector.<int>;
			//first only - 12 zack
			matchingContexts = cif.sfdb.findLabelFromValues( -1, cif.cast.getCharByName("Zack"));
			//for each (var cnum:int in matchingContexts) Debug.debug(this, "testFindLabelFromValue() cnum: " + cnum);
			//Debug.debug(this, "testFindLabelFromValues(): zack as first matching contexts: " + matchingContexts.length);
			Assert.assertTrue(matchingContexts.length == 10);
			
			//first and second - 2 Monical, lil
			matchingContexts = cif.sfdb.findLabelFromValues( -1, cif.cast.getCharByName("Monica"), cif.cast.getCharByName("Lil"));
			//Debug.debug(this, "testFindLabelFromValues(): monica as first and lil as second matching contexts: " + matchingContexts.length);
			Assert.assertTrue(matchingContexts.length == 2);
		
			//label only
			matchingContexts = cif.sfdb.findLabelFromValues( SocialFactsDB.ROMANTIC);
			//Debug.debug(this, "testFindLabelFromValues(): label of romantic matching contexts: " + matchingContexts.length);
			Assert.assertTrue(matchingContexts.length == 3);
			
			//first and label only
			matchingContexts = cif.sfdb.findLabelFromValues( SocialFactsDB.MEAN, cif.cast.getCharByName("Nicholas"));
			//Debug.debug(this, "testFindLabelFromValues(): label of mean and first Nicholas matching contexts: " + matchingContexts.length);
			Assert.assertTrue(matchingContexts.length == 2);
			
			//second and label only
			matchingContexts = cif.sfdb.findLabelFromValues( SocialFactsDB.RUDE, null, cif.cast.getCharByName("lil"));
			//Debug.debug(this, "testFindLabelFromValues(): label of nice and second Lil matching contexts: " + matchingContexts.length);
			Assert.assertTrue(matchingContexts.length == 2);
			
			//first, second, and label
			matchingContexts = cif.sfdb.findLabelFromValues( SocialFactsDB.NICE, cif.cast.getCharByName("Jordan"), cif.cast.getCharByName("Doug"));
			//Debug.debug(this, "testFindLabelFromValues(): label of mean and first Nicholas matching contexts: " + matchingContexts.length);
			Assert.assertTrue(matchingContexts.length == 2);
			
		}
		
		[Test]
		public function testfindPredicateInChange():void {
			//var result:int;
			//var pred:Predicate = new Predicate();
			//pred.setNetworkPredicate("initiator", "responder", "lessthan", 10, SocialNetwork.BUDDY);
			//pred.window = 1;
			//result = cif.sfdb.findPredicateInChange(pred);
			//Debug.debug(this, "testfindPredicateInChange(): " + result);
			//Assert.assertTrue(true);
			
		}
		
		[Test]
		public function timeOfPredicateInHistory():void {
			
			
			
			Assert.assertTrue(true);
			
		}
		
	}

}