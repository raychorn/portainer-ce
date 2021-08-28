#!/bin/bash

VENV=.venv
REQS=./requirements.txt

TARGET_PY="3.9"
LOCAL_BIN=~/.local/bin

DIR0="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
UTILS=$DIR0/utils

if [ ! -d $UTILS ]; then
    echo "Missing the directory $UTILS so cannot continue."
    exit 1
fi

ARRAY=()

find_python(){
    pythons=$1
    PYTHONS=$(whereis $pythons)
    for val in $PYTHONS; do
        if [[ $val == *"/usr/bin/"* ]]; then
            if [[ $val != *"-config"* ]]; then
                ARRAY+=($val)
            fi
        fi
    done
}

python39=$(which python3.9)

if [[ -f $python39 ]]
then
    echo "7. Found $python39"
else
    echo "8. Installing python3.9"
    apt update -y
    apt install software-properties-common -y
    echo -ne '\n' | add-apt-repository ppa:deadsnakes/ppa
    apt install python3.9 -y
	apt install python3.9-distutils -y
fi

python39=$(which python3.9)
pip3=$(which pip3)
setuptools="0"

if [[ -f $python39 ]]
then
    PY3_VERS=$($python39 -c 'import sys; i=sys.version_info; print("{}.{}".format(i.major,i.minor))')
    PIP3_VERS_TEST=$pip3 --version | grep $PY3_VERS
    if [[ -z "$PIP3_VERS_TEST" ]]
    then
        pip3=
    fi
    pip_local=$LOCAL_BIN/pip3
    if [[ -f $pip_local ]]
    then
        echo "8. Found $pip_local"
        export PATH=$LOCAL_BIN:$PATH
    else
        echo "Must install PIP?"
        if [[ -f $pip3 ]]
        then
            echo "9. $pip3 exists so not installing pip3, at this time."
        else
            echo "10. Installing pip3"
            GETPIP=$UTILS/get-pip.py

            if [[ ! -f $GETPIP ]]
            then
                echo "12. Downloading get-pip.py"
                curl https://bootstrap.pypa.io/get-pip.py -o $GETPIP
            fi

            if [[ -f $GETPIP ]]
            then
                $python39 $GETPIP
                export PATH=$LOCAL_BIN:$PATH
                pip3=$(which pip3)
                if [[ -f $pip3 ]]
                then
                    echo "11. Upgrading setuptools"
                    setuptools="1"
                    $pip3 install --upgrade setuptools > /dev/null 2>&1
                fi
            fi
        fi
    fi
fi

pip3=$(which pip3)
echo "12. pip3 is $pip3"

if [[ ! -f $pip3 ]]
then
    echo "13. Upgrading pip"
    $pip3 install --upgrade pip > /dev/null 2>&1
    if [[ "$setuptools." == "0." ]]
    then
        echo "14. Upgrading setuptools"
        $pip3 install --upgrade setuptools > /dev/null 2>&1
    fi
fi

virtualenv=$(which virtualenv)
echo "15. virtualenv is $virtualenv"

if [[ ! -f $virtualenv ]]
then
    echo "16. Installing virtualenv"
    $pip3 install virtualenv > /dev/null 2>&1
    $pip3 install --upgrade virtualenv > /dev/null 2>&1
fi

virtualenv=$(which virtualenv)
echo "16. virtualenv is $virtualenv"

if [[ ! -f $virtualenv ]]
then
    echo "17. Cannot find virtualenv ($virtualenv)"
    exit 1
fi

find_python python

SORTPY=$UTILS/sort.py
if [ -f $SORTPY ] # check if the file exists
then
    echo "18. Found $SORTPY"
else
    echo "19. Cannot find $SORTPY"
    exit 1
fi

#echo ${ARRAY[@]}
v=$($python39 $SORTPY "${ARRAY[@]}")
#echo "17. Use this -> $v"
ARRAY=()
ARRAY2=()
for val in $v; do
    ARRAY+=($val)
    x=$($val -c 'import sys; i=sys.version_info; print("{}.{}.{}".format(i.major,i.minor,i.micro))')
    ARRAY2+=("$val $x")
done
#echo ${ARRAY[@]}
#echo ${ARRAY2[@]}

PS3="Choose: "

select option in "${ARRAY2[@]}";
do
    echo "Selected number: $REPLY"
    choice=${ARRAY[$REPLY-1]}
    break
done

version=$($choice --version)
echo "Use this -> $choice --> $version"

v=$($choice -c 'import sys; i=sys.version_info; print("{}{}{}".format(i.major,i.minor,i.micro))')
vv=$($choice -c 'import sys; i=sys.version_info; print("{}.{}.{}".format(i.major,i.minor,i.micro))')
echo "Use this -> $choice --> $v -> $vv"

VENV=$VENV$v
echo "VENV -> $VENV"

if [[ -d $VENV ]]
then
    rm -R -f $VENV
fi

if [[ ! -d $VENV ]]
then
    echo "Making virtualenv for Python $choice -> $VENV"

    if [[ ! -f "$choice" ]]
    then
        echo "Cannot find python:$choice"
        exit 1
    fi
    $virtualenv --python $choice -v $VENV
fi

if [[ -d $VENV ]]
then
    . ./$VENV/bin/activate
    pip install --upgrade setuptools > /dev/null 2>&1
    pip install --upgrade pip > /dev/null 2>&1

    if [[ -f $REQS ]]
    then
        echo "Installing $REQS"
        pip install -r $REQS
    fi

fi
