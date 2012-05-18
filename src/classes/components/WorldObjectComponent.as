package classes.components
{
	import classes.game_objects.GameObject;
	import classes.game_objects.World;
	
	import starling.display.Sprite;
	
	/**
	 * This class implements functionality for placement within
	 * a world and interaction with other objects with world components.
	 * */
	public class WorldObjectComponent extends Component
	{
		private var m_world:World;
		private var m_x:Number;
		private var m_y:Number;
		private var m_sprite:Sprite;
		
		public function WorldObjectComponent(gameObject:GameObject, world:World)
		{
			super(gameObject);
			m_world = world;
		}
		
		public function setWorldPosition(x:Number, y:Number):void
		{
			m_x = x;
			m_y = y;
		}
		
		public function attachSprite(sprite:Sprite):void
		{
			if (m_sprite && m_sprite.parent)
			{
				m_sprite.removeFromParent(true);
			}
			m_sprite = sprite;
			m_world.addSprite(m_sprite);
		}
		
		override public function dispose(removeFromGameObject:Boolean=true):Boolean
		{
			// Call super function to check if disposal is in progress and to set disposal flag
			if (!super.dispose(removeFromGameObject))
			{
				return false;
			}
			
			m_world = null;
			m_sprite = null;
			
			return true;
		}
	}
}