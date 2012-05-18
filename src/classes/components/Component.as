package classes.components
{
	import classes.game_objects.GameObject;

	/**
	 * This is the base class for components which are used to add functionality to GameObject classes.
	 * */
	public class Component
	{
		protected var m_gameObject:GameObject;
		private var m_isDisposing:Boolean;
		
		public function Component(gameObject:GameObject)
		{
			m_gameObject = gameObject;
			m_gameObject.addComponent(this);
		}
		
		public function getGameObject():GameObject { return m_gameObject; }
		public function getIsDisposing():Boolean { return m_isDisposing; }
		
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
				
				// Return true to indicate that disposal succeeded
				return true;
			}
		}
	}
}