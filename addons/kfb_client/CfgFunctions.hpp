class CfgFunctions {
	class A3 {
		tag = BIS;
		project = "arma3";
		
		class Ambient {
			file = "exile_client\trashBin";
			
			class animalBehaviour {};
		};
		
		class Misc {
			delete progressLoadingScreen;
		};
		
		class BecauseArma {
			file = "kfb_client\bootstrap";
			
			class progressLoadingScreen {};
		};
		
		class MP {
			file = "exile_client\trashBin";
			
			class execFSM {};
			
			class execVM {};
			
			class execRemote {};
			
			class addScore {};
			
			class setRespawnDelay {};
			
			class onPlayerConnected {};
			
			class initPlayable {};
			
			class missionTimeLeft {};
			
			class MP {};
			
			class MPexec {};
			
			class initMultiplayer {};
			
			class call {};
			
			class spawn {};
			
			class deleteVehicleCrew {};
			
			class admin {};
			
			class spawnOrdered {};
		};
	};
	
	class ExileClient {
		class Bootstrap {
			file = "kfb_client\bootstrap";
			
			class preStart {
				preStart = 1;
			};
			
			class preInit {
				preInit = 1;
			};
			
			class postInit {
				postInit = 1;
			};
		};
		
		class FiniteStateMachine {
			file = "exile_client\fsm";
			
			class login {
				ext = ".fsm";
			};
			
			class scheduledCall {
				ext = ".fsm";
			};
			
			class Exile_Animal_Goat {
				ext = ".fsm";
			};
			
			class Exile_Animal_Hen {
				ext = ".fsm";
			};
			
			class Exile_Animal_Rooster {
				ext = ".fsm";
			};
			
			class Exile_Animal_Sheep {
				ext = ".fsm";
			};
		};
	};
};
