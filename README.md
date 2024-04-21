# angular-module
## Why ?
### Context
During my studies at Wild Code School, i learned to organized my Angular Projects in a certain way :

Modules contains directories :
* shared -> services / business layer
* components 
* components/feature -> smart components
* components/ui -> dumb components
* models -> classes/interfaces/types
* pages -> view components

Modules can contain sub-modules, organized in same way

### Observation
It would be boring to create always same directories

### Solution
Create a script to do automatically this directories...
In bash ?
I never do it !
Learn, try, learn and try !

## How install it ?
### One use
Copy the script in your project root.
Launch it with :
`
bash angular-module.sh
`
### Multiples uses
Create a directory and copy the `angular-module.sh` script.

Open your `.bashrc` file in your root directory.

See if these lines are present, else add them :

`
if [ -f ~/.bash_aliases ]; then

    . ~/.bash_aliases

fi
`

If there's not a `.bash_aliases` file in your root directoty, create it.
Add these lines to it :
`
alias nicomakemodule='bash ~/bash-script/angular-module/angular-module.sh'

alias nmm='bash ~/bash-script/angular-module/angular-module.sh'
`

You can now launch this script by `nicomakemodule` or `nmm` after restarting your bash terminal.

## How it works ?
Launch script.

First, it ask your module's name.

You could skip this step by add it after lauch command: `bash angular-module.sh account`

![capture of first question](help/images/img1.png)

Script will ask you if it's a sub-module.

![capture of second question](help/images/img2.png)

**Y** or **y** will be yes, by default other response will be no.

Yes or no, script creates directories and launch angular command :
`
ng g module modules/your-module --routing
`

Now, the lasy loading.

![capture of third question](help/images/img3.png)

If you accept, your file app-routing-module.ts will be updated.

**Note : lazy-loading for sub-modules isn't yet implemented** You would implement it manually.

![capture of routes updated](help/images/routes-updated.png)


