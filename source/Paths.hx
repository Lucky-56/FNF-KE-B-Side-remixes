package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, gameStyle:String = "fnf", library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, gameStyle, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel, gameStyle);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared", gameStyle);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file, gameStyle);
	}

	static public function getLibraryPath(file:String, library = "preload", gameStyle:String)
	{
		return if (library == "preload" || library == "default") getPreloadPath(file, gameStyle); else getLibraryPathForce(file, gameStyle, library);
	}

	inline static function getLibraryPathForce(file:String, gameStyle:String, library:String)
	{
		return '$gameStyle/$library:assets/$gameStyle/$library/$file';
	}

	inline static function getPreloadPath(file:String, gameStyle:String)
	{
		return 'assets/$gameStyle/$file';
	}

	inline static public function file(file:String, gameStyle:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, gameStyle, library);
	}

	inline static public function lua(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/$key.lua', TEXT, gameStyle, library);
	}

	inline static public function luaImage(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/$key.png', IMAGE, gameStyle, library);
	}

	inline static public function txt(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, gameStyle, library);
	}

	inline static public function xml(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, gameStyle, library);
	}

	inline static public function json(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, gameStyle, library);
	}

	static public function sound(key:String, gameStyle:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, gameStyle, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, gameStyle:String, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), gameStyle, library);
	}

	inline static public function music(key:String, gameStyle:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, gameStyle, library);
	}

	inline static public function voices(song:String, gameStyle:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		return '$gameStyle/songs:assets/$gameStyle/songs/${songLowercase}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String, gameStyle:String)
	{
		trace('getting da Song');
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		trace(' got da song: $gameStyle/songs:assets/$gameStyle/songs/${songLowercase}/Inst.$SOUND_EXT');
		return '$gameStyle/songs:assets/$gameStyle/songs/${songLowercase}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, gameStyle:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, gameStyle, library);
	}

	inline static public function font(key:String, gameStyle:String)
	{
		return 'assets/$gameStyle/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, gameStyle:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, gameStyle, library), file('images/$key.xml', gameStyle, library));
	}

	inline static public function getPackerAtlas(key:String, gameStyle:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, gameStyle, library), file('images/$key.txt', gameStyle, library));
	}
}
