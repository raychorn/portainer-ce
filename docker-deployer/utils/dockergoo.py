import os
import sys
import docker
import dotenv

import fast_json as json

import socket

dotenv.load_dotenv(dotenv.find_dotenv())
assert os.environ.get('DOCKERHOST'), 'DOCKERHOST is not set.'

libs = os.environ.get('libs')
if (libs):
    sys.path.insert(0, libs)

__host__ = socket.gethostname()
__is_prod__ = __host__ in ['DESKTOP-9J3LL5Q', 'server1']

from vyperlogix.misc import _utils
from vyperlogix.decorators import tunnel

ssh_pkey = os.environ.get('PRIVKEY')
assert _utils.is_something(ssh_pkey), 'ssh_pkey is not set.  Check your .env file.'

remote_bind_address = os.environ.get('REMOTE_DOCKER')
assert _utils.is_something(remote_bind_address), 'remote_bind_address is not set.  Check your .env file.'

local_bind_port = os.environ.get('DOCKER_PORT')
local_bind_address = '127.0.0.1:{}'.format(local_bind_port)

def os_command(cmd, message=None, verbose=False, logger=None):
    import subprocess

    assert _utils.is_something(cmd), "Command must be a string, you know, a non-empty string."
    if (verbose) and (_utils.is_something(message)):
        if (logger):
            logger.info(message)
        else:
            print('BEGIN: {}'.format(message))
    response = []
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    for line in p.stdout.readlines():
        if (verbose):
            if (logger):
                logger.info(line)
            else:
                print(line.strip())
        else:
            response.append(line.strip())
    retval = p.wait()
    if (verbose) and (_utils.is_something(message)):
        if (logger):
            logger.info('END: {}'.format(message))
        else:
            print('END!!! {}'.format(message))
    return retval, response

if (__name__ == "__main__"):
    remote = os.environ.get('USER_IP_ADDR')
    assert _utils.is_something(remote), 'remote is not set.  Check your .env file.'
    ssh_username = remote.split('@')[0]
    remote = remote.split('@')[-1]
    toks = remote.split(':')

    host = os.environ.get('DOCKERHOST')
    assert host, 'DOCKERHOST is not set.'

    if (len(toks) != 2):
        remote = '{}:{}'.format(toks[0], '22')
    has_context = False
    resp = os_command('docker context ls')
    if (len(resp[-1]) >= 2):
        has_context = str(resp[-1][1]).find(host) > -1

    @tunnel.ssh_tunnel(remote=remote, ssh_username=ssh_username, ssh_pkey=ssh_pkey, remote_bind_address=remote_bind_address, local_bind_address=local_bind_address)
    def do_the_thing(**kwargs):
        #_utils.os_command('netstat -tunlp', message='(***)', verbose=True)
        print(host)
        has_worked = has_context
        resp = os_command('docker context ls')
        if (not has_context):
            print('Creating context for {}'.format(host))
            resp = os_command('docker context create {} --docker "host={}"'.format(os.environ.get('DOCKERCONTEXT'), host))
            has_worked = any([str(s).lower().find('successfully created') > -1 for s in resp[-1]])
            if (has_worked):
                print('Successfully created context for {}'.format(host))
        if (has_worked):
            resp = os_command('docker context use {}'.format(os.environ.get('DOCKERCONTEXT')))
            print(str(resp[-1][-1]))
            #################################################################
            # BEGIN: do stuff with the context
            #################################################################
            resp = os_command('docker ps')
            print('\n'.join([str(s) for s in resp[-1]]))
            #################################################################
            # END!!! do stuff with the context
            #################################################################
            resp = os_command('docker context use default')
            print(str(resp[-1][-1]))
            resp = os_command('docker context rm {}'.format(os.environ.get('DOCKERCONTEXT')))
        print('DONE.')

    do_the_thing()
