package com.crowdstar.cs.classes.game_objects
{
	import com.crowdstar.cs.classes.Game;
	import com.crowdstar.cs.classes.components.SpriteComponent;
	import com.crowdstar.cs.classes.components.UpdateComponent;
	import com.crowdstar.cs.classes.utils.CSStringUtil;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import com.crowdstar.cs.classes.managers.AssetManager;

	public class TestObject extends GameObject
	{
		private var m_update:UpdateComponent;
		private var m_sprite:SpriteComponent;
		private var m_textField:TextField;
		
		public function TestObject()
		{
			super();
			
			m_update = new UpdateComponent(this, update);
			m_sprite = new SpriteComponent(this);
			
			var sprite:Sprite = m_sprite.getSprite();
			sprite.addEventListener(Event.ADDED_TO_STAGE, onSpriteAddedToStage);
			getGame().getStage().addChild(sprite);
			
			var text:String = CSStringUtil.getNumberString(.12, 1, 3, 4);
			m_textField = new TextField(100, 30, text);
			m_textField.x = 200;
			m_textField.y = 50;
			m_sprite.getSprite().addChild(m_textField);
		}
		
		private function update(dt:int):void
		{
			Game.log("TestObject updated");
		}
		
		private function onSpriteAddedToStage(e:Event):void
		{
			Game.log("TestObject initialized");
			
			/*
			SAMPLE ADD IMAGE
			var testImage:Image = new Image(AssetManager.getTexture(AssetManager.TestImageName));
			m_sprite.getSprite().addChild(testImage);
			*/
		}
	}
}