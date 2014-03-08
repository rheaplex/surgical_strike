/*
    Surgical Strike (Free Software Version).
    Copyright (C) 2008, 2014 Rob Myers

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

%{

#include <cstdio>
#include <cstring>
#include <string>

#include "surgical_strike.h"

#include "y.tab.hpp"

void yyerror(const char *);
int yyparse (void);
int yylex (void);

extern "C" int yywrap (void)
{
    return 1;
}

#define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if ( result <= 0 ) \
      result = YY_NULL; \
    }

#define YYERROR_VERBOSE (1)

%}

%defines

%union
 {
   double floatnum;
   char string[256];
}

%start program

%token INCOMING
%token CODEWORD
%token SET
%token MARK
%token CLEAR
%token MANOUVER
%token ROLL
%token SCALE
%token LOAD
%token CAMOUFLAGE
%token DELIVER

%token <floatnum> NUMBER
%token <string> STRING
%token <string> IDENTIFIER

%%

program: incoming statements;

incoming: INCOMING               { parse_incoming (); };

statements: statement
| codeword_definition
| statements statement;

codeword_start: CODEWORD IDENTIFIER { parse_codeword ($2); };

codeword_end: SET                { parse_set (); };

codeword_definition: codeword_start statements codeword_end;

statement:
MARK                             { parse_mark (); }
| CLEAR                          { parse_clear (); }
| MANOUVER NUMBER NUMBER NUMBER  { parse_manouver ($2, $3, $4); }
| ROLL NUMBER NUMBER NUMBER      { parse_roll ($2, $3, $4); }
| SCALE NUMBER NUMBER NUMBER     { parse_scale ($2, $3, $4); }
| LOAD STRING                    { parse_payload ($2); }
| CAMOUFLAGE STRING              { parse_camouflage ($2); }
| IDENTIFIER NUMBER              { parse_codeword_execution ($1, $2); }
| DELIVER                        { parse_deliver (); }
;

%%

extern int yylineno;
extern char * yytext;

extern bool debug;

void yyerror (const char *msg)
{
  std::fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
}


int main(int argc, char ** argv)
{
  std::string output_file = "out.obj";
  if (((argc == 2) &&
       (std::strcmp (argv[1], "--help") == 0)) ||
      (argc > 3))
  {
      std::printf ("Surgical Strike Free Software version 0.3\n"
		   "USAGE:\n"
		   "surgical_strike - Read from stdin, write to out.obj|.mtl\n"
		   "surgical_strike [input file] [output file] - "
		   "Read input file, write output file\n");
      exit (0);
  }
  if (debug) std::fprintf (stderr, "Starting up.\n");
  if (argc == 2)
  {
      std::fprintf (stderr, "Opening input file %s.\n", argv[1]);
      FILE * new_stdin = freopen (argv[1], "r", stdin);
      if (new_stdin == NULL)
      {
          std::fprintf (stderr, "Couldn't open input file %s.\n", argv[1]);
          exit (1);
      }
  }
  if (argc == 3)
  {
      output_file = argv[2];
  }
  if (debug) std::fprintf (stderr, "Parsing input file.\n");
  yyparse ();
  if (debug) std::fprintf (stderr, "Executing commands.\n");
  run_main (output_file);
}
