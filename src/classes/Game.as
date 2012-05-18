package classes
{
	import classes.components.UpdateComponent;
	import classes.game_objects.TestObject;
	import classes.game_objects.World;
	
	import flash.utils.Timer;
	
	import mx.managers.SystemManager;
	
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * This class is the singleton used to initialize managers and run the game.
	 * */
	public class Game extends Sprite
	{
		private static var instance:Game;
		
		// Stage and Display Layers
		private var s_starlingStage:Stage;
		private var s_layerWorld:Sprite;
		
		// Update properties
		private var m_timer:Timer;
		private var m_updateComponents:Array;
		private var m_sortUpdateComponents:Boolean;
		
		// World
		private var s_world:World;
		
		public function Game()
		{
			if (instance)
			{
				throw new Error("Cannot create a second instance of singleton Game class");
			}
			
			// Initialize update loop
			m_timer = new Timer(1);
			m_timer.start();
			m_updateComponents = [];
			addEventListener(Event.ENTER_FRAME, update);
			
			// Add listener for added to stage to finish init
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Set instance
			log("Game instance created.");
			instance = this;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			s_starlingStage = stage;
			log("Starling framework initialized.");
			
			// Add display layers
			s_layerWorld = new Sprite();
			s_starlingStage.addChild(s_layerWorld);
			
			init();
			log("Game initialized.");
		}
		
		/**
		 * Override in subclass for addition initialization process.
		 * */
		protected function init():void { }
		
		public static function getInstance():Game
		{
			if (!instance)
			{
				throw new Error("An instance of Game class has not been created.");
			}
			return instance;
		}
		
		public function getStage():Stage { return s_starlingStage; }
		public function getLayerWorld():Sprite { return s_layerWorld; }
		
		public function registerUpdateComponent(component:UpdateComponent):Boolean
		{
			if (component in m_updateComponents)
			{
				return false;
			}
			else
			{
				m_updateComponents.push(component);
				m_sortUpdateComponents = true;
				return true;
			}
		}
		
		public function unregisterUpdateComponent(component:UpdateComponent):Boolean
		{
			var index:int = m_updateComponents.indexOf(component);
			if (index == -1)
			{
				return false;
			}
			else
			{
				m_updateComponents.splice(index, 1);
				return true;
			}
		}
		
		private function update(e:Event):Array
		{
			// Get delta time for updates
			var dt:int = m_timer.currentCount;
//			timer.reset();
			
			// Sort update components if necessary
			var successArr:Array = [];
			if (m_sortUpdateComponents)
			{
				m_updateComponents.sortOn("priority", Array.NUMERIC);
				m_sortUpdateComponents = false;
			}
			
			// Iterate through components to update
			for (var i:int = 0; i < m_updateComponents.length; i++)
			{
				var ac:UpdateComponent = m_updateComponents[i];
				successArr.push(ac.update(dt));
			}
			return successArr;
		}
		
		public function getWorld():World { return s_world; }
		public function setWorld(world:World):void
		{
			if (s_world)
			{
				s_world.dispose();
			}
			s_world = world;
			s_layerWorld.addChild(s_world.getSprite());
			log("World initialized.");
		}
		
		public static function log(message:String):void
		{
			trace("LOG: "+message);
		}
	}
}