<?php
require_once 'PHPUnit/Extensions/Database/TestCase.php';
require_once 'CsvDataSet.php';
require_once '../global.php';
require_once '../toolkit.php';

class APITests extends PHPUnit_Extensions_Database_TestCase
{
	protected $baseURL;
	
	public function __construct()
	{
		$dbConfig = PromweekConfig::get();
		$this->baseURL = $dbConfig['baseURL'];
		
		parent::__construct();
	}
	
	protected function getConnection()
	{
		$dbConfig = PromweekConfig::get();
		$pdo = new PDO('mysql:host=' . $dbConfig['host'] . ';dbname=' . $dbConfig['db'], $dbConfig['user'], $dbConfig['pass']);
		return $this->createDefaultDBConnection($pdo);
	}
 
	protected function getDataSet()
	{
		$this->dataSet = new CsvDataSet();
		$this->dataSet->addTable('Users', __DIR__ . '/fixtures/users.csv');
		$this->dataSet->addTable('LevelTraces', __DIR__ . '/fixtures/levelTraces.csv');
		$this->dataSet->addTable('AchievementsUnlocked', __DIR__ . '/fixtures/achievementsUnlocked.csv');
		return $this->dataSet;
	}
	
	protected function getUserInfo($facebookId)
	{
		$data = array('uuid' => $facebookId); 
		
		$ch = curl_init($this->baseURL . "/userinfo.php");
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		
		$result = curl_exec($ch);
		$this->assertEquals("", curl_error($ch));
		
		curl_close ($ch);
		return $result;
	}
	
	protected function getAchievements($facebookId)
	{
		$data = array('uuid' => $facebookId); 
		
		$ch = curl_init($this->baseURL . "/getachievements.php");
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		
		$result = curl_exec($ch);
		$this->assertEquals("", curl_error($ch));
		
		curl_close ($ch);
		return $result;
	}
	
	protected function unlockAchievement($facebookId, $achievementId, $levelTraceId = null)
	{
		$data = array(
			'uuid' => $facebookId,
			'aid'	 => $achievementId,
		); 
		
		if (!is_null($levelTraceId))
			$data['ltid'] = $levelTraceId;
		
		$ch = curl_init($this->baseURL . "/unlockachievement.php");
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		
		$result = curl_exec($ch);
		$this->assertEquals("", curl_error($ch));
		
		curl_close ($ch);
		return $result;
	}
	
	public function insertLevelTrace($testfilecontents="",$uuid="",$turns="",$story="",$level="",$rulestrue="")
	{
		$file_to_upload = array('leveltracedata'=>$testfilecontents,
		                        'UUID'=>$uuid,
		                        'TURNS'=>$turns,
		                        'STORY'=>$story,
		                        'LEVEL'=>$level,
		                        'RULESTRUE'=>$rulestrue);

		$ch = curl_init(); 

		curl_setopt($ch, CURLOPT_URL, $this->baseURL . "/receiveLevelTrace.php"); 
		curl_setopt($ch, CURLOPT_POST,1); 
		curl_setopt($ch, CURLOPT_POSTFIELDS, $file_to_upload); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

		$result=curl_exec ($ch);
		curl_close ($ch); 
		return $result;
	}
	

	public function ParseXMLForLevelTraces($file){
				 $result = parseLevelTraceXMLForAnalysis($file);
				 return $result;
	}
	
	public function testTrue()
	{
		$this->assertTrue(true);
	}
	
	public function testInsertLevelTraceNoArgs(){
		$expected = "No UUID Specified";
		$this->assertEquals($expected,$this->insertLevelTrace());
	}

	public function testParseXMLForLevelTracesWithBadXMLFile(){
		$expected = "Malformed XML file";
		$file = file_get_contents(__DIR__ . "/SampleLevelTrace-01.xml");
		$this->assertEquals($expected,$this->ParseXMLForLevelTraces($file));
	}

	public function testParseXMLForLevelTraceWithGoodXMLFile(){
		$expected = array("Make Plans,Naomi,Zack,15");
		$file = file_get_contents(__DIR__ . "/SampleLevelTrace-02.xml");
		$this->assertEquals($expected,$this->ParseXMLForLevelTraces($file));
	}

	public function testParseXMLForLevelTraceWithEmptyXML(){
		$expected = array("Empty level trace detected");
		$file = file_get_contents(__DIR__ . "/EmptyLevelTrace.xml");
		$this->assertEquals($expected,$this->ParseXMLForLevelTraces($file));
	}
	
	public function testSubmitLevelTrace(){
		$this->markTestIncomplete('This test is currently broken, meh.');
		$file = file_get_contents(__DIR__ . "/SampleLevelTrace-02.xml");
		$this->assertEquals("",$this->insertLevelTrace($file, 1, 10, "Arm Chair", "Blah", "meh"));
	}
	
	public function testUserinfoRejectEmptyParameter()
	{
		$userinfo = $this->getUserInfo('');
		$this->assertEquals("Query formulated incorrectly, please refer to the documentation for usage<br>\n", $userinfo);
	}
	
	public function testUserinfoFor100000145644104()
	{
		$expected = "<user><id>1</id><uuid>100000145644104</uuid><playCount>5</playCount><visits>5</visits></user>";
		$userinfo = $this->getUserInfo("100000145644104");
		$this->assertXmlStringEqualsXmlString($expected, $userinfo);
	}
	
	public function testUserinfoForInvalidUser()
	{
		$userinfo = $this->getUserInfo("1234");
		$this->assertEquals("", $userinfo);
	}
	
	public function testGetAchievements()
	{
		$achievements = $this->getAchievements("100000145644104");
		$this->assertEquals("1,2,3", $achievements);
	}
	
	public function testUnlockAchievementWithoutLevelTrace()
	{
		$unlockAchievement = $this->unlockAchievement(1, 4);
		$this->assertEquals("", $unlockAchievement);
		
		// test if new achievement is returned
		$achievements = $this->getAchievements("100000145644104");
		$this->assertEquals("1,2,3,4", $achievements, "New achievement isn't returned on getAchievements call");
	}

	public function testUnlockAchievementInvalidUser()
	{
	  $this->markTestIncomplete('This test is currently broken, meh.');
		$unlockAchievement = $this->unlockAchievement(99, 4);
		$this->assertEquals("FAILED", $unlockAchievement, "Unlocking achievement for non-existing user didn't fail");
	}
}
?>
