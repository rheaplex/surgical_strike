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

%{
#include <math.h>
#include <stdlib.h>
#include "y.tab.hpp"
%}

%option yylineno

%%

"incoming!"          { return INCOMING; }
"codeword"           { return CODEWORD; }
"set"                { return SET; }
"mark"               { return MARK; }
"clear"              { return CLEAR; }
"manouver"           { return MANOUVER; }
"roll"               { return ROLL; }
"scale"              { return SCALE; }
"load"               { return LOAD; }
"camouflage"         { return CAMOUFLAGE; }
"deliver"            { return DELIVER; }

[a-z][a-z0-9]*       { strcpy (yylval.string, yytext ); 
                       return IDENTIFIER; }

-?([0-9]+|([0-9]*\.[0-9]+)) { yylval.floatnum = atof (yytext); 
                              return NUMBER; }

\"[^"]*\"            { memset (yylval.string, '\0', sizeof(yylval.string));
                       strncpy (yylval.string, yytext + 1, 
                       strlen (yytext) - 2);
                       return STRING; }

"//"[^\n]*\n         ;       /* ignore comment */

[ \t\n]+             ;       /* ignore whitespace */

.                    { printf("Unknown character [%c]\n",yytext[0]); }

%%
