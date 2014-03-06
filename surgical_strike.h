/*
    Surgical Strike (Free Software Version).
    Copyright (C) 2008 Rob Myers

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef __SURGICAL_STRIKE_H__
#define __SURGICAL_STRIKE_H__

void parse_incoming ();
void parse_manouver (float x, float y, float z);
void parse_roll (float x, float y, float z);
void parse_scale (float x, float y, float z);
void parse_codeword (std::string word);
void parse_set ();
void parse_mark ();
void parse_clear ();
void parse_camouflage (std::string camouflage_file_name);
void parse_payload (std::string payload_file_name);
void parse_deliver ();
void parse_codeword_execution (const char * codeword, int times);

void write_file (const std::string & filename);
void run_main (const std::string & savefilename);

#endif
