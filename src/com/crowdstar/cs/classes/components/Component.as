package com.crowdstar.cs.classes.components
{
	import com.crowdstar.cs.classes.game_objects.GameObject;

	/**
	 * This is the base class for components which are used to add functionality to GameObject classes.
	 * */
	public class Component
	{
		/**Class of this component. This should be specified in subclasses.*/
		protected var m_type:Class = Component;
		
		/**Game object to which this component belongs.*/
		protected var m_gameObject:GameObject;
		
		/**Flag used to indicate whether or not disposal process has been initiated.*/
		private var m_isDisposing:Boolean;
		
		/**
		 * Constructs a component and adds it to the given game object. Subclasses
		 * of Component should specify their class as the "type" arguement for fast
		 * type lookup within the game object.
		 * */
		public function Component(type:Class, gameObject:GameObject)
		{
			m_type = type;
			m_gameObject = gameObject;
			m_gameObject.addComponent(this);
		}
		
		/**
		 * Returns the class type of this component.
		 * */
		public function getType():Class { return m_type; }
		
		/**
		 * Returns the game object to which this comopnent belongs.
		 * */
		public function getGameObject():GameObject { return m_gameObject; }
		public function getIsDisposing():Boolean { return m_isDisposing; }
		
		/**
		 * Nulls the reference to the game object. This should be called only
		 * when this component is removed from the gameObject.
		 * */
		public function onRemovedFromGameObject():void
		{
			m_gameObject = null;
		}
		
		/**
		 * Override in derived classes for cleanup process.
		 * This funtion sets the disposal flag and returns whether or not disposal process succeeds.
		 * Overides of this function should run super.dispose() to check if disposal can continue.
		 * An optional parameter is can be set true to bypass removal from the game object.
		 * Set this parameter to true when removal is already in process*/
		public function dispose(removeFromGameObject:Boolean = true):Boolean
		{
			if (m_isDisposing)
			{
				// Return false to indicate that disposal is already in process and cannot run again
				return false;
			}
			else
			{
				// Set disposal flag to prevent second run
				m_isDisposing = true;
				
				// Ensure this component is removed from its game object
				if (removeFromGameObject)
				{
					m_gameObject.removeComponent(this);
				}
				
				// Null references
				m_type = null;
				m_gameObject = null;
				
				// Return true to indicate that disposal succeeded
				return true;
			}
		}
	}
}