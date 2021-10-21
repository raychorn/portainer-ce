#!/bin/bash

ACTIVATE=$(ls ../.venv*/bin/activate)

if [ ! -f $ACTIVATE ]; then
    echo "Cannot find the $ACTIVATE virtual environment. Please issue the makevenv.sh command in the root of this project to try again."
    exit 1
fi

. $ACTIVATE

PY3=$(which python)
PIP3=$(which pip)

echo "Using python: $PY3"
echo "Using pip: $PIP3"

if [ ! -f "$PY3" ]; then
    echo "Python 3.9 not found. Please install it.  Cannot continue."
    exit 1
fi

PYVERS=$($PY3 -c 'import sys; i=sys.version_info; print("{}.{}".format(i.major,i.minor))')
echo "Python version: $PYVERS"

if [ "$PYVERS." != "3.9." ]; then
    echo "Python 3.9 not found but Version $PYVERS was found. Please install it.  Cannot continue."
    exit 1
fi

PY_FILE=/tmp/pyfile.py
cat << PY_FILE_EOF > $PY_FILE
import os
import dotenv

pwd = os.getcwd()
while (1):
    files = [os.path.join(pwd, f, '.env') for f in os.listdir(pwd) if (os.path.exists(os.path.join(pwd, f, '.env')))]
    if (len(files) > 0):
        print(files[0])
        break
    pwd = os.path.dirname(pwd)
    if (pwd in ['/', '/mnt', '/tmp']):
        break

if (not os.path.exists(p)):
    files = [os.path.join(pwd, f, '.env') for f in os.listdir(pwd) if (os.path.exists(os.path.join(pwd, f, '.env')))]
    if (len(files) > 0):
        print(files[0])
else:
    print(p)
PY_FILE_EOF

if [ -f "$PY_FILE" ]; then
    echo "$PY_FILE file created."
    sudo chmod 777 $PY_FILE
else
    echo "ERROR: $PY_FILE file not created. Cannot continue."
    exit 1
fi

ENVPATH=$($PY3 $PY_FILE)
echo "Environment file: $ENVPATH"

if [ -f "$ENVPATH" ]; then
    echo "Importing environment variables."
    export $(cat $ENVPATH | sed 's/#.*//g' | xargs)
    echo "Done importing environment variables."
else
    echo "ERROR: Environment variables not found. Please run the following command to generate them:"
    exit 1
fi

# Working on the web-head deployment below:

SSH_BOX=/mnt/FourTB/__projects_server1/portainer-ce/docker/ssh-box-securex/docker-compose.yml

if [ ! -f "$SSH_BOX" ]; then
    echo "SSH_BOX:$SSH_BOX not found. Please install it.  Cannot continue."
    exit 1
fi

BUILD_SCRIPT=/tmp/deploy-sshbox.sh
cat << BUILD_SCRIPT_EOF > $BUILD_SCRIPT
#!/bin/bash

SSH_BOX=\$1
ENVPATH=\$2
echo "SSH_BOX:\$SSH_BOX"
echo "ENVPATH:\$ENVPATH"

CNAME=ssh_box_securex
echo "CNAME:\$CNAME"

if [ ! -f "\$SSH_BOX" ]; then
    echo "SSH_BOX:\$SSH_BOX not found. Please install it.  Cannot continue."
    exit 1
fi

cd \$(dirname \$SSH_BOX)

if [ -f "\$ENVPATH" ]; then
    echo "Importing environment variables."
    export \$(cat \$ENVPATH | sed 's/#.*//g' | xargs  >/dev/null 2>&1)
    echo "Done importing environment variables."
fi

ls -la

docker context ls

docker-compose -f \$(basename \$SSH_BOX) up --build --force-recreate --no-deps -d

sleep 15

CID=\$(docker ps -qf "name=\$CNAME")
echo "CID:\$CID"

if [ -z "\$CID" ]; then
    echo "ERROR: \$CNAME container not found.  Cannot continue."
    exit 1
fi

ROOT=\$(dirname \$SSH_BOX)
echo "ROOT:\$ROOT"

WORKSPACES=\$ROOT/workspaces
echo "WORKSPACES:\$WORKSPACES"

if [ ! -d "\$WORKSPACES" ]; then
    echo "ERROR: \$WORKSPACES directory not found.  Cannot continue."
    exit 1
fi

docker cp \$WORKSPACES \$CID:/

docker exec -it \$CID bash -c "cd / && ls -la"

docker exec -it \$CID bash -c "cd /workspaces && ls -la"

docker exec -it \$CID bash -c "cd /workspaces && ./entrypoint.sh" #  &> /dev/stdout

BUILD_SCRIPT_EOF

if [ -f "$BUILD_SCRIPT" ]; then
    echo "$BUILD_SCRIPT file created."
    sudo chmod 777 $BUILD_SCRIPT
else
    echo "ERROR: $BUILD_SCRIPT file not created. Cannot continue."
    exit 1
fi

$PY3 $DOCKERGOO "['$BUILD_SCRIPT', '$SSH_BOX', '$ENVPATH']"

exit
