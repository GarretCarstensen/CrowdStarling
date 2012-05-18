package classes.game_objects
{
	import classes.Game;
	import classes.components.Component;
	import classes.components.UpdateComponent;

	/**
	 * This is the base class for all AS3 objects comprising of components.
	 * */
	public class GameObject
	{
		private var m_game:Game;
		private var m_components:Vector.<Component>;
		
		public function GameObject(game:Game = null)
		{
			m_game = (game) ? game : Game.getInstance();
			m_components = new Vector.<Component>();
		}
		
		protected function getGame():Game { return m_game; }
		protected function getComponents():Vector.<Component> { return m_components; }
		
		public function addComponent(component:Component):Boolean
		{
			if (component in m_components)
			{
				return false;
			}
			else
			{
				m_components.push(component);
				return true;
			}
		}
		
		public function removeComponent(component:Component):Boolean
		{
			var success:Boolean = false;
			var index:int = m_components.indexOf(component);
			if (index == -1)
			{
				m_components.splice(index, 1);
				if (!component.getIsDisposing())
				{
					// Ensure the component is disposed
					// This will run dispose, but will not run the remove component function again
					component.dispose(false);
				}
				success = true;
			}
			return success;
		}
		
		public function dispose():Boolean
		{
			// Remove all components
			while (m_components.length)
			{
				var c:Component = m_components.pop();
				c.dispose(false);
			}
			
			// Return success
			return true;
		}
	}
}