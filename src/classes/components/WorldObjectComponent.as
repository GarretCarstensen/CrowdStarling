package classes.components
{
	import classes.game_objects.GameObject;
	import classes.game_objects.World;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;
	
	/**
	 * This class implements functionality for placement within
	 * a world and interaction with other objects with world components.
	 * */
	public class WorldObjectComponent extends Component
	{
		private var m_world:World;
		private var m_position:Point;
		private var m_sprite:Sprite;
		
		public function WorldObjectComponent(gameObject:GameObject, world:World, position:Point = null)
		{
			super(gameObject);
			m_world = world;
			m_position = (position) ? position : new Point(0,0);
		}
		
		public function setWorldPosition(position:Point):void
		{
			m_position = position;
			updateSpritePosition();
		}
		
		public function attachSprite(sprite:Sprite):void
		{
			if (m_sprite && m_sprite.parent)
			{
				m_sprite.removeFromParent(true);
			}
			m_sprite = sprite;
			m_world.addSprite(m_sprite);
			updateSpritePosition();
		}
		
		public function updateSpritePosition():void
		{
			if (m_sprite)
			{
				// Set sprite position
				var stagePosition:Point = m_world.getStagePosition(m_position);
				m_sprite.x = stagePosition.x;
				m_sprite.y = stagePosition.y;
			}
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