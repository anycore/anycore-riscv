User Guide for AnyCore RISC-V
===========================================================================

1. [Quickstart](#quickstart)
2. [Tour of The Sources](#tour)
3. [Build the Tools](#build-tools)
4. [AnyCore Test Infrastructure](#test-infra)
5. [Synthesizing Cores](#synth)
6. [Commit Changes in Submodules](#commit-submodules)

# <a name="quickstart"></a>Quickstart

Check the version your git by using:

	% git --version

#####If your git version is above 1.7.9

	% git clone --recursive https://github.com/anycore/anycore-riscv.git

#####If you are using git version before 1.7.9, you might need to specify your username

######If using C-Shell:

	% set GIT_USER_NAME=<username>    
	% git clone https://`echo $GIT_USER_NAME`@github.com/anycore/anycore-riscv.git
	% cd anycore-riscv/
	% sed -i -- 's/github/'`echo $GIT_USER_NAME`'@github/g' .gitmodules 
	% git submodule update --init --recursive
	
######If using Bash:	

	$ export GIT_USER_NAME=<username>    
	$ git clone https://`echo $GIT_USER_NAME`@github.com/anycore/anycore-riscv.git
	$ cd anycore-riscv/
	$ sed -i -- 's/github/'`echo $GIT_USER_NAME`'@github/g' .gitmodules 
	$ git submodule update --init --recursive


#####WARNING:
If you just want to use the codebase to run tests, you are all set to move on to 
[Build The Tools.]#build-tools). However, if you think that you might need to modify 
code in any of the submodules and want to commit them back to upstream repo, read the 
section on [Committing Submodules](#commit-submodules) very carefully. You have been 
warned! Unless you have a very good reason to checkout riscv-pk, riscv-fesvr, 
and riscv-isa-sim, do not checkout these repos. 
The Anycore toolset is tied to a 
specific version of these repos and checking them out will mess up the dependncy and 
the toolset will either fail to build or run correctly.

# <a name="build-tools"></a>Build the Tools
The tools need GCC version 4.9.2 or above to be built correctly. If you are using the 
latest version of Ubuntu or Fedora, you are good to go. If you are using RHEL-6 or below, 
you must  use the precompiled version of gcc-4.9.2 provided by RHEL devtoolset-3. 
The build scripts can automatically use devtoolset-3 by comenting out the 'source devtoolset-3' line
in build-all.sh. If you want to use a different GCC you 
must set the appropriate environment variables in build-all.sh . Things that need to be 
done to use a different toolchain is in the notes.

Now, execute the folloing commands:

	% cd anycore-riscv
	% vi build.common   #Change the number of jobs in this filebased on your build machine
	% ./build-gcc.sh    # If you do not already have the RISC-V cross compiler
	% ./build-all.sh    # To compile rest of the tools
	
This will build all the necessary tools and install them in anycore-riscv/install. Yo can change the install
path by changing the RISCV_INSTALL variable in build-all.sh. You 
should add this location to your path (in ~.mycshrc or ~/.bashrc) so that it is easy to use the tools.

######NOTE:
If using the gcc-4.9.2 installed on your system or a custom gcc, edit build-all.sh and 
modify GCC_PATH and GCC_SUFFIX variables to match your GCC's path and suffix. For installed 
GCCs, the path will probably be /usr/bin and suffix will be "" (blank).

# <a name="tour"></a>Tour of the Sources

A fresh clone of the toolchain consists of the following components:

*   `riscv-fesvr`, a "front-end" server that services calls between the 
host (x86 PC) and target processors (RISC-V simulated system) on the Host-Target
InterFace (HTIF) (it also provides a virtualized console and disk device)
*   `riscv-isa-sim`, the ISA simulator and "golden standard" of execution
*   `riscv-pk`, a proxy kernel that services system calls generated by code 
built and linked with the RISC-V Newlib port (this does not apply to Linux, 
as _it_ handles the system calls)
*   `riscv-tests`, a set of assembly tests and benchmarks for RISC-V compatibility
*   `anycore-riscv-src`, The RTL for AnyCore-RISCV
*   `anycore-riscv-tests`, The AnyCore test infrastructure to create checkpoints of benchmarks and 
run RTL and functional tests
*   `anycore-riscv-synth`, The synthesis and physical design infrastructure for AnyCore-RISCV
*   `riscv-dpi`, DPI code needed for RTL simualtions and checking committed instructions

# <a name="test-infra"></a>AnyCore Test Infrastructure

The submodule anycore-riscv-test contains a MAKE driven infrastructure for easily running tests. It can use parallel make to run tests in parallel, making it quite fast and efficient. The infrastructure can be used to run RTL tests, gate-level simulations, and tests on the Spike functional simulator. It supports both microbenchmarks and full benchmarks such as SPEC (Read about building SPEC benchmarks at https://github.com/anycore/Speckle). The infrastructure also supports gathering <a href=https://cseweb.ucsd.edu/~calder/simpoint/>Simpoints</a> and generate benchmark checkpoints for faster simulations. More details on how to use the infrastructure can be found in https://github.com/anycore/anycore-riscv-tests/blob/master/README.md .


## <a name="functional-sim"></a>Run Functional Simulator (Spike)

You can test the RISC-V toolchain installation by running a quick simulation without using the AnyCore test infrastructure. Write a short C program and name it hello.c.  Then, compile it into a RISC-V. 
If you are at NCSU, the comross compiler can be added using 'add risv'. Otherwise, 
you need to compile your own cross compiler by following [these instructions] (https://github.com/riscv/anycore-riscv/blob/master/README.md)

Build the ELF binary named hello:

    % add riscv
    % riscv64-unknown-elf-gcc -o hello hello.c

Now you can simulate the program atop the proxy kernel:

    % spike pk -c hello

Tests can also be run using the AnyCore test infrastructure by adding a testcase for "hello world" in anycore-riscv-tests/bmarks.mk (Use existing testcases as an example) and running:

    % cd anycore-riscv-tests 
    % make spike

All functional and RTL simulations are run in a separate scratch directory to prevent tests from using up AFS/NFS storage space. The path to this scratch space should be specified in the Makefile or overridden from the command 
line. For more information, visit https://github.com/sherry151/riscv-isa-sim/blob/master/README.md

## <a name="rtl-sim"></a>Run RTL Simulations

RTL simulations already defined in the Makefile can be run as follows (`NOTE`: You must change the SCRATCH_SPACE variable in the Makefile to point to a valid location):

    % cd anycore-riscv-tests 
    % make rtl 

Simulation runs are done in SCRATCH_SPACE/anycore_rtl_test and appropriate test directories are created in this hierarchy.
More usage instructions are in https://github.com/anycore/anycore-riscv-tests/blob/master/README.md .

# <a name="synth"></a>Synthesizing Cores

The synthesis and physical design infrastructure in in anycore-riscv-synth. It contains TCL scripts to be used with Synopsys Design Compiler to synthesize specific cores configured using a configuration file. Example configuration files can be found in anycore-riscv-src/config. Once you have created the core config of your choice, synthesize it by running the following commands:

    % cd anycore-riscv-synth
    % make synth

# <a name="commit-submodules"></a>Commit Changes in Submodules

When you clone a repo and recursively init all its submodules, each submodule remains
in a state called "Detached HEAD State". What this basically means is that the submodule
repo is "branchless". It does not track any local or remote branches. In this state, you 
can use everything in the repo, play around, modify and even commit your changes. What you
can't do however is push your commits to a remote as your HEAD is not tracking any branch.
There are at least two simple ways to get around this issue:

## Checkout a branch and then start modifying
	% cd <submodule_directory>
	% git checkout <branch_you_want_to_use>
	...
	..
	Make all modifications
	..
	% git add <Stuff you want to commit>
	% git commit -m"Made bunch of modifications"
	% git push
	% cd <parent repo>
	% git status        ## This will show you changes in the submodule
	% git add <submodule_directory>
	% git commit -m"Modified a submodule"
	% git push

## If you didn't checkout before modifying, create a new branch with your latest commit and merge

	% cd <submodule_directory>
	...
	..
	Make all modifications
	..
	% git add <Stuff you want to commit>
	% git commit -m"Made bunch of modifications"
	% git branch temp_commit_branch <##Commit hash>
	% git checkout <branch_you_want_to_actually_commit_to>
	% git merge temp_commit_branch <branch_you_want_to_actually_commit_to>
	% git push
	% cd <parent repo>
	% git status        ## This will show you changes in the submodule
	% git add <submodule_directory>
	% git commit -m"Modified a submodule"
	% git push


[Return to top.](#quickstart)

## <a name="references"></a> References
* https://github.com/riscv/anycore-riscv/blob/master/README.md
* Waterman, A., Lee, Y., Patterson, D., and Asanovic, K,. "The RISC-V Instruction Set Manual," vol. II, [http://inst.eecs.berkeley.edu/~cs152/sp12/handouts/riscv-supervisor.pdf](http://inst.eecs.berkeley.edu/~cs152/sp12/handouts/riscv-supervisor.pdf), 2012.

