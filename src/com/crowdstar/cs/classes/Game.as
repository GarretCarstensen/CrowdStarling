package com.crowdstar.cs.classes
{
	import com.crowdstar.cs.classes.components.UpdateComponent;
	import com.crowdstar.cs.classes.game_objects.TestObject;
	import com.crowdstar.cs.classes.game_objects.World;
	import com.crowdstar.cs.classes.managers.AssetManager;
	
	import flash.utils.Timer;
	
	import mx.managers.SystemManager;
	
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * This class is the singleton class used to initialize managers and run the game.
	 * It also contains references to the Starling Stage object, a world object, and
	 * layers for sorting display objects on the Starling Stage.
	 * 
	 * Typically a CrowdStarling project should use a custom game class that extends
	 * this class. The init() function in this class is available for custom initialization
	 * processes required by a subclass.
	 * */
	public class Game extends Sprite
	{
		private static var instance:Game;
		
		// Stage and Display Layers
		/**Static reference to the main stage used by the Starling framework.*/
		private var s_starlingStage:Stage;
		
		/**Static reference to the layer used to display the sprite component of the world object.*/
		private var s_layerWorld:Sprite;
		
		// Update properties
		/**Timer used to calculate the delta time between update calls.*/
		private var m_timer:Timer;
		
		/**List of components registered for update.*/
		private var m_updateComponents:Array;
		
		/**Flag used to queue a resort of update components prior to the next update call.*/
		private var m_sortUpdateComponents:Boolean;
		
		// World
		/**Static reference to the current World object.*/
		private var s_world:World;
		
		/**
		 * Base class constructor for a CrowdStarling game.
		 * This constructor initialized game manager classes and update loop.
		 * 
		 * ARG
		 * assetClass: the class in which assets are embedded. This class is used by the asset manager for loading game assets.
		 * */
		public function Game(assetClass:Class)
		{
			if (instance)
			{
				throw new Error("Cannot create a second instance of singleton Game class");
			}
			
			// Initialize game manager casses
			AssetManager.init(assetClass);
			
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
		
		/**
		 * Completes initializtion processes that require reference to the
		 * Starling stage, because the stage is not available until the Game class
		 * object has been added.
		 * */
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
		
		/**
		 * Returns the current instance of the singleton Game class.
		 * */
		public static function getInstance():Game
		{
			if (!instance)
			{
				throw new Error("An instance of Game class has not been created.");
			}
			return instance;
		}
		
		/**
		 * Returns the stage to which the Game class object is added.
		 * */
		public function getStage():Stage { return s_starlingStage; }
		
		/**
		 * Returns the layer to which the World object should be added.
		 * */
		public function getLayerWorld():Sprite { return s_layerWorld; }
		
		/**
		 * Registers an update component so its update function will be called each frame.
		 * This function also queues a resort of the update component list.
		 * */
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
		
		/**
		 * Removes an update component from the current list so its update function
		 * is no longer called each frame.
		 * */
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
		
		/**
		 * Runs the update function of game managers and registered update components.
		 * A resort of registered components will be run prior to update if queued.
		 * 
		 * RETURN
		 * Returns the array of each success values for each component's update.
		 * */
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
		
		/**
		 * Returns the current World object.
		 * */
		public function getWorld():World { return s_world; }
		
		/**
		 * Assigns and initializes the current World object. If a current
		 * World object is already assigned, it is disposed before assigning
		 * the new World object.
		 * */
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
		
		/**
		 * Outputs a CrowdStarling standard-formatted message.
		 * */
		public static function log(message:String):void
		{
			trace("LOG: "+message);
		}
		
		/**
		 *  Outputs a CrowdStarling standard-formatted warning message.
		 * */
		public static function warning(message:String):void
		{
			trace("WARNING: "+message);
		}
	}
}