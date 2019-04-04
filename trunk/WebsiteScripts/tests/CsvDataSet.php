<?php
require_once 'PHPUnit/Extensions/Database/DataSet/CsvDataSet.php';

class CsvDataSet extends PHPUnit_Extensions_Database_DataSet_CsvDataSet {
	public function getCsvRow($fh) {
		$csv = parent::getCsvRow($fh);
		
		for ($i = 0; $i < count($csv); $i++) {
			if ($csv[$i] == "NULL")
				$csv[$i] = NULL;
		}
		
		return $csv;
	}
}