import os
import sys
import docker
import dotenv

import subprocess

import fast_json as json

import socket

import traceback
import binascii

root = '/'
roots = ['/mnt/', '/srv/', '/home/', '/media/']
if (any([__file__.startswith(f) for f in roots])):
    base_root = [f for f in roots if __file__.startswith(f)][0]
    resp = subprocess.check_output('mount | grep {}'.format(base_root).split(), shell=True)
    is_found = False
    for line in resp.decode().split('\n'):
        if (line.find(base_root) > -1):
            base_root = [tok for tok in line.split() if (tok.find(base_root) > -1)][0]
            base_root = os.sep.join([base_root, os.sep.join(__file__.split(base_root)[-1].split(os.sep)[1:2])])
            is_found = True
            break
    if (not is_found):
        base_root = os.sep.join(__file__.split(os.sep)[0:2])
        is_found = True
else:
    raise Exception('1: Could not find base root for {}'.format(__file__))

assert is_found, "2: Could not find base root for {}".format(__file__)

is_found = False
for dirname,dirs,files in os.walk(base_root, topdown=True):
    if (not __file__.startswith(dirname)):
        continue
    for file in files:
        if (file == '.env'):
            fpath = os.path.join(dirname, file)
            fp = os.sep.join(fpath.split(os.sep)[0:-1])
            if (not __file__.startswith(fp)):
                continue
            assert os.path.exists(fpath) and os.path.isfile(fpath), "Could not find .env file at {}".format(fpath)
            dotenv.load_dotenv(os.path.join(dirname, file))
            is_found = True
            break

assert is_found, "3: Could not find base root for {}".format(__file__)

dockerhost = os.environ.get('DOCKERHOST')
assert dockerhost, 'DOCKERHOST is not set.'

libs = os.environ.get('libs')
if (libs):
    sys.path.insert(0, libs)

__host__ = socket.gethostname()
__is_prod__ = __host__ in ['pop-os', 'server1']

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
        has_context = str(resp[-1][1].decode('ascii')).find(host) > -1

    print('*** remote: {}'.format(remote))
    print('*** ssh_username: {}'.format(ssh_username))
    print('*** ssh_pkey: {}'.format(ssh_pkey))
    print('*** remote_bind_address: {}'.format(remote_bind_address))
    print('*** local_bind_address: {}'.format(local_bind_address))
    @tunnel.ssh_tunnel(remote=remote, ssh_username=ssh_username, ssh_pkey=ssh_pkey, remote_bind_address=remote_bind_address, local_bind_address=local_bind_address)
    def do_the_thing(**kwargs):
        #_utils.os_command('netstat -tunlp', message='(***)', verbose=True)
        print(host)
        has_worked = has_context
        resp = os_command('docker context ls')
        if (not has_context):
            print('Creating context for {}'.format(host))
            cmd = 'docker context create {} --docker "host={}"'.format(os.environ.get('DOCKERCONTEXT'), host)
            print(cmd)
            resp = os_command(cmd)
            has_worked = any([str(s.decode('ascii')).lower().find('successfully created') > -1 for s in resp[-1]])
            if (has_worked):
                print('Successfully created context for {}'.format(host))
            else:
                print('Failed to create context for {} because: {}.'.format(host, resp[-1][0].decode('ascii')))
        if (has_worked):
            resp = os_command('docker context use {}'.format(os.environ.get('DOCKERCONTEXT')))
            print(str(resp[-1][-1].decode('ascii')))
            #################################################################
            # BEGIN: do stuff with the context
            #################################################################
            if (len(sys.argv) > 1):
                try:
                    commands = eval(sys.argv[1:][0])
                    commands = commands if (isinstance(commands, list)) else [commands]
                    commands = [' '.join(commands) if (len(commands) > 1) else commands]
                    print('DEBUG: commands -> {}'.format(commands))
                    def __decode__(ch):
                        try:
                            return ch.decode('utf-8')
                        except:
                            return ch.decode('ascii')
                    for cmd in commands:
                        print('='*40)
                        print('DEBUG: cmd -> {}'.format(cmd))
                        resp = os_command(cmd)
                        print('\n'.join([str(__decode__(s)) for s in resp[-1]]))
                        print('='*40)
                        print()
                except Exception as ex:
                    traceback.print_exc(file=sys.stdout)
            elif (0):
                resp = os_command('docker ps')
                print('\n'.join([str(s.decode('ascii')) for s in resp[-1]]))
            #################################################################
            # END!!! do stuff with the context
            #################################################################
            resp = os_command('docker context use default')
            print(str(resp[-1][-1].decode('ascii')))
            resp = os_command('docker context rm {}'.format(os.environ.get('DOCKERCONTEXT')))
        print('DONE.')

    do_the_thing()
