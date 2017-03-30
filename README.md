([version française](http://github.com/jytou/vanitygen/blob/master/README_fr.md))

Purpose: Generates Duniter vanity adresses

# Introduction

This program enables to search for public addresses that contain a certain form of pattern and gives you the password and salt needed to connect to these addresses. Haven't you ever dreamed of having an address in the form:

    JohnDoe49R1PivbbQCsfyJrAUDZJTqfnQHqJm2E89Vc

What about

    MyCompanySrb7tfj3buJUQbL7xTSWi5JnGYwmC6Qpes

Well, if so, this generator is exactly what you are looking for.

# Warning

Be aware that if you run this utility on any machine you don't have fully control on, someone could be spying on you and thus get the generated password and salt. Run this **only** on environments you fully trust! Ideally, this should be run on a live CD after disconnecting the internet, and write down everything on paper.

# Requirements

- A gcc compiler, optionally make. No extra library needed.
- One fast computer (or even better, a bunch of them!).
- Patience. It may require just a few hours to weeks or months to find an address that suits you, depending on your requirements. Check the "Guidance" section bellow.

# Building

Download the repository or "git clone https://github.com/jytou/vanitygen.git".
Check the Makefile and uncomment/comment what is right for your system.

To check whether your CPU supports SSE or not, here are a few hints:
- if the processor is not an ARM and is pretty recent, there is a high chance it supports SSE,
- type "grep -i sse /proc/cpuinfo" on the command line, if it doesn't show anything, then your CPU doesn't support SSE, otherwise it does.
- it is likely that with SSE activated the compilation will fail on a non SSE system, since some libraries will be missing.

Note that for processors not using SSE, the search will be much longer. A 1.2GHz quad core ARM without SSE from a Raspberry Pi 3 reaches 22 keys/s, whereas AMD or similar i5 Intel processors at 1.4GHz with SSE reach 150-200 keys/s on 4 cores, and dual Xeon systems with 24 cores can go up to 1000 keys/s. But the power consumption and the cost of these different systems are as wide as their speed.

Run make. Et voilà!

Note that I have only tested on Unix-like systems such as Linux and Solaris. Feel free to come back with fixes for Windows, MacOS or whatever system you're using.
Note that since a lot of tricky low level operations (bit shifts, xors, etc.) are performed, the very first thing that the program does is that it generates a known address for a known password/salt, and makes sure that the address generated is correct to avoid generating garbage.

# Matching what you want

The program searches for regular expressions (regex) that you provide. The regex are in the form of standard POSIX regex, and matched through standard regex library calls. You can search for as many regex as you want, and put them in a text file, one regex per line.

# Guidance on the complexity of the regex

On a decent machine, you can expect to search for 200 addresses per second. If you generate from seeds, you can reach 50k addresses per second, but you won't be able to log into Duniter clients, except Silkaj at the moment. This is very slow. So if the percentage of finding your regex is, say, 0.000001%, you would be ready to wait at least a month to get a result. That's a long time. So before thinking about what regex you want to search for, it is wise to get an estimate of the complexity of the search. You don't want to search for something if it will take 500 years to find it.

Public addresses are using 62 different characters. So, if you search for a word of 5 letters (case sensitive) at the beginning of the string, the probability of finding one is: (1/62)^5=.000000001. Which, at 200 keys a second, gives you roughly a 50 days time frame to find what you want. If you don't require it to be at the beginning of the key, then you multiply by the length of the string minus 5 (keys are 43 characters in length), which is less than a day. But then your "beautiful string" may be in the very middle of the key, and people will not notice it.

In reality, things are a little more complex since characters are not used in a uniform distribution (try searching for "^a" and "^A"), but it gives some rough estimates of the time you'll have to wait before getting a result.

You can also get better odds by allowing non case sensitive matches, and even "hacker-style" characters (1 for l, 3 for E, etc.).

And of course, if you can run it on several machines at the same time, you are multiplying your chances by that many.

If you're uncomfortable with statistics, you can just try out "easy" regex, such as "^bad" and see how long it takes to get a result. You can then iteratively make more complex searches.

# Usage

Usage: [-s][-n min max][-r|-R resultfile][-w wordfile [-f filler_type][-c]] regexfile

	-n min max (optional): minimum and maximum number of characters/words to use to generate passwords.
	-w wordfile (optional): generate passwords/salt using a list of words contained in the file "wordfile", rather than simply random characters.
		-f type (optional) filler type between words: 0=spaces (default), 1=special characters and numbers, 2=none.
		-c (optional): capitalize the first character of words (non capitalized by default - you can also capitalize the words in the given file).
	-r resultfile (optional): a file to which the results should be written to.
	-R resultfile (optional): same as -r, but do not show the results found on the standard output.
	-s (optional): Do not generate password/salt, but only a seed (!!!WARNING!!! You will not be able to connect with Sakia or Cesium with this).
	regexfile (required): a file containing a list of regex (one per line). Lines beginning by a tab are ignored.

Regex examples:

    Public Key starting with "duniter" not case sensitive: "^[Dd][Uu][Nn][Ii][Tt][Ee][rR]"
    Public Key containing "Duniter" case sensitive: "Duniter"
    Public Key ending with "Freedom" (including hacker style :p ): "[fF][rR][eE3][eE3][dD][oO0][mM]$"

Usage examples:

    Basic with regex: regex.txt
        Example of generated password/salt: "q,d/dQ[i6-?_w$,#I/yu"

    Generate with a word file, using from 6 to 10 words, capitalized: -w words.txt -n 6 10 -c regex.txt
        Example of generated password/salt: "Apple Factory Jump Music Truck Buddha Movie Fountain"

    Generate with a word file, using random and numeric characters as separators: -w words.txt -f 1 regex.txt
        Example of generated password/salt: "apple!factory5jump;music-truck9buddha<movie(fountain"

# Copyrights

This contains code from the NaCL library.
I have also copied strips of code from various sources, but it has been remodelled.

# For the curious

I wrote this program with the hopes to convert it one day to opencl to accelerate the process, which is why I took all I could from any dependencies in order to port the code to opencl. It may still happen one day!
