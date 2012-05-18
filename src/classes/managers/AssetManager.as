package classes.managers
{
	import classes.Game;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class AssetManager
	{
		/*
		SAMPLE IMAGE EMBEDDING FOR ASSET LOADING
		ADD THIS CODE TO THE "Assets" CLASS FILE IN YOUR PROJECT
		[Embed(source="../assets/images/test.png")]
		public static const TestImage:Class;
		public static const TestImageName:String = "TestImage";
		*/
		
		private static var assetClass:Class;
		private static var gameTextures:Dictionary = new Dictionary();
		
		/**
		 * Run the initialization function to set the class in which assets are embedded.
		 * */
		public static function init(assetClass:Class):void
		{
			AssetManager.assetClass = assetClass;
		}
		
		/**
		 * This function returns a starling texture using the specified name of an
		 * asset embedded in your assets class.
		 * */
		public static function getTexture(name:String):Texture
		{
			if (!assetClass)
			{
				Game.log("AssetManager has not been initialized. Call AssetManager.init() before getting a game texture.");
			}
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new assetClass[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
	}
}