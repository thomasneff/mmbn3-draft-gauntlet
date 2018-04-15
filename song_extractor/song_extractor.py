import sys
import struct
import os

class SongTable:
    song_header_ptrs        = None  # 4 bytes per song header
    track_group_numbers     = None  # 1/1/1/1 = 4 bytes per song header, might need to manually modify the maximum number of tracks in ** 4) Track-group RAM pointers format **

class SongHeader:
    number_of_tracks        = 0     # 1 byte
    unknown                 = 0     # 1 byte
    song_priority           = 0     # 1 byte
    echo                    = 0     # 1 byte
    instrument_def_ptr      = 0     # 4 bytes
    track_data_ptrs         = None  # number_of_tracks * 4 bytes

class InstrumentDef:
    instrument_type         = 0     # not written back to patch, used to detect programmable/sample/key split instruments
    data_1                  = 0     # 4 bytes
    ptr_1                   = 0     # 4 bytes, CAN be ptr when sample/programmable/key split instrument
    ptr_2                   = 0     # 4 bytes, is ptr for key split (not *every key split*) instrument

class ProgrammableWaveform:
    data_1                  = 0     # 4 bytes
    data_2                  = 0     # 4 bytes
    data_3                  = 0     # 4 bytes
    data_4                  = 0     # 4 bytes


class SampledInstrument:
    data_1                  = 0     # 4 bytes
    data_2                  = 0     # 4 bytes
    data_3                  = 0     # 4 bytes
    sample_size             = 0     # 4 bytes
    invalid                 = True
    sample_pcm_data         = 0     # sample_size bytes

def ensure_dir(file_path):
    directory = os.path.dirname(file_path)
    if not os.path.exists(directory):
        os.makedirs(directory)

def read_32_bit_from_file_at_offset(file_contents, offset):
    return struct.unpack("I", file_contents[offset:offset+4])[0]

def read_8_bit_from_file_at_offset(file_contents, offset):
    return struct.unpack("B", file_contents[offset:offset+1])[0]

def extract_song_table(file_contents, song_table_address, first_song_index, last_song_index):
    # Read from song_table_address
    # Format is 4 bytes address, 4 bytes track group stuff
    song_table = SongTable()
    song_table.song_header_ptrs = []
    song_table.track_group_numbers = []
    working_address = song_table_address
    working_address = working_address + first_song_index * 8
    for idx in range(first_song_index, last_song_index + 1):
        song_header_ptr = read_32_bit_from_file_at_offset(file_contents, working_address)
        working_address = working_address + 4
        track_group_numbers = read_32_bit_from_file_at_offset(file_contents, working_address)
        working_address = working_address + 4
        song_table.song_header_ptrs.append(song_header_ptr)
        song_table.track_group_numbers.append(track_group_numbers)

    return song_table

def extract_song_header(file_contents, song_header_address):
    song_header = SongHeader()
    working_address = song_header_address - 0x08000000 # addresses are stored with 0x08 because of ROM memory domain

    song_header.number_of_tracks  = read_8_bit_from_file_at_offset(file_contents, working_address)
    working_address = working_address + 1
    song_header.unknown = read_8_bit_from_file_at_offset(file_contents, working_address)
    working_address = working_address + 1
    song_header.song_priority = read_8_bit_from_file_at_offset(file_contents, working_address)
    working_address = working_address + 1
    song_header.echo = read_8_bit_from_file_at_offset(file_contents, working_address)
    working_address = working_address + 1
    song_header.instrument_def_ptr = read_32_bit_from_file_at_offset(file_contents, working_address)
    working_address = working_address + 4
    song_header.track_data_ptrs = []
    for track_idx in range(song_header.number_of_tracks):
        song_header.track_data_ptrs.append(read_32_bit_from_file_at_offset(file_contents, working_address))
        working_address = working_address + 4

    return song_header

def extract_instrument_def(file_contents, instrument_def_address):
    instrument_def = InstrumentDef()

    instrument_def.instrument_type = read_8_bit_from_file_at_offset(file_contents, instrument_def_address)

    instrument_def.data_1 = read_32_bit_from_file_at_offset(file_contents, instrument_def_address)
    instrument_def_address = instrument_def_address + 4

    instrument_def.ptr_1 = read_32_bit_from_file_at_offset(file_contents, instrument_def_address)
    instrument_def_address = instrument_def_address + 4

    instrument_def.ptr_2 = read_32_bit_from_file_at_offset(file_contents, instrument_def_address)
    instrument_def_address = instrument_def_address + 4

    return instrument_def

