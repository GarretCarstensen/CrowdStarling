package com.crowdstar.cs.classes.components
{
	import com.crowdstar.cs.classes.game_objects.GameObject;
	import com.crowdstar.cs.classes.managers.AssetManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * This class adds display object functionality to game objects
	 * by using a reference to a Starling Sprite object. The sprite
	 * assigned to this component may contain other display objects
	 * including an image created from a Starling Texture
	 * */
	public class SpriteComponent extends Component
	{
		/**Starling Sprite which can be added to a stage as the display for a game object.*/
		private var m_sprite:Sprite;
		
		/**Starling Image which can be added to this sprite.*/
		private var m_image:Image;
		
		/**
		 * Constructs a SpriteComponent and adds it to the given game object.
		 * */
		public function SpriteComponent(gameObject:GameObject)
		{
			super(SpriteComponent, gameObject);
			m_sprite = new Sprite();
		}
		
		/**
		 * Returns the Starling Sprite associated with this sprite component.
		 * */
		public function getSprite():Sprite
		{
			return m_sprite;
		}
		
		/**
		 * Removes the current image if applicable, and assigns the given image.
		 * */
		public function setImage(image:Image):void
		{
			// Remove the current image if available
			if (m_image)
			{
				m_image.removeFromParent(true);
			}
			m_image = image;
			
			// Add the image if available
			if (m_image)
			{
				m_sprite.addChild(m_image);
			}
		}
		
		/**
		 * Removes the current image if applicable, and assigns a new image
		 * from the AssetManager using the given image name.
		 * */
		public function setImageWithName(name:String):Boolean
		{
			// Create a new image using the AssetManager and the given image name
			setImage( new Image(AssetManager.getTexture(name)) );
			
			// Return success
			return (m_image != null);
		}
		
		/**
		 * Prepares the SpriteComponent for garbage collection by removing the associated
		 * sprite and image from the display tree and nulling references.
		 * */
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