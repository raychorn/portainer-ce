#!/bin/bash

VENV=/workspaces/.venv
REQS=/workspaces/requirements.txt

python39=$(which python3.9)
pip3=$(which pip3)

echo "python39=$python39"
echo "pip3=$pip3"
$pip3 install -r /workspaces/$REQS

$python39 /workspaces/python_runner/cloudns-python/WindowsDynURL/dynamic-url-python.py

exit

TARGET_PY="3.9"
LOCAL_BIN=~/.local/bin

DIR0="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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

pypy3=$(which pypy3)

if [[ -f $pypy3 ]]
then
    echo "7. Found $pypy3"
else
    echo "8. Installing pypy3"
    apt update -y
    echo -ne '\n' | add-apt-repository ppa:pypy/ppa
    apt update -y
    apt install pypy3 -y
fi

python39=$(which python3.9)

if [[ -f $python39 ]]
then
    echo "9. Found $python39"
else
    echo "10. Installing python3.9"
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
    pip_local=$LOCAL_BIN/pip3
    if [[ -f $pip_local ]]
    then
        echo "11. Found $pip_local"
        export PATH=$LOCAL_BIN:$PATH
    else
        echo "Must install PIP?"
        if [[ -f $pip3 ]]
        then
            echo "12. $pip3 exists so not installing pip3, at this time."
        else
            echo "13. Installing pip3"
            GETPIP=$DIR0/get-pip.py

            if [[ -f $GETPIP ]]
            then
                $python39 $GETPIP
                export PATH=$LOCAL_BIN:$PATH
                pip3=$(which pip3)
                if [[ -f $pip3 ]]
                then
                    echo "14. Upgrading setuptools"
                    setuptools="1"
                    $pip3 install --upgrade setuptools > /dev/null 2>&1
                fi
            fi
        fi
    fi
fi

pip3=$(which pip3)
echo "15. pip3 is $pip3"

if [[ -f $pip3 ]]
then
    echo "16. Upgrading pip"
    $pip3 install --upgrade pip > /dev/null 2>&1
    if [[ "$setuptools." == "0." ]]
    then
        echo "17. Upgrading setuptools"
        $pip3 install --upgrade setuptools > /dev/null 2>&1
    fi
fi

virtualenv=$(which virtualenv)
#virtualenv=/usr/local/bin/virtualenv
echo "18. virtualenv is $virtualenv"

if [[ -f $virtualenv ]]
then
    echo "19. Found $virtualenv"
else
    $pip3 install virtualenv > /dev/null 2>&1
    $pip3 install --upgrade virtualenv > /dev/null 2>&1
    virtualenv=$(which virtualenv)
fi

find_python pypy3
find_python python

choice=$(which python3.9)

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
    virtualenv --python $choice -v $VENV
fi

echo "*** VENV --> $VENV"
exit
if [[ -d $VENV ]]
then
    . /workspaces/$VENV/bin/activate
    pip install --upgrade setuptools > /dev/null 2>&1
    pip install --upgrade pip > /dev/null 2>&1

    if [[ -f $REQS ]]
    then
        echo "Installing $REQS"
        pip install -r $REQS
    fi
fi

$python39 /workspaces/python_runner/cloudns-python/WindowsDynURL/dynamic-url-python.py

echo "DONE!!!"