def extract_sampled_instrument(file_contents, ptr):
    sampled_instrument = SampledInstrument()
    print("ptr: ", hex(ptr))
    sampled_instrument.data_1 = read_32_bit_from_file_at_offset(file_contents, ptr)


    sampled_instrument.invalid = (read_8_bit_from_file_at_offset(file_contents, ptr) +\
                                 read_8_bit_from_file_at_offset(file_contents, ptr + 1) +\
                                 read_8_bit_from_file_at_offset(file_contents, ptr + 2)) != 0

    ptr = ptr + 4

    sampled_instrument.data_2 = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4

    sampled_instrument.data_3 = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4

    sampled_instrument.sample_size = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4

    sampled_instrument.sample_pcm_data = bytearray()

    if sampled_instrument.invalid:
        print("invalid sampled instrument")
        sampled_instrument.sample_size = len(sampled_instrument.sample_pcm_data)
        return sampled_instrument

    print("Sample size: ", hex(sampled_instrument.sample_size))

    if(sampled_instrument.sample_size > 0xFFFF):
        print("-------------------------------------------------------------------------------------------------------")
        print("Sample size too large - capping it!")
        print("-------------------------------------------------------------------------------------------------------")
        sampled_instrument.sample_size = 0xFFFF

    for idx in range(sampled_instrument.sample_size):
        sampled_instrument.sample_pcm_data.append(struct.pack("B", read_8_bit_from_file_at_offset(file_contents, ptr))[0])
        ptr = ptr + 1

    return sampled_instrument

def extract_programmable_waveform(file_contents, ptr):
    programmable_waveform = ProgrammableWaveform()

    programmable_waveform.data_1 = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4

    programmable_waveform.data_2 = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4

    programmable_waveform.data_3 = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4

    programmable_waveform.data_4 = read_32_bit_from_file_at_offset(file_contents, ptr)
    ptr = ptr + 4


    return programmable_waveform


def write_instrument_def_to_bytearray(instrument_def, arr):
    arr.extend(struct.pack("L", instrument_def.data_1))
    arr.extend(struct.pack("L", instrument_def.ptr_1))
    arr.extend(struct.pack("L", instrument_def.ptr_2))

def write_sampled_instrument_to_bytearray(sampled_instrument, arr):
    arr.extend(struct.pack("L", sampled_instrument.data_1))
    arr.extend(struct.pack("L", sampled_instrument.data_2))
    arr.extend(struct.pack("L", sampled_instrument.data_3))
    arr.extend(struct.pack("L", sampled_instrument.sample_size))
    arr.extend(sampled_instrument.sample_pcm_data)

def write_programmable_waveform_to_bytearray(programmable_waveform, arr):
    arr.extend(struct.pack("L", programmable_waveform.data_1))
    arr.extend(struct.pack("L", programmable_waveform.data_2))
    arr.extend(struct.pack("L", programmable_waveform.data_3))
    arr.extend(struct.pack("L", programmable_waveform.data_4))

def write_song_header_to_bytearray(song_header, arr):
    arr.extend(struct.pack("B", song_header.number_of_tracks))
    arr.extend(struct.pack("B", song_header.unknown))
    arr.extend(struct.pack("B", song_header.song_priority))
    arr.extend(struct.pack("B", song_header.echo))
    arr.extend(struct.pack("I", song_header.instrument_def_ptr))

    for track_data_ptr in song_header.track_data_ptrs:
        arr.extend(struct.pack("I", track_data_ptr))

