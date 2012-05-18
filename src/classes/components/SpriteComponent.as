package classes.components
{
	import classes.game_objects.GameObject;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import classes.managers.AssetManager;
	
	public class SpriteComponent extends Component
	{
		private var m_sprite:Sprite;
		private var m_image:Image;
		
		public function SpriteComponent(gameObject:GameObject, imageName:String = null)
		{
			super(gameObject);
			m_sprite = new Sprite();
			if (imageName)
			{
				setImage(imageName);
			}
		}
		
		public function getSprite():Sprite
		{
			return m_sprite;
		}
		
		private function setImage(name:String):Boolean
		{
			if (m_image)
			{
				m_image.removeFromParent(true);
			}
			m_image = new Image(AssetManager.getTexture(name));
			
			// Assign the image from the given name and return the success value
			if (m_image)
			{
				m_sprite.addChild(m_image);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		override public function dispose(removeFromGameObject:Boolean = true):Boolean
		{
			// Call super function to check if disposal is in progress and to set disposal flag
			if (!super.dispose(removeFromGameObject))
			{
				return false;
			}
			
			// Remove the sprite
			if (m_sprite && m_sprite.parent)
			{
				m_sprite.removeFromParent(true);
			}
			m_sprite = null;
			
			// Remove the image
			if (m_image && m_image.parent)
			{
				m_image.removeFromParent(true);
			}
			m_image = null;
			
			// Dispose succeeded
			return true;
		}
	}
}