using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RomPatcher
{
	class Program
	{
		const int MMBN3_BATTLE_MUSIC_POINTER = 0x0148D34;
		const int NEW_MUSIC_POINTER = 0x08800000;
		const int ROM_SIZE_INCREASE = 0x01800000;
		const string PATCHED_EXT = ".patched";

		static void Main(string[] args)
		{

			if (args.Length != 1)
			{
				System.Console.WriteLine("Usage: RomPatcher.exe <mmbn3_blue_us_rom_name>");
				System.Console.WriteLine("Example: RomPatcher.exe mmbn3.gba");
				return;
			}

			var rom_path = args[0];

			byte[] file = System.IO.File.ReadAllBytes(rom_path);


			// Patch battle music pointer
			file[MMBN3_BATTLE_MUSIC_POINTER] = (byte) (NEW_MUSIC_POINTER & 0x000000FF);
			file[MMBN3_BATTLE_MUSIC_POINTER + 1] = (byte)((NEW_MUSIC_POINTER & 0x0000FF00) >> 8);
			file[MMBN3_BATTLE_MUSIC_POINTER + 2] = (byte)((NEW_MUSIC_POINTER & 0x00FF0000) >> 16);
			file[MMBN3_BATTLE_MUSIC_POINTER + 3] = (byte)((NEW_MUSIC_POINTER & 0xFF000000) >> 24);


			// Increase file size
			List<byte> new_file = new List<byte>();
			new_file.AddRange(file);

			new_file.AddRange(new byte[ROM_SIZE_INCREASE]);

			// Write out

			System.IO.File.WriteAllBytes(rom_path + PATCHED_EXT, new_file.ToArray());

			System.Console.WriteLine("Patching and Size-Change successful!");
			System.Console.WriteLine("New file " + rom_path + PATCHED_EXT + " generated.");
			System.Console.WriteLine("Use this file for Music Patching in the Gauntlet!");
		}
	}
}