def extract_instrument_data(file_contents, song_header, instrument_start_offset):
    a = 3

    # Iterate over number of tracks (that's the number of main instruments we have)
    # parse every instrument, stick it into a bytearray(). Offset is computed on the fly
    main_instrument_def_address = song_header.instrument_def_ptr - 0x08000000

    # This bytearray stores only the instrument defs
    instrument_defs_bytes = bytearray()

    # This bytearray stores the instrument data (samples, programmable waveforms, key split instruments, etc.)
    instrument_data_bytes = bytearray()


    all_instrument_bytes = bytearray()

    instrument_data_starting_address = instrument_start_offset + 256 * 12

    total_instrument_data_address = instrument_data_starting_address

    for track_idx in range(0, 256):#range(song_header.number_of_tracks):
        # Parse instrument definition
        main_track_instrument_def = extract_instrument_def(file_contents, main_instrument_def_address)
        print("Main instrument address at ", hex(main_instrument_def_address))
        main_instrument_def_address = main_instrument_def_address + 12 # 12 bytes per track instrument def

        print("Instrument " + str(track_idx) + ", Type: " + str(main_track_instrument_def.instrument_type))
        print("Current total instrument data addr: ", hex(total_instrument_data_address), hex(len(instrument_data_bytes)))



        # Check for special instrument types that require additional handling
        if main_track_instrument_def.instrument_type == 0x00 or main_track_instrument_def.instrument_type == 0x08:
            # Sample instrument
            # Read sampled instrument data from ptr_1
            print("sample instrument at addr ", hex(main_instrument_def_address - 12))
            print(hex(main_track_instrument_def.ptr_1), hex(main_track_instrument_def.ptr_2))

            if main_track_instrument_def.ptr_1 <= 0x08000000 or (main_track_instrument_def.ptr_1 - 0x08000000) > len(file_contents):
                write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes)
                continue

            sampled_instrument = extract_sampled_instrument(file_contents,
                                                            main_track_instrument_def.ptr_1 - 0x08000000)

            # Remap main_track_instrument.ptr1
            # We start at the current "data" address
            main_track_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000

            # Write sample data into bytearray
            write_sampled_instrument_to_bytearray(sampled_instrument, instrument_data_bytes)

            total_instrument_data_address = total_instrument_data_address + 16 + sampled_instrument.sample_size

            # Pad to aligned 4 bytes if necessary
            num_padding_bytes = 0x04 - (total_instrument_data_address) & 0x03
            print("num ", num_padding_bytes)
            # Not sure if we need the alignment.
            for i in range(num_padding_bytes):
                instrument_data_bytes.append(struct.pack("B", 0)[0])
                total_instrument_data_address = total_instrument_data_address + 1
                print("padd")

            if (total_instrument_data_address & 0x03) != 0:
                print(total_instrument_data_address & 0x03)
                assert (False)

            a = 3
        elif main_track_instrument_def.instrument_type == 0x03 or main_track_instrument_def.instrument_type == 0x0B:
            # Programmable Waveform

            if main_track_instrument_def.ptr_1 <= 0x08000000 or (main_track_instrument_def.ptr_1 - 0x08000000) > len(file_contents):
                write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes)
                continue

            programmable_waveform = extract_programmable_waveform(file_contents, main_track_instrument_def.ptr_1 - 0x08000000)

            # Remap main_track_instrument.ptr1
            # We start at the current "data" address
            main_track_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000

            print("Remapped programmable ptr to ", hex(main_track_instrument_def.ptr_1), hex(len(instrument_data_bytes)))

            write_programmable_waveform_to_bytearray(programmable_waveform, instrument_data_bytes)


            total_instrument_data_address = total_instrument_data_address + 16

            b = 3
        elif main_track_instrument_def.instrument_type == 0x40:

            # Key split instrument
            key_split_instrument_def_address = main_track_instrument_def.ptr_1 - 0x08000000
            key_split_table_address = main_track_instrument_def.ptr_2 - 0x08000000
            # We first store the key_split table
            main_track_instrument_def.ptr_2 = total_instrument_data_address + 0x08000000

            total_instrument_data_address = total_instrument_data_address + 128
            main_track_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000




            key_split_data = bytearray()
            key_split_instruments = bytearray()
            key_split_table_data = bytearray()
            # Read and allocate keysplit table

            keys = []

            for idx in range(0, 128):
                key = read_8_bit_from_file_at_offset(file_contents, key_split_table_address)
                key_split_table_data.append(key)
                keys.append(int(key))
                key_split_table_address = key_split_table_address + 1

            # Add the key_split table
            key_split_data.extend(key_split_table_data)

            # Iterate from 0 to max_key (more instruments do not need to be copied)
            max_key = max(keys)

            total_instrument_data_address = total_instrument_data_address + (max_key + 1) * 12

            for instrument_index in range(0, max_key + 1):
                key_split_instrument_def = extract_instrument_def(file_contents,
                                                                        key_split_instrument_def_address)
                key_split_instrument_def_address = key_split_instrument_def_address + 12

                # I'm not sure if this is possible, but I don't think a key-split instrument can split again.

                if key_split_instrument_def.instrument_type == 0x00 or key_split_instrument_def.instrument_type == 0x08:
                    # Read sampled instrument data from ptr_1

                    if key_split_instrument_def.ptr_1 <= 0x08000000 or (key_split_instrument_def.ptr_1 - 0x08000000) > len(file_contents):
                        write_instrument_def_to_bytearray(key_split_instrument_def, key_split_instruments)
                        continue

                    sampled_instrument = extract_sampled_instrument(file_contents,
                                                                    key_split_instrument_def.ptr_1 - 0x08000000)

                    # Remap every_key_split_instrument_def.ptr1
                    # We start at the current "data" address
                    key_split_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000


                    # Write sample data into bytearray
                    write_sampled_instrument_to_bytearray(sampled_instrument, key_split_data)

                    total_instrument_data_address = total_instrument_data_address + 16 + sampled_instrument.sample_size

                    # Pad to aligned 4 bytes if necessary
                    num_padding_bytes = 0x04 - (total_instrument_data_address) & 0x03
                    print("num ", num_padding_bytes)
                    # Not sure if we need the alignment.
                    for i in range(num_padding_bytes):
                        key_split_data.append(struct.pack("B", 0)[0])
                        total_instrument_data_address = total_instrument_data_address + 1
                        print("padd")

                    if (total_instrument_data_address & 0x03) != 0:
                        print(total_instrument_data_address & 0x03)
                        assert (False)

                    a = 3
                elif key_split_instrument_def.instrument_type == 0x03 or key_split_instrument_def.instrument_type == 0x0B:
                    # Programmable Waveform

                    if key_split_instrument_def.ptr_1 <= 0x08000000 or (key_split_instrument_def.ptr_1 - 0x08000000) > len(file_contents):
                        write_instrument_def_to_bytearray(key_split_instrument_def, key_split_instruments)
                        continue

                    programmable_waveform = extract_programmable_waveform(file_contents,
                                                                          key_split_instrument_def.ptr_1 - 0x08000000)

                    # Remap every_key_split_instrument_def.ptr1
                    # We start at the current "data" address
                    key_split_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000


                    write_programmable_waveform_to_bytearray(programmable_waveform, key_split_data)

                    total_instrument_data_address = total_instrument_data_address + 16

                    b = 3
                elif key_split_instrument_def.instrument_type == 0x40:
                    # Key split instrument, we ignore it.
                    print('ignored key_split instrument while inside every_key_split instrument')

                elif key_split_instrument_def.instrument_type == 0x80:
                    # Every-key split instrument
                    print('ignored every_key_split instrument while inside every_key_split instrument')

                # Write every_key_split_instrument_def into bytearray
                write_instrument_def_to_bytearray(key_split_instrument_def, key_split_instruments)

            # Write sub-instrument into instrument_data_bytes
            instrument_data_bytes.extend(key_split_instruments)
            instrument_data_bytes.extend(key_split_data)
            c = 3
        elif main_track_instrument_def.instrument_type == 0x80:
            # Every-key split instrument
            # For this, ptr_1 points to exactly 128 SubInstruments (e.g. for percussion)
            # Therefore, we need to extract 128 instruments (with their respective samples)
            every_key_split_instrument_def_address = main_track_instrument_def.ptr_1 - 0x08000000

            print("every key split instrument at addr ", hex(every_key_split_instrument_def_address))

            # Adjust the main_track_instrument_def ptr1 to the new region
            main_track_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000

            # Since all 128 instruments need to be after each other, we need another bytearray to store data.
            every_key_split_data = bytearray()
            every_key_split_instruments = bytearray()

            total_instrument_data_address = total_instrument_data_address + 128 * 12

            lulcounter = 0

            for every_key_split_index in range(0, 128):
                print("Current total instrument data addr: ", hex(total_instrument_data_address), hex(len(every_key_split_data)))
                every_key_split_instrument_def = extract_instrument_def(file_contents, every_key_split_instrument_def_address)
                every_key_split_instrument_def_address = every_key_split_instrument_def_address + 12

                # I'm not sure if this is possible, but I don't think a key-split instrument can split again.

                if every_key_split_instrument_def.instrument_type == 0x00 or every_key_split_instrument_def.instrument_type == 0x08:
                    # Read sampled instrument data from ptr_1
                    print("sample instrument at addr ", hex(every_key_split_instrument_def_address  - 12) )
                    print(hex(every_key_split_instrument_def.ptr_1), hex(every_key_split_instrument_def.ptr_2))

                    if every_key_split_instrument_def.ptr_1 <= 0x08000000 or (every_key_split_instrument_def.ptr_1 - 0x08000000) > len(file_contents):
                        write_instrument_def_to_bytearray(every_key_split_instrument_def, every_key_split_instruments)
                        continue

                    sampled_instrument = extract_sampled_instrument(file_contents, every_key_split_instrument_def.ptr_1 - 0x08000000)

                    # Remap every_key_split_instrument_def.ptr1
                    # We start at the current "data" address
                    every_key_split_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000


                    # Write sample data into bytearray
                    write_sampled_instrument_to_bytearray(sampled_instrument, every_key_split_data)




                    total_instrument_data_address = total_instrument_data_address + 16 + sampled_instrument.sample_size
                    lulcounter = lulcounter + 16 + sampled_instrument.sample_size

                    # Pad to aligned 4 bytes if necessary
                    num_padding_bytes = 0x04 - (total_instrument_data_address) & 0x03
                    print("num ", num_padding_bytes)
                    # Not sure if we need the alignment.
                    for i in range(num_padding_bytes):
                        every_key_split_data.append(struct.pack("B", 0)[0])
                        total_instrument_data_address = total_instrument_data_address + 1
                        print("padd")

                    if (total_instrument_data_address & 0x03) != 0:
                        print(total_instrument_data_address & 0x03)
                        assert (False)

                    print("sample ", hex(total_instrument_data_address), hex(len(every_key_split_data)), hex(lulcounter))


                    a = 3
                elif every_key_split_instrument_def.instrument_type == 0x03 or every_key_split_instrument_def.instrument_type == 0x0B:
                    # Programmable Waveform

                    print("Programmable waveform ", hex(every_key_split_instrument_def.ptr_1))

                    if every_key_split_instrument_def.ptr_1 <= 0x08000000 or (every_key_split_instrument_def.ptr_1 - 0x08000000) > len(file_contents):
                        write_instrument_def_to_bytearray(every_key_split_instrument_def, every_key_split_instruments)
                        continue

                    programmable_waveform = extract_programmable_waveform(file_contents,
                                                                          every_key_split_instrument_def.ptr_1 - 0x08000000)

                    # Remap every_key_split_instrument_def.ptr1
                    # We start at the current "data" address
                    every_key_split_instrument_def.ptr_1 = total_instrument_data_address + 0x08000000

                    write_programmable_waveform_to_bytearray(programmable_waveform, every_key_split_data)

                    total_instrument_data_address = total_instrument_data_address + 16

                    lulcounter = lulcounter + 16
                    print("programmable waveform ", hex(total_instrument_data_address), hex(len(every_key_split_data)), hex(lulcounter))
                    b = 3
                elif every_key_split_instrument_def.instrument_type == 0x40:
                    # Key split instrument, we ignore it.
                    print('ignored key_split instrument while inside every_key_split instrument')

                elif every_key_split_instrument_def.instrument_type == 0x80:
                    # Every-key split instrument
                    print('ignored every_key_split instrument while inside every_key_split instrument')




                # Write every_key_split_instrument_def into bytearray
                write_instrument_def_to_bytearray(every_key_split_instrument_def, every_key_split_instruments)

            print("pre: ", hex(len(instrument_data_bytes)))
            print("writing into instrument_data: ", hex(len(every_key_split_instruments) + len(every_key_split_data)))
            # Write sub-instrument into instrument_data_bytes
            instrument_data_bytes.extend(every_key_split_instruments)
            instrument_data_bytes.extend(every_key_split_data)


        # Write main instrument into the instrument def buffer
        write_instrument_def_to_bytearray(main_track_instrument_def, instrument_defs_bytes)

        a = 3


    all_instrument_bytes.extend(instrument_defs_bytes)
    all_instrument_bytes.extend(instrument_data_bytes)

    return all_instrument_bytes


