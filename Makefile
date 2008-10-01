# Surgical Strike Free Software.
# Copyright (C) 2008 Rob Myers
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option, and if the Coin3D library supports it) any later 
# version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

all: lex.yy.c y.tab.cpp surgical_strike

lex.yy.c: surgical_strike.l
	flex surgical_strike.l

lex.yy.o: lex.yy.c
	cc -c lex.yy.c -o lex.yy.o

y.tab.cpp: surgical_strike.y
	bison --verbose --debug --defines surgical_strike.y -o y.tab.cpp

surgical_strike: lex.yy.o y.tab.cpp surgical_strike.cpp
	c++ lex.yy.o y.tab.cpp surgical_strike.cpp \
	    -losg -losgDB -losgViewer -o surgical_strike

release: 
	tar -zcvf surgical_strike.tar.gz \
	../surgical_strike/surgical_strike.l \
	../surgical_strike/surgical_strike.y \
	../surgical_strike/surgical_strike.cpp \
	../surgical_strike/surgical_strike.h \
	../surgical_strike/*.strike \
	../surgical_strike/*.png \
	../surgical_strike/*.dxf \
	../surgical_strike/test.strike \
	../surgical_strike/Makefile \
	../surgical_strike/AUTHORS \
	../surgical_strike/COPYING \
	../surgical_strike/Changelog \
	../surgical_strike/DISCLAIMER \
	../surgical_strike/README 

clean:
	rm *.o
	rm lex.yy.c 
	rm y.tab.cpp
	rm surgical_strike
