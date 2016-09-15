#!/usr/bin/env python
# coding=utf-8
#
# vmstat-collectd
# ===============
# vmstat-collectd is a python based plugin for collectd that reports metrics
# collected from the unix command vmstat
# https://github.com/signalfx/vmstat-collectd
#
# This project is based on the SignalFx maintained fork of 
# collectd-iostat-python project.
# 
# https://github.com/signalfx/collectd-iostat-python
# 
# Information about the original collectd-iostat-python project: 
# -------------------------------------------------------------
# Collectd-iostat-python is an iostat plugin for collectd that allows you to
# graph Linux iostat metrics in Graphite or other output formats that are
# supported by collectd.
#
# https://github.com/powdahound/redis-collectd-plugin
#   - was used as template
# https://github.com/keirans/collectd-iostat/
#   - was used as inspiration and contains some code from
# https://bitbucket.org/jakamkon/python-iostat
#   - by Kuba Kończyk <jakamkon at users.sourceforge.net>
#
# This fork is maintained by SignalFx <support@signalfx.com>

import signal
import string
import subprocess
import sys


__version__ = '0.0.1'

__author__ = 'SignalFx'

# Fork maintained by SignalFx
__maintainer__ = 'SignalFx'
__email__ = 'support@signalfx.com'


class VMStatError(Exception):
    pass


class CmdError(VMStatError):
    pass


class ParseError(VMStatError):
    pass


class VMStat(object):
    def __init__(self, path='/usr/bin/vmstat', interval=2, count=2):
        self.path = path
        self.interval = interval
        self.count = count

    def parse_vmstats(self, input):
        """
        Parse vmstat.
        By default parse statistics for all avaliable devices.

        @type input: C{string}
        @param input: vmstat output

        @return: C{dictionary} contains per block device statistics.
        Statistics are in form of C{dictonary}.
        """
        vmstats = {}
        # Find the line with the column headers
        hdr_index = input.rfind('r  b')
        if hdr_index == -1:
            raise ParseError('Unknown input format: %r' % input)
        
        # data string of headers and values
        ds = input[hdr_index:].splitlines()

        # pop off the header string and store
        hdr = ds.pop(0).split()

        # For data point in data string
        for stats in ds:
            # If string of data points
            if stats:
                # split the data points
                stats = stats.split()
                vmstats = dict([(k, float(v)) for k, v in zip(hdr, stats)])

        return vmstats


    def _run(self, options=None):
        """
        Run vmstat command.
        """
        close_fds = 'posix' in sys.builtin_module_names
        args = '%s %s %s %s' % (
            self.path,
            ''.join(options),
            self.interval,
            self.count)

        return subprocess.Popen(
            args,
            bufsize=1,
            shell=True,
            stdout=subprocess.PIPE,
            close_fds=close_fds)

    @staticmethod
    def _get_childs_data(child):
        """
        Return child's data when avaliable.
        """
        (stdout, stderr) = child.communicate()
        ecode = child.poll()

        if ecode != 0:
            raise CmdError('Command %r returned %d' % (child.cmd, ecode))

        return stdout

    def get_vmstats(self):
        """
        Get all avaliable vmstats that we can get.
        """
        dstats = self._run(options=['-n -S K'])
        extdstats = self._run(options=['-an -S K'])
        dsd = self._get_childs_data(dstats)
        edd = self._get_childs_data(extdstats)
        ds = self.parse_vmstats(dsd)
        eds = self.parse_vmstats(edd)
        
        if len(eds) > 0:
            ds.update(eds)

        return ds