# old_track_starting_address is the address stored in the ROM, new_track_starting_address is the address in the patch
def extract_track(file_contents, old_track_starting_address, new_track_starting_address):
    # TODO: read until B1 is found, which signals end-of-track. Also pad data with zeros to be 4-byte aligned.
    # TODO: if B2/B3 are found the addresses need to be recomputed
    a = 3
    raw_track_data = bytearray()
    track_working_address = old_track_starting_address - 0x08000000

    read_byte = 0x00

    while (read_byte != 0xB1):

        read_byte = read_8_bit_from_file_at_offset(file_contents, track_working_address)
        track_working_address = track_working_address + 1

        raw_track_data.append(struct.pack("B", read_byte)[0])

        if (read_byte == 0xB2 or read_byte == 0xB3):
            # Jump to address of 4 bytes, needs to be recomputed
            ptr = read_32_bit_from_file_at_offset(file_contents, track_working_address)
            track_working_address = track_working_address + 4
            ptr =  (ptr - old_track_starting_address) + new_track_starting_address + 0x08000000
            raw_track_data.extend(struct.pack("I", ptr))


    # Pad to aligned 4 bytes if necessary
    num_padding_bytes = 0x04 - ((new_track_starting_address + len(raw_track_data)) & 0x03)

    # Not sure if we need the alignment.
    for i in range(num_padding_bytes):
        raw_track_data.append(struct.pack("B", 0)[0])


    return raw_track_data

