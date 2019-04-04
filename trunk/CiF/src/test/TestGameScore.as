package test 
{
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.GameScore;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestGameScore
	{
		
		public var cif:CiFSingleton;
		public var gameScore:GameScore;
		public var gameScore2:GameScore;

		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			gameScore = new GameScore();
			gameScore2 = new GameScore();
			
			//and fill up our gameScore with some default values!
			gameScore.name = "ask out";
			gameScore.initiator = "karen";
			gameScore.responder = "edward";
			gameScore.score = 30;
		
		}
		
		[Test]
		public function testXMLString():void {
			var baseLine:String = "<GameScore name=\"ask out\" initiator=\"karen\" responder=\"edward\" score=\"30\" />";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "testXML:\n" + gameScore.toXMLString());
			Assert.assertTrue(baseLine == gameScore.toXMLString());
		}
		
		[Test]
		public function testEquals():void {
			//Debug.debug(this, "GameScore Equals");
			Assert.assertTrue(GameScore.equals(gameScore, gameScore));
			Assert.assertFalse(GameScore.equals(gameScore, gameScore2));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(GameScore.equals(gameScore, gameScore.clone()));
		}
		
	}

}