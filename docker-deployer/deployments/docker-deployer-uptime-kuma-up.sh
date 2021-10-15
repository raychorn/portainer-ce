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

UPTIME_KUMA=/mnt/FourTB/__projects_server1/portainer-ce/docker/uptime-kuma/docker-compose.yml

if [ ! -f "$UPTIME_KUMA" ]; then
    echo "UPTIME_KUMA:$UPTIME_KUMA not found. Please install it.  Cannot continue."
    exit 1
fi

BUILD_SCRIPT=/tmp/deploy-uptime-kuma.sh
cat << BUILD_SCRIPT_EOF > $BUILD_SCRIPT
#!/bin/bash

UPTIME_KUMA=\$1
ENVPATH=\$2
echo "UPTIME_KUMA:\$UPTIME_KUMA"
echo "ENVPATH:\$ENVPATH"

if [ ! -f "\$UPTIME_KUMA" ]; then
    echo "UPTIME_KUMA:\$UPTIME_KUMA not found. Please install it.  Cannot continue."
    exit 1
fi

cd \$(dirname \$UPTIME_KUMA)

if [ -f "\$ENVPATH" ]; then
    echo "Importing environment variables."
    export \$(cat \$ENVPATH | sed 's/#.*//g' | xargs  >/dev/null 2>&1)
    echo "Done importing environment variables."
fi

VOLUME_NAME=uptime-kuma
VOLUME_TEST=\$(docker volume ls | grep \$VOLUME_NAME)
echo "(***) VOLUME_TEST:\$VOLUME_TEST"

if [ -z "\$VOLUME_TEST" ]; then
    echo "INFO: \$VOLUME_NAME does not exist.  Creating it."
    docker volume create \$VOLUME_NAME
fi

ls -la

docker context ls

docker-compose -f \$(basename \$UPTIME_KUMA) up --build --force-recreate --no-deps -d

BUILD_SCRIPT_EOF

if [ -f "$BUILD_SCRIPT" ]; then
    echo "$BUILD_SCRIPT file created."
    sudo chmod 777 $BUILD_SCRIPT
else
    echo "ERROR: $BUILD_SCRIPT file not created. Cannot continue."
    exit 1
fi

$PY3 $DOCKERGOO "['$BUILD_SCRIPT', '$UPTIME_KUMA', '$ENVPATH']"

exit