def extract_track_data(file_contents, song_header, track_data_starting_address, track_data_starting_address_relative, out_track_starting_addresses):
    # Iterate over all track ptrs in song_header
    track_base_address = track_data_starting_address

    all_track_data = bytearray()

    out_track_starting_addresses['ptrs'] = []

    for track_idx in range(0, len(song_header.track_data_ptrs)):
        a = 3
        track_data_ptr = song_header.track_data_ptrs[track_idx]
        raw_track_data = extract_track(file_contents, track_data_ptr, track_data_starting_address)

        song_header.track_data_ptrs[track_idx] = track_data_starting_address + 0x08000000
        out_track_starting_addresses['ptrs'].append(track_data_starting_address_relative)

        track_data_starting_address = track_data_starting_address + len(raw_track_data)
        track_data_starting_address_relative = track_data_starting_address_relative + len(raw_track_data)

        all_track_data.extend(raw_track_data)

    return all_track_data

def extract_song_data(file_contents, song_table, patch_file_song_header_address, game_name, first_song_index):
    # TODO:
    # extract song headers
    # extract instrument data
    # make sure all ptrs are set correctly
    # extract tracks
    # concatenate everything for final patching


    # This bytearray will contain the final data
    extracted_song_data = bytearray()

    song_number = first_song_index

    for song_header_ptr in song_table.song_header_ptrs:
        print("Extracting song header at address " + hex(song_header_ptr))
        song_header = extract_song_header(file_contents, song_header_ptr)


        song_header_size = 4 * song_header.number_of_tracks + 8

        if song_header.number_of_tracks == 0:
            song_number = song_number + 1
            continue

        # Instruments start directly after the song header, which is at patch_file_song_header_address + song_header_size
        raw_instrument_data = extract_instrument_data(file_contents, song_header, patch_file_song_header_address + song_header_size)


        song_header.instrument_def_ptr = (patch_file_song_header_address + song_header_size) + 0x08000000

        raw_instrument_data_size = len(raw_instrument_data)

        track_starting_offsets = {}
        # TODO: extract_track_data (this also needs to remap the song_header ptrs)
        raw_track_data = extract_track_data(file_contents,
                                            song_header,
                                            patch_file_song_header_address + song_header_size + raw_instrument_data_size,
                                            song_header_size + raw_instrument_data_size,
                                            track_starting_offsets)

        game_name = os.path.splitext(game_name)[0]
        ensure_dir(os.path.join('out', game_name, 'test.abc'))

        folder_path = os.path.join('out', game_name)

        with open(os.path.join(folder_path, str(song_number) + ".offsets"), "wt") as out_file:
            for ptr in track_starting_offsets['ptrs']:
                out_file.write(str(ptr) + '\n')

        with open(os.path.join(folder_path, str(song_number) + ".songpatch"), "wb") as out_file:
            raw_song_header = bytearray()
            write_song_header_to_bytearray(song_header, raw_song_header)
            out_file.write(raw_song_header)
            out_file.write(raw_instrument_data)
            out_file.write(raw_track_data)


        song_number = song_number + 1



def main():
    if len(sys.argv) != 6:
        #mmbn3.gba 0x00148C6C 0 0 0x0015BEC4
        print("Usage: song_extractor.py <rom_path> <song_table address (hex)> <first_song_index> <last_song_index> <patch_file_song_header address (hex)>")
        print("Example: song_extractor.py mmbn3.gba 0x00148C6C 0 0 0015BEC4")
        return

    rom_path = sys.argv[1]
    song_table_address = int(sys.argv[2], 16)
    first_song_index = int(sys.argv[3])
    last_song_index = int(sys.argv[4])
    patch_file_song_header_address = int(sys.argv[5], 16)

    file_contents = None

    with open(rom_path, "rb") as in_file:
        file_contents = in_file.read()

    song_table = extract_song_table(file_contents, song_table_address, first_song_index, last_song_index)

    extract_song_data(file_contents, song_table, patch_file_song_header_address, os.path.basename(rom_path), first_song_index)


    a = 3


if __name__ == "__main__":
    main()