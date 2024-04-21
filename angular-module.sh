#! /bin/bash
RED_COLOR="\e[0;31m"
GREEN_COLOR="\e[0;32m"
NEUTRAL_COLOR="\e[0;m"
VERSION="0.0.1"

verifyAngularDirectory() {
    directory="src/app"
    if [ -f "angular.json" ] && dirExists "src/app" 
        then echo "Angular Directory"
        else echo -e "${RED_COLOR}It's not an Angular Directory${NEUTRAL_COLOR}"; exit;
    fi
}

dirExists() {
 if [ -d "$1" ] 
        then true
        else false
    fi
}

createDirectory() {
    if dirExists $1
        then return
    else mkdir $1; echo "Creating directory $1"
    fi
}

help() {
    echo this is help; exit;
}

check() {
if [ $? -eq 0 ]
    then
        echo -e "${GREEN_COLOR}success $2${NEUTRAL_COLOR}" 
    else
        echo -e "${RED_COLOR}failure $2${NEUTRAL_COLOR}"
        exit
fi
}

# call function without ()
echo "Nico's Module Maker for Angular for Pilou's organization v${VERSION}"
verifyAngularDirectory

if [ $1 ]
    then 
        if [ $1 = "-h" ]
            then help;
        fi
        new_module_name=$1
    else echo -n "What's your module's name ? (unknown by default) " # -n do not output a trailing newline
        read new_module_name
fi

new_module_name="$new_module_name" | xargs # trim
new_module_name="${new_module_name,,}" # to lower
new_module_name="${new_module_name// /-}" # replace space inside string by -

if [ ! $new_module_name ]
    then new_module_name="unknown"
fi

echo "Your module is $new_module_name"

module_directory="src/app/modules"
createDirectory $module_directory
echo -n "Is it a sub-module ? (y/N) "
    read is_sub_module

if [ ! $is_sub_module ] 
    then is_sub_module="N"
fi
is_sub_module="${is_sub_module,,}"
if [ $is_sub_module = "y" ];
    then echo "Which module will be your sub-module's parent ? "
    echo -e "\tIf your module will be a sub-module of another sub-module, please write all tree structure"
    echo -e "\texample: you want an counter module in an utils module in game module:"
    echo -e "\twrite : game/utils"
    echo -n "So which module will be your sub-module's parent ? "
    read parent_module;
fi

if [ $parent_module ]
    then
        if dirExists "$module_directory/$parent_module"
            then module_directory="$module_directory/$parent_module"
            else echo -e "${RED_COLOR}parent module $parent_module not found"
            echo -e "module $new_module_name created in $module_directory ${NEUTRAL_COLOR}" 
        fi
fi
module_directory="$module_directory/$new_module_name"
createDirectory $module_directory

IFS=' '
read -ra sub_directory <<< "shared components components/feature components/ui pages models"

for i in "${sub_directory[@]}"; do createDirectory "$module_directory/$i";done

module_ng=${module_directory:8}

ng g module $module_ng --routing

#
#       LAZY LOADING
#

echo -n -e "Do you want implement lazy loading in ${GREEN_COLOR}app-module.routing.ts${NEUTRAL_COLOR} ?(y/N) "
read is_lazy_loading_wanted

if [ ! $is_lazy_loading_wanted ] 
    then is_lazy_loading_wanted="N"
fi
is_lazy_loading_wanted="${is_lazy_loading_wanted,,}"
if [ ! $is_lazy_loading_wanted = "y" ];
    then exit;
fi

if [ $is_sub_module = "y" ];
    then
        echo -e "${RED_COLOR}Sorry, auto lazy loading for sub-module not yet implemented${NEUTRAL_COLOR}"
        exit
fi

module_pascal_case="${new_module_name^}Module"
router="{ path: '$new_module_name', loadChildren: () =>  import('.\/modules\/$new_module_name\/$new_module_name.module').then(m  => m.$module_pascal_case) },"

sed -i -e "s/Routes = \[\]/Routes = \[\n\t\]/g" src/app/app-routing.module.ts
sed -i -e "s/Routes = \[/Routes = \[\n\t${router}/g" src/app/app-routing.module.ts 
check $? "to update app-routing.module.ts"


