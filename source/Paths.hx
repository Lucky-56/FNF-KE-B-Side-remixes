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

	static function getPath(folder:String, file:String, type:AssetType, gameStyle:String, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(folder, file, gameStyle, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(folder, file, gameStyle, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(folder, file, gameStyle, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(folder, file, gameStyle);
	}

	static public function getLibraryPath(folder:String, file:String, gameStyle:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(folder, file, gameStyle); else getLibraryPathForce(folder, file, gameStyle, library);
	}

	inline static function getLibraryPathForce(folder:String, file:String, gameStyle:String, library:String)
	{
		return '$library:assets/$library/$gameStyle/$folder' + '$file';
	}

	inline static function getPreloadPath(folder:String, file:String, gameStyle:String)
	{
		return 'assets/$folder' + '$gameStyle/$file';
	}

	inline static public function file(folder:String, file:String, gameStyle:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(folder, file, type, gameStyle, library);
	}

	inline static public function lua(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/', '$key.lua', TEXT, gameStyle, library);
	}

	inline static public function luaImage(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/', '$key.png', IMAGE, gameStyle, library);
	}

	inline static public function txt(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/', '$key.txt', TEXT, gameStyle, library);
	}

	inline static public function xml(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/', '$key.xml', TEXT, gameStyle, library);
	}

	inline static public function json(key:String, gameStyle:String, ?library:String)
	{
		return getPath('data/', '$key.json', TEXT, gameStyle, library);
	}

	static public function sound(key:String, gameStyle:String, ?library:String)
	{
		return getPath('sounds/', '$key.$SOUND_EXT', SOUND, gameStyle, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, gameStyle:String, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), gameStyle, library);
	}

	inline static public function music(key:String, gameStyle:String, ?library:String)
	{
		return getPath('music/', '$key.$SOUND_EXT', MUSIC, gameStyle, library);
	}

	inline static public function voices(song:String, gameStyle:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		return 'songs:assets/songs/$gameStyle/${songLowercase}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String, gameStyle:String)
	{
		var songLowercase = StringTools.replace(song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		return 'songs:assets/songs/$gameStyle/${songLowercase}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, gameStyle:String, ?library:String)
	{
		return getPath('images/', '$key.png', IMAGE, gameStyle, library);
	}

	inline static public function font(key:String, gameStyle:String)
	{
		return 'assets/fonts/$gameStyle/$key';
	}

	inline static public function getSparrowAtlas(key:String, gameStyle:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, gameStyle, library), file('images/', '$key.xml', gameStyle, library));
	}

	inline static public function getPackerAtlas(key:String, gameStyle:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, gameStyle, library), file('images/', '$key.txt', gameStyle, library));
	}
}
