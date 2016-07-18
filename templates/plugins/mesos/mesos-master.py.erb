#! /usr/bin/python
# Copyright 2015 Ray Rodriguez
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import collectd
import collections

import mesos_collectd


IS_MASTER = True
PREFIX = "mesos-master"
MESOS_CLUSTER = "cluster-0"
MESOS_INSTANCE = "master-0"
MESOS_PATH = "/usr/sbin"
MESOS_HOST = "localhost"
MESOS_PORT = 5050
MESOS_URL = ""
VERBOSE_LOGGING = False

Stat = collections.namedtuple('Stat', ('type', 'path'))

# DICT: Common Metrics in 0.19.0, 0.20.0, 0.21.0, 0.22.0 and 0.23.0
STATS_MESOS = {
    # Master
    'master/cpus_percent': Stat("percent", "master/cpus_percent"),
    'master/cpus_total': Stat("gauge", "master/cpus_total"),
    'master/cpus_used': Stat("gauge", "master/cpus_used"),
    'master/disk_percent': Stat("percent", "master/disk_percent"),
    'master/disk_total': Stat("gauge", "master/disk_total"),
    'master/disk_used': Stat("gauge", "master/disk_used"),
    'master/dropped_messages': Stat("counter", "master/dropped_messages"),
    'master/elected': Stat("gauge", "master/elected"),
    'master/frameworks_active': Stat("gauge", "master/frameworks_active"),
    'master/frameworks_inactive': Stat("gauge", "master/frameworks_inactive"),
    'master/invalid_framework_to_executor_messages':
        Stat("counter", "master/invalid_framework_to_executor_messages"),
    'master/invalid_status_update_acknowledgements':
        Stat("counter", "master/invalid_status_update_acknowledgements"),
    'master/invalid_status_updates':
        Stat("counter", "master/invalid_status_updates"),
    'master/mem_percent': Stat("percent", "master/mem_percent"),
    'master/mem_total': Stat("gauge", "master/mem_total"),
    'master/mem_used': Stat("gauge", "master/mem_used"),
    'master/messages_authenticate':
        Stat("counter", "master/messages_authenticate"),
    'master/messages_deactivate_framework':
        Stat("counter", "master/messages_deactivate_framework"),
    'master/messages_exited_executor':
        Stat("counter", "master/messages_exited_executor"),
    'master/messages_framework_to_executor':
        Stat("counter", "master/messages_framework_to_executor"),
    'master/messages_kill_task': Stat("counter", "master/messages_kill_task"),
    'master/messages_launch_tasks':
        Stat("counter", "master/messages_launch_tasks"),
    'master/messages_reconcile_tasks':
        Stat("counter", "master/messages_reconcile_tasks"),
    'master/messages_register_framework':
        Stat("counter", "master/messages_register_framework"),
    'master/messages_register_slave':
        Stat("counter", "master/messages_register_slave"),
    'master/messages_reregister_framework':
        Stat("counter", "master/messages_reregister_framework"),
    'master/messages_reregister_slave':
        Stat("counter", "master/messages_reregister_slave"),
    'master/messages_revive_offers':
        Stat("counter", "master/messages_revive_offers"),
    'master/messages_status_update':
        Stat("counter", "master/messages_status_update"),
    'master/messages_status_update_acknowledgement':
        Stat("counter", "master/messages_status_update_acknowledgement"),
    'master/messages_unregister_framework':
        Stat("counter", "master/messages_unregister_framework"),
    'master/messages_unregister_slave':
        Stat("counter", "master/messages_unregister_slave"),
    'master/outstanding_offers': Stat("gauge", "master/outstanding_offers"),
    'master/recovery_slave_removals':
        Stat("counter", "master/recovery_slave_removals"),
    'master/slave_registrations':
        Stat("counter", "master/slave_registrations"),
    'master/slave_removals': Stat("counter", "master/slave_removals"),
    'master/slave_reregistrations':
        Stat("counter", "master/slave_reregistrations"),
    'master/slaves_active': Stat("gauge", "master/slaves_active"),
    'master/slaves_inactive': Stat("gauge", "master/slaves_inactive"),
    'master/tasks_failed': Stat("counter", "master/tasks_failed"),
    'master/tasks_finished': Stat("counter", "master/tasks_finished"),
    'master/tasks_killed': Stat("counter", "master/tasks_killed"),
    'master/tasks_lost': Stat("counter", "master/tasks_lost"),
    'master/tasks_running': Stat("gauge", "master/tasks_running"),
    'master/tasks_staging': Stat("gauge", "master/tasks_staging"),
    'master/tasks_starting': Stat("gauge", "master/tasks_starting"),
    'master/uptime_secs': Stat("gauge", "master/uptime_secs"),
    'master/valid_framework_to_executor_messages':
        Stat("counter", "master/valid_framework_to_executor_messages"),
    'master/valid_status_update_acknowledgements':
        Stat("counter", "master/valid_status_update_acknowledgements"),
    'master/valid_status_updates':
        Stat("counter", "master/valid_status_updates"),

    # Registrar
    'registrar/queued_operations':
        Stat("gauge", "registrar/queued_operations"),
    'registrar/registry_size_bytes':
        Stat("bytes", "registrar/registry_size_bytes"),
    'registrar/state_fetch_ms': Stat("gauge", "registrar/state_fetch_ms"),
    'registrar/state_store_ms': Stat("gauge", "registrar/state_store_ms"),
    'registrar/state_store_ms/count':
        Stat("gauge", "registrar/state_store_ms/count"),
    'registrar/state_store_ms/max':
        Stat("gauge", "registrar/state_store_ms/max"),
    'registrar/state_store_ms/min':
        Stat("gauge", "registrar/state_store_ms/min"),
    'registrar/state_store_ms/p50':
        Stat("gauge", "registrar/state_store_ms/p50"),
    'registrar/state_store_ms/p90':
        Stat("gauge", "registrar/state_store_ms/p90"),
    'registrar/state_store_ms/p95':
        Stat("gauge", "registrar/state_store_ms/p95"),
    'registrar/state_store_ms/p99':
        Stat("gauge", "registrar/state_store_ms/p99"),
    'registrar/state_store_ms/p999':
        Stat("gauge", "registrar/state_store_ms/p999"),
    'registrar/state_store_ms/p9999':
        Stat("gauge", "registrar/state_store_ms/p9999"),

    # Elected Master System Metrics
    'system/cpus_total': Stat("gauge", "system/cpus_total"),
    'system/load_15min': Stat("gauge", "system/load_15min"),
    'system/load_1min': Stat("gauge", "system/load_1min"),
    'system/load_5min': Stat("gauge", "system/load_5min"),
    'system/mem_free_bytes': Stat("bytes", "system/mem_free_bytes"),
    'system/mem_total_bytes': Stat("bytes", "system/mem_total_bytes"),
}

