package com.crowdstar.cs.classes.game_objects
{
	import com.crowdstar.cs.classes.Game;
	import com.crowdstar.cs.classes.components.Component;
	import com.crowdstar.cs.classes.components.UpdateComponent;

	/**
	 * This is the base class for all CrowdStarling game objects comprising of components.
	 * The majority of CrowdStarling classes should extend this class and implement sets
	 * of functions by adding components in favor of class inheritance.
	 * */
	public class GameObject
	{
		/**CrowdStarling game to which this object belongs.*/
		private var m_game:Game;
		
		/**List of components used to give functionality sets to this class.*/
		private var m_components:Vector.<Component>;
		
		/**List of classes of each component for fast reference.*/
		private var m_componentTypes:Vector.<Class>;
		
		/**
		 * Constructs a game object and initializes its components list.
		 * An optional Game object may be passed to save calling the static Game.getInstance()
		 * function in order to retrieve a reference to the current game.
		 * */
		public function GameObject(game:Game = null)
		{
			m_game = (game) ? game : Game.getInstance();
			m_components = new Vector.<Component>();
			m_componentTypes = new Vector.<Class>();
		}
		
		/**
		 * Returns this game object's reference to the singleton Game object.
		 * */
		protected function getGame():Game { return m_game; }
		
		/**
		 * Returns this game object's list of components.
		 * */
		protected function getComponents():Vector.<Component> { return m_components; }
		
		/**
		 * Adds a component to this game object. A reference to the component is stored
		 * along with a reference to its class for fast type lookup.
		 * */
		public function addComponent(component:Component):Boolean
		{
			if (component in m_components)
			{
				return false;
			}
			else
			{
				m_components.push(component);
				m_componentTypes.push(component.getType());
				return true;
			}
		}
		
		/**
		 * Removes a component from this game objects list of components and returns whether
		 * or not the removal process succeeded. An optional arguement is available to
		 * specify whether or not the component should be disposed when removed.
		 * */
		public function removeComponent(component:Component, dispose:Boolean = true):Boolean
		{
			var success:Boolean = false;
			var index:int;
			index = m_components.indexOf(component);
			if (index != -1)
			{
				// Remove entry of the component from the list
				m_components.splice(index, 1);
				component.onRemovedFromGameObject();
				
				// Remove entry of the component class from the list
				index = m_componentTypes.indexOf(component.getType());
				if (index != -1)
				{
					m_componentTypes.splice(index, 1);
				}
				
				// Dispose the component
				if (dispose && !component.getIsDisposing())
				{
					// Ensure the component is disposed
					// This will run dispose, but will not run the remove component function again
					component.dispose(false);
				}
				
				// Indicate that the component was found for removal
				success = true;
			}
			
			return success;
		}
		
		/**
		 * Returns whether or not this game object has a component of the given type.
		 * */
		public function getHasComponentType(type:Class):Boolean
		{
			return (type in m_componentTypes);
		}
		
		/**
		 * Disposes this game object by removing all components and other references.
		 * */
		public function dispose(disposeComponents:Boolean = true):Boolean
		{
			// Remove all components
			while (m_components.length)
			{
				var component:Component = m_components.pop();
				component.onRemovedFromGameObject();
				if (disposeComponents)
				{
					component.dispose(false); // Use false to prevent calling repeated removal attempt
				}
			}
			
			// Clear component classes
			while (m_componentTypes.length)
			{
				m_componentTypes.pop();
			}
			
			// Null references
			m_game = null;
			
			// Return success
			return true;
		}
	}
}