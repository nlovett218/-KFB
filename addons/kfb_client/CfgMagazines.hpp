class CfgMagazines {
	class CA_Magazine;	// External class reference
	
	class Exile_AbstractItem : CA_Magazine {
		scope = protected;
		descriptionShort = "Dummy";
		displayName = "Dummy";
		count = 1;
		mass = 1;
		picture = "\exile_assets\texture\item\Dummy.paa";
		model = "\exile_assets\model\Dummy.p3d";
		
		class Interactions {};
	};
	
	class Exile_Item_ThermalScannerPro : Exile_AbstractItem {
		scope = public;
		displayName = "Thermal Scanner Pro";
		descriptionShort = "Prints thermal image of the last three digits on a recently used code lock. Must be used within 15 minutes of the lock being used to get a print.";
		picture = "\kfb_assets\textures\item\thermalscannerpro.paa";
		model = "\exile_assets\model\Exile_Item_ThermalScannerPro.p3d";
		mass = 5;
		count = 5;
	};
	
};
