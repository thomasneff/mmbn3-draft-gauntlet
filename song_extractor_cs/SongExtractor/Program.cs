using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SongExtractor
{
	class Program
	{
		// Credits for reverse-engineering all sound engine related stuff go to Bregalad, with their amazing
		// GBA "Sappy" sound engine information document  ( https://www.romhacking.net/documents/462/ )

		public const int ROM_ADDRESS_MASK = 0x08000000;
		public const int SAMPLE_SIZE_LIMIT = 0xFFFF;
		public const int USED_INSTRUMENTS_MAX = -1;

		public const byte INSTRUMENT_SAMPLE_1 = 0x00;
		public const byte INSTRUMENT_SAMPLE_2 = 0x08;
		public const byte INSTRUMENT_PROGRAMMABLE_WAVEFORM_1 = 0x03;
		public const byte INSTRUMENT_PROGRAMMABLE_WAVEFORM_2 = 0x0B;
		public const byte INSTRUMENT_KEY_SPLIT = 0x40;
		public const byte INSTRUMENT_EVERY_KEY_SPLIT = 0x80;

		public const byte CMD_END_OF_TRACK = 0xB1;
		public const byte CMD_INSTRUMENT_CHANGE = 0xBD;
		public const byte CMD_JUMP_TO_ADDRESS = 0xB2;
		public const byte CMD_CALL = 0xB3;
		public const byte CMD_TEMPO = 0xBB;
		public const byte CMD_TRANSPOSE = 0xBC;
		public const byte CMD_SET_INSTRUMENT = 0xBD;

		public const string KEY_POINTERS = "ptrs";
		public const string KEY_TRANSPOSE = "transpose";
		public const string KEY_TEMPO = "bpm";

		public const string DIRECTORY_OUT = "out";

		public const string FILE_EXTENSION_PATCH = ".songpatch";
		public const string FILE_EXTENSION_TRANSPOSE = ".transposeoffsets";
		public const string FILE_EXTENSION_TEMPO = ".bpmoffsets";
		



		struct SongTable
		{
			public List<int> song_header_ptrs;		// 4 bytes per song header
			public List<int> track_group_numbers;   // 1/1/1/1 = 4 bytes per song header, might need to manually modify the maximum number of tracks in ** 4) Track-group RAM pointers format **
		}

		struct SongHeader
		{
			public byte number_of_tracks;			// 1 byte
			public byte unknown;                    // 1 byte
			public byte song_priority;              // 1 byte
			public byte echo;                       // 1 byte
			public int instrument_def_ptr;          // 4 bytes
			public List<int> track_data_ptrs;		// number_of_tracks * 4 bytes
		}

		struct InstrumentDef
		{
			public byte instrument_type;            // not written back to patch, used to detect programmable/sample/key split instruments
			public int data_1;                      // 4 bytes
			public int ptr_1;                       // 4 bytes, can be ptr when sample/programmable/key split instrument
			public int ptr_2;                       // 4 bytes, is ptr for key split (not *every key split*) instrument
		}

		struct ProgrammableWaveform
		{
			public int data_1;						// 4 bytes
			public int data_2;                      // 4 bytes
			public int data_3;                      // 4 bytes
			public int data_4;                      // 4 bytes
		}

		struct SampledInstrument
		{
			public int data_1;                      // 4 bytes
			public int data_2;                      // 4 bytes
			public int data_3;                      // 4 bytes
			public int sample_size;                 // 4 bytes
			public bool invalid;
			public List<byte> sample_pcm_data;		// sample_size bytes
		}

		static void ensure_dir(string file_path)
		{
			System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(file_path)); 
		}


		static int read_32_bit_from_file_at_offset(byte[] file_contents, int offset)
		{
			return BitConverter.ToInt32(file_contents, offset);
		}

		static byte read_8_bit_from_file_at_offset(byte[] file_contents, int offset)
		{
			return file_contents[offset];
		}

		static SongTable extract_song_table(byte[] file_contents, int song_table_address, int first_song_index, int last_song_index)
		{
			SongTable song_table = new SongTable();

			song_table.song_header_ptrs = new List<int>();
			song_table.track_group_numbers = new List<int>();

			var working_address = song_table_address;
			working_address += first_song_index * 8;

			for (int idx = first_song_index; idx < last_song_index + 1; ++idx)
			{
				var song_header_ptr = read_32_bit_from_file_at_offset(file_contents, working_address);
				working_address += 4;
				var track_group_numbers = read_32_bit_from_file_at_offset(file_contents, working_address);
				working_address += 4;
				song_table.song_header_ptrs.Add(song_header_ptr);
				song_table.track_group_numbers.Add(track_group_numbers);
			}


			return song_table;
		}

		static SongHeader extract_song_header(byte[] file_contents, int song_header_address)
		{
			SongHeader song_header = new SongHeader();

			if(song_header_address < ROM_ADDRESS_MASK || (song_header_address - ROM_ADDRESS_MASK) > file_contents.Length)
			{
				return song_header;
			}

			var working_address = song_header_address - ROM_ADDRESS_MASK; // Addresses are stored with 0x08 because of ROM memory domain

			song_header.number_of_tracks = read_8_bit_from_file_at_offset(file_contents, working_address);
			working_address += 1;
			song_header.unknown = read_8_bit_from_file_at_offset(file_contents, working_address);
			working_address += 1;
			song_header.song_priority = read_8_bit_from_file_at_offset(file_contents, working_address);
			working_address += 1;
			song_header.echo = read_8_bit_from_file_at_offset(file_contents, working_address);
			working_address += 1;
			song_header.instrument_def_ptr = read_32_bit_from_file_at_offset(file_contents, working_address);
			working_address += 4;

			song_header.track_data_ptrs = new List<int>();

			for (int track_idx = 0; track_idx < song_header.number_of_tracks; ++track_idx)
			{
				song_header.track_data_ptrs.Add(read_32_bit_from_file_at_offset(file_contents, working_address));
				working_address += 4;
			}

			return song_header;
		}


		static InstrumentDef extract_instrument_def(byte[] file_contents, int instrument_def_address)
		{
			InstrumentDef instrument_def = new InstrumentDef();
			instrument_def.instrument_type = read_8_bit_from_file_at_offset(file_contents, instrument_def_address);

			instrument_def.data_1 = read_32_bit_from_file_at_offset(file_contents, instrument_def_address);
			instrument_def_address += 4;

			instrument_def.ptr_1 = read_32_bit_from_file_at_offset(file_contents, instrument_def_address);
			instrument_def_address += 4;

			instrument_def.ptr_2 = read_32_bit_from_file_at_offset(file_contents, instrument_def_address);
			instrument_def_address += 4;

			return instrument_def;
		}

		static SampledInstrument extract_sampled_instrument(byte[] file_contents, int sampled_instrument_address)
		{
			SampledInstrument sampled_instrument = new SampledInstrument();

			sampled_instrument.data_1 = read_32_bit_from_file_at_offset(file_contents, sampled_instrument_address);

			sampled_instrument.invalid = (read_8_bit_from_file_at_offset(file_contents, sampled_instrument_address) +
								 read_8_bit_from_file_at_offset(file_contents, sampled_instrument_address + 1) +
								 read_8_bit_from_file_at_offset(file_contents, sampled_instrument_address + 2)) != 0;

			sampled_instrument_address += 4;

			sampled_instrument.data_2 = read_32_bit_from_file_at_offset(file_contents, sampled_instrument_address);
			sampled_instrument_address += 4;


			sampled_instrument.data_3 = read_32_bit_from_file_at_offset(file_contents, sampled_instrument_address);
			sampled_instrument_address += 4;


			sampled_instrument.sample_size = read_32_bit_from_file_at_offset(file_contents, sampled_instrument_address);
			sampled_instrument_address += 4;

			sampled_instrument.sample_pcm_data = new List<byte>();

			if (sampled_instrument.invalid)
			{
				System.Console.WriteLine("Invalid Sampled Instrument!");
				sampled_instrument.sample_size = 0;
				return sampled_instrument;
			}

			System.Console.WriteLine("Sample size: " + sampled_instrument.sample_size.ToString("X"));

			if(sampled_instrument.sample_size > SAMPLE_SIZE_LIMIT)
			{
				System.Console.WriteLine("-------------------------------------------------------------------------------------------------------");
				System.Console.WriteLine("Sample size too large, capping it to " + SAMPLE_SIZE_LIMIT.ToString("X"));
				System.Console.WriteLine("-------------------------------------------------------------------------------------------------------");
				sampled_instrument.sample_size = SAMPLE_SIZE_LIMIT;
			}

			for (int idx = 0; idx < sampled_instrument.sample_size; ++idx)
			{
				sampled_instrument.sample_pcm_data.Add(read_8_bit_from_file_at_offset(file_contents, sampled_instrument_address));
				sampled_instrument_address += 1;
			}

			return sampled_instrument;
		}

		static ProgrammableWaveform extract_programmable_waveform(byte[] file_contents, int programmable_waveform_address)
		{
			ProgrammableWaveform programmable_waveform = new ProgrammableWaveform();

			programmable_waveform.data_1 = read_32_bit_from_file_at_offset(file_contents, programmable_waveform_address);
			programmable_waveform_address += 4;

			programmable_waveform.data_2 = read_32_bit_from_file_at_offset(file_contents, programmable_waveform_address);
			programmable_waveform_address += 4;

			programmable_waveform.data_3 = read_32_bit_from_file_at_offset(file_contents, programmable_waveform_address);
			programmable_waveform_address += 4;

			programmable_waveform.data_4 = read_32_bit_from_file_at_offset(file_contents, programmable_waveform_address);
			programmable_waveform_address += 4;

			return programmable_waveform;
		}

		static void write_instrument_def_to_bytearray(InstrumentDef instrument_def, List<byte> arr)
		{
			arr.AddRange(BitConverter.GetBytes(instrument_def.data_1));
			arr.AddRange(BitConverter.GetBytes(instrument_def.ptr_1));
			arr.AddRange(BitConverter.GetBytes(instrument_def.ptr_2));
		}

		static void write_sampled_instrument_to_bytearray(SampledInstrument sampled_instrument, List<byte> arr)
		{
			arr.AddRange(BitConverter.GetBytes(sampled_instrument.data_1));
			arr.AddRange(BitConverter.GetBytes(sampled_instrument.data_2));
			arr.AddRange(BitConverter.GetBytes(sampled_instrument.data_3));
			arr.AddRange(BitConverter.GetBytes(sampled_instrument.sample_size));
			arr.AddRange(sampled_instrument.sample_pcm_data);
		}

		static void write_programmable_waveform_to_bytearray(ProgrammableWaveform programmable_waveform, List<byte> arr)
		{
			arr.AddRange(BitConverter.GetBytes(programmable_waveform.data_1));
			arr.AddRange(BitConverter.GetBytes(programmable_waveform.data_2));
			arr.AddRange(BitConverter.GetBytes(programmable_waveform.data_3));
			arr.AddRange(BitConverter.GetBytes(programmable_waveform.data_4));
		}

		static void write_song_header_to_bytearray(SongHeader song_header, List<byte> arr)
		{
			arr.Add(song_header.number_of_tracks);
			arr.Add(song_header.unknown);
			arr.Add(song_header.song_priority);
			arr.Add(song_header.echo);
			arr.AddRange(BitConverter.GetBytes(song_header.instrument_def_ptr));

			foreach(var track_data_ptr in song_header.track_data_ptrs)
			{
				arr.AddRange(BitConverter.GetBytes(track_data_ptr));
			}
		}

		static List<byte> extract_instrument_data(byte[] file_contents, SongHeader song_header, int instrument_start_offset, Dictionary<int, int> used_instruments)
		{
			// Iterate over number of tracks (that's the number of main instruments we have)
			// parse every instrument, stick it into a bytearray(). Offset is computed on the fly

			// This bytearray stores the whole combined instrument definition, including all instruments and samples
			List<byte> all_instrument_bytes = new List<byte>();

			// This bytearray stores only the instrument defs
			List<byte> instrument_defs_bytes = new List<byte>();

			// This bytearray stores the instrument data (samples, programmable waveforms, key split instruments, etc.)
			List<byte> instrument_data_bytes = new List<byte>();

			var main_instrument_def_address = song_header.instrument_def_ptr - ROM_ADDRESS_MASK;
			var instrument_data_starting_address = instrument_start_offset + (used_instruments[USED_INSTRUMENTS_MAX] + 1) * 12;
			var total_instrument_data_address = instrument_data_starting_address;

			for (int track_idx = 0; track_idx < used_instruments[USED_INSTRUMENTS_MAX] + 1; ++track_idx)
			{
				// Parse instrument definition
				var main_track_instrument_def = extract_instrument_def(file_contents, main_instrument_def_address);
				System.Console.WriteLine("Main instrument address at " + main_instrument_def_address.ToString("X"));
				main_instrument_def_address += 12; // 12 bytes per track instrument def

				Console.WriteLine("Instrument " + track_idx + ", Type: " + main_track_instrument_def.instrument_type);

				// If we don't use the instrument, no need to extract samples or programmable synth stuff
				if (used_instruments.ContainsKey(track_idx) == false)
				{
					write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes);
					continue;
				}


				// Check for special instrument types that require additional handling
				if (main_track_instrument_def.instrument_type == INSTRUMENT_SAMPLE_1 || main_track_instrument_def.instrument_type == INSTRUMENT_SAMPLE_2)
				{
					// Sample Instrument
					if (main_track_instrument_def.ptr_1 <= ROM_ADDRESS_MASK || (main_track_instrument_def.ptr_1 - ROM_ADDRESS_MASK) > file_contents.Length)
					{
						write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes);
						continue;
					}

					var sampled_instrument = extract_sampled_instrument(file_contents, main_track_instrument_def.ptr_1 - ROM_ADDRESS_MASK);

					// Remap main_track_instrument.ptr1
					// We start at the current "data" address
					main_track_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

					// Write sample data into bytearray
					write_sampled_instrument_to_bytearray(sampled_instrument, instrument_data_bytes);

					total_instrument_data_address += 16 + sampled_instrument.sample_size;

					// Pad to aligned 4 bytes if necessary
					var num_padding_bytes = 0x04 - (total_instrument_data_address) & 0x03;

					for (int i = 0; i < num_padding_bytes; ++i)
					{
						instrument_data_bytes.Add(0);
						total_instrument_data_address += 1;
					}

					if ((total_instrument_data_address & 0x03) != 0)
					{
						System.Console.WriteLine("Padding Info: " + (total_instrument_data_address & 0x03));
						System.Diagnostics.Debug.Assert(false);
					}

				} 
				else if (main_track_instrument_def.instrument_type == INSTRUMENT_PROGRAMMABLE_WAVEFORM_1 || main_track_instrument_def.instrument_type == INSTRUMENT_PROGRAMMABLE_WAVEFORM_2)
				{
					// Programmable Waveform
					if (main_track_instrument_def.ptr_1 <= ROM_ADDRESS_MASK || (main_track_instrument_def.ptr_1 - ROM_ADDRESS_MASK) > file_contents.Length)
					{
						write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes);
						continue;
					}

					var programmable_waveform = extract_programmable_waveform(file_contents, main_track_instrument_def.ptr_1 - ROM_ADDRESS_MASK);

					// Remap main_track_instrument.ptr1
					// We start at the current "data" address
					main_track_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

					// Write sample data into bytearray
					write_programmable_waveform_to_bytearray(programmable_waveform, instrument_data_bytes);

					total_instrument_data_address += 16;
				}
				else if (main_track_instrument_def.instrument_type == INSTRUMENT_KEY_SPLIT)
				{
					// key_split instrument
					var key_split_instrument_def_address = main_track_instrument_def.ptr_1 - ROM_ADDRESS_MASK;
					var key_split_table_address = main_track_instrument_def.ptr_2 - ROM_ADDRESS_MASK;

					// We first store the key_split table
					main_track_instrument_def.ptr_2 = total_instrument_data_address + ROM_ADDRESS_MASK;

					total_instrument_data_address += 128;
					main_track_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

					List<byte> key_split_data = new List<byte>();
					List<byte> key_split_instruments = new List<byte>();
					List<byte> key_split_table_data = new List<byte>();

					// Iterate from 0 to max_key (more instruments do not need to be copied)
					int max_key = Int32.MinValue;

					// Read and allocate key_split table
					for (int idx = 0; idx < 128; ++idx)
					{
						var key = read_8_bit_from_file_at_offset(file_contents, key_split_table_address);
						key_split_table_address += 1;

						key_split_table_data.Add(key);

						if (key > max_key)
							max_key = key;	
					}

					// Add the key_split table
					key_split_data.AddRange(key_split_table_data);

					total_instrument_data_address += ((max_key + 1) * 12);

					for (int instrument_index = 0; instrument_index < max_key + 1; ++instrument_index)
					{
						var key_split_instrument_def = extract_instrument_def(file_contents, key_split_instrument_def_address);
						key_split_instrument_def_address += 12;

						// We assume a key_split instrument can not split again.

						if (key_split_instrument_def.instrument_type == INSTRUMENT_SAMPLE_1 || key_split_instrument_def.instrument_type == INSTRUMENT_SAMPLE_2)
						{
							// Sample Instrument
							if (key_split_instrument_def.ptr_1 <= ROM_ADDRESS_MASK || (key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK) > file_contents.Length)
							{
								write_instrument_def_to_bytearray(key_split_instrument_def, key_split_instruments);
								continue;
							}

							var sampled_instrument = extract_sampled_instrument(file_contents, key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK);

							// Remap key_split_instrument_def.ptr1
							// We start at the current "data" address
							key_split_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

							// Write sample data into bytearray
							write_sampled_instrument_to_bytearray(sampled_instrument, key_split_data);

							total_instrument_data_address += 16 + sampled_instrument.sample_size;

							// Pad to aligned 4 bytes if necessary
							var num_padding_bytes = 0x04 - (total_instrument_data_address) & 0x03;

							for (int i = 0; i < num_padding_bytes; ++i)
							{
								key_split_data.Add(0);
								total_instrument_data_address += 1;
							}

							if ((total_instrument_data_address & 0x03) != 0)
							{
								System.Console.WriteLine("Padding Info: " + (total_instrument_data_address & 0x03));
								System.Diagnostics.Debug.Assert(false);
							}

						}
						else if (key_split_instrument_def.instrument_type == INSTRUMENT_PROGRAMMABLE_WAVEFORM_1 || key_split_instrument_def.instrument_type == INSTRUMENT_PROGRAMMABLE_WAVEFORM_2)
						{
							// Programmable Waveform
							if (key_split_instrument_def.ptr_1 <= ROM_ADDRESS_MASK || (key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK) > file_contents.Length)
							{
								write_instrument_def_to_bytearray(key_split_instrument_def, key_split_instruments);
								continue;
							}

							var programmable_waveform = extract_programmable_waveform(file_contents, key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK);

							// Remap key_split_instrument_def.ptr1
							// We start at the current "data" address
							key_split_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

							// Write sample data into bytearray
							write_programmable_waveform_to_bytearray(programmable_waveform, key_split_data);

							total_instrument_data_address += 16;
						}
						else if (key_split_instrument_def.instrument_type == INSTRUMENT_KEY_SPLIT)
						{
							System.Console.WriteLine("Ignored key_split instrument while inside key_split instrument!");
						}
						else if (key_split_instrument_def.instrument_type == INSTRUMENT_EVERY_KEY_SPLIT)
						{
							System.Console.WriteLine("Ignored every_key_split instrument while inside key_split instrument!");
						}

						// Write key_split_instrument_def into bytearry
						write_instrument_def_to_bytearray(key_split_instrument_def, key_split_instruments);

					}

					// Write sub-instrument into instrument_data_bytes
					instrument_data_bytes.AddRange(key_split_instruments);
					instrument_data_bytes.AddRange(key_split_data);
				}
				else if (main_track_instrument_def.instrument_type == INSTRUMENT_EVERY_KEY_SPLIT)
				{
					// every_key_split instrument
					// For this, ptr_1 points to exactly 128 sub-instruments (e.g. for percussion)
					// Therefore, we need to extract 128 sub-instruments (with their respective samples)
					// Ideally, we would go through the track and check which sub-instruments are actually used, but it's fine as is for now

					var every_key_split_instrument_def_address = main_track_instrument_def.ptr_1 - ROM_ADDRESS_MASK;

					// Adjust the main_Track_instrument_def.ptr1 to the new region
					main_track_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

					// Since all 128 instruments need to be after each other, we need another bytearray to store data.
					List<byte> every_key_split_data = new List<byte>();
					List<byte> every_key_split_instruments = new List<byte>();

					total_instrument_data_address += 128 * 12;

					for (int every_key_split_index = 0; every_key_split_index < 128; ++every_key_split_index)
					{

						var every_key_split_instrument_def = extract_instrument_def(file_contents, every_key_split_instrument_def_address);
						every_key_split_instrument_def_address += 12;

						// We assume an every_key_split instrument can not split again.

						if (every_key_split_instrument_def.instrument_type == INSTRUMENT_SAMPLE_1 || every_key_split_instrument_def.instrument_type == INSTRUMENT_SAMPLE_2)
						{
							// Sample Instrument
							if (every_key_split_instrument_def.ptr_1 <= ROM_ADDRESS_MASK || (every_key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK) > file_contents.Length)
							{
								write_instrument_def_to_bytearray(every_key_split_instrument_def, every_key_split_instruments);
								continue;
							}

							var sampled_instrument = extract_sampled_instrument(file_contents, every_key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK);

							// Remap every_key_split_instrument_def.ptr1
							// We start at the current "data" address
							every_key_split_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

							// Write sample data into bytearray
							write_sampled_instrument_to_bytearray(sampled_instrument, every_key_split_data);

							total_instrument_data_address += 16 + sampled_instrument.sample_size;

							// Pad to aligned 4 bytes if necessary
							var num_padding_bytes = 0x04 - (total_instrument_data_address) & 0x03;

							for (int i = 0; i < num_padding_bytes; ++i)
							{
								every_key_split_data.Add(0);
								total_instrument_data_address += 1;
							}

							if ((total_instrument_data_address & 0x03) != 0)
							{
								System.Console.WriteLine("Padding Info: " + (total_instrument_data_address & 0x03));
								System.Diagnostics.Debug.Assert(false);
							}

						}
						else if (every_key_split_instrument_def.instrument_type == INSTRUMENT_PROGRAMMABLE_WAVEFORM_1 || every_key_split_instrument_def.instrument_type == INSTRUMENT_PROGRAMMABLE_WAVEFORM_2)
						{
							// Programmable Waveform
							if (every_key_split_instrument_def.ptr_1 <= ROM_ADDRESS_MASK || (every_key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK) > file_contents.Length)
							{
								write_instrument_def_to_bytearray(every_key_split_instrument_def, every_key_split_instruments);
								continue;
							}

							var programmable_waveform = extract_programmable_waveform(file_contents, every_key_split_instrument_def.ptr_1 - ROM_ADDRESS_MASK);

							// Remap every_key_split_instrument_def.ptr1
							// We start at the current "data" address
							every_key_split_instrument_def.ptr_1 = total_instrument_data_address + ROM_ADDRESS_MASK;

							// Write sample data into bytearray
							write_programmable_waveform_to_bytearray(programmable_waveform, every_key_split_data);

							total_instrument_data_address += 16;
						}
						else if (every_key_split_instrument_def.instrument_type == INSTRUMENT_KEY_SPLIT)
						{
							System.Console.WriteLine("Ignored key_split instrument while inside key_split instrument!");
						}
						else if (every_key_split_instrument_def.instrument_type == INSTRUMENT_EVERY_KEY_SPLIT)
						{
							System.Console.WriteLine("Ignored every_key_split instrument while inside key_split instrument!");
						}

						// Write key_split_instrument_def into bytearry
						write_instrument_def_to_bytearray(every_key_split_instrument_def, every_key_split_instruments);

					}

					// Write sub-instrument into instrument_data_bytes
					instrument_data_bytes.AddRange(every_key_split_instruments);
					instrument_data_bytes.AddRange(every_key_split_data);

				}

				// Write main instrument into the instrument def buffer
				write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes);

			}


			// Combine instrument defs and instrument data

			all_instrument_bytes.AddRange(instrument_defs_bytes);
			all_instrument_bytes.AddRange(instrument_data_bytes);

			return all_instrument_bytes;
		}

		static void extract_used_instruments(byte[] file_contents, int track_starting_address, Dictionary<int, int> used_instruments)
		{
			// Iterate over track, find all instrument change commands (0xBD) and set corresponding flag in used_instruments

			var track_working_address = track_starting_address - ROM_ADDRESS_MASK;

			byte read_byte = 0x00;

			while (read_byte != CMD_END_OF_TRACK)
			{
				read_byte = read_8_bit_from_file_at_offset(file_contents, track_working_address);
				track_working_address += 1;

				if (read_byte == CMD_INSTRUMENT_CHANGE)
				{
					var instrument_byte = read_8_bit_from_file_at_offset(file_contents, track_working_address);
					track_working_address += 1;
					used_instruments[instrument_byte] = 1;
					used_instruments[USED_INSTRUMENTS_MAX] = Math.Max(used_instruments[USED_INSTRUMENTS_MAX], instrument_byte);

				}
			}
		}

		// old_track_starting_address is the address stored in the ROM, new_track_starting_address is the address in the patch
		static List<byte> extract_track(byte[] file_contents, int old_track_starting_address, int new_track_starting_address, Dictionary<string, List<int>> out_control_ptrs, int track_data_starting_address_relative)
		{
			List<byte> raw_track_data = new List<byte>();
			var track_working_address = old_track_starting_address - ROM_ADDRESS_MASK;

			byte read_byte = 0x00;

			out_control_ptrs[KEY_TRANSPOSE] = new List<int>();
			out_control_ptrs[KEY_TEMPO] = new List<int>();
			

			int num_bytes_read = 0;

			while (read_byte != CMD_END_OF_TRACK)
			{
				read_byte = read_8_bit_from_file_at_offset(file_contents, track_working_address);
				track_working_address += 1;
				num_bytes_read += 1;

				// Force-Insert a 'repeat' call to force all tracks to loop

				if (read_byte == CMD_END_OF_TRACK)
				{
					raw_track_data.Add(CMD_JUMP_TO_ADDRESS);
					raw_track_data.AddRange(BitConverter.GetBytes(new_track_starting_address));
					raw_track_data.Add(CMD_END_OF_TRACK);
					break;
				}

				raw_track_data.Add(read_byte);

				if (read_byte == CMD_JUMP_TO_ADDRESS || read_byte == CMD_CALL)
				{
					// Jump to address of 4 bytes, needs to be recomputed
					var ptr = read_32_bit_from_file_at_offset(file_contents, track_working_address);
					track_working_address += 4;
					num_bytes_read += 4;

					ptr = (ptr - old_track_starting_address) + new_track_starting_address + ROM_ADDRESS_MASK;
					raw_track_data.AddRange(BitConverter.GetBytes(ptr));
				}
				else if (read_byte == CMD_TEMPO)
				{
					out_control_ptrs[KEY_TEMPO].Add(track_data_starting_address_relative + num_bytes_read);
				}
				else if (read_byte == CMD_TRANSPOSE)
				{
					out_control_ptrs[KEY_TRANSPOSE].Add(track_data_starting_address_relative + num_bytes_read);
				}
			}

			// Pad to aligned 4 bytes
			var num_padding_bytes = 0x04 - ((new_track_starting_address + raw_track_data.Count) & 0x03);

			for (int i = 0; i < num_padding_bytes; ++i)
			{
				raw_track_data.Add(0);
			}

			return raw_track_data;
		}

		static List<byte> extract_track_data(byte[] file_contents, SongHeader song_header, int track_data_starting_address, int track_data_starting_address_relative, Dictionary<string, List<int>> out_track_starting_addresses)
		{
			List<byte> all_track_data = new List<byte>();

			out_track_starting_addresses[KEY_POINTERS] = new List<int>();
			out_track_starting_addresses[KEY_TRANSPOSE] = new List<int>();
			out_track_starting_addresses[KEY_TEMPO] = new List<int>();

			// Iterate over all track pointers in song_header
			for (int track_idx = 0; track_idx < song_header.track_data_ptrs.Count; ++track_idx)
			{
				var track_data_ptr = song_header.track_data_ptrs[track_idx];

				var out_control_ptrs = new Dictionary<string, List<int>>();

				var raw_track_data = extract_track(file_contents, track_data_ptr, track_data_starting_address, out_control_ptrs, track_data_starting_address_relative);

				if (out_control_ptrs.ContainsKey(KEY_TRANSPOSE))
				{
					out_track_starting_addresses[KEY_TRANSPOSE].AddRange(out_control_ptrs[KEY_TRANSPOSE]);
				}

				if (out_control_ptrs.ContainsKey(KEY_TEMPO))
				{
					out_track_starting_addresses[KEY_TEMPO].AddRange(out_control_ptrs[KEY_TEMPO]);
				}

				song_header.track_data_ptrs[track_idx] = track_data_starting_address + ROM_ADDRESS_MASK;
				out_track_starting_addresses[KEY_POINTERS].Add(track_data_starting_address_relative);

				track_data_starting_address += raw_track_data.Count;
				track_data_starting_address_relative += raw_track_data.Count;

				all_track_data.AddRange(raw_track_data);
			}

			return all_track_data;
		}

		static void extract_song_data(byte[] file_contents, SongTable song_table, int patch_file_song_header_address, string game_name, int first_song_index)
		{
			// Extract song headers
			// Extract instrument data
			// Make sure all pointers are set correctly
			// Extract tracks
			// Combine everything into a single binary file for final patching

			var song_number = first_song_index;

			foreach (var song_header_ptr in song_table.song_header_ptrs)
			{
				try
				{
					System.Console.WriteLine("Extracting song header at address " + (song_header_ptr).ToString("X"));

					var song_header = extract_song_header(file_contents, song_header_ptr);

					var song_header_size = 4 * song_header.number_of_tracks + 8;

					if (song_header.number_of_tracks == 0)
					{
						song_number += 1;
						continue;
					}

					var used_instruments = new Dictionary<int, int>();
					used_instruments[USED_INSTRUMENTS_MAX] = -1;

					foreach (var track_data_ptr in song_header.track_data_ptrs)
					{
						extract_used_instruments(file_contents, track_data_ptr, used_instruments);
					}

					// Instruments start directly after the song header, which is at patch_file_song_header_address + song_header_size
					var raw_instrument_data = extract_instrument_data(file_contents, song_header, patch_file_song_header_address + song_header_size, used_instruments);

					song_header.instrument_def_ptr = (patch_file_song_header_address + song_header_size) + ROM_ADDRESS_MASK;

					var raw_instrument_data_size = raw_instrument_data.Count;

					var track_starting_offsets = new Dictionary<string, List<int>>();

					var raw_track_data = extract_track_data(
						file_contents,
						song_header,
						patch_file_song_header_address + song_header_size + raw_instrument_data_size,
						song_header_size + raw_instrument_data_size,
						track_starting_offsets
						);

					ensure_dir(System.IO.Path.Combine(DIRECTORY_OUT, game_name, "dummy.abc"));

					var folder_path = System.IO.Path.Combine(DIRECTORY_OUT, game_name);

					List<byte> all_patch_bytes = new List<byte>();
					List<byte> raw_song_header = new List<byte>();

					write_song_header_to_bytearray(song_header, raw_song_header);
					all_patch_bytes.AddRange(raw_song_header);
					all_patch_bytes.AddRange(raw_instrument_data);
					all_patch_bytes.AddRange(raw_track_data);

					System.IO.File.WriteAllBytes(System.IO.Path.Combine(folder_path, song_number.ToString() + FILE_EXTENSION_PATCH), all_patch_bytes.ToArray());


					using (System.IO.StreamWriter out_file = new System.IO.StreamWriter(System.IO.Path.Combine(folder_path, song_number.ToString() + FILE_EXTENSION_TRANSPOSE)))
					{
						foreach(var ptr in track_starting_offsets[KEY_TRANSPOSE])
						{
							out_file.WriteLine(ptr.ToString());
						}
					}

					using (System.IO.StreamWriter out_file = new System.IO.StreamWriter(System.IO.Path.Combine(folder_path, song_number.ToString() + FILE_EXTENSION_TEMPO)))
					{
						foreach (var ptr in track_starting_offsets[KEY_TEMPO])
						{
							out_file.WriteLine(ptr.ToString());
						}
					}
				}
				catch
				{
					// If we catch an exception, we're probably already in an invalid memory region.
					return;
				}
				song_number += 1;


			}
		}

		

		

		static void Main(string[] args)
		{

			if (args.Length != 5)
			{
				System.Console.WriteLine("Usage: SongExtractor.exe <rom_path> <song_table address (hex)> <first_song_index> <last_song_index> <patch_file_song_header address (hex)>");
				System.Console.WriteLine("Example: SongExtractor.exe mmbn3.gba 0x00148C6C 0 200 800000");
				return;
			}

			var rom_path = args[0];
			var song_table_address = Convert.ToInt32(args[1], 16);
			var first_song_index = Convert.ToInt32(args[2]);
			var last_song_index = Convert.ToInt32(args[3]);
			var patch_file_song_header_address = Convert.ToInt32(args[4], 16);

			var file_contents = System.IO.File.ReadAllBytes(rom_path);

			var song_table = extract_song_table(file_contents, song_table_address, first_song_index, last_song_index);

			extract_song_data(file_contents, song_table, patch_file_song_header_address, System.IO.Path.GetFileNameWithoutExtension(rom_path), first_song_index);

		}
	}
}
