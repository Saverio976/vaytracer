/*
MIT License

Copyright (c) 2025 Xavier Mitault

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
// https://github.com/Saverio976/vmake-vsh

import flag
import os
import arrays

struct Rules {
}

struct Args {
	directory string = os.getwd() @[short: C]
	jobs      int    = 1    @[short: j]
}

pub fn (args Args) execute_rule(rule string) !bool {
	if args.directory != os.getwd() {
		os.chdir(args.directory) or { return error('vmake: *** Can not change directory. Stop.') }
	}
	rules := Rules{}
	$for method in Rules.methods {
		mut method_name := arrays.find_first[string](method.attrs, fn (e string) bool {
			return e.starts_with('name: ')
		}) or { method.name }
		if method_name.starts_with('name: ') {
			method_name = method_name.after('name: ')
		}
		if method_name == rule {
			mut really_execute := false
			if _ := arrays.find_first[string](method.attrs, fn (e string) bool {
				return e.starts_with('phony')
			})
			{
				really_execute = true
			} else if deps := arrays.find_first[string](method.attrs, fn (e string) bool {
				return e.starts_with('deps: ')
			})
			{
				deps_ := deps.after('deps: ').fields()
				really_execute = args.check_and_run_deps(rule, deps_)!
			}
			if really_execute {
				rules.$method(args) or { return error('vmake: *** [${rule}] Error:\n${err}') }
				return true
			}
			return false
		}
	}
	if os.exists(rule) {
		return false
	}
	return error("vmake: *** No rule to make target '${rule}'.  Stop.")
}

pub fn (args Args) check_and_run_deps(rule string, deps []string) !bool {
	mut updated := false
	mut rule_stat := os.Stat{}
	$if windows {
		if tmp_stat := os.lstat(rule) {
			rule_stat = tmp_stat
		} else if tmp_stat := os.lstat(rule + '.exe') {
			rule_stat = tmp_stat
		} else {
			updated = true
		}
	} $else {
		if tmp_stat := os.lstat(rule) {
			rule_stat = tmp_stat
		} else {
			updated = true
		}
	}
	rule_mtime := rule_stat.mtime
	for dep in deps {
		mut dep_stat_set := true
		mut dep_stat := os.Stat{}
		$if windows {
			if tmp_stat := os.lstat(dep) {
				dep_stat = tmp_stat
			} else if tmp_stat := os.lstat(dep + '.exe') {
				dep_stat = tmp_stat
			} else {
				dep_stat_set = false
			}
		} $else {
			if tmp_stat := os.lstat(dep) {
				dep_stat = tmp_stat
			} else {
				dep_stat_set = false
			}
		}
		res := args.execute_rule(dep) or { return error("${err}  Needed by '${rule}'.") }
		if res {
			updated = true
		}
		dep_mtime := dep_stat.mtime
		if dep_stat_set && dep_mtime > rule_mtime {
			updated = true
		}
	}
	return updated
}

pub fn (args Args) sh(cmd string) ! {
	println(cmd)
	res := os.execute_opt(cmd)!
	print(res.output)
}

fn main() {
	args, no_matches := flag.using[Args](Args{}, os.args, skip: 1) or {
		eprintln('ERROR: ${err}')
		doc := flag.to_doc[Args]() or {
			eprintln('vmake: *** For some reason when creating the documentation')
			exit(2)
		}
		eprintln(doc)
		exit(2)
	}
	for rule in no_matches {
		args.execute_rule(rule) or {
			eprintln(err)
			exit(2)
		}
	}
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// End Of License
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------

// Write your Rules here:

const target_name = 'vaytracer'
const target_dev = 'vaytracer-dev'

@[deps: 'vaytracer']
fn (r Rules) all(args Args) ! {
}

@[name: 'vaytracer'; phony]
fn (r Rules) target(args Args) ! {
	cmd := (
		@VEXE
		+ ' .'
		+ ' -o "${target_name}"'
		+ ' -prod'
		+ ' -gc none'
		+ ' -d no_segfault_handler'
		+ ' -cflags "-march=native -O3"'
	)
	args.sh(cmd)!
}

fn (r Rules) dev(args Args) ! {
	cmd := (
		@VEXE
		+ ' .'
		+ ' -o "${target_dev}"'
		+ ' -cg'
	)
	args.sh(cmd)!
}

@[phony]
fn (r Rules) fmt(args Args) ! {
	args.sh(@VEXE + ' fmt -w .')!
}

@[phony]
fn (r Rules) clean(args Args) ! {
	os.rm(target_name) or {}
	os.rm(target_dev) or {}
}

@[phony]
fn (r Rules) profile(args Args) ! {
	cmd := (
		@VEXE
		+ ' -profile profile.txt'
		+ ' run .'
		+ " --scene-file './scenes/basic1.toml'"
		+ ' --quiet'
	)
	args.sh(cmd)!
	$if windows {
		return error('can"t sort')
	}
	cmd2 := (
		'sort'
		+ ' -n'
		+ ' -k2'
		+ ' profile.txt'
		+ ' --reverse'
		+ ' -o tmp.txt'
	)
	args.sh(cmd2)!
	cmd3 := (
		'mv'
		+ ' tmp.txt'
		+ ' profile.txt'
	)
	args.sh(cmd3)!
}