# DICT: Mesos 0.19.0, 0.19.1
STATS_MESOS_019 = {
    'master/event_queue_size': Stat("gauge", "master/event_queue_size")
}

# DICT: Mesos 0.20.0, 0.20.1
STATS_MESOS_020 = {
    'master/event_queue_dispatches':
        Stat("gauge", "master/event_queue_dispatches"),
    'master/event_queue_http_requests':
        Stat("gauge", "master/event_queue_http_requests"),
    'master/event_queue_messages':
        Stat("gauge", "master/event_queue_messages"),
    'master/messages_resource_request':
        Stat("counter", "master/messages_resource_request")
}

# DICT: Mesos 0.21.0, 0.21.1
STATS_MESOS_021 = {
    'master/event_queue_dispatches':
        Stat("gauge", "master/event_queue_dispatches"),
    'master/event_queue_http_requests':
        Stat("gauge", "master/event_queue_http_requests"),
    'master/event_queue_messages':
        Stat("gauge", "master/event_queue_messages"),
    'master/frameworks_connected':
        Stat("gauge", "master/frameworks_connected"),
    'master/frameworks_disconnected':
        Stat("gauge", "master/frameworks_disconnected"),
    'master/messages_resource_request':
        Stat("counter", "master/messages_resource_request"),
    'master/slaves_connected': Stat("gauge", "master/slaves_connected"),
    'master/slaves_disconnected': Stat("gauge", "master/slaves_disconnected")
}

# DICT: Mesos 0.22.0, 0.22.1
STATS_MESOS_022 = {
    'master/event_queue_dispatches':
        Stat("gauge", "master/event_queue_dispatches"),
    'master/event_queue_http_requests':
        Stat("gauge", "master/event_queue_http_requests"),
    'master/event_queue_messages':
        Stat("gauge", "master/event_queue_messages"),
    'master/frameworks_connected':
        Stat("gauge", "master/frameworks_connected"),
    'master/frameworks_disconnected':
        Stat("gauge", "master/frameworks_disconnected"),
    'master/messages_decline_offers':
        Stat("counter", "master/messages_decline_offers"),
    'master/messages_resource_request':
        Stat("counter", "master/messages_resource_request"),
    'master/slaves_connected': Stat("gauge", "master/slaves_connected"),
    'master/slaves_disconnected': Stat("gauge", "master/slaves_disconnected"),
    'master/slave_shutdowns_canceled':
        Stat("counter", "master/slave_shutdowns_canceled"),
    'master/slave_shutdowns_scheduled':
        Stat("counter", "master/slave_shutdowns_scheduled"),
    'master/task_lost/source_master/reason_slave_removed':
        Stat("counter", "task_lost/source_master/reason_slave_removed"),
    'master/tasks_error': Stat("counter", "master/tasks_error")
}


def configure_callback(conf):
    mesos_collectd.configure_callback(conf, IS_MASTER, PREFIX, MESOS_CLUSTER,
                                      MESOS_INSTANCE, MESOS_PATH, MESOS_HOST,
                                      MESOS_PORT, MESOS_URL, VERBOSE_LOGGING)


def read_callback():
    mesos_collectd.read_callback(IS_MASTER, STATS_MESOS, STATS_MESOS_019,
                                 STATS_MESOS_020, STATS_MESOS_021,
                                 STATS_MESOS_022)


collectd.register_config(configure_callback)
collectd.register_read(read_callback)
