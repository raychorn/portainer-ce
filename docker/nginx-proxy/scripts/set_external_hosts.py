import os
import sys
import socket

__target__ = '${EXTERNAL_HOST}'

sources = {}

def process_the_source(fname, dest=None, host_ip=None, verbose=False):
    assert (os.path.exists(fname) and os.path.isfile(fname)), 'Cannot proceed without the fname in process_the_source().'
    the_lines = []
    with open(fname, 'r') as fIn:
        for line in fIn:
            l = line.rstrip()
            l = l.replace(__target__, host_ip)
            the_lines.append(l)
    with open(dest, 'w') as fOut:
        for l in the_lines:
            print(l, file=fOut)
    assert (os.path.exists(dest) and os.path.isfile(dest)), 'Cannot proceed without the dest file in process_the_source().'
    

if (__name__ == '__main__'):
    is_verbose = False
    root = sys.argv[1]
    host_ip = sys.argv[2]
    assert (len(host_ip) > 0), 'Cannot proceed without the host ip address.'

    assert (os.path.exists(root) and os.path.isdir(root)), 'Cannot proceed without the root in process_the_source().'
    sources['{}/templates/conf.d/authelia_portal.conf'.format(root)] = '{}/nginx-proxy/nginx/conf.d/authelia_portal.conf'.format(os.path.dirname(root))

    if (is_verbose):
        print('BEGIN:')
    for s,d in sources.items():
        if (is_verbose):
            print('{} -> {}'.format(s, d))
        assert os.path.exists(s) and os.path.isfile(s), 'Cannot find "{}" so cannot proceed.'.format(s)
        process_the_source(s, dest=d, host_ip=host_ip, verbose=is_verbose)
    if (is_verbose):
        print('END!!!')

    if (is_verbose):
        print()
        print('Done.')