class VMMon(object):
    def __init__(self):
        self.plugin_name = 'vmstat'
        self.vmstat_path = '/usr/bin/vmstat'
        self.interval = 10.0
        self.vmstat_interval = 1
        self.vmstat_count = 2
        self.vmstat_nice_names = False
        self.verbose_logging = False
        self.include = set([])
        self.names = {
            'r': {'t': 'vmstat_process', 'ti': 'waiting'},
            'b': {'t': 'vmstat_process', 'ti': 'uninterruptible_sleep'},
            'swpd': {'t': 'vmstat_memory', 'ti': 'swap'},
            'free': {'t': 'vmstat_memory', 'ti': 'free'},
            'buff': {'t': 'vmstat_memory', 'ti': 'buffer'},
            'cache': {'t': 'vmstat_memory', 'ti': 'cache'},
            'inact': {'t': 'vmstat_memory', 'ti': 'inactive'},
            'active': {'t': 'vmstat_memory', 'ti': 'active'},
            'si': {'t': 'vmstat_swap', 'ti': 'in_per_second'},
            'so': {'t': 'vmstat_swap', 'ti': 'out_per_second'},
            'bi': {'t': 'vmstat_blocks', 'ti': 'received_per_second'},
            'bo': {'t': 'vmstat_blocks', 'ti': 'sent_per_second'},
            'in': {'t': 'vmstat_system', 'ti': 'interrupts_per_second'},
            'cs': {'t': 'vmstat_system', 'ti': 'context_switches_per_second'},
            'us': {'t': 'vmstat_cpu', 'ti': 'user'},
            'sy': {'t': 'vmstat_cpu', 'ti': 'system'},
            'id': {'t': 'vmstat_cpu', 'ti': 'idle'},
            'wa': {'t': 'vmstat_cpu', 'ti': 'wait'},
            'st': {'t': 'vmstat_cpu', 'ti': 'stolen'}
        }

    def log_verbose(self, msg):
        if not self.verbose_logging:
            return
        collectd.info('%s plugin [verbose]: %s' % (self.plugin_name, msg))

    def configure_callback(self, conf):
        """
        Receive configuration block
        """
        for node in conf.children:
            val = str(node.values[0])

            if node.key == 'Path':
                self.vmstat_path = val
            elif node.key == 'Interval':
                self.interval = float(val)
            elif node.key == 'VMStatInterval':
                self.vmstat_interval = int(float(val))
            elif node.key == 'Count':
                self.vmstat_count = int(float(val))
            elif node.key == 'NiceNames':
                self.vmstat_nice_names = val in ['True', 'true']
            elif node.key == 'PluginName':
                self.plugin_name = val
            elif node.key == 'Verbose':
                self.verbose_logging = val in ['True', 'true']
            elif node.key == 'Include':
                self.include.update(node.values)
            else:
                collectd.warning(
                    '%s plugin: Unknown config key: %s.' % (
                        self.plugin_name,
                        node.key))

        self.log_verbose(
            'Configured with vmstat=%s, interval=%s, count=%s, ' % (
                self.vmstat_path,
                self.vmstat_interval,
                self.vmstat_count))

        if len(self.include) != 0:
            self.log_verbose('Report only the following metrics: {0}'
                             .format(self.include))

        collectd.register_read(self.read_callback, self.interval)

    def dispatch_value(self, val_type, type_instance, value):
        """
        Dispatch a value to collectd
        """
        plugin_instance = "vmstat"
        self.log_verbose(
            'Sending value: %s-%s.%s=%s' % (
                self.plugin_name,
                plugin_instance,
                '-'.join([val_type, type_instance]),
                value))

        val = collectd.Values()
        val.plugin = self.plugin_name
        val.plugin_instance = plugin_instance
        val.type = val_type
        if len(type_instance):
            val.type_instance = type_instance
        val.values = [value, ]
        val.meta = {'0': True}
        val.dispatch()

    def read_callback(self):
        """
        Collectd read callback
        """
        self.log_verbose('Read callback called')
        vmstat = VMStat(
            path=self.vmstat_path,
            interval=self.vmstat_interval)
        ds = vmstat.get_vmstats()

        if not ds:
            self.log_verbose('%s plugin: No info received.' % self.plugin_name)
            return

        for name in ds:
            if self.vmstat_nice_names and name in self.names:
                val_type = self.names[name]['t']

                if 'ti' in self.names[name]:
                    type_instance = self.names[name]['ti']
                else:
                    type_instance = ''

                value = ds[name]
                if 'm' in self.names[name]:
                    value *= self.names[name]['m']
            else:
                val_type = 'gauge'
                type_instance = name
                value = ds[name]

            if len(self.include) == 0 \
                or (self.vmstat_nice_names is True
                    and ('.'.join([val_type, type_instance]) in self.include
                        or val_type in self.include)) \
                or (self.vmstat_nice_names is False and
                    type_instance in self.include):
                self.dispatch_value(val_type, type_instance, value)


def restore_sigchld():
    """
    Restore SIGCHLD handler for python <= v2.6
    It will BREAK exec plugin!!!
    See https://github.com/deniszh/collectd-iostat-python/issues/2 for details
    """
    if sys.version_info[0] == 2 and sys.version_info[1] <= 6:
        signal.signal(signal.SIGCHLD, signal.SIG_DFL)


if __name__ == '__main__':
    vmstat = VMStat()
    ds = vmstat.get_vmstats()

    for metric in ds:
        print("%s:%s" % (metric, ds[metric]))

    sys.exit(0)
else:
    import collectd

    vmmon = VMMon()

    # Register callbacks
    collectd.register_init(restore_sigchld)
    collectd.register_config(vmmon.configure_callback)
